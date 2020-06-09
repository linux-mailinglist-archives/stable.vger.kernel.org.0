Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5061F44B5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388304AbgFISHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:07:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41514 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388193AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pA-8A; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vvl-7l; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Todd Poynor" <toddpoynor@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Hannes Reinecke" <hare@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hannes Reinecke" <hare@suse.de>
Date:   Tue, 09 Jun 2020 19:04:17 +0100
Message-ID: <lsq.1591725832.192679477@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 26/61] scsi: sg: protect accesses to 'reserved' page
 array
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

commit 1bc0eb0446158cc76562176b80623aa119afee5b upstream.

The 'reserved' page array is used as a short-cut for mapping data,
saving us to allocate pages per request. However, the 'reserved' array
is only capable of holding one request, so this patch introduces a mutex
for protect 'sg_fd' against concurrent accesses.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[toddpoynor@google.com: backport to 3.18-4.9,  fixup for bad ioctl
SG_SET_FORCE_LOW_DMA code removed in later versions and not modified by
the original patch.]

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -150,6 +150,7 @@ typedef struct sg_fd {		/* holds the sta
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
+	struct mutex f_mutex;	/* protect against changes in this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
@@ -163,6 +164,7 @@ typedef struct sg_fd {		/* holds the sta
 	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	char res_in_use;	/* 1 -> 'reserve' array in use */
 	struct kref f_ref;
 	struct execute_work ew;
 } Sg_fd;
@@ -206,7 +208,6 @@ static void sg_remove_sfp(struct kref *)
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static int sg_res_in_use(Sg_fd * sfp);
 static Sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 
@@ -652,6 +653,7 @@ sg_write(struct file *filp, const char _
 	}
 	buf += SZ_SG_HEADER;
 	__get_user(opcode, buf);
+	mutex_lock(&sfp->f_mutex);
 	if (sfp->next_cmd_len > 0) {
 		cmd_size = sfp->next_cmd_len;
 		sfp->next_cmd_len = 0;	/* reset so only this write() effected */
@@ -660,6 +662,7 @@ sg_write(struct file *filp, const char _
 		if ((opcode >= 0xc0) && old_hdr.twelve_byte)
 			cmd_size = 12;
 	}
+	mutex_unlock(&sfp->f_mutex);
 	SCSI_LOG_TIMEOUT(4, printk(
 		"sg_write:   scsi opcode=0x%02x, cmd_size=%d\n", (int) opcode, cmd_size));
 /* Determine buffer size.  */
@@ -758,7 +761,7 @@ sg_new_write(Sg_fd *sfp, struct file *fi
 			sg_remove_request(sfp, srp);
 			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
 		}
-		if (sg_res_in_use(sfp)) {
+		if (sfp->res_in_use) {
 			sg_remove_request(sfp, srp);
 			return -EBUSY;	/* reserve buffer already being used */
 		}
@@ -933,7 +936,7 @@ sg_ioctl(struct file *filp, unsigned int
 			return result;
 		if (val) {
 			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
+			if ((0 == sfp->low_dma) && !sfp->res_in_use) {
 				val = (int) sfp->reserve.bufflen;
 				sg_remove_scat(&sfp->reserve);
 				sg_build_reserve(sfp, val);
@@ -1008,12 +1011,18 @@ sg_ioctl(struct file *filp, unsigned int
                         return -EINVAL;
 		val = min_t(int, val,
 			    max_sectors_bytes(sdp->device->request_queue));
+		mutex_lock(&sfp->f_mutex);
 		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
+			if (sfp->mmap_called ||
+			    sfp->res_in_use) {
+				mutex_unlock(&sfp->f_mutex);
 				return -EBUSY;
+			}
+
 			sg_remove_scat(&sfp->reserve);
 			sg_build_reserve(sfp, val);
 		}
+		mutex_unlock(&sfp->f_mutex);
 		return 0;
 	case SG_GET_RESERVED_SIZE:
 		val = min_t(int, sfp->reserve.bufflen,
@@ -1752,13 +1761,22 @@ sg_start_req(Sg_request *srp, unsigned c
 		md = &map_data;
 
 	if (md) {
-		if (!sg_res_in_use(sfp) && dxfer_len <= rsv_schp->bufflen)
+		mutex_lock(&sfp->f_mutex);
+		if (dxfer_len <= rsv_schp->bufflen &&
+		    !sfp->res_in_use) {
+			sfp->res_in_use = 1;
 			sg_link_reserve(sfp, srp, dxfer_len);
-		else {
+		} else if ((hp->flags & SG_FLAG_MMAP_IO) && sfp->res_in_use) {
+			mutex_unlock(&sfp->f_mutex);
+			return -EBUSY;
+		} else {
 			res = sg_build_indirect(req_schp, sfp, dxfer_len);
-			if (res)
+			if (res) {
+				mutex_unlock(&sfp->f_mutex);
 				return res;
+			}
 		}
+		mutex_unlock(&sfp->f_mutex);
 
 		md->pages = req_schp->pages;
 		md->page_order = req_schp->page_order;
@@ -2155,6 +2173,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	rwlock_init(&sfp->rq_list_lock);
 
 	kref_init(&sfp->f_ref);
+	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
@@ -2229,20 +2248,6 @@ sg_remove_sfp(struct kref *kref)
 	schedule_work(&sfp->ew.work);
 }
 
-static int
-sg_res_in_use(Sg_fd * sfp)
-{
-	const Sg_request *srp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp = sfp->headrp; srp; srp = srp->nextrp)
-		if (srp->res_used)
-			break;
-	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return srp ? 1 : 0;
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 static int
 sg_idr_max_id(int id, void *p, void *data)

