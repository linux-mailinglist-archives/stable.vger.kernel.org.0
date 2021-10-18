Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6543173F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhJRL32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhJRL31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 317CC600D4;
        Mon, 18 Oct 2021 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556436;
        bh=XPPmnTLOMQpLhYWDR57mPf16ZSPyIglmTmuKizPqHh0=;
        h=Subject:To:Cc:From:Date:From;
        b=gwA6L13dLF6fEXJiAsQehSuwoPCwTfWarXMqExkFFh3KdtjO6Jo/Kc3wKEo3HBYWl
         RPJLQyLVBYNHWbhfA6xdven6EuN/AXYqhv6pUHtQOdD8/hHCgjDbMl6fhJwdnKOxpF
         THGdxTf5IVCp7JWA339BKAUN0AkXS9av3z5PPASo=
Subject: FAILED: patch "[PATCH] drm/msm/dsi: dsi_phy_14nm: Take ready-bit into account in" failed to apply to 4.14-stable tree
To:     marijn.suijten@somainline.org, dmitry.baryshkov@linaro.org,
        robdclark@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:27:14 +0200
Message-ID: <163455643498102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90b7c1c66132c20e8a550006011a3cbfb73dbfc1 Mon Sep 17 00:00:00 2001
From: Marijn Suijten <marijn.suijten@somainline.org>
Date: Mon, 6 Sep 2021 22:25:51 +0200
Subject: [PATCH] drm/msm/dsi: dsi_phy_14nm: Take ready-bit into account in
 poll_for_ready

The downstream driver models this PLL lock check as an if-elseif-else.
The only way to reach the else case where pll_locked=true [1] is by
succeeding both readl_poll_timeout_atomic calls (which return zero on
success) in the if _and_ elseif condition.  Hence both the "lock" and
"ready" bit need to be tested in the SM_READY_STATUS register before
considering the PLL locked and ready to go.

Tested on the Sony Xperia XA2 Ultra (nile-discovery, sdm630).

[1]: https://source.codeaurora.org/quic/la/kernel/msm-4.19/tree/drivers/clk/qcom/mdss/mdss-dsi-pll-14nm-util.c?h=LA.UM.9.2.1.r1-08000-sdm660.0#n302

Fixes: f079f6d999cb ("drm/msm/dsi: Add PHY/PLL for 8x96")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210906202552.824598-1-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index d13552b2213b..5b4e991f220d 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -110,14 +110,13 @@ static struct dsi_pll_14nm *pll_14nm_list[DSI_MAX];
 static bool pll_14nm_poll_for_ready(struct dsi_pll_14nm *pll_14nm,
 				    u32 nb_tries, u32 timeout_us)
 {
-	bool pll_locked = false;
+	bool pll_locked = false, pll_ready = false;
 	void __iomem *base = pll_14nm->phy->pll_base;
 	u32 tries, val;
 
 	tries = nb_tries;
 	while (tries--) {
-		val = dsi_phy_read(base +
-			       REG_DSI_14nm_PHY_PLL_RESET_SM_READY_STATUS);
+		val = dsi_phy_read(base + REG_DSI_14nm_PHY_PLL_RESET_SM_READY_STATUS);
 		pll_locked = !!(val & BIT(5));
 
 		if (pll_locked)
@@ -126,23 +125,24 @@ static bool pll_14nm_poll_for_ready(struct dsi_pll_14nm *pll_14nm,
 		udelay(timeout_us);
 	}
 
-	if (!pll_locked) {
-		tries = nb_tries;
-		while (tries--) {
-			val = dsi_phy_read(base +
-				REG_DSI_14nm_PHY_PLL_RESET_SM_READY_STATUS);
-			pll_locked = !!(val & BIT(0));
+	if (!pll_locked)
+		goto out;
 
-			if (pll_locked)
-				break;
+	tries = nb_tries;
+	while (tries--) {
+		val = dsi_phy_read(base + REG_DSI_14nm_PHY_PLL_RESET_SM_READY_STATUS);
+		pll_ready = !!(val & BIT(0));
 
-			udelay(timeout_us);
-		}
+		if (pll_ready)
+			break;
+
+		udelay(timeout_us);
 	}
 
-	DBG("DSI PLL is %slocked", pll_locked ? "" : "*not* ");
+out:
+	DBG("DSI PLL is %slocked, %sready", pll_locked ? "" : "*not* ", pll_ready ? "" : "*not* ");
 
-	return pll_locked;
+	return pll_locked && pll_ready;
 }
 
 static void dsi_pll_14nm_config_init(struct dsi_pll_config *pconf)

