Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D764699C1
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345377AbhLFPDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345097AbhLFPC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:02:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7248AC0611F7;
        Mon,  6 Dec 2021 06:59:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B8D4B8110C;
        Mon,  6 Dec 2021 14:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2DDC341C2;
        Mon,  6 Dec 2021 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802766;
        bh=+Wy/6HLzOQc95Ah+cNm7QcwzJPo5GSxm4AfS01jHXMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yaktPmjINpAVb+nHtH/HCC1TmQR8SPFxFYFhkin5OUtZ50N5WS6hEIklhQcg9flv5
         4a8hMLCJTxl19+xwOv2/fXOiz7tVK1OFNKSfsowvZo9tp/KNjdmvUBav83HQ/l+wqR
         eq4bwTi9O+8SgSEsmz8Oc9STaqkGDtwROymml4VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 4.4 26/52] xen/blkfront: read response from backend only once
Date:   Mon,  6 Dec 2021 15:56:10 +0100
Message-Id: <20211206145548.780741851@linuxfoundation.org>
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

commit 71b66243f9898d0e54296b4e7035fb33cdcb0707 upstream.

In order to avoid problems in case the backend is modifying a response
on the ring page while the frontend has already seen it, just read the
response into a local buffer in one go and then operate on that buffer
only.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Link: https://lore.kernel.org/r/20210730103854.12681-2-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1296,7 +1296,7 @@ static void blkif_completion(struct blk_
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 {
 	struct request *req;
-	struct blkif_response *bret;
+	struct blkif_response bret;
 	RING_IDX i, rp;
 	unsigned long flags;
 	struct blkfront_info *info = (struct blkfront_info *)dev_id;
@@ -1316,8 +1316,9 @@ static irqreturn_t blkif_interrupt(int i
 	for (i = info->ring.rsp_cons; i != rp; i++) {
 		unsigned long id;
 
-		bret = RING_GET_RESPONSE(&info->ring, i);
-		id   = bret->id;
+		RING_COPY_RESPONSE(&info->ring, i, &bret);
+		id   = bret.id;
+
 		/*
 		 * The backend has messed up and given us an id that we would
 		 * never have given to it (we stamp it up to BLK_RING_SIZE -
@@ -1325,29 +1326,29 @@ static irqreturn_t blkif_interrupt(int i
 		 */
 		if (id >= BLK_RING_SIZE(info)) {
 			WARN(1, "%s: response to %s has incorrect id (%ld)\n",
-			     info->gd->disk_name, op_name(bret->operation), id);
+			     info->gd->disk_name, op_name(bret.operation), id);
 			/* We can't safely get the 'struct request' as
 			 * the id is busted. */
 			continue;
 		}
 		req  = info->shadow[id].request;
 
-		if (bret->operation != BLKIF_OP_DISCARD)
-			blkif_completion(&info->shadow[id], info, bret);
+		if (bret.operation != BLKIF_OP_DISCARD)
+			blkif_completion(&info->shadow[id], info, &bret);
 
 		if (add_id_to_freelist(info, id)) {
 			WARN(1, "%s: response to %s (id %ld) couldn't be recycled!\n",
-			     info->gd->disk_name, op_name(bret->operation), id);
+			     info->gd->disk_name, op_name(bret.operation), id);
 			continue;
 		}
 
-		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
-		switch (bret->operation) {
+		error = (bret.status == BLKIF_RSP_OKAY) ? 0 : -EIO;
+		switch (bret.operation) {
 		case BLKIF_OP_DISCARD:
-			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
+			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
-					   info->gd->disk_name, op_name(bret->operation));
+					   info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 				info->feature_discard = 0;
 				info->feature_secdiscard = 0;
@@ -1358,15 +1359,15 @@ static irqreturn_t blkif_interrupt(int i
 			break;
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
-			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
+			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
-				       info->gd->disk_name, op_name(bret->operation));
+				       info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 			}
-			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
+			if (unlikely(bret.status == BLKIF_RSP_ERROR &&
 				     info->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
-				       info->gd->disk_name, op_name(bret->operation));
+				       info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(error)) {
@@ -1378,9 +1379,9 @@ static irqreturn_t blkif_interrupt(int i
 			/* fall through */
 		case BLKIF_OP_READ:
 		case BLKIF_OP_WRITE:
-			if (unlikely(bret->status != BLKIF_RSP_OKAY))
+			if (unlikely(bret.status != BLKIF_RSP_OKAY))
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
-					"request: %x\n", bret->status);
+					"request: %x\n", bret.status);
 
 			blk_mq_complete_request(req, error);
 			break;


