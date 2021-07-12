Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31C3C48DC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbhGLGlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236829AbhGLGhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:37:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95D686115C;
        Mon, 12 Jul 2021 06:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071638;
        bh=sLZqPd6icQY48axYyPkhPX8jqEK+TBD0MO81dgmceno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aasAgbpKl4POqzNrT0zkT4oKwZT3yd+LhictmEVi69dbD3sDVmqVUlewuz8PRW1Do
         CpL7w6Joj4iDrUHlGDpK/p7Z6Mcd6VHVWDQ96ckG/iEhKIlvzlXzsiv9mtIT1AufLj
         DMmGXEokloVeNUGYpeg0DHrRYfbgUTRqKviH3v2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/593] media: exynos4-is: fix pm_runtime_get_sync() usage count
Date:   Mon, 12 Jul 2021 08:04:32 +0200
Message-Id: <20210712060855.504602772@linuxfoundation.org>
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

[ Upstream commit 59f96244af9403ddf4810ec5c0fbe8920857634e ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.

On some places, this is ok, but on others the usage count
ended being unbalanced on failures.

Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

As a bonus, such function always return zero on success. So,
some code can be simplified.

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/fimc-capture.c   |  6 ++----
 drivers/media/platform/exynos4-is/fimc-is.c        |  4 ++--
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  3 +--
 drivers/media/platform/exynos4-is/fimc-isp.c       |  7 +++----
 drivers/media/platform/exynos4-is/fimc-lite.c      |  5 +++--
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  5 +----
 drivers/media/platform/exynos4-is/media-dev.c      |  9 +++------
 drivers/media/platform/exynos4-is/mipi-csis.c      | 10 ++++------
 8 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 6000a4e789ad..808b490c1910 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -478,11 +478,9 @@ static int fimc_capture_open(struct file *file)
 		goto unlock;
 
 	set_bit(ST_CAPT_BUSY, &fimc->state);
-	ret = pm_runtime_get_sync(&fimc->pdev->dev);
-	if (ret < 0) {
-		pm_runtime_put_sync(&fimc->pdev->dev);
+	ret = pm_runtime_resume_and_get(&fimc->pdev->dev);
+	if (ret < 0)
 		goto unlock;
-	}
 
 	ret = v4l2_fh_open(file);
 	if (ret) {
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 32ab01e89196..d26fa5967d82 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -828,9 +828,9 @@ static int fimc_is_probe(struct platform_device *pdev)
 			goto err_irq;
 	}
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
-		goto err_pm;
+		goto err_irq;
 
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 612b9872afc8..8d9dc597deaa 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -275,7 +275,7 @@ static int isp_video_open(struct file *file)
 	if (ret < 0)
 		goto unlock;
 
-	ret = pm_runtime_get_sync(&isp->pdev->dev);
+	ret = pm_runtime_resume_and_get(&isp->pdev->dev);
 	if (ret < 0)
 		goto rel_fh;
 
@@ -293,7 +293,6 @@ static int isp_video_open(struct file *file)
 	if (!ret)
 		goto unlock;
 rel_fh:
-	pm_runtime_put_noidle(&isp->pdev->dev);
 	v4l2_fh_release(file);
 unlock:
 	mutex_unlock(&isp->video_lock);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index a77c49b18511..74b49d30901e 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -304,11 +304,10 @@ static int fimc_isp_subdev_s_power(struct v4l2_subdev *sd, int on)
 	pr_debug("on: %d\n", on);
 
 	if (on) {
-		ret = pm_runtime_get_sync(&is->pdev->dev);
-		if (ret < 0) {
-			pm_runtime_put(&is->pdev->dev);
+		ret = pm_runtime_resume_and_get(&is->pdev->dev);
+		if (ret < 0)
 			return ret;
-		}
+
 		set_bit(IS_ST_PWR_ON, &is->state);
 
 		ret = fimc_is_start_firmware(is);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index fdd0d369b192..d279f282d592 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -469,9 +469,9 @@ static int fimc_lite_open(struct file *file)
 	}
 
 	set_bit(ST_FLITE_IN_USE, &fimc->state);
-	ret = pm_runtime_get_sync(&fimc->pdev->dev);
+	ret = pm_runtime_resume_and_get(&fimc->pdev->dev);
 	if (ret < 0)
-		goto err_pm;
+		goto err_in_use;
 
 	ret = v4l2_fh_open(file);
 	if (ret < 0)
@@ -499,6 +499,7 @@ static int fimc_lite_open(struct file *file)
 	v4l2_fh_release(file);
 err_pm:
 	pm_runtime_put_sync(&fimc->pdev->dev);
+err_in_use:
 	clear_bit(ST_FLITE_IN_USE, &fimc->state);
 unlock:
 	mutex_unlock(&fimc->lock);
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 4acb179556c4..24b1badd2080 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -73,17 +73,14 @@ static void fimc_m2m_shutdown(struct fimc_ctx *ctx)
 static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
-	int ret;
 
-	ret = pm_runtime_get_sync(&ctx->fimc_dev->pdev->dev);
-	return ret > 0 ? 0 : ret;
+	return pm_runtime_resume_and_get(&ctx->fimc_dev->pdev->dev);
 }
 
 static void stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 
-
 	fimc_m2m_shutdown(ctx);
 	fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 	pm_runtime_put(&ctx->fimc_dev->pdev->dev);
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index e636c33e847b..1272f4703b81 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -508,11 +508,9 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 	if (!fmd->pmf)
 		return -ENXIO;
 
-	ret = pm_runtime_get_sync(fmd->pmf);
-	if (ret < 0) {
-		pm_runtime_put(fmd->pmf);
+	ret = pm_runtime_resume_and_get(fmd->pmf);
+	if (ret < 0)
 		return ret;
-	}
 
 	fmd->num_sensors = 0;
 
@@ -1287,8 +1285,7 @@ static int cam_clk_prepare(struct clk_hw *hw)
 	if (camclk->fmd->pmf == NULL)
 		return -ENODEV;
 
-	ret = pm_runtime_get_sync(camclk->fmd->pmf);
-	return ret < 0 ? ret : 0;
+	return pm_runtime_resume_and_get(camclk->fmd->pmf);
 }
 
 static void cam_clk_unprepare(struct clk_hw *hw)
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 1aac167abb17..ebf39c856894 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -494,7 +494,7 @@ static int s5pcsis_s_power(struct v4l2_subdev *sd, int on)
 	struct device *dev = &state->pdev->dev;
 
 	if (on)
-		return pm_runtime_get_sync(dev);
+		return pm_runtime_resume_and_get(dev);
 
 	return pm_runtime_put_sync(dev);
 }
@@ -509,11 +509,9 @@ static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
 
 	if (enable) {
 		s5pcsis_clear_counters(state);
-		ret = pm_runtime_get_sync(&state->pdev->dev);
-		if (ret && ret != 1) {
-			pm_runtime_put_noidle(&state->pdev->dev);
+		ret = pm_runtime_resume_and_get(&state->pdev->dev);
+		if (ret < 0)
 			return ret;
-		}
 	}
 
 	mutex_lock(&state->lock);
@@ -535,7 +533,7 @@ unlock:
 	if (!enable)
 		pm_runtime_put(&state->pdev->dev);
 
-	return ret == 1 ? 0 : ret;
+	return ret;
 }
 
 static int s5pcsis_enum_mbus_code(struct v4l2_subdev *sd,
-- 
2.30.2



