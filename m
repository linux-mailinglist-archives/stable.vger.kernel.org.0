Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7999C1F4503
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgFISKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:10:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41302 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388151AbgFISF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001p5-4W; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vvd-4e; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Akinobu Mita" <akinobu.mita@gmail.com>,
        "Christoph Hellwig" <hch@lst.de>
Date:   Tue, 09 Jun 2020 19:04:15 +0100
Message-ID: <lsq.1591725832.224367208@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 24/61] sg: prevent integer overflow when converting
 from sectors to bytes
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

From: Akinobu Mita <akinobu.mita@gmail.com>

commit 46f69e6a6bbbf3858617c8729e31895846c15a79 upstream.

This prevents integer overflow when converting the request queue's
max_sectors from sectors to bytes.  However, this is a preparation for
extending the data type of max_sectors in struct Scsi_Host and
scsi_host_template.  So, it is impossible to happen this integer
overflow for now, because SCSI low-level drivers can not specify
max_sectors greater than 0xffff due to the data type limitation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -865,6 +865,15 @@ static int srp_done(Sg_fd *sfp, Sg_reque
 	return ret;
 }
 
+static int max_sectors_bytes(struct request_queue *q)
+{
+	unsigned int max_sectors = queue_max_sectors(q);
+
+	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+
+	return max_sectors << 9;
+}
+
 static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1004,7 +1013,7 @@ sg_ioctl(struct file *filp, unsigned int
                 if (val < 0)
                         return -EINVAL;
 		val = min_t(int, val,
-			    queue_max_sectors(sdp->device->request_queue) * 512);
+			    max_sectors_bytes(sdp->device->request_queue));
 		if (val != sfp->reserve.bufflen) {
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
 				return -EBUSY;
@@ -1014,7 +1023,7 @@ sg_ioctl(struct file *filp, unsigned int
 		return 0;
 	case SG_GET_RESERVED_SIZE:
 		val = min_t(int, sfp->reserve.bufflen,
-			    queue_max_sectors(sdp->device->request_queue) * 512);
+			    max_sectors_bytes(sdp->device->request_queue));
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);
@@ -1154,7 +1163,7 @@ sg_ioctl(struct file *filp, unsigned int
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
-		return put_user(queue_max_sectors(sdp->device->request_queue) * 512,
+		return put_user(max_sectors_bytes(sdp->device->request_queue),
 				ip);
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
@@ -2170,7 +2179,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 		sg_big_buff = def_reserved_size;
 
 	bufflen = min_t(int, sg_big_buff,
-			queue_max_sectors(sdp->device->request_queue) * 512);
+			max_sectors_bytes(sdp->device->request_queue));
 	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));

