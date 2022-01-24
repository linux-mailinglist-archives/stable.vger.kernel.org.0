Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77044993ED
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386147AbiAXUfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384815AbiAXUaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:30:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F33C07A968;
        Mon, 24 Jan 2022 11:43:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F79B8122F;
        Mon, 24 Jan 2022 19:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D91C340EA;
        Mon, 24 Jan 2022 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053385;
        bh=PqqgOMdQYsjVK+c5rEKxPaFKwUlR+y4hoxNyhmOITC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9KUG/hdbiBkuL/OMM0UyxuSG5B6dZNNeEIaiMRdI1Rgh07MWzXJMUForknH2E7a9
         ZO3GBGkrKyqu+iQtE5dq/WYgEfQyJQ/CDuU+mNg1rnuWvXw4E9z8rs1Rdrhr8llOd0
         DB7QowVmhDgVYalPQhAIGC4dzELH8dI1SSE8xM2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, aleksandr.o.makarov@gmail.com,
        Brian Norris <briannorris@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Chen-Yu Tsai <wenst@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 048/563] drm/rockchip: dsi: Hold pm-runtime across bind/unbind
Date:   Mon, 24 Jan 2022 19:36:53 +0100
Message-Id: <20220124184026.078735949@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 514db871922f103886ad4d221cf406b4fcc5e74a upstream.

In commit 43c2de1002d2 ("drm/rockchip: dsi: move all lane config except
LCDC mux to bind()"), we moved most HW configuration to bind(), but we
didn't move the runtime PM management. Therefore, depending on initial
boot state, runtime-PM workqueue delays, and other timing factors, we
may disable our power domain in between the hardware configuration
(bind()) and when we enable the display. This can cause us to lose
hardware state and fail to configure our display. For example:

  dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
  panel-innolux-p079zca ff960000.mipi.0: failed to write command 0

or:

  dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
  panel-kingdisplay-kd097d04 ff960000.mipi.0: failed write init cmds: -110

We should match the runtime PM to the lifetime of the bind()/unbind()
cycle.

Tested on Acer Chrometab 10 (RK3399 Gru-Scarlet), with panel drivers
built either as modules or built-in.

Side notes: it seems one is more likely to see this problem when the
panel driver is built into the kernel. I've also seen this problem
bisect down to commits that simply changed Kconfig dependencies, because
it changed the order in which driver init functions were compiled into
the kernel, and therefore the ordering and timing of built-in device
probe.

Fixes: 43c2de1002d2 ("drm/rockchip: dsi: move all lane config except LCDC mux to bind()")
Link: https://lore.kernel.org/linux-rockchip/9aedfb528600ecf871885f7293ca4207c84d16c1.camel@gmail.com/
Reported-by: <aleksandr.o.makarov@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210928143413.v3.1.Ic2904d37f30013a7f3d8476203ad3733c186827e@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |   37 ++++++++++++------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -753,10 +753,6 @@ static void dw_mipi_dsi_encoder_enable(s
 	if (mux < 0)
 		return;
 
-	pm_runtime_get_sync(dsi->dev);
-	if (dsi->slave)
-		pm_runtime_get_sync(dsi->slave->dev);
-
 	/*
 	 * For the RK3399, the clk of grf must be enabled before writing grf
 	 * register. And for RK3288 or other soc, this grf_clk must be NULL,
@@ -775,20 +771,10 @@ static void dw_mipi_dsi_encoder_enable(s
 	clk_disable_unprepare(dsi->grf_clk);
 }
 
-static void dw_mipi_dsi_encoder_disable(struct drm_encoder *encoder)
-{
-	struct dw_mipi_dsi_rockchip *dsi = to_dsi(encoder);
-
-	if (dsi->slave)
-		pm_runtime_put(dsi->slave->dev);
-	pm_runtime_put(dsi->dev);
-}
-
 static const struct drm_encoder_helper_funcs
 dw_mipi_dsi_encoder_helper_funcs = {
 	.atomic_check = dw_mipi_dsi_encoder_atomic_check,
 	.enable = dw_mipi_dsi_encoder_enable,
-	.disable = dw_mipi_dsi_encoder_disable,
 };
 
 static int rockchip_dsi_drm_create_encoder(struct dw_mipi_dsi_rockchip *dsi,
@@ -918,10 +904,14 @@ static int dw_mipi_dsi_rockchip_bind(str
 		put_device(second);
 	}
 
+	pm_runtime_get_sync(dsi->dev);
+	if (dsi->slave)
+		pm_runtime_get_sync(dsi->slave->dev);
+
 	ret = clk_prepare_enable(dsi->pllref_clk);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to enable pllref_clk: %d\n", ret);
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	/*
@@ -933,7 +923,7 @@ static int dw_mipi_dsi_rockchip_bind(str
 	ret = clk_prepare_enable(dsi->grf_clk);
 	if (ret) {
 		DRM_DEV_ERROR(dsi->dev, "Failed to enable grf_clk: %d\n", ret);
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	dw_mipi_dsi_rockchip_config(dsi);
@@ -945,16 +935,23 @@ static int dw_mipi_dsi_rockchip_bind(str
 	ret = rockchip_dsi_drm_create_encoder(dsi, drm_dev);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to create drm encoder\n");
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	ret = dw_mipi_dsi_bind(dsi->dmd, &dsi->encoder);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to bind: %d\n", ret);
-		return ret;
+		goto out_pm_runtime;
 	}
 
 	return 0;
+
+out_pm_runtime:
+	pm_runtime_put(dsi->dev);
+	if (dsi->slave)
+		pm_runtime_put(dsi->slave->dev);
+
+	return ret;
 }
 
 static void dw_mipi_dsi_rockchip_unbind(struct device *dev,
@@ -969,6 +966,10 @@ static void dw_mipi_dsi_rockchip_unbind(
 	dw_mipi_dsi_unbind(dsi->dmd);
 
 	clk_disable_unprepare(dsi->pllref_clk);
+
+	pm_runtime_put(dsi->dev);
+	if (dsi->slave)
+		pm_runtime_put(dsi->slave->dev);
 }
 
 static const struct component_ops dw_mipi_dsi_rockchip_ops = {


