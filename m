Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C069D4051C6
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352690AbhIIMie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352572AbhIIMdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E955661B4E;
        Thu,  9 Sep 2021 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188399;
        bh=OYyROW1PCq+7mdbfs6tCayDgsBg4hoE91IZ4MGRMzWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTuJrfd48St1OxtPb6/R16FoOY7EfOqnaAAg97Yfy8+YBt2fJOJdSZxQfAUjRNRlk
         k4RwuJLxSGBCrOfPgLevTaik9i+dcOgDi3Hs9/7P4FIXc/nNjEVgKf9GYkJx/sqNFP
         rBcN0BYVZrUSTeRw2q/Fb1AEJJfC0dXw2q+JsjN4P2mL2BjyHyr6zpdY17TC52gSOt
         iBpXHcFhugjSJ1jxBRewv5MzfemDBjVOxMCuOArINBMo8szegyTlHhe3ZUESfSAn3k
         HxFkqKU0LiUUmDIATKVInqRI7UijYDKMMOmCvLEEt2y13eudSHebMoqxceLf7tLIJd
         uCMiWFXCHRScQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quanyang Wang <quanyang.wang@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 094/176] drm: xlnx: zynqmp_dpsub: Call pm_runtime_get_sync before setting pixel clock
Date:   Thu,  9 Sep 2021 07:49:56 -0400
Message-Id: <20210909115118.146181-94-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit a19effb6dbe5bd1be77a6d68eba04dba8993ffeb ]

The Runtime PM subsystem will force the device "fd4a0000.zynqmp-display"
to enter suspend state while booting if the following conditions are met:
- the usage counter is zero (pm_runtime_get_sync hasn't been called yet)
- no 'active' children (no zynqmp-dp-snd-xx node under dpsub node)
- no other device in the same power domain (dpdma node has no
		"power-domains = <&zynqmp_firmware PD_DP>" property)

So there is a scenario as below:
1) DP device enters suspend state   <- call zynqmp_gpd_power_off
2) zynqmp_disp_crtc_setup_clock	    <- configurate register VPLL_FRAC_CFG
3) pm_runtime_get_sync		    <- call zynqmp_gpd_power_on and clear previous
				       VPLL_FRAC_CFG configuration
4) clk_prepare_enable(disp->pclk)   <- enable failed since VPLL_FRAC_CFG
				       configuration is corrupted

From above, we can see that pm_runtime_get_sync may clear register
VPLL_FRAC_CFG configuration and result the failure of clk enabling.
Putting pm_runtime_get_sync at the very beginning of the function
zynqmp_disp_crtc_atomic_enable can resolve this issue.

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_disp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_disp.c b/drivers/gpu/drm/xlnx/zynqmp_disp.c
index 8cd8af35cfaa..205c72a249b7 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_disp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_disp.c
@@ -1447,9 +1447,10 @@ zynqmp_disp_crtc_atomic_enable(struct drm_crtc *crtc,
 	struct drm_display_mode *adjusted_mode = &crtc->state->adjusted_mode;
 	int ret, vrefresh;
 
+	pm_runtime_get_sync(disp->dev);
+
 	zynqmp_disp_crtc_setup_clock(crtc, adjusted_mode);
 
-	pm_runtime_get_sync(disp->dev);
 	ret = clk_prepare_enable(disp->pclk);
 	if (ret) {
 		dev_err(disp->dev, "failed to enable a pixel clock\n");
-- 
2.30.2

