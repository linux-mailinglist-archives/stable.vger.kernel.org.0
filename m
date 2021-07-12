Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA4E3C523F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbhGLHpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244254AbhGLHmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 829D661107;
        Mon, 12 Jul 2021 07:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075574;
        bh=K3uzl1plUp1aL0N8nM0i7W9fK3+fbytkaUqHg6ZS26Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kN1zrKU+DeXbbs3DufMmt7MN7Z/pQepH8yAqdXusKVYtg7YitCnMjKlP4lVKWP1So
         JTDa4lNnEhrQD29zF1HAQe3DtL0QmRHbOiXt1jbhiRxWKny1+mLWfRx1pZvxDsNzyZ
         wGaV3S/1/N1mPETr9CsdCORevLXROQTFJBj6C6TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 272/800] media: hantro: do a PM resume earlier
Date:   Mon, 12 Jul 2021 08:04:55 +0200
Message-Id: <20210712060953.163870909@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 892bb6ecead9b834ba7ad1d07513e9eba1baa3a4 ]

The device_run() first enables the clock and then
tries to resume PM runtime, checking for errors.

Well, if for some reason the pm_runtime can not resume,
it would be better to detect it beforehand.

So, change the order inside device_run().

Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Fixes: 775fec69008d ("media: add Rockchip VPU JPEG encoder driver")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_drv.c | 33 +++++++++++++++--------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index 595e82a82728..eea2009fa17b 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -56,16 +56,12 @@ dma_addr_t hantro_get_ref(struct hantro_ctx *ctx, u64 ts)
 	return hantro_get_dec_buf_addr(ctx, buf);
 }
 
-static void hantro_job_finish(struct hantro_dev *vpu,
-			      struct hantro_ctx *ctx,
-			      enum vb2_buffer_state result)
+static void hantro_job_finish_no_pm(struct hantro_dev *vpu,
+				    struct hantro_ctx *ctx,
+				    enum vb2_buffer_state result)
 {
 	struct vb2_v4l2_buffer *src, *dst;
 
-	pm_runtime_mark_last_busy(vpu->dev);
-	pm_runtime_put_autosuspend(vpu->dev);
-	clk_bulk_disable(vpu->variant->num_clocks, vpu->clocks);
-
 	src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
@@ -81,6 +77,18 @@ static void hantro_job_finish(struct hantro_dev *vpu,
 					 result);
 }
 
+static void hantro_job_finish(struct hantro_dev *vpu,
+			      struct hantro_ctx *ctx,
+			      enum vb2_buffer_state result)
+{
+	pm_runtime_mark_last_busy(vpu->dev);
+	pm_runtime_put_autosuspend(vpu->dev);
+
+	clk_bulk_disable(vpu->variant->num_clocks, vpu->clocks);
+
+	hantro_job_finish_no_pm(vpu, ctx, result);
+}
+
 void hantro_irq_done(struct hantro_dev *vpu,
 		     enum vb2_buffer_state result)
 {
@@ -152,12 +160,15 @@ static void device_run(void *priv)
 	src = hantro_get_src_buf(ctx);
 	dst = hantro_get_dst_buf(ctx);
 
+	ret = pm_runtime_get_sync(ctx->dev->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(ctx->dev->dev);
+		goto err_cancel_job;
+	}
+
 	ret = clk_bulk_enable(ctx->dev->variant->num_clocks, ctx->dev->clocks);
 	if (ret)
 		goto err_cancel_job;
-	ret = pm_runtime_get_sync(ctx->dev->dev);
-	if (ret < 0)
-		goto err_cancel_job;
 
 	v4l2_m2m_buf_copy_metadata(src, dst, true);
 
@@ -165,7 +176,7 @@ static void device_run(void *priv)
 	return;
 
 err_cancel_job:
-	hantro_job_finish(ctx->dev, ctx, VB2_BUF_STATE_ERROR);
+	hantro_job_finish_no_pm(ctx->dev, ctx, VB2_BUF_STATE_ERROR);
 }
 
 static struct v4l2_m2m_ops vpu_m2m_ops = {
-- 
2.30.2



