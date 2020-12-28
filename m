Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7796D2E4243
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408428AbgL1PTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436969AbgL1OCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F5E208B3;
        Mon, 28 Dec 2020 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164149;
        bh=NMq65m3O4RH8XPEsZ7VXQymMd2yHgMB6CzqTJ+0nq0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQp5QmO+1XPDVQAVcJACYSFXok4TugeVlbE2DZ9OuOIosyuui8OgDziL03jO8vafT
         tBWmcGf2oapkuOel9+Oyx60UYbFoVJkiCrBBvN0scn3egJJIcuoCQPo/Uj1cAgvFdH
         ak61r9nBOZG4xUeuoVFl2X31J+qrqAEV1BhosfzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/717] drm/msm/dsi_pll_10nm: restore VCO rate during restore_state
Date:   Mon, 28 Dec 2020 13:40:46 +0100
Message-Id: <20201228125023.292549141@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a4ccc37693a271330a46208afbeaed939d54fdbb ]

PHY disable/enable resets PLL registers to default values. Thus in
addition to restoring several registers we also need to restore VCO rate
settings.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: c6659785dfb3 ("drm/msm/dsi/pll: call vco set rate explicitly")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c
index 6ac04fc303f56..e4e9bf04b7368 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c
@@ -559,6 +559,7 @@ static int dsi_pll_10nm_restore_state(struct msm_dsi_pll *pll)
 	struct pll_10nm_cached_state *cached = &pll_10nm->cached_state;
 	void __iomem *phy_base = pll_10nm->phy_cmn_mmio;
 	u32 val;
+	int ret;
 
 	val = pll_read(pll_10nm->mmio + REG_DSI_10nm_PHY_PLL_PLL_OUTDIV_RATE);
 	val &= ~0x3;
@@ -573,6 +574,13 @@ static int dsi_pll_10nm_restore_state(struct msm_dsi_pll *pll)
 	val |= cached->pll_mux;
 	pll_write(phy_base + REG_DSI_10nm_PHY_CMN_CLK_CFG1, val);
 
+	ret = dsi_pll_10nm_vco_set_rate(&pll->clk_hw, pll_10nm->vco_current_rate, pll_10nm->vco_ref_clk_rate);
+	if (ret) {
+		DRM_DEV_ERROR(&pll_10nm->pdev->dev,
+			"restore vco rate failed. ret=%d\n", ret);
+		return ret;
+	}
+
 	DBG("DSI PLL%d", pll_10nm->id);
 
 	return 0;
-- 
2.27.0



