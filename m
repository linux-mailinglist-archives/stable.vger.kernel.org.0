Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269E01F44C2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbgFISIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:08:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41502 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388192AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pV-JS; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vw6-Ep; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hannes Reinecke" <hare@suse.de>,
        "Bart Van Assche" <bart.vanassche@wdc.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hannes Reinecke" <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Christoph Hellwig" <hch@lst.de>
Date:   Tue, 09 Jun 2020 19:04:24 +0100
Message-ID: <lsq.1591725832.196896298@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 33/61] scsi: sg: factor out sg_fill_request_table()
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

commit 4759df905a474d245752c9dc94288e779b8734dd upstream.

Factor out sg_fill_request_table() for better readability.

[mkp: typos, applied by hand]

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 61 +++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -870,6 +870,40 @@ static int max_sectors_bytes(struct requ
 	return max_sectors << 9;
 }
 
+static void
+sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
+{
+	Sg_request *srp;
+	int val;
+	unsigned int ms;
+
+	val = 0;
+	list_for_each_entry(srp, &sfp->rq_list, entry) {
+		if (val > SG_MAX_QUEUE)
+			break;
+		memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
+		rinfo[val].req_state = srp->done + 1;
+		rinfo[val].problem =
+			srp->header.masked_status &
+			srp->header.host_status &
+			srp->header.driver_status;
+		if (srp->done)
+			rinfo[val].duration =
+				srp->header.duration;
+		else {
+			ms = jiffies_to_msecs(jiffies);
+			rinfo[val].duration =
+				(ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
+		}
+		rinfo[val].orphan = srp->orphan;
+		rinfo[val].sg_io_owned = srp->sg_io_owned;
+		rinfo[val].pack_id = srp->header.pack_id;
+		rinfo[val].usr_ptr = srp->header.usr_ptr;
+		val++;
+	}
+}
+
 static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1063,38 +1097,13 @@ sg_ioctl(struct file *filp, unsigned int
 			return -EFAULT;
 		else {
 			sg_req_info_t *rinfo;
-			unsigned int ms;
 
 			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
 								GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
-			val = 0;
-			list_for_each_entry(srp, &sfp->rq_list, entry) {
-				if (val >= SG_MAX_QUEUE)
-					break;
-				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
-				rinfo[val].req_state = srp->done + 1;
-				rinfo[val].problem =
-					srp->header.masked_status &
-					srp->header.host_status &
-					srp->header.driver_status;
-				if (srp->done)
-					rinfo[val].duration =
-						srp->header.duration;
-				else {
-					ms = jiffies_to_msecs(jiffies);
-					rinfo[val].duration =
-						(ms > srp->header.duration) ?
-						(ms - srp->header.duration) : 0;
-				}
-				rinfo[val].orphan = srp->orphan;
-				rinfo[val].sg_io_owned = srp->sg_io_owned;
-				rinfo[val].pack_id = srp->header.pack_id;
-				rinfo[val].usr_ptr = srp->header.usr_ptr;
-				val++;
-			}
+			sg_fill_request_table(sfp, rinfo);
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = __copy_to_user(p, rinfo,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);

