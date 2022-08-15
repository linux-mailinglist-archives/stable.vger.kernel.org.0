Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE76059385B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343743AbiHOTMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344175AbiHOTLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:11:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BFF501B9;
        Mon, 15 Aug 2022 11:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95998B81082;
        Mon, 15 Aug 2022 18:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C38C433D7;
        Mon, 15 Aug 2022 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588638;
        bh=N3qyH8pGWQC5ePmuhX+7tI2CgB4S9Qep2kWgA+wiwOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD5MI6sUqQZ4lyiBUL514vQ9H35/P3bZlWIxj0zrboqzAoCNTeQHgPuqeLdWpzDQ0
         l2Cd0b5xwhhETT8xaM2qz39je8LsE4JwZS2+KzJY0QagJaj6pvfNwppuP2jn6j93ps
         TjAhaMcisxaQ0rs+vWgf/GLWWQ5LAURKWnITHyww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Viacheslav Mitrofanov <v.v.mitrofanov@yadro.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 468/779] dmaengine: sf-pdma: Add multithread support for a DMA channel
Date:   Mon, 15 Aug 2022 20:01:52 +0200
Message-Id: <20220815180357.300353993@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viacheslav Mitrofanov <v.v.mitrofanov@yadro.com>

[ Upstream commit b2cc5c465c2cb8ab697c3fd6583c614e3f6cfbcc ]

When we get a DMA channel and try to use it in multiple threads it
will cause oops and hanging the system.

% echo 64 > /sys/module/dmatest/parameters/threads_per_chan
% echo 10000 > /sys/module/dmatest/parameters/iterations
% echo 1 > /sys/module/dmatest/parameters/run
[   89.480664] Unable to handle kernel NULL pointer dereference at virtual
               address 00000000000000a0
[   89.488725] Oops [#1]
[   89.494708] CPU: 2 PID: 1008 Comm: dma0chan0-copy0 Not tainted
               5.17.0-rc5
[   89.509385] epc : vchan_find_desc+0x32/0x46
[   89.513553]  ra : sf_pdma_tx_status+0xca/0xd6

This happens because of data race. Each thread rewrite channels's
descriptor as soon as device_prep_dma_memcpy() is called. It leads to the
situation when the driver thinks that it uses right descriptor that
actually is freed or substituted for other one.

With current fixes a descriptor changes its value only when it has
been used. A new descriptor is acquired from vc->desc_issued queue that
is already filled with descriptors that are ready to be sent. Threads
have no direct access to DMA channel descriptor. Now it is just possible
to queue a descriptor for further processing.

Fixes: 6973886ad58e ("dmaengine: sf-pdma: add platform DMA support for HiFive Unleashed A00")
Signed-off-by: Viacheslav Mitrofanov <v.v.mitrofanov@yadro.com>
Link: https://lore.kernel.org/r/20220701082942.12835-1-v.v.mitrofanov@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sf-pdma/sf-pdma.c | 44 ++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/sf-pdma/sf-pdma.c b/drivers/dma/sf-pdma/sf-pdma.c
index f12606aeff87..ab0ad7a2f201 100644
--- a/drivers/dma/sf-pdma/sf-pdma.c
+++ b/drivers/dma/sf-pdma/sf-pdma.c
@@ -52,16 +52,6 @@ static inline struct sf_pdma_desc *to_sf_pdma_desc(struct virt_dma_desc *vd)
 static struct sf_pdma_desc *sf_pdma_alloc_desc(struct sf_pdma_chan *chan)
 {
 	struct sf_pdma_desc *desc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	if (chan->desc && !chan->desc->in_use) {
-		spin_unlock_irqrestore(&chan->lock, flags);
-		return chan->desc;
-	}
-
-	spin_unlock_irqrestore(&chan->lock, flags);
 
 	desc = kzalloc(sizeof(*desc), GFP_NOWAIT);
 	if (!desc)
@@ -111,7 +101,6 @@ sf_pdma_prep_dma_memcpy(struct dma_chan *dchan,	dma_addr_t dest, dma_addr_t src,
 	desc->async_tx = vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
 
 	spin_lock_irqsave(&chan->vchan.lock, iflags);
-	chan->desc = desc;
 	sf_pdma_fill_desc(desc, dest, src, len);
 	spin_unlock_irqrestore(&chan->vchan.lock, iflags);
 
@@ -170,11 +159,17 @@ static size_t sf_pdma_desc_residue(struct sf_pdma_chan *chan,
 	unsigned long flags;
 	u64 residue = 0;
 	struct sf_pdma_desc *desc;
-	struct dma_async_tx_descriptor *tx;
+	struct dma_async_tx_descriptor *tx = NULL;
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);
 
-	tx = &chan->desc->vdesc.tx;
+	list_for_each_entry(vd, &chan->vchan.desc_submitted, node)
+		if (vd->tx.cookie == cookie)
+			tx = &vd->tx;
+
+	if (!tx)
+		goto out;
+
 	if (cookie == tx->chan->completed_cookie)
 		goto out;
 
@@ -241,6 +236,19 @@ static void sf_pdma_enable_request(struct sf_pdma_chan *chan)
 	writel(v, regs->ctrl);
 }
 
+static struct sf_pdma_desc *sf_pdma_get_first_pending_desc(struct sf_pdma_chan *chan)
+{
+	struct virt_dma_chan *vchan = &chan->vchan;
+	struct virt_dma_desc *vdesc;
+
+	if (list_empty(&vchan->desc_issued))
+		return NULL;
+
+	vdesc = list_first_entry(&vchan->desc_issued, struct virt_dma_desc, node);
+
+	return container_of(vdesc, struct sf_pdma_desc, vdesc);
+}
+
 static void sf_pdma_xfer_desc(struct sf_pdma_chan *chan)
 {
 	struct sf_pdma_desc *desc = chan->desc;
@@ -268,8 +276,11 @@ static void sf_pdma_issue_pending(struct dma_chan *dchan)
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);
 
-	if (vchan_issue_pending(&chan->vchan) && chan->desc)
+	if (!chan->desc && vchan_issue_pending(&chan->vchan)) {
+		/* vchan_issue_pending has made a check that desc in not NULL */
+		chan->desc = sf_pdma_get_first_pending_desc(chan);
 		sf_pdma_xfer_desc(chan);
+	}
 
 	spin_unlock_irqrestore(&chan->vchan.lock, flags);
 }
@@ -298,6 +309,11 @@ static void sf_pdma_donebh_tasklet(struct tasklet_struct *t)
 	spin_lock_irqsave(&chan->vchan.lock, flags);
 	list_del(&chan->desc->vdesc.node);
 	vchan_cookie_complete(&chan->desc->vdesc);
+
+	chan->desc = sf_pdma_get_first_pending_desc(chan);
+	if (chan->desc)
+		sf_pdma_xfer_desc(chan);
+
 	spin_unlock_irqrestore(&chan->vchan.lock, flags);
 }
 
-- 
2.35.1



