Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0A92FA294
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392700AbhAROIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390605AbhARLpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F40C22CAD;
        Mon, 18 Jan 2021 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970283;
        bh=52cgkSDHRH+2o6cRpLrqyX2ojxeA/U2dXCx4mc7ZFyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CWxtBW+OcfS6coowgWAp1PeTgaLwL/BMKASdTFBACxVYyPWF7aRrG64LML856pnq
         a31YMUXudzSUTR36TvQyWUrS+vRSdanxXA0k4hereZ1xHmXuFQxvQnQIuL7Vhwm6WF
         1ilVICY+MHD9Ldl4njhraWjreiJNHRTBxjrDEx/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 115/152] ASoC: meson: axg-tdmin: fix axg skew offset
Date:   Mon, 18 Jan 2021 12:34:50 +0100
Message-Id: <20210118113358.243339481@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit a84dfb3d55934253de6aed38ad75990278a2d21e upstream.

The signal captured on from tdm decoder of the AXG SoC is incorrect. It
appears amplified. The skew offset of the decoder is wrong.

Setting the skew offset to 3, like the g12 and sm1 SoCs, solves and gives
correct data.

Fixes: 13a22e6a98f8 ("ASoC: meson: add tdm input driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201217150834.3247526-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/meson/axg-tdmin.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/sound/soc/meson/axg-tdmin.c
+++ b/sound/soc/meson/axg-tdmin.c
@@ -228,15 +228,6 @@ static const struct axg_tdm_formatter_dr
 	.regmap_cfg	= &axg_tdmin_regmap_cfg,
 	.ops		= &axg_tdmin_ops,
 	.quirks		= &(const struct axg_tdm_formatter_hw) {
-		.skew_offset	= 2,
-	},
-};
-
-static const struct axg_tdm_formatter_driver g12a_tdmin_drv = {
-	.component_drv	= &axg_tdmin_component_drv,
-	.regmap_cfg	= &axg_tdmin_regmap_cfg,
-	.ops		= &axg_tdmin_ops,
-	.quirks		= &(const struct axg_tdm_formatter_hw) {
 		.skew_offset	= 3,
 	},
 };
@@ -247,10 +238,10 @@ static const struct of_device_id axg_tdm
 		.data = &axg_tdmin_drv,
 	}, {
 		.compatible = "amlogic,g12a-tdmin",
-		.data = &g12a_tdmin_drv,
+		.data = &axg_tdmin_drv,
 	}, {
 		.compatible = "amlogic,sm1-tdmin",
-		.data = &g12a_tdmin_drv,
+		.data = &axg_tdmin_drv,
 	}, {}
 };
 MODULE_DEVICE_TABLE(of, axg_tdmin_of_match);


