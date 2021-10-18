Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308C4431EA1
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhJROFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhJROBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F182D61A7A;
        Mon, 18 Oct 2021 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564557;
        bh=eIHRv6fE1GBqYgB1i/8Uj7mnbLSto9DBvCMfyDMiSlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otU8ns12l2H7ytBaL9NspYumdcIDQCyJGMwXn8eylD8yOLl8Wlj4I9IJ/8UHyEF/u
         qdHyOwbKiJcyNMm2IIw/Ga1b4wEm1ZrDVsVfdTihFX58NsTVFGpGAsj/wfZkE5fyp/
         KpEhfJXDeIW45xTZiHXhvRAvuVNU5WsQTqYY8ABc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.14 133/151] drm/msm/dsi: dsi_phy_14nm: Take ready-bit into account in poll_for_ready
Date:   Mon, 18 Oct 2021 15:25:12 +0200
Message-Id: <20211018132344.984768216@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

commit 90b7c1c66132c20e8a550006011a3cbfb73dbfc1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c |   30 ++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -110,14 +110,13 @@ static struct dsi_pll_14nm *pll_14nm_lis
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
@@ -126,23 +125,24 @@ static bool pll_14nm_poll_for_ready(stru
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


