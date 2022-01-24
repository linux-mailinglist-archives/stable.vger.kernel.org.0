Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2CB49A972
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322584AbiAYDWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385055AbiAXUbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BABAC07A96D;
        Mon, 24 Jan 2022 11:43:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4BCDB811FB;
        Mon, 24 Jan 2022 19:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE84C340EA;
        Mon, 24 Jan 2022 19:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053388;
        bh=4RUcMj1GoLMRgwa1w50kVg3OcRDZyoHyt2bFDIJJZb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHdSzKk/RHT40JtqLLfiiAl6yHbOYIUqiBYzCb+OuXKUGxht4qVhOkxznM4/v5z7f
         mfguVqrFhgW0lmhQq69PKiNgLSmcfLlqAbFyV53v/2O903l3/pK9YlPwyUSnpQIwY/
         pWXozx2ayk736W+ZPQh1/ei1VxNJqRduSJ55pDMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/563] drm/rockchip: dsi: Disable PLL clock on bind error
Date:   Mon, 24 Jan 2022 19:36:54 +0100
Message-Id: <20220124184026.116047314@linuxfoundation.org>
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

[ Upstream commit 5a614570172e1c9f59035d259dd735acd4f1c01b ]

Fix some error handling here noticed in review of other changes.

Fixes: 2d4f7bdafd70 ("drm/rockchip: dsi: migrate to use dw-mipi-dsi bridge driver")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reported-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210928143413.v3.4.I8bb7a91ecc411d56bc155763faa15f289d7fc074@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index d3cea42dde436..6691e45230126 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -923,7 +923,7 @@ static int dw_mipi_dsi_rockchip_bind(struct device *dev,
 	ret = clk_prepare_enable(dsi->grf_clk);
 	if (ret) {
 		DRM_DEV_ERROR(dsi->dev, "Failed to enable grf_clk: %d\n", ret);
-		goto out_pm_runtime;
+		goto out_pll_clk;
 	}
 
 	dw_mipi_dsi_rockchip_config(dsi);
@@ -935,17 +935,19 @@ static int dw_mipi_dsi_rockchip_bind(struct device *dev,
 	ret = rockchip_dsi_drm_create_encoder(dsi, drm_dev);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to create drm encoder\n");
-		goto out_pm_runtime;
+		goto out_pll_clk;
 	}
 
 	ret = dw_mipi_dsi_bind(dsi->dmd, &dsi->encoder);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Failed to bind: %d\n", ret);
-		goto out_pm_runtime;
+		goto out_pll_clk;
 	}
 
 	return 0;
 
+out_pll_clk:
+	clk_disable_unprepare(dsi->pllref_clk);
 out_pm_runtime:
 	pm_runtime_put(dsi->dev);
 	if (dsi->slave)
-- 
2.34.1



