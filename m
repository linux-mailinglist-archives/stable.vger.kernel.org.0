Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3311F44A6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388279AbgFISHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:07:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41488 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388185AbgFISGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:06:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pR-Fg; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vvz-Ct; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Hannes Reinecke" <hare@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hannes Reinecke" <hare@suse.de>
Date:   Tue, 09 Jun 2020 19:04:22 +0100
Message-ID: <lsq.1591725832.998347312@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 31/61] scsi: sg: use standard lists for sg_requests
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 109bade9c625c89bb5ea753aaa1a0a97e6fbb548 upstream.

'Sg_request' is using a private list implementation; convert it to
standard lists.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 147 +++++++++++++++++++---------------------------
 1 file changed, 61 insertions(+), 86 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -130,7 +130,7 @@ struct sg_device;		/* forward declaratio
 struct sg_fd;
 
 typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
-	struct sg_request *nextrp;	/* NULL -> tail request (slist) */
+	struct list_head entry;	/* list entry */
 	struct sg_fd *parentfp;	/* NULL -> not in use */
 	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
@@ -154,7 +154,7 @@ typedef struct sg_fd {		/* holds the sta
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	Sg_request *headrp;	/* head of request slist, NULL->empty */
+	struct list_head rq_list; /* head of request list */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
 	char low_dma;		/* as in parent but possibly overridden to 1 */
@@ -981,7 +981,7 @@ sg_ioctl(struct file *filp, unsigned int
 		if (!access_ok(VERIFY_WRITE, ip, sizeof (int)))
 			return -EFAULT;
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
-		for (srp = sfp->headrp; srp; srp = srp->nextrp) {
+		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 == srp->done) && (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
@@ -994,7 +994,8 @@ sg_ioctl(struct file *filp, unsigned int
 		return 0;
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
-		for (val = 0, srp = sfp->headrp; srp; srp = srp->nextrp) {
+		val = 0;
+		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 == srp->done) && (!srp->sg_io_owned))
 				++val;
 		}
@@ -1069,35 +1070,33 @@ sg_ioctl(struct file *filp, unsigned int
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
-			for (srp = sfp->headrp, val = 0; val < SG_MAX_QUEUE;
-			     ++val, srp = srp ? srp->nextrp : srp) {
+			val = 0;
+			list_for_each_entry(srp, &sfp->rq_list, entry) {
+				if (val > SG_MAX_QUEUE)
+					break;
 				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
-				if (srp) {
-					rinfo[val].req_state = srp->done + 1;
-					rinfo[val].problem =
-					    srp->header.masked_status & 
-					    srp->header.host_status & 
-					    srp->header.driver_status;
-					if (srp->done)
-						rinfo[val].duration =
-							srp->header.duration;
-					else {
-						ms = jiffies_to_msecs(jiffies);
-						rinfo[val].duration =
-						    (ms > srp->header.duration) ?
-						    (ms - srp->header.duration) : 0;
-					}
-					rinfo[val].orphan = srp->orphan;
-					rinfo[val].sg_io_owned =
-							srp->sg_io_owned;
-					rinfo[val].pack_id =
-							srp->header.pack_id;
-					rinfo[val].usr_ptr =
-							srp->header.usr_ptr;
+				rinfo[val].req_state = srp->done + 1;
+				rinfo[val].problem =
+					srp->header.masked_status &
+					srp->header.host_status &
+					srp->header.driver_status;
+				if (srp->done)
+					rinfo[val].duration =
+						srp->header.duration;
+				else {
+					ms = jiffies_to_msecs(jiffies);
+					rinfo[val].duration =
+						(ms > srp->header.duration) ?
+						(ms - srp->header.duration) : 0;
 				}
+				rinfo[val].orphan = srp->orphan;
+				rinfo[val].sg_io_owned = srp->sg_io_owned;
+				rinfo[val].pack_id = srp->header.pack_id;
+				rinfo[val].usr_ptr = srp->header.usr_ptr;
+				val++;
 			}
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			result = __copy_to_user(p, rinfo, 
+			result = __copy_to_user(p, rinfo,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result = result ? -EFAULT : 0;
 			kfree(rinfo);
@@ -1229,7 +1228,7 @@ sg_poll(struct file *filp, poll_table *
 		return POLLERR;
 	poll_wait(filp, &sfp->read_wait, wait);
 	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp = sfp->headrp; srp; srp = srp->nextrp) {
+	list_for_each_entry(srp, &sfp->rq_list, entry) {
 		/* if any read waiting, flag it */
 		if ((0 == res) && (1 == srp->done) && (!srp->sg_io_owned))
 			res = POLLIN | POLLRDNORM;
@@ -2080,7 +2079,7 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 	unsigned long iflags;
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (resp = sfp->headrp; resp; resp = resp->nextrp) {
+	list_for_each_entry(resp, &sfp->rq_list, entry) {
 		/* look for requests that are ready + not SG_IO owned */
 		if ((1 == resp->done) && (!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
@@ -2098,70 +2097,45 @@ sg_add_request(Sg_fd * sfp)
 {
 	int k;
 	unsigned long iflags;
-	Sg_request *resp;
 	Sg_request *rp = sfp->req_arr;
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	resp = sfp->headrp;
-	if (!resp) {
-		memset(rp, 0, sizeof (Sg_request));
-		rp->parentfp = sfp;
-		resp = rp;
-		sfp->headrp = resp;
-	} else {
-		if (0 == sfp->cmd_q)
-			resp = NULL;	/* command queuing disallowed */
-		else {
-			for (k = 0; k < SG_MAX_QUEUE; ++k, ++rp) {
-				if (!rp->parentfp)
-					break;
-			}
-			if (k < SG_MAX_QUEUE) {
-				memset(rp, 0, sizeof (Sg_request));
-				rp->parentfp = sfp;
-				while (resp->nextrp)
-					resp = resp->nextrp;
-				resp->nextrp = rp;
-				resp = rp;
-			} else
-				resp = NULL;
+	if (!list_empty(&sfp->rq_list)) {
+		if (!sfp->cmd_q)
+			goto out_unlock;
+
+		for (k = 0; k < SG_MAX_QUEUE; ++k, ++rp) {
+			if (!rp->parentfp)
+				break;
 		}
+		if (k >= SG_MAX_QUEUE)
+			goto out_unlock;
 	}
-	if (resp) {
-		resp->nextrp = NULL;
-		resp->header.duration = jiffies_to_msecs(jiffies);
-	}
+	memset(rp, 0, sizeof (Sg_request));
+	rp->parentfp = sfp;
+	rp->header.duration = jiffies_to_msecs(jiffies);
+	list_add_tail(&rp->entry, &sfp->rq_list);
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
+	return rp;
+out_unlock:
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return NULL;
 }
 
 /* Return of 1 for found; 0 for not found */
 static int
 sg_remove_request(Sg_fd * sfp, Sg_request * srp)
 {
-	Sg_request *prev_rp;
-	Sg_request *rp;
 	unsigned long iflags;
 	int res = 0;
 
-	if ((!sfp) || (!srp) || (!sfp->headrp))
+	if (!sfp || !srp || list_empty(&sfp->rq_list))
 		return res;
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	prev_rp = sfp->headrp;
-	if (srp == prev_rp) {
-		sfp->headrp = prev_rp->nextrp;
-		prev_rp->parentfp = NULL;
+	if (!list_empty(&srp->entry)) {
+		list_del(&srp->entry);
+		srp->parentfp = NULL;
 		res = 1;
-	} else {
-		while ((rp = prev_rp->nextrp)) {
-			if (srp == rp) {
-				prev_rp->nextrp = rp->nextrp;
-				rp->parentfp = NULL;
-				res = 1;
-				break;
-			}
-			prev_rp = rp;
-		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return res;
@@ -2180,7 +2154,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
-
+	INIT_LIST_HEAD(&sfp->rq_list);
 	kref_init(&sfp->f_ref);
 	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
@@ -2218,10 +2192,13 @@ sg_remove_sfp_usercontext(struct work_st
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
+	Sg_request *srp;
 
 	/* Cleanup any responses which were never read(). */
-	while (sfp->headrp)
-		sg_finish_rem_req(sfp->headrp);
+	while (!list_empty(&sfp->rq_list)) {
+		srp = list_first_entry(&sfp->rq_list, Sg_request, entry);
+		sg_finish_rem_req(srp);
+	}
 
 	if (sfp->reserve.bufflen > 0) {
 		SCSI_LOG_TIMEOUT(6,
@@ -2626,7 +2603,7 @@ static int sg_proc_seq_show_devstrs(stru
 /* must be called while holding sg_index_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
-	int k, m, new_interface, blen, usg;
+	int k, new_interface, blen, usg;
 	Sg_request *srp;
 	Sg_fd *fp;
 	const sg_io_hdr_t *hp;
@@ -2646,13 +2623,11 @@ static void sg_proc_debug_helper(struct
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan);
-		for (m = 0, srp = fp->headrp;
-				srp != NULL;
-				++m, srp = srp->nextrp) {
+		list_for_each_entry(srp, &fp->rq_list, entry) {
 			hp = &srp->header;
 			new_interface = (hp->interface_id == '\0') ? 0 : 1;
 			if (srp->res_used) {
-				if (new_interface && 
+				if (new_interface &&
 				    (SG_FLAG_MMAP_IO & hp->flags))
 					cp = "     mmap>> ";
 				else
@@ -2683,7 +2658,7 @@ static void sg_proc_debug_helper(struct
 			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
 		}
-		if (0 == m)
+		if (list_empty(&fp->rq_list))
 			seq_puts(s, "     No requests active\n");
 		read_unlock(&fp->rq_list_lock);
 	}

