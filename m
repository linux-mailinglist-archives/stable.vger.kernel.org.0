Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C973404EFC
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350476AbhIIMQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350316AbhIIMNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:13:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D9761A55;
        Thu,  9 Sep 2021 11:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188143;
        bh=W+T/E0zEhT623KLpFLXe20x3q4+PmgWC1T7ywY51mYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6wA73DzW00i/sr1aNyR4jexrV29Z4qlLRlx/SvVvxC32VGIlXtRT0avB0bkIE3WO
         d2Rsc4X5KK7L/wyeY2ondVnMlTHva4DYqGkLECsk3JdLFV6vfxgLjkN9yAynsFhsrw
         93sdo05CffHhJBs7Mou+j11c6NcfxLVBh5ihwoCIF9cXHct9W7Pw+VoJ7EYlR2TGwN
         UE7Uztu042m47PlmcySKDlUxIwjaMV5PgFqPXJYpataCqKE2MBB67MdFAqRTVbOzq7
         YTM9QVaNcUfcuf+6cYR5+TxGJoR5tmQegwqF5FWmkQ4uZ0Dqwoq3OJ4l+habxu2k3/
         +j2uYTNQxYK4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quanyang Wang <quanyang.wang@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 114/219] drm: xlnx: zynqmp_dpsub: Call pm_runtime_get_sync before setting pixel clock
Date:   Thu,  9 Sep 2021 07:44:50 -0400
Message-Id: <20210909114635.143983-114-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 109d627968ac..01c6ce7784dd 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_disp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_disp.c
@@ -1452,9 +1452,10 @@ zynqmp_disp_crtc_atomic_enable(struct drm_crtc *crtc,
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

