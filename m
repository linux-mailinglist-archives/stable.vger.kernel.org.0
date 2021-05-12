Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32FB37C4AB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhELPcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235588AbhELP2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5359D61927;
        Wed, 12 May 2021 15:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832439;
        bh=ebpeTUPceSpVd/grUiwFhwsx4iF7Qk0hPHsj90j+/UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdaeL2HqulA4mutKvno4nIk6UkM4vve9DOwIhkOjQgqjkxSLX4qLUBU/TmUKMhWsc
         JDdoeWwwJbuOtg0Zt1iLh3xcr3U2Ktvohrokk+uURs6aIDx12w0g5dWv+havFUGhTD
         nIPYwFJwiGgPUFeY1WDGLVqEof141cuGrRsNPk14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/530] drm/mcde/panel: Inverse misunderstood flag
Date:   Wed, 12 May 2021 16:46:30 +0200
Message-Id: <20210512144829.013545161@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit d0c5ac04e7feedbc069f26f4dcbf35b521ae7fc5 ]

A recent patch renaming MIPI_DSI_MODE_EOT_PACKET to
MIPI_DSI_MODE_NO_EOT_PACKET brought to light the
misunderstanding in the current MCDE driver and all
its associated panel drivers that MIPI_DSI_MODE_EOT_PACKET
would mean "use EOT packet" when in fact it means the
reverse.

Fix it up by implementing the flag right in the MCDE
DSI driver and remove the flag from panels that actually
want the EOT packet.

Suggested-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Nicolas Boichat <drinkcat@chromium.org>
Fixes: 5fc537bfd000 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
Fixes: 899f24ed8d3a ("drm/panel: Add driver for Novatek NT35510-based panels")
Fixes: ac1d6d74884e ("drm/panel: Add driver for Samsung S6D16D0 panel")
Fixes: 435e06c06cb2 ("drm/panel: s6e63m0: Add DSI transport")
Fixes: 8152c2bfd780 ("drm/panel: Add driver for Sony ACX424AKP panel")
Link: https://patchwork.freedesktop.org/patch/msgid/20210304004138.1785057-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_dsi.c                   | 2 +-
 drivers/gpu/drm/panel/panel-novatek-nt35510.c     | 3 +--
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c     | 4 +---
 drivers/gpu/drm/panel/panel-samsung-s6e63m0-dsi.c | 1 -
 drivers/gpu/drm/panel/panel-sony-acx424akp.c      | 3 +--
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/mcde/mcde_dsi.c b/drivers/gpu/drm/mcde/mcde_dsi.c
index 2314c8122992..b3fd3501c412 100644
--- a/drivers/gpu/drm/mcde/mcde_dsi.c
+++ b/drivers/gpu/drm/mcde/mcde_dsi.c
@@ -760,7 +760,7 @@ static void mcde_dsi_start(struct mcde_dsi *d)
 		DSI_MCTL_MAIN_DATA_CTL_BTA_EN |
 		DSI_MCTL_MAIN_DATA_CTL_READ_EN |
 		DSI_MCTL_MAIN_DATA_CTL_REG_TE_EN;
-	if (d->mdsi->mode_flags & MIPI_DSI_MODE_EOT_PACKET)
+	if (!(d->mdsi->mode_flags & MIPI_DSI_MODE_EOT_PACKET))
 		val |= DSI_MCTL_MAIN_DATA_CTL_HOST_EOT_GEN;
 	writel(val, d->regs + DSI_MCTL_MAIN_DATA_CTL);
 
diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35510.c b/drivers/gpu/drm/panel/panel-novatek-nt35510.c
index b9a0e56f33e2..ef70140c5b09 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35510.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35510.c
@@ -898,8 +898,7 @@ static int nt35510_probe(struct mipi_dsi_device *dsi)
 	 */
 	dsi->hs_rate = 349440000;
 	dsi->lp_rate = 9600000;
-	dsi->mode_flags = MIPI_DSI_CLOCK_NON_CONTINUOUS |
-		MIPI_DSI_MODE_EOT_PACKET;
+	dsi->mode_flags = MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
 	/*
 	 * Every new incarnation of this display must have a unique
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c b/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
index 4aac0d1573dd..70560cac53a9 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
@@ -184,9 +184,7 @@ static int s6d16d0_probe(struct mipi_dsi_device *dsi)
 	 * As we only send commands we do not need to be continuously
 	 * clocked.
 	 */
-	dsi->mode_flags =
-		MIPI_DSI_CLOCK_NON_CONTINUOUS |
-		MIPI_DSI_MODE_EOT_PACKET;
+	dsi->mode_flags = MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
 	s6->supply = devm_regulator_get(dev, "vdd1");
 	if (IS_ERR(s6->supply))
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e63m0-dsi.c b/drivers/gpu/drm/panel/panel-samsung-s6e63m0-dsi.c
index eec74c10ddda..9c3563c61e8c 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e63m0-dsi.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e63m0-dsi.c
@@ -97,7 +97,6 @@ static int s6e63m0_dsi_probe(struct mipi_dsi_device *dsi)
 	dsi->hs_rate = 349440000;
 	dsi->lp_rate = 9600000;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO |
-		MIPI_DSI_MODE_EOT_PACKET |
 		MIPI_DSI_MODE_VIDEO_BURST;
 
 	ret = s6e63m0_probe(dev, s6e63m0_dsi_dcs_read, s6e63m0_dsi_dcs_write,
diff --git a/drivers/gpu/drm/panel/panel-sony-acx424akp.c b/drivers/gpu/drm/panel/panel-sony-acx424akp.c
index 065efae213f5..95659a4d15e9 100644
--- a/drivers/gpu/drm/panel/panel-sony-acx424akp.c
+++ b/drivers/gpu/drm/panel/panel-sony-acx424akp.c
@@ -449,8 +449,7 @@ static int acx424akp_probe(struct mipi_dsi_device *dsi)
 			MIPI_DSI_MODE_VIDEO_BURST;
 	else
 		dsi->mode_flags =
-			MIPI_DSI_CLOCK_NON_CONTINUOUS |
-			MIPI_DSI_MODE_EOT_PACKET;
+			MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
 	acx->supply = devm_regulator_get(dev, "vddi");
 	if (IS_ERR(acx->supply))
-- 
2.30.2



