Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B326D49A96F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322588AbiAYDWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385053AbiAXUbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45844C07A96F;
        Mon, 24 Jan 2022 11:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7FD66153B;
        Mon, 24 Jan 2022 19:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0592C340E8;
        Mon, 24 Jan 2022 19:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053391;
        bh=RSMJmFAYFn44dqCpz6Ef7WGavdzCauuu95FS6ErIU1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvsgo2YtIWJ/mJfmTDqMNCQOXHevbyS90knen1gBpfnR+OyZ+LLvIgjo6A5VEEqY4
         f1+EshkVXWf0Pb5eAA6KmCdFkyoKjHFfl8+t7h9cfubbpQUenAevsSaBX+9mc35ANY
         2y8lxFPnYxGkX/CuPFMdLRMfd7tOtQl0F8SZRZrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 050/563] drm/rockchip: dsi: Reconfigure hardware on resume()
Date:   Mon, 24 Jan 2022 19:36:55 +0100
Message-Id: <20220124184026.156578432@linuxfoundation.org>
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

commit e584cdc1549932f87a2707b56bc588cfac5d89e0 upstream.

Since commit 43c2de1002d2 ("drm/rockchip: dsi: move all lane config except
LCDC mux to bind()"), we perform most HW configuration in the bind()
function. This configuration may be lost on suspend/resume, so we
need to call it again. That may lead to errors like this after system
suspend/resume:

  dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
  panel-kingdisplay-kd097d04 ff960000.mipi.0: failed write init cmds: -110

Tested on Acer Chromebook Tab 10 (RK3399 Gru-Scarlet).

Note that early mailing list versions of this driver borrowed Rockchip's
downstream/BSP solution, to do HW configuration in mode_set() (which
*is* called at the appropriate pre-enable() times), but that was
discarded along the way. I've avoided that still, because mode_set()
documentation doesn't suggest this kind of purpose as far as I can tell.

Fixes: 43c2de1002d2 ("drm/rockchip: dsi: move all lane config except LCDC mux to bind()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210928143413.v3.2.I4e9d93aadb00b1ffc7d506e3186a25492bf0b732@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |   37 ++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -243,6 +243,8 @@ struct dw_mipi_dsi_rockchip {
 	struct dw_mipi_dsi *dmd;
 	const struct rockchip_dw_dsi_chip_data *cdata;
 	struct dw_mipi_dsi_plat_data pdata;
+
+	bool dsi_bound;
 };
 
 struct dphy_pll_parameter_map {
@@ -944,6 +946,8 @@ static int dw_mipi_dsi_rockchip_bind(str
 		goto out_pll_clk;
 	}
 
+	dsi->dsi_bound = true;
+
 	return 0;
 
 out_pll_clk:
@@ -965,6 +969,8 @@ static void dw_mipi_dsi_rockchip_unbind(
 	if (dsi->is_slave)
 		return;
 
+	dsi->dsi_bound = false;
+
 	dw_mipi_dsi_unbind(dsi->dmd);
 
 	clk_disable_unprepare(dsi->pllref_clk);
@@ -1029,6 +1035,36 @@ static const struct dw_mipi_dsi_host_ops
 	.detach = dw_mipi_dsi_rockchip_host_detach,
 };
 
+static int __maybe_unused dw_mipi_dsi_rockchip_resume(struct device *dev)
+{
+	struct dw_mipi_dsi_rockchip *dsi = dev_get_drvdata(dev);
+	int ret;
+
+	/*
+	 * Re-configure DSI state, if we were previously initialized. We need
+	 * to do this before rockchip_drm_drv tries to re-enable() any panels.
+	 */
+	if (dsi->dsi_bound) {
+		ret = clk_prepare_enable(dsi->grf_clk);
+		if (ret) {
+			DRM_DEV_ERROR(dsi->dev, "Failed to enable grf_clk: %d\n", ret);
+			return ret;
+		}
+
+		dw_mipi_dsi_rockchip_config(dsi);
+		if (dsi->slave)
+			dw_mipi_dsi_rockchip_config(dsi->slave);
+
+		clk_disable_unprepare(dsi->grf_clk);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops dw_mipi_dsi_rockchip_pm_ops = {
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, dw_mipi_dsi_rockchip_resume)
+};
+
 static int dw_mipi_dsi_rockchip_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1248,6 +1284,7 @@ struct platform_driver dw_mipi_dsi_rockc
 	.remove		= dw_mipi_dsi_rockchip_remove,
 	.driver		= {
 		.of_match_table = dw_mipi_dsi_rockchip_dt_ids,
+		.pm	= &dw_mipi_dsi_rockchip_pm_ops,
 		.name	= "dw-mipi-dsi-rockchip",
 	},
 };


