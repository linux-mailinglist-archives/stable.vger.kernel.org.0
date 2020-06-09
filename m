Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E58A1F44E7
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388228AbgFISJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:09:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41504 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388187AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pZ-Js; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006VwE-HR; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Christoph Hellwig" <hch@lst.de>, "Hannes Reinecke" <hare@suse.de>,
        "Hannes Reinecke" <hare@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 09 Jun 2020 19:04:27 +0100
Message-ID: <lsq.1591725832.401309253@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 36/61] scsi: sg: disable SET_FORCE_LOW_DMA
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

commit 745dfa0d8ec26b24f3304459ff6e9eacc5c8351b upstream.

The ioctl SET_FORCE_LOW_DMA has never worked since the initial git
check-in, and the respective setting is nowadays handled correctly. So
disable it entirely.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 30 +++++++++---------------------
 include/scsi/sg.h |  1 -
 2 files changed, 9 insertions(+), 22 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -157,7 +157,6 @@ typedef struct sg_fd {		/* holds the sta
 	struct list_head rq_list; /* head of request list */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
-	char low_dma;		/* as in parent but possibly overridden to 1 */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
 	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
@@ -963,24 +962,14 @@ sg_ioctl(struct file *filp, unsigned int
 				/* strange ..., for backward compatibility */
 		return sfp->timeout_user;
 	case SG_SET_FORCE_LOW_DMA:
-		result = get_user(val, ip);
-		if (result)
-			return result;
-		if (val) {
-			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && !sfp->res_in_use) {
-				val = (int) sfp->reserve.bufflen;
-				sg_remove_scat(&sfp->reserve);
-				sg_build_reserve(sfp, val);
-			}
-		} else {
-			if (atomic_read(&sdp->detaching))
-				return -ENODEV;
-			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
-		}
+		/*
+		 * N.B. This ioctl never worked properly, but failed to
+		 * return an error value. So returning '0' to keep compability
+		 * with legacy applications.
+		 */
 		return 0;
 	case SG_GET_LOW_DMA:
-		return put_user((int) sfp->low_dma, ip);
+		return put_user((int) sdp->device->host->unchecked_isa_dma, ip);
 	case SG_GET_SCSI_ID:
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
 			return -EFAULT;
@@ -1890,6 +1879,7 @@ sg_build_indirect(Sg_scatter_hold * schp
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	int blk_size = buff_size, order;
 	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
+	struct sg_device *sdp = sfp->parentdp;
 
 	if (blk_size < 0)
 		return -EFAULT;
@@ -1914,7 +1904,7 @@ sg_build_indirect(Sg_scatter_hold * schp
 			scatter_elem_sz_prev = num;
 	}
 
-	if (sfp->low_dma)
+	if (sdp->device->host->unchecked_isa_dma)
 		gfp_mask |= GFP_DMA;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -2168,8 +2158,6 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
-	sfp->low_dma = (SG_DEF_FORCE_LOW_DMA == 0) ?
-	    sdp->device->host->unchecked_isa_dma : 1;
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
@@ -2627,7 +2615,7 @@ static void sg_proc_debug_helper(struct
 			   jiffies_to_msecs(fp->timeout),
 			   fp->reserve.bufflen,
 			   (int) fp->reserve.k_use_sg,
-			   (int) fp->low_dma);
+			   (int) sdp->device->host->unchecked_isa_dma);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan);
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -234,7 +234,6 @@ typedef struct sg_req_info { /* used by
 #define SG_DEFAULT_RETRIES 0
 
 /* Defaults, commented if they differ from original sg driver */
-#define SG_DEF_FORCE_LOW_DMA 0  /* was 1 -> memory below 16MB on i386 */
 #define SG_DEF_FORCE_PACK_ID 0
 #define SG_DEF_KEEP_ORPHAN 0
 #define SG_DEF_RESERVED_SIZE SG_SCATTER_SZ /* load time option */

