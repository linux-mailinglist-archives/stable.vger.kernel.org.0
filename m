Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A626124B33F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgHTJnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbgHTJmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:42:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0A420724;
        Thu, 20 Aug 2020 09:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916525;
        bh=9zn7Db9w62ApQpABObHu79a6WnMP7YzYnfd/TNvQ3qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRRBUw0v68aq1PkArlkpqSi5u1DV0//Q4UXGCzFrPzgvzloj6kAiMwvn2U1xOAfUr
         BuoxYKxs71KJxpZC8s18eLhtn9gfbD74L4Yc+5hPJ4sglbd27QO46W0qAjnI/63Hea
         +xij9RkQE+toyjcxf4/7bZnzenKcc5iMmxig/MEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 129/204] gpu: ipu-v3: image-convert: Wait for all EOFs before completing a tile
Date:   Thu, 20 Aug 2020 11:20:26 +0200
Message-Id: <20200820091612.724794122@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

[ Upstream commit dd81d821d0b3f77d949d0cac5c05c1f05b921d46 ]

Use a bit-mask of EOF irqs to determine when all required idmac
channel EOFs have been received for a tile conversion, and only do
tile completion processing after all EOFs have been received. Otherwise
it was found that a conversion would stall after the completion of a
tile and the start of the next tile, because the input/read idmac
channel had not completed and entered idle state, thus locking up the
channel when attempting to re-start it for the next tile.

Fixes: 0537db801bb01 ("gpu: ipu-v3: image-convert: reconfigure IC per tile")
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 109 +++++++++++++++++++------
 1 file changed, 82 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index f8b031ded3cf2..aa1d4b6d278f7 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -137,6 +137,17 @@ struct ipu_image_convert_ctx;
 struct ipu_image_convert_chan;
 struct ipu_image_convert_priv;
 
+enum eof_irq_mask {
+	EOF_IRQ_IN      = BIT(0),
+	EOF_IRQ_ROT_IN  = BIT(1),
+	EOF_IRQ_OUT     = BIT(2),
+	EOF_IRQ_ROT_OUT = BIT(3),
+};
+
+#define EOF_IRQ_COMPLETE (EOF_IRQ_IN | EOF_IRQ_OUT)
+#define EOF_IRQ_ROT_COMPLETE (EOF_IRQ_IN | EOF_IRQ_OUT |	\
+			      EOF_IRQ_ROT_IN | EOF_IRQ_ROT_OUT)
+
 struct ipu_image_convert_ctx {
 	struct ipu_image_convert_chan *chan;
 
@@ -173,6 +184,9 @@ struct ipu_image_convert_ctx {
 	/* where to place converted tile in dest image */
 	unsigned int out_tile_map[MAX_TILES];
 
+	/* mask of completed EOF irqs at every tile conversion */
+	enum eof_irq_mask eof_mask;
+
 	struct list_head list;
 };
 
@@ -189,6 +203,8 @@ struct ipu_image_convert_chan {
 	struct ipuv3_channel *rotation_out_chan;
 
 	/* the IPU end-of-frame irqs */
+	int in_eof_irq;
+	int rot_in_eof_irq;
 	int out_eof_irq;
 	int rot_out_eof_irq;
 
@@ -1380,6 +1396,9 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 	dev_dbg(priv->ipu->dev, "%s: task %u: starting ctx %p run %p tile %u -> %u\n",
 		__func__, chan->ic_task, ctx, run, tile, dst_tile);
 
+	/* clear EOF irq mask */
+	ctx->eof_mask = 0;
+
 	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
 		/* swap width/height for resizer */
 		dest_width = d_image->tile[dst_tile].height;
@@ -1615,7 +1634,7 @@ static bool ic_settings_changed(struct ipu_image_convert_ctx *ctx)
 }
 
 /* hold irqlock when calling */
-static irqreturn_t do_irq(struct ipu_image_convert_run *run)
+static irqreturn_t do_tile_complete(struct ipu_image_convert_run *run)
 {
 	struct ipu_image_convert_ctx *ctx = run->ctx;
 	struct ipu_image_convert_chan *chan = ctx->chan;
@@ -1700,6 +1719,7 @@ static irqreturn_t do_irq(struct ipu_image_convert_run *run)
 		ctx->cur_buf_num ^= 1;
 	}
 
+	ctx->eof_mask = 0; /* clear EOF irq mask for next tile */
 	ctx->next_tile++;
 	return IRQ_HANDLED;
 done:
@@ -1715,8 +1735,9 @@ static irqreturn_t eof_irq(int irq, void *data)
 	struct ipu_image_convert_priv *priv = chan->priv;
 	struct ipu_image_convert_ctx *ctx;
 	struct ipu_image_convert_run *run;
+	irqreturn_t ret = IRQ_HANDLED;
+	bool tile_complete = false;
 	unsigned long flags;
-	irqreturn_t ret;
 
 	spin_lock_irqsave(&chan->irqlock, flags);
 
@@ -1729,27 +1750,33 @@ static irqreturn_t eof_irq(int irq, void *data)
 
 	ctx = run->ctx;
 
-	if (irq == chan->out_eof_irq) {
-		if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
-			/* this is a rotation op, just ignore */
-			ret = IRQ_HANDLED;
-			goto out;
-		}
-	} else if (irq == chan->rot_out_eof_irq) {
+	if (irq == chan->in_eof_irq) {
+		ctx->eof_mask |= EOF_IRQ_IN;
+	} else if (irq == chan->out_eof_irq) {
+		ctx->eof_mask |= EOF_IRQ_OUT;
+	} else if (irq == chan->rot_in_eof_irq ||
+		   irq == chan->rot_out_eof_irq) {
 		if (!ipu_rot_mode_is_irt(ctx->rot_mode)) {
 			/* this was NOT a rotation op, shouldn't happen */
 			dev_err(priv->ipu->dev,
 				"Unexpected rotation interrupt\n");
-			ret = IRQ_HANDLED;
 			goto out;
 		}
+		ctx->eof_mask |= (irq == chan->rot_in_eof_irq) ?
+			EOF_IRQ_ROT_IN : EOF_IRQ_ROT_OUT;
 	} else {
 		dev_err(priv->ipu->dev, "Received unknown irq %d\n", irq);
 		ret = IRQ_NONE;
 		goto out;
 	}
 
-	ret = do_irq(run);
+	if (ipu_rot_mode_is_irt(ctx->rot_mode))
+		tile_complete =	(ctx->eof_mask == EOF_IRQ_ROT_COMPLETE);
+	else
+		tile_complete = (ctx->eof_mask == EOF_IRQ_COMPLETE);
+
+	if (tile_complete)
+		ret = do_tile_complete(run);
 out:
 	spin_unlock_irqrestore(&chan->irqlock, flags);
 	return ret;
@@ -1783,6 +1810,10 @@ static void force_abort(struct ipu_image_convert_ctx *ctx)
 
 static void release_ipu_resources(struct ipu_image_convert_chan *chan)
 {
+	if (chan->in_eof_irq >= 0)
+		free_irq(chan->in_eof_irq, chan);
+	if (chan->rot_in_eof_irq >= 0)
+		free_irq(chan->rot_in_eof_irq, chan);
 	if (chan->out_eof_irq >= 0)
 		free_irq(chan->out_eof_irq, chan);
 	if (chan->rot_out_eof_irq >= 0)
@@ -1801,7 +1832,27 @@ static void release_ipu_resources(struct ipu_image_convert_chan *chan)
 
 	chan->in_chan = chan->out_chan = chan->rotation_in_chan =
 		chan->rotation_out_chan = NULL;
-	chan->out_eof_irq = chan->rot_out_eof_irq = -1;
+	chan->in_eof_irq = -1;
+	chan->rot_in_eof_irq = -1;
+	chan->out_eof_irq = -1;
+	chan->rot_out_eof_irq = -1;
+}
+
+static int get_eof_irq(struct ipu_image_convert_chan *chan,
+		       struct ipuv3_channel *channel)
+{
+	struct ipu_image_convert_priv *priv = chan->priv;
+	int ret, irq;
+
+	irq = ipu_idmac_channel_irq(priv->ipu, channel, IPU_IRQ_EOF);
+
+	ret = request_threaded_irq(irq, eof_irq, do_bh, 0, "ipu-ic", chan);
+	if (ret < 0) {
+		dev_err(priv->ipu->dev, "could not acquire irq %d\n", irq);
+		return ret;
+	}
+
+	return irq;
 }
 
 static int get_ipu_resources(struct ipu_image_convert_chan *chan)
@@ -1837,31 +1888,33 @@ static int get_ipu_resources(struct ipu_image_convert_chan *chan)
 	}
 
 	/* acquire the EOF interrupts */
-	chan->out_eof_irq = ipu_idmac_channel_irq(priv->ipu,
-						  chan->out_chan,
-						  IPU_IRQ_EOF);
+	ret = get_eof_irq(chan, chan->in_chan);
+	if (ret < 0) {
+		chan->in_eof_irq = -1;
+		goto err;
+	}
+	chan->in_eof_irq = ret;
 
-	ret = request_threaded_irq(chan->out_eof_irq, eof_irq, do_bh,
-				   0, "ipu-ic", chan);
+	ret = get_eof_irq(chan, chan->rotation_in_chan);
 	if (ret < 0) {
-		dev_err(priv->ipu->dev, "could not acquire irq %d\n",
-			 chan->out_eof_irq);
-		chan->out_eof_irq = -1;
+		chan->rot_in_eof_irq = -1;
 		goto err;
 	}
+	chan->rot_in_eof_irq = ret;
 
-	chan->rot_out_eof_irq = ipu_idmac_channel_irq(priv->ipu,
-						     chan->rotation_out_chan,
-						     IPU_IRQ_EOF);
+	ret = get_eof_irq(chan, chan->out_chan);
+	if (ret < 0) {
+		chan->out_eof_irq = -1;
+		goto err;
+	}
+	chan->out_eof_irq = ret;
 
-	ret = request_threaded_irq(chan->rot_out_eof_irq, eof_irq, do_bh,
-				   0, "ipu-ic", chan);
+	ret = get_eof_irq(chan, chan->rotation_out_chan);
 	if (ret < 0) {
-		dev_err(priv->ipu->dev, "could not acquire irq %d\n",
-			chan->rot_out_eof_irq);
 		chan->rot_out_eof_irq = -1;
 		goto err;
 	}
+	chan->rot_out_eof_irq = ret;
 
 	return 0;
 err:
@@ -2440,6 +2493,8 @@ int ipu_image_convert_init(struct ipu_soc *ipu, struct device *dev)
 		chan->ic_task = i;
 		chan->priv = priv;
 		chan->dma_ch = &image_convert_dma_chan[i];
+		chan->in_eof_irq = -1;
+		chan->rot_in_eof_irq = -1;
 		chan->out_eof_irq = -1;
 		chan->rot_out_eof_irq = -1;
 
-- 
2.25.1



