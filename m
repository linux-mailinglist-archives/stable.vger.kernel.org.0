Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7FA4622F4
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhK2VJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbhK2VHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:07:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA964C125329;
        Mon, 29 Nov 2021 10:27:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B224DB815E0;
        Mon, 29 Nov 2021 18:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE559C53FCD;
        Mon, 29 Nov 2021 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210428;
        bh=i/9SKJcRfYOYxn9q99qoi6kb9ad2vbPLVHg8GLiHAg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRNOs0X6U4rMNr6pwAXtXiEJNEtn9FEv4mqD6ZNGEQY4oBbt2tP1nDsNL3GFQMhJs
         wfRXqfSRHRsIHY7FdzUSHSdNKoJ6cSDaCwV8vZu6+z7+/pfKpZ+fmnLFRIBA+Rzzco
         CrvpP9oxhx8GkyIfcoZWmIMhdTzHjhNgPPihpRNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 5.4 85/92] xen/blkfront: read response from backend only once
Date:   Mon, 29 Nov 2021 19:18:54 +0100
Message-Id: <20211129181710.230223831@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
@@ -1549,7 +1549,7 @@ static bool blkif_completion(unsigned lo
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 {
 	struct request *req;
-	struct blkif_response *bret;
+	struct blkif_response bret;
 	RING_IDX i, rp;
 	unsigned long flags;
 	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
@@ -1566,8 +1566,9 @@ static irqreturn_t blkif_interrupt(int i
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
@@ -1575,39 +1576,39 @@ static irqreturn_t blkif_interrupt(int i
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
 
-		if (bret->status == BLKIF_RSP_OKAY)
+		if (bret.status == BLKIF_RSP_OKAY)
 			blkif_req(req)->error = BLK_STS_OK;
 		else
 			blkif_req(req)->error = BLK_STS_IOERR;
 
-		switch (bret->operation) {
+		switch (bret.operation) {
 		case BLKIF_OP_DISCARD:
-			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
+			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
-					   info->gd->disk_name, op_name(bret->operation));
+					   info->gd->disk_name, op_name(bret.operation));
 				blkif_req(req)->error = BLK_STS_NOTSUPP;
 				info->feature_discard = 0;
 				info->feature_secdiscard = 0;
@@ -1617,15 +1618,15 @@ static irqreturn_t blkif_interrupt(int i
 			break;
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
-			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
+			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
-				       info->gd->disk_name, op_name(bret->operation));
+				       info->gd->disk_name, op_name(bret.operation));
 				blkif_req(req)->error = BLK_STS_NOTSUPP;
 			}
-			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
+			if (unlikely(bret.status == BLKIF_RSP_ERROR &&
 				     rinfo->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
-				       info->gd->disk_name, op_name(bret->operation));
+				       info->gd->disk_name, op_name(bret.operation));
 				blkif_req(req)->error = BLK_STS_NOTSUPP;
 			}
 			if (unlikely(blkif_req(req)->error)) {
@@ -1638,9 +1639,9 @@ static irqreturn_t blkif_interrupt(int i
 			/* fall through */
 		case BLKIF_OP_READ:
 		case BLKIF_OP_WRITE:
-			if (unlikely(bret->status != BLKIF_RSP_OKAY))
+			if (unlikely(bret.status != BLKIF_RSP_OKAY))
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
-					"request: %x\n", bret->status);
+					"request: %x\n", bret.status);
 
 			break;
 		default:


