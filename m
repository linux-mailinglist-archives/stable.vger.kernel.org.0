Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6865934CA93
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhC2IjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhC2Ihe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7989461996;
        Mon, 29 Mar 2021 08:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007039;
        bh=RHIqCcF0DTcyY7IN0URo8sQrH/fKoLvRgDD/wApvKZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVnxLftJQ0lOzUUKUxS1EvUrQWaRrB/CGHf81PvX9A5xuhxhNwqcVk9U0SdROKBD5
         aCV65hZvPGG/+D/VHi1RqTpHHuiAGdySBWxkyQLjU6b1nFy8uKNss83faIbco16jKc
         KUvMamgdAVODpZ8MJtictlke5A/fBxKjGMRhgDwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 163/254] drm/msm/dsi: fix check-before-set in the 7nm dsi_pll code
Date:   Mon, 29 Mar 2021 09:57:59 +0200
Message-Id: <20210329075638.543610619@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3b24cdfc721a5f1098da22f9f68ff5f4a5efccc9 ]

Fix setting min/max DSI PLL rate for the V4.1 7nm DSI PLL (used on
sm8250). Current code checks for pll->type before it is set (as it is
set in the msm_dsi_pll_init() after calling device-specific functions.

Cc: Jonathan Marek <jonathan@marek.ca>
Fixes: 1ef7c99d145c ("drm/msm/dsi: add support for 7nm DSI PHY/PLL")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.c     | 2 +-
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.h     | 6 ++++--
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c | 5 +++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c
index a45fe95aff49..3dc65877fa10 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c
@@ -163,7 +163,7 @@ struct msm_dsi_pll *msm_dsi_pll_init(struct platform_device *pdev,
 		break;
 	case MSM_DSI_PHY_7NM:
 	case MSM_DSI_PHY_7NM_V4_1:
-		pll = msm_dsi_pll_7nm_init(pdev, id);
+		pll = msm_dsi_pll_7nm_init(pdev, type, id);
 		break;
 	default:
 		pll = ERR_PTR(-ENXIO);
diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h
index 3405982a092c..bbecb1de5678 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h
@@ -117,10 +117,12 @@ msm_dsi_pll_10nm_init(struct platform_device *pdev, int id)
 }
 #endif
 #ifdef CONFIG_DRM_MSM_DSI_7NM_PHY
-struct msm_dsi_pll *msm_dsi_pll_7nm_init(struct platform_device *pdev, int id);
+struct msm_dsi_pll *msm_dsi_pll_7nm_init(struct platform_device *pdev,
+					enum msm_dsi_phy_type type, int id);
 #else
 static inline struct msm_dsi_pll *
-msm_dsi_pll_7nm_init(struct platform_device *pdev, int id)
+msm_dsi_pll_7nm_init(struct platform_device *pdev,
+					enum msm_dsi_phy_type type, int id)
 {
 	return ERR_PTR(-ENODEV);
 }
diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c
index 93bf142e4a4e..c1f6708367ae 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c
@@ -852,7 +852,8 @@ err_base_clk_hw:
 	return ret;
 }
 
-struct msm_dsi_pll *msm_dsi_pll_7nm_init(struct platform_device *pdev, int id)
+struct msm_dsi_pll *msm_dsi_pll_7nm_init(struct platform_device *pdev,
+					enum msm_dsi_phy_type type, int id)
 {
 	struct dsi_pll_7nm *pll_7nm;
 	struct msm_dsi_pll *pll;
@@ -885,7 +886,7 @@ struct msm_dsi_pll *msm_dsi_pll_7nm_init(struct platform_device *pdev, int id)
 	pll = &pll_7nm->base;
 	pll->min_rate = 1000000000UL;
 	pll->max_rate = 3500000000UL;
-	if (pll->type == MSM_DSI_PHY_7NM_V4_1) {
+	if (type == MSM_DSI_PHY_7NM_V4_1) {
 		pll->min_rate = 600000000UL;
 		pll->max_rate = (unsigned long)5000000000ULL;
 		/* workaround for max rate overflowing on 32-bit builds: */
-- 
2.30.1



