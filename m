Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1819469A36
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbhLFPGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:06:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37802 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345735AbhLFPFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 294ABB81017;
        Mon,  6 Dec 2021 15:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDE9C341C1;
        Mon,  6 Dec 2021 15:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802926;
        bh=2yQiW1tdxikI+ykPrJeHmnKKuAFSA4tfRbufHW3P9Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WE4AXjB56PxcyLj30qU7Sr93jC3aLmZ1jG+Y7EWWiGn/bgLGezI6Fny+fF3gJKkK9
         HmygpHHgYWrORM+CDPDmBgndfy0FhC1CKK2FkVZq5jxNMNxIG5K6Cch2WaIfbKzudK
         KeatrzmuWTD+KGsW57eQJ1CQmw2YFWR/QWwda+j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 4.9 29/62] xen/blkfront: read response from backend only once
Date:   Mon,  6 Dec 2021 15:56:12 +0100
Message-Id: <20211206145550.183263611@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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
@@ -1538,7 +1538,7 @@ static bool blkif_completion(unsigned lo
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 {
 	struct request *req;
-	struct blkif_response *bret;
+	struct blkif_response bret;
 	RING_IDX i, rp;
 	unsigned long flags;
 	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
@@ -1556,8 +1556,9 @@ static irqreturn_t blkif_interrupt(int i
 	for (i = rinfo->ring.rsp_cons; i != rp; i++) {
 		unsigned long id;
 
-		bret = RING_GET_RESPONSE(&rinfo->ring, i);
-		id   = bret->id;
+		RING_COPY_RESPONSE(&rinfo->ring, i, &bret);
+		id = bret.id;
+
 		/*
 		 * The backend has messed up and given us an id that we would
 		 * never have given to it (we stamp it up to BLK_RING_SIZE -
@@ -1565,35 +1566,35 @@ static irqreturn_t blkif_interrupt(int i
 		 */
 		if (id >= BLK_RING_SIZE(info)) {
 			WARN(1, "%s: response to %s has incorrect id (%ld)\n",
-			     info->gd->disk_name, op_name(bret->operation), id);
+			     info->gd->disk_name, op_name(bret.operation), id);
 			/* We can't safely get the 'struct request' as
 			 * the id is busted. */
 			continue;
 		}
 		req  = rinfo->shadow[id].request;
 
-		if (bret->operation != BLKIF_OP_DISCARD) {
+		if (bret.operation != BLKIF_OP_DISCARD) {
 			/*
 			 * We may need to wait for an extra response if the
 			 * I/O request is split in 2
 			 */
-			if (!blkif_completion(&id, rinfo, bret))
+			if (!blkif_completion(&id, rinfo, &bret))
 				continue;
 		}
 
 		if (add_id_to_freelist(rinfo, id)) {
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
@@ -1604,15 +1605,15 @@ static irqreturn_t blkif_interrupt(int i
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
 				     rinfo->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
-				       info->gd->disk_name, op_name(bret->operation));
+				       info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(error)) {
@@ -1625,9 +1626,9 @@ static irqreturn_t blkif_interrupt(int i
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


