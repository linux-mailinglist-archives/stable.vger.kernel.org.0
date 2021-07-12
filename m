Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9213C48F8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbhGLGlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238067AbhGLGjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF97C611CC;
        Mon, 12 Jul 2021 06:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071770;
        bh=doRM6/VhL8J0RB3pRps9gsAt4Q9KZsH/pNPxk8rpPK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0v3JCT4Y7HjrRUTXmpFGvJejGug15BHU8unPjoEw3qnvQsGCNh76tH5ZiBNcOGuxx
         EP+Eo3xPCYROFH5pmPg6HALs9yPWcjy9+aL9Qvkqa7cbXAbQ6ew3zKbqyIX6J7Z9dl
         HGVqHW+1ZE7bm4a7qMEK1RzE/Ewi6SNCW1VUHwW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/593] media: hantro: do a PM resume earlier
Date:   Mon, 12 Jul 2021 08:06:13 +0200
Message-Id: <20210712060906.351356730@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 3cd00cc0a364..7749ca9a8ebb 100644
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



