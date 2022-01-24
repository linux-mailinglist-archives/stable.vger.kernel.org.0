Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053BD49965E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445440AbiAXVDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:03:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52140 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443303AbiAXU4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:56:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3797B811A9;
        Mon, 24 Jan 2022 20:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CF5C340E5;
        Mon, 24 Jan 2022 20:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057797;
        bh=ANJ5LKnxfnBTuQcDEKga1MP8P7cUsecKPu5TOiY2Go0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2V6hGdv8OY/bqHOcNQ9p+tDVWzBB+Uzy84UyhGcCUEYW4fonbjVC7u1sByi4FWRl
         M0SNquKs4mPEVuS6NbVJmDRNhoCSNxKBWybiMq+g7rRxDhxoP7Cxgg/xPmTLtS0VY9
         IJtnYEK6AQiM6lggSbAL7RrZRKlPf0tRjv5l1Zd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.16 0081/1039] drm/rockchip: dsi: Reconfigure hardware on resume()
Date:   Mon, 24 Jan 2022 19:31:10 +0100
Message-Id: <20220124184127.887606666@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -267,6 +267,8 @@ struct dw_mipi_dsi_rockchip {
 	struct dw_mipi_dsi *dmd;
 	const struct rockchip_dw_dsi_chip_data *cdata;
 	struct dw_mipi_dsi_plat_data pdata;
+
+	bool dsi_bound;
 };
 
 struct dphy_pll_parameter_map {
@@ -963,6 +965,8 @@ static int dw_mipi_dsi_rockchip_bind(str
 		goto out_pm_runtime;
 	}
 
+	dsi->dsi_bound = true;
+
 	return 0;
 
 out_pm_runtime:
@@ -982,6 +986,8 @@ static void dw_mipi_dsi_rockchip_unbind(
 	if (dsi->is_slave)
 		return;
 
+	dsi->dsi_bound = false;
+
 	dw_mipi_dsi_unbind(dsi->dmd);
 
 	clk_disable_unprepare(dsi->pllref_clk);
@@ -1276,6 +1282,36 @@ static const struct phy_ops dw_mipi_dsi_
 	.exit		= dw_mipi_dsi_dphy_exit,
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
@@ -1593,6 +1629,7 @@ struct platform_driver dw_mipi_dsi_rockc
 	.remove		= dw_mipi_dsi_rockchip_remove,
 	.driver		= {
 		.of_match_table = dw_mipi_dsi_rockchip_dt_ids,
+		.pm	= &dw_mipi_dsi_rockchip_pm_ops,
 		.name	= "dw-mipi-dsi-rockchip",
 	},
 };


