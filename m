Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F107840E774
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348675AbhIPRcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353304AbhIPRa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 888EB610A4;
        Thu, 16 Sep 2021 16:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810817;
        bh=6XPkMybdNHKrHU4KwX8+K12QhA29HKIgLYqu2LzrJgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ue1UYQM52yNodkeHqeo2lYt1PN4gmPMYJpINgd2oNOWD7mul9aa4Zg3UPJ8kPqJlA
         zw2Bfs0/BzAmzF1Sc6gwGw/SA3Q7JVPA9ovWC8tJ0c+sDD3tR3waIIxk/xgWs7yIFF
         v0/oFFIztd/bdxiGxc14XbXzQ45M8Sf9NCiv56+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 279/432] drm: xlnx: zynqmp_dpsub: Call pm_runtime_get_sync before setting pixel clock
Date:   Thu, 16 Sep 2021 18:00:28 +0200
Message-Id: <20210916155820.267592904@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

>From above, we can see that pm_runtime_get_sync may clear register
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



