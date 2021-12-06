Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E1B4699C3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345018AbhLFPDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344944AbhLFPDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:03:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BABC0698C1;
        Mon,  6 Dec 2021 06:59:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26944612C0;
        Mon,  6 Dec 2021 14:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DF4C341C2;
        Mon,  6 Dec 2021 14:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802771;
        bh=oRk2MEDiiStvMv6Ddu8jY/q6TXtar055ZLY1850mRPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jgstAGsGh0tC2faVwV5QMqMFx7g29PIAYwtBOPmtR5LNlFGTCwSuhnWiCQIAxtvc
         B9cQiKxKLKPKZRL0Uu6N+akIrYF+jknUNewYLA2je5YUDxfACoDEhQQGb2jy6uFzj9
         TZ92mfYCjWP8Vh7ci+eAokQiPLfI7Uc/NtMsM3Uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 4.4 28/52] xen/blkfront: dont trust the backend response data blindly
Date:   Mon,  6 Dec 2021 15:56:12 +0100
Message-Id: <20211206145548.846452252@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit b94e4b147fd1992ad450e1fea1fdaa3738753373 upstream.

Today blkfront will trust the backend to send only sane response data.
In order to avoid privilege escalations or crashes in case of malicious
backends verify the data to be within expected limits. Especially make
sure that the response always references an outstanding request.

Introduce a new state of the ring BLKIF_STATE_ERROR which will be
switched to in case an inconsistency is being detected. Recovering from
this state is possible only via removing and adding the virtual device
again (e.g. via a suspend/resume cycle).

Make all warning messages issued due to valid error responses rate
limited in order to avoid message floods being triggered by a malicious
backend.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Link: https://lore.kernel.org/r/20210730103854.12681-4-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   57 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 11 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -64,6 +64,7 @@ enum blkif_state {
 	BLKIF_STATE_DISCONNECTED,
 	BLKIF_STATE_CONNECTED,
 	BLKIF_STATE_SUSPENDED,
+	BLKIF_STATE_ERROR,
 };
 
 struct grant {
@@ -79,6 +80,7 @@ struct blk_shadow {
 	struct grant **indirect_grants;
 	struct scatterlist *sg;
 	unsigned int num_sg;
+	bool inflight;
 };
 
 struct split_bio {
@@ -495,6 +497,7 @@ static int blkif_queue_discard_req(struc
 
 	/* Copy the request to the ring page. */
 	*final_ring_req = *ring_req;
+	info->shadow[id].inflight = true;
 
 	return 0;
 }
@@ -712,6 +715,7 @@ static int blkif_queue_rw_req(struct req
 
 	/* Copy request(s) to the ring page. */
 	*final_ring_req = *ring_req;
+	info->shadow[id].inflight = true;
 
 	if (new_persistent_gnts)
 		gnttab_free_grant_references(setup.gref_head);
@@ -1324,11 +1328,17 @@ static irqreturn_t blkif_interrupt(int i
 	}
 
  again:
-	rp = info->ring.sring->rsp_prod;
+	rp = READ_ONCE(info->ring.sring->rsp_prod);
 	rmb(); /* Ensure we see queued responses up to 'rp'. */
+	if (RING_RESPONSE_PROD_OVERFLOW(&info->ring, rp)) {
+		pr_alert("%s: illegal number of responses %u\n",
+			 info->gd->disk_name, rp - info->ring.rsp_cons);
+		goto err;
+	}
 
 	for (i = info->ring.rsp_cons; i != rp; i++) {
 		unsigned long id;
+		unsigned int op;
 
 		RING_COPY_RESPONSE(&info->ring, i, &bret);
 		id   = bret.id;
@@ -1339,14 +1349,28 @@ static irqreturn_t blkif_interrupt(int i
 		 * look in get_id_from_freelist.
 		 */
 		if (id >= BLK_RING_SIZE(info)) {
-			WARN(1, "%s: response to %s has incorrect id (%ld)\n",
-			     info->gd->disk_name, op_name(bret.operation), id);
-			/* We can't safely get the 'struct request' as
-			 * the id is busted. */
-			continue;
+			pr_alert("%s: response has incorrect id (%ld)\n",
+				 info->gd->disk_name, id);
+			goto err;
+		}
+		if (!info->shadow[id].inflight) {
+			pr_alert("%s: response references no pending request\n",
+				 info->gd->disk_name);
+			goto err;
 		}
+
+		info->shadow[id].inflight = false;
 		req  = info->shadow[id].request;
 
+		op = info->shadow[id].req.operation;
+		if (op == BLKIF_OP_INDIRECT)
+			op = info->shadow[id].req.u.indirect.indirect_op;
+		if (bret.operation != op) {
+			pr_alert("%s: response has wrong operation (%u instead of %u)\n",
+				 info->gd->disk_name, bret.operation, op);
+			goto err;
+		}
+
 		if (bret.operation != BLKIF_OP_DISCARD)
 			blkif_completion(&info->shadow[id], info, &bret);
 
@@ -1361,7 +1385,8 @@ static irqreturn_t blkif_interrupt(int i
 		case BLKIF_OP_DISCARD:
 			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
-				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
+
+				pr_warn_ratelimited("blkfront: %s: %s op failed\n",
 					   info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 				info->feature_discard = 0;
@@ -1374,13 +1399,13 @@ static irqreturn_t blkif_interrupt(int i
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
-				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
+				pr_warn_ratelimited("blkfront: %s: %s op failed\n",
 				       info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(bret.status == BLKIF_RSP_ERROR &&
 				     info->shadow[id].req.u.rw.nr_segments == 0)) {
-				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
+				pr_warn_ratelimited("blkfront: %s: empty %s op failed\n",
 				       info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 			}
@@ -1394,8 +1419,9 @@ static irqreturn_t blkif_interrupt(int i
 		case BLKIF_OP_READ:
 		case BLKIF_OP_WRITE:
 			if (unlikely(bret.status != BLKIF_RSP_OKAY))
-				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
-					"request: %x\n", bret.status);
+				dev_dbg_ratelimited(&info->xbdev->dev,
+					"Bad return from blkdev data request: %x\n",
+					bret.status);
 
 			blk_mq_complete_request(req, error);
 			break;
@@ -1419,6 +1445,14 @@ static irqreturn_t blkif_interrupt(int i
 	spin_unlock_irqrestore(&info->io_lock, flags);
 
 	return IRQ_HANDLED;
+
+ err:
+	info->connected = BLKIF_STATE_ERROR;
+
+	spin_unlock_irqrestore(&info->io_lock, flags);
+
+	pr_alert("%s disabled for further use\n", info->gd->disk_name);
+	return IRQ_HANDLED;
 }
 
 
@@ -1928,6 +1962,7 @@ out_of_memory:
 		info->shadow[i].sg = NULL;
 		kfree(info->shadow[i].indirect_grants);
 		info->shadow[i].indirect_grants = NULL;
+		info->shadow[i].inflight = false;
 	}
 	if (!list_empty(&info->indirect_pages)) {
 		struct page *indirect_page, *n;


