Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF979469A3E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345585AbhLFPGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344927AbhLFPFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7CFC07E5E4;
        Mon,  6 Dec 2021 07:02:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB1E7B8111A;
        Mon,  6 Dec 2021 15:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F69C341C1;
        Mon,  6 Dec 2021 15:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802932;
        bh=jBAktePyEPZ7+Hrl5aR77ofeN77bF15tRHc0726jft0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6dSETOH03r1tDc199vflIXhLoYyQB4bzwADO67TdmH3tSAk7ZROe/gmMnVEbfCqC
         tauOdnxDCMpjVSk7Iqorvsn/F0bIb451bbd/hVreroV9WViGhibswMVh6fyMjJXUh7
         tkZ6Zd6d96l84kIe7BOO5LExlW+E+qNbuWoKlllQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 4.9 31/62] xen/blkfront: dont trust the backend response data blindly
Date:   Mon,  6 Dec 2021 15:56:14 +0100
Message-Id: <20211206145550.244254385@linuxfoundation.org>
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
 drivers/block/xen-blkfront.c |   70 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 17 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -78,6 +78,7 @@ enum blkif_state {
 	BLKIF_STATE_DISCONNECTED,
 	BLKIF_STATE_CONNECTED,
 	BLKIF_STATE_SUSPENDED,
+	BLKIF_STATE_ERROR,
 };
 
 struct grant {
@@ -87,6 +88,7 @@ struct grant {
 };
 
 enum blk_req_status {
+	REQ_PROCESSING,
 	REQ_WAITING,
 	REQ_DONE,
 	REQ_ERROR,
@@ -529,7 +531,7 @@ static unsigned long blkif_ring_get_requ
 
 	id = get_id_from_freelist(rinfo);
 	rinfo->shadow[id].request = req;
-	rinfo->shadow[id].status = REQ_WAITING;
+	rinfo->shadow[id].status = REQ_PROCESSING;
 	rinfo->shadow[id].associated_id = NO_ASSOCIATED_ID;
 
 	rinfo->shadow[id].req.u.rw.id = id;
@@ -558,6 +560,7 @@ static int blkif_queue_discard_req(struc
 
 	/* Copy the request to the ring page. */
 	*final_ring_req = *ring_req;
+	rinfo->shadow[id].status = REQ_WAITING;
 
 	return 0;
 }
@@ -830,8 +833,11 @@ static int blkif_queue_rw_req(struct req
 
 	/* Copy request(s) to the ring page. */
 	*final_ring_req = *ring_req;
-	if (unlikely(require_extra_req))
+	rinfo->shadow[id].status = REQ_WAITING;
+	if (unlikely(require_extra_req)) {
 		*final_extra_ring_req = *extra_ring_req;
+		rinfo->shadow[extra_id].status = REQ_WAITING;
+	}
 
 	if (max_grefs > 0)
 		gnttab_free_grant_references(setup.gref_head);
@@ -1401,8 +1407,8 @@ static enum blk_req_status blkif_rsp_to_
 static int blkif_get_final_status(enum blk_req_status s1,
 				  enum blk_req_status s2)
 {
-	BUG_ON(s1 == REQ_WAITING);
-	BUG_ON(s2 == REQ_WAITING);
+	BUG_ON(s1 < REQ_DONE);
+	BUG_ON(s2 < REQ_DONE);
 
 	if (s1 == REQ_ERROR || s2 == REQ_ERROR)
 		return BLKIF_RSP_ERROR;
@@ -1435,7 +1441,7 @@ static bool blkif_completion(unsigned lo
 		s->status = blkif_rsp_to_req_status(bret->status);
 
 		/* Wait the second response if not yet here. */
-		if (s2->status == REQ_WAITING)
+		if (s2->status < REQ_DONE)
 			return 0;
 
 		bret->status = blkif_get_final_status(s->status,
@@ -1555,11 +1561,17 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_lock_irqsave(&rinfo->ring_lock, flags);
  again:
-	rp = rinfo->ring.sring->rsp_prod;
-	rmb(); /* Ensure we see queued responses up to 'rp'. */
+	rp = READ_ONCE(rinfo->ring.sring->rsp_prod);
+	virt_rmb(); /* Ensure we see queued responses up to 'rp'. */
+	if (RING_RESPONSE_PROD_OVERFLOW(&rinfo->ring, rp)) {
+		pr_alert("%s: illegal number of responses %u\n",
+			 info->gd->disk_name, rp - rinfo->ring.rsp_cons);
+		goto err;
+	}
 
 	for (i = rinfo->ring.rsp_cons; i != rp; i++) {
 		unsigned long id;
+		unsigned int op;
 
 		RING_COPY_RESPONSE(&rinfo->ring, i, &bret);
 		id = bret.id;
@@ -1570,14 +1582,28 @@ static irqreturn_t blkif_interrupt(int i
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
+		if (rinfo->shadow[id].status != REQ_WAITING) {
+			pr_alert("%s: response references no pending request\n",
+				 info->gd->disk_name);
+			goto err;
 		}
+
+		rinfo->shadow[id].status = REQ_PROCESSING;
 		req  = rinfo->shadow[id].request;
 
+		op = rinfo->shadow[id].req.operation;
+		if (op == BLKIF_OP_INDIRECT)
+			op = rinfo->shadow[id].req.u.indirect.indirect_op;
+		if (bret.operation != op) {
+			pr_alert("%s: response has wrong operation (%u instead of %u)\n",
+				 info->gd->disk_name, bret.operation, op);
+			goto err;
+		}
+
 		if (bret.operation != BLKIF_OP_DISCARD) {
 			/*
 			 * We may need to wait for an extra response if the
@@ -1598,7 +1624,8 @@ static irqreturn_t blkif_interrupt(int i
 		case BLKIF_OP_DISCARD:
 			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
-				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
+
+				pr_warn_ratelimited("blkfront: %s: %s op failed\n",
 					   info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 				info->feature_discard = 0;
@@ -1611,13 +1638,13 @@ static irqreturn_t blkif_interrupt(int i
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret.status == BLKIF_RSP_EOPNOTSUPP)) {
-				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
+				pr_warn_ratelimited("blkfront: %s: %s op failed\n",
 				       info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(bret.status == BLKIF_RSP_ERROR &&
 				     rinfo->shadow[id].req.u.rw.nr_segments == 0)) {
-				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
+				pr_warn_ratelimited("blkfront: %s: empty %s op failed\n",
 				       info->gd->disk_name, op_name(bret.operation));
 				error = -EOPNOTSUPP;
 			}
@@ -1632,8 +1659,9 @@ static irqreturn_t blkif_interrupt(int i
 		case BLKIF_OP_READ:
 		case BLKIF_OP_WRITE:
 			if (unlikely(bret.status != BLKIF_RSP_OKAY))
-				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
-					"request: %x\n", bret.status);
+				dev_dbg_ratelimited(&info->xbdev->dev,
+					"Bad return from blkdev data request: %#x\n",
+					bret.status);
 
 			blk_mq_complete_request(req, error);
 			break;
@@ -1657,6 +1685,14 @@ static irqreturn_t blkif_interrupt(int i
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 
 	return IRQ_HANDLED;
+
+ err:
+	info->connected = BLKIF_STATE_ERROR;
+
+	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
+
+	pr_alert("%s disabled for further use\n", info->gd->disk_name);
+	return IRQ_HANDLED;
 }
 
 


