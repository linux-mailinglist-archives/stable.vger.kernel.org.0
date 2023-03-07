Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735286AEA10
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjCGRa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCGRaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74354A2F0F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:25:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054AC614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F005EC433EF;
        Tue,  7 Mar 2023 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209917;
        bh=46X7D2sW8optM+g2EHzOyHb4MN2Fe3Ss7mY5jmJgFTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLNXLsBh8lS0WwBE/KsdYEg12PSSgixQAcclCmTLWnJp47QIo7NGq0iiHOmnnr/EL
         8iBg3DEdQNwCL37vxXrJBS6JTbkyT9RxGpmnZhBUqCP3aEPgAoxaS+fKgd9XC8dzti
         goXiDpagw7GTZqNd3iPCioblA9ldQwnpWwzW8AKY=
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
Subject: [PATCH 6.2 0374/1001] drm: exynos: dsi: Fix MIPI_DSI*_NO_* mode flags
Date:   Tue,  7 Mar 2023 17:52:26 +0100
Message-Id: <20230307170037.591240058@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index ec673223d6b7a..b5305b145ddbd 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -805,15 +805,15 @@ static int exynos_dsi_init_link(struct exynos_dsi *dsi)
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
index 5c621b15e84c2..439ef30735128 100644
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
index e06fd35de814b..9c3e76171759a 100644
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
index 54213beafaf5e..ebf4c2d39ea88 100644
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



