Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1F0451F5E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356170AbhKPAix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343907AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 278B5633A5;
        Mon, 15 Nov 2021 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002095;
        bh=GIxLn44M6K5RbIEtHjAZqpbTm9WG364rW+X5v5TjWng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUuIj8V4iicfO1B+FBZ/q1CfdibJ3WrGlYihRqgOQDw57mNFb2sqBRVs4U5DTGi55
         QJA/Ii4hhuEIq5FkgkXlcOM3stR7Z+1AmMDJjcJKQx+sA9nk1Hlz3CogHofj9KXGXb
         qV1oDPA/IaspAPtw8SdUz6OmhBWnMXUkq2B7mYQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/917] drm/msm/dsi: do not enable irq handler before powering up the host
Date:   Mon, 15 Nov 2021 17:58:51 +0100
Message-Id: <20211115165443.572666822@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit bf94ec093d05e3ed3142d9291b876eeb9997ba5c ]

The DSI host might be left in some state by the bootloader. If this
state generates an IRQ, it might hang the system by holding the
interrupt line before the driver sets up the DSI host to the known
state.

Move the request_irq into msm_dsi_host_init and pass IRQF_NO_AUTOEN to
it. Call enable/disable_irq after msm_dsi_host_power_on/_off()
functions, so that we can be sure that the interrupt is delivered when
the host is in the known state.

It is not possible to defer the interrupt enablement to a later point,
because drm_panel_prepare might need to communicate with the panel over
the DSI link and that requires working interrupt.

Fixes: a689554ba6ed ("drm/msm: Initial add DSI connector support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Link: https://lore.kernel.org/r/20211002010830.647416-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi.h         |  2 ++
 drivers/gpu/drm/msm/dsi/dsi_host.c    | 48 +++++++++++++++++----------
 drivers/gpu/drm/msm/dsi/dsi_manager.c | 16 +++++++++
 3 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi.h b/drivers/gpu/drm/msm/dsi/dsi.h
index b50db91cb8a7e..569c8ff062ba4 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.h
+++ b/drivers/gpu/drm/msm/dsi/dsi.h
@@ -107,6 +107,8 @@ void msm_dsi_host_cmd_xfer_commit(struct mipi_dsi_host *host,
 					u32 dma_base, u32 len);
 int msm_dsi_host_enable(struct mipi_dsi_host *host);
 int msm_dsi_host_disable(struct mipi_dsi_host *host);
+void msm_dsi_host_enable_irq(struct mipi_dsi_host *host);
+void msm_dsi_host_disable_irq(struct mipi_dsi_host *host);
 int msm_dsi_host_power_on(struct mipi_dsi_host *host,
 			struct msm_dsi_phy_shared_timings *phy_shared_timings,
 			bool is_bonded_dsi, struct msm_dsi_phy *phy);
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index c86b5090fae60..bccd379bdba75 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1898,6 +1898,23 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 		return ret;
 	}
 
+	msm_host->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (msm_host->irq < 0) {
+		ret = msm_host->irq;
+		dev_err(&pdev->dev, "failed to get irq: %d\n", ret);
+		return ret;
+	}
+
+	/* do not autoenable, will be enabled later */
+	ret = devm_request_irq(&pdev->dev, msm_host->irq, dsi_host_irq,
+			IRQF_TRIGGER_HIGH | IRQF_ONESHOT | IRQF_NO_AUTOEN,
+			"dsi_isr", msm_host);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request IRQ%u: %d\n",
+				msm_host->irq, ret);
+		return ret;
+	}
+
 	init_completion(&msm_host->dma_comp);
 	init_completion(&msm_host->video_comp);
 	mutex_init(&msm_host->dev_mutex);
@@ -1941,25 +1958,8 @@ int msm_dsi_host_modeset_init(struct mipi_dsi_host *host,
 {
 	struct msm_dsi_host *msm_host = to_msm_dsi_host(host);
 	const struct msm_dsi_cfg_handler *cfg_hnd = msm_host->cfg_hnd;
-	struct platform_device *pdev = msm_host->pdev;
 	int ret;
 
-	msm_host->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
-	if (msm_host->irq < 0) {
-		ret = msm_host->irq;
-		DRM_DEV_ERROR(dev->dev, "failed to get irq: %d\n", ret);
-		return ret;
-	}
-
-	ret = devm_request_irq(&pdev->dev, msm_host->irq,
-			dsi_host_irq, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-			"dsi_isr", msm_host);
-	if (ret < 0) {
-		DRM_DEV_ERROR(&pdev->dev, "failed to request IRQ%u: %d\n",
-				msm_host->irq, ret);
-		return ret;
-	}
-
 	msm_host->dev = dev;
 	ret = cfg_hnd->ops->tx_buf_alloc(msm_host, SZ_4K);
 	if (ret) {
@@ -2315,6 +2315,20 @@ void msm_dsi_host_get_phy_clk_req(struct mipi_dsi_host *host,
 	clk_req->escclk_rate = msm_host->esc_clk_rate;
 }
 
+void msm_dsi_host_enable_irq(struct mipi_dsi_host *host)
+{
+	struct msm_dsi_host *msm_host = to_msm_dsi_host(host);
+
+	enable_irq(msm_host->irq);
+}
+
+void msm_dsi_host_disable_irq(struct mipi_dsi_host *host)
+{
+	struct msm_dsi_host *msm_host = to_msm_dsi_host(host);
+
+	disable_irq(msm_host->irq);
+}
+
 int msm_dsi_host_enable(struct mipi_dsi_host *host)
 {
 	struct msm_dsi_host *msm_host = to_msm_dsi_host(host);
diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index c41d39f5b7cf4..fb4ccffdcfe13 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -377,6 +377,14 @@ static void dsi_mgr_bridge_pre_enable(struct drm_bridge *bridge)
 		}
 	}
 
+	/*
+	 * Enable before preparing the panel, disable after unpreparing, so
+	 * that the panel can communicate over the DSI link.
+	 */
+	msm_dsi_host_enable_irq(host);
+	if (is_bonded_dsi && msm_dsi1)
+		msm_dsi_host_enable_irq(msm_dsi1->host);
+
 	/* Always call panel functions once, because even for dual panels,
 	 * there is only one drm_panel instance.
 	 */
@@ -411,6 +419,10 @@ host_en_fail:
 	if (panel)
 		drm_panel_unprepare(panel);
 panel_prep_fail:
+	msm_dsi_host_disable_irq(host);
+	if (is_bonded_dsi && msm_dsi1)
+		msm_dsi_host_disable_irq(msm_dsi1->host);
+
 	if (is_bonded_dsi && msm_dsi1)
 		msm_dsi_host_power_off(msm_dsi1->host);
 host1_on_fail:
@@ -523,6 +535,10 @@ static void dsi_mgr_bridge_post_disable(struct drm_bridge *bridge)
 								id, ret);
 	}
 
+	msm_dsi_host_disable_irq(host);
+	if (is_bonded_dsi && msm_dsi1)
+		msm_dsi_host_disable_irq(msm_dsi1->host);
+
 	/* Save PHY status if it is a clock source */
 	msm_dsi_phy_pll_save_state(msm_dsi->phy);
 
-- 
2.33.0



