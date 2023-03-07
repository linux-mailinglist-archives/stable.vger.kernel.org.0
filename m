Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB316AF454
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCGTQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjCGTPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198E4CD672
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC42D61518
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB738C433EF;
        Tue,  7 Mar 2023 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215249;
        bh=D53Vla1UyjRnZPM2Z3PtwBCxbJ8IOM5j0WSZXoWdxvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wn1wp/Y520WEJH4mDjS/NzTyG7GokEd23o57FFCzl3NDfbnE76mOQYDa0iq916Svs
         L3noBZHvueHFxMJaAuwGinAsiF4LDHwt9QerO+pvYBvGBsSkjZbhydw+T2j7g93YXG
         VZgxlONdL7Dz6L/NEFZHatk1HeXaWaY69aR1HR04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Nicolas Boichat <drinkcat@chromium.org>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/567] drm: exynos: dsi: Fix MIPI_DSI*_NO_* mode flags
Date:   Tue,  7 Mar 2023 17:58:56 +0100
Message-Id: <20230307165914.594622296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit 996e1defca34485dd2bd70b173f069aab5f21a65 ]

HFP/HBP/HSA/EOT_PACKET modes in Exynos DSI host specifies
0 = Enable and 1 = Disable.

The logic for checking these mode flags was correct before
the MIPI_DSI*_NO_* mode flag conversion.

This patch is trying to fix this MIPI_DSI*_NO_* mode flags handling
Exynos DSI host and update the mode_flags in relevant panel drivers.

Fixes: 0f3b68b66a6d ("drm/dsi: Add _NO_ to MIPI_DSI_* flags disabling features")
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Nicolas Boichat <drinkcat@chromium.org>
Reported-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221212145745.15387-1-jagan@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c          | 8 ++++----
 drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c    | 4 +++-
 drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c | 3 ++-
 drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c    | 2 --
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 8d137857818ca..e0465b604f210 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -809,15 +809,15 @@ static int exynos_dsi_init_link(struct exynos_dsi *dsi)
 			reg |= DSIM_AUTO_MODE;
 		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_HSE)
 			reg |= DSIM_HSE_MODE;
-		if (!(dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HFP))
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HFP)
 			reg |= DSIM_HFP_MODE;
-		if (!(dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HBP))
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HBP)
 			reg |= DSIM_HBP_MODE;
-		if (!(dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HSA))
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HSA)
 			reg |= DSIM_HSA_MODE;
 	}
 
-	if (!(dsi->mode_flags & MIPI_DSI_MODE_NO_EOT_PACKET))
+	if (dsi->mode_flags & MIPI_DSI_MODE_NO_EOT_PACKET)
 		reg |= DSIM_EOT_DISABLE;
 
 	switch (dsi->format) {
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c b/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c
index 0ab1b7ec84cda..166d7d41cd9b5 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c
@@ -692,7 +692,9 @@ static int s6e3ha2_probe(struct mipi_dsi_device *dsi)
 
 	dsi->lanes = 4;
 	dsi->format = MIPI_DSI_FMT_RGB888;
-	dsi->mode_flags = MIPI_DSI_CLOCK_NON_CONTINUOUS;
+	dsi->mode_flags = MIPI_DSI_CLOCK_NON_CONTINUOUS |
+		MIPI_DSI_MODE_VIDEO_NO_HFP | MIPI_DSI_MODE_VIDEO_NO_HBP |
+		MIPI_DSI_MODE_VIDEO_NO_HSA | MIPI_DSI_MODE_NO_EOT_PACKET;
 
 	ctx->supplies[0].supply = "vdd3";
 	ctx->supplies[1].supply = "vci";
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c b/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
index ccc8ed6fe3aed..2fc46fdd0e7a0 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
@@ -446,7 +446,8 @@ static int s6e63j0x03_probe(struct mipi_dsi_device *dsi)
 
 	dsi->lanes = 1;
 	dsi->format = MIPI_DSI_FMT_RGB888;
-	dsi->mode_flags = MIPI_DSI_MODE_NO_EOT_PACKET;
+	dsi->mode_flags = MIPI_DSI_MODE_VIDEO_NO_HFP |
+		MIPI_DSI_MODE_VIDEO_NO_HBP | MIPI_DSI_MODE_VIDEO_NO_HSA;
 
 	ctx->supplies[0].supply = "vdd3";
 	ctx->supplies[1].supply = "vci";
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c b/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c
index 9b3599d6d2dea..737b8ca22b374 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c
@@ -990,8 +990,6 @@ static int s6e8aa0_probe(struct mipi_dsi_device *dsi)
 	dsi->lanes = 4;
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST
-		| MIPI_DSI_MODE_VIDEO_NO_HFP | MIPI_DSI_MODE_VIDEO_NO_HBP
-		| MIPI_DSI_MODE_VIDEO_NO_HSA | MIPI_DSI_MODE_NO_EOT_PACKET
 		| MIPI_DSI_MODE_VSYNC_FLUSH | MIPI_DSI_MODE_VIDEO_AUTO_VERT;
 
 	ret = s6e8aa0_parse_dt(ctx);
-- 
2.39.2



