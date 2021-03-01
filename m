Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF80328BBF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240341AbhCASiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234419AbhCASdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:33:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EA98650C3;
        Mon,  1 Mar 2021 17:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620577;
        bh=X3iQd77FCKkj72n3KxqXb/JyOMiOHBUQJJesxBrWpOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xy3dfSKn2DzMDzojyrjKIwfBPTufuQtf0U1p8Er7t0EIEG6VYu7EAt7YeoiY8O1Uo
         19UgB5hzVM41ESZsaKKfhufpWWvSd6UP5QTm9docMKg39qEwEs57otrhgTRRyuekMp
         s7Cp/xaSybBH9nBOGhjIN4xkFhF7CMUPX6vdSfow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 173/775] drm/panel: s6e63m0: Fix init sequence again
Date:   Mon,  1 Mar 2021 17:05:41 +0100
Message-Id: <20210301161210.182366931@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 47b1adc1d2a3b39233a56e183296b335222c9a6d ]

The DSI version of the panel behaved instable and close
scrutiny of the vendor driver from the Samsung
GT-S8190 shows a different initialization sequence for
the DSI mode panel than the DPI mode panel.

Make the initialization depend on whether we are in
DSI or DPI mode and handle the differences.

After this the panel on the GT-I8190 becomes much more
stable.

Also spell out some more custom DCS commands found in
the vendor source code to cut down a bit on magic
where we can.

Fixes: f0aee45ffc8b ("drm/panel: s6e63m0: Fix init sequence")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephan Gerhold <stephan@gerhold.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20201205122229.1952980-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-samsung-s6e63m0.c | 42 ++++++++++++++-----
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c b/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c
index 6b4e97bfd46ee..bf6d704d4d272 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c
@@ -25,6 +25,14 @@
 /* Manufacturer Command Set */
 #define MCS_ELVSS_ON		0xb1
 #define MCS_TEMP_SWIRE		0xb2
+#define MCS_PENTILE_1		0xb3
+#define MCS_PENTILE_2		0xb4
+#define MCS_GAMMA_DELTA_Y_RED	0xb5
+#define MCS_GAMMA_DELTA_X_RED	0xb6
+#define MCS_GAMMA_DELTA_Y_GREEN	0xb7
+#define MCS_GAMMA_DELTA_X_GREEN	0xb8
+#define MCS_GAMMA_DELTA_Y_BLUE	0xb9
+#define MCS_GAMMA_DELTA_X_BLUE	0xba
 #define MCS_MIECTL1		0xc0
 #define MCS_BCMODE		0xc1
 #define MCS_ERROR_CHECK		0xd5
@@ -281,6 +289,7 @@ struct s6e63m0 {
 	struct backlight_device *bl_dev;
 	u8 lcd_type;
 	u8 elvss_pulse;
+	bool dsi_mode;
 
 	struct regulator_bulk_data supplies[2];
 	struct gpio_desc *reset_gpio;
@@ -395,9 +404,21 @@ static int s6e63m0_check_lcd_type(struct s6e63m0 *ctx)
 
 static void s6e63m0_init(struct s6e63m0 *ctx)
 {
-	s6e63m0_dcs_write_seq_static(ctx, MCS_PANELCTL,
-				     0x01, 0x27, 0x27, 0x07, 0x07, 0x54, 0x9f,
-				     0x63, 0x8f, 0x1a, 0x33, 0x0d, 0x00, 0x00);
+	/*
+	 * We do not know why there is a difference in the DSI mode.
+	 * (No datasheet.)
+	 *
+	 * In the vendor driver this sequence is called
+	 * "SEQ_PANEL_CONDITION_SET" or "DCS_CMD_SEQ_PANEL_COND_SET".
+	 */
+	if (ctx->dsi_mode)
+		s6e63m0_dcs_write_seq_static(ctx, MCS_PANELCTL,
+					     0x01, 0x2c, 0x2c, 0x07, 0x07, 0x5f, 0xb3,
+					     0x6d, 0x97, 0x1d, 0x3a, 0x0f, 0x00, 0x00);
+	else
+		s6e63m0_dcs_write_seq_static(ctx, MCS_PANELCTL,
+					     0x01, 0x27, 0x27, 0x07, 0x07, 0x54, 0x9f,
+					     0x63, 0x8f, 0x1a, 0x33, 0x0d, 0x00, 0x00);
 
 	s6e63m0_dcs_write_seq_static(ctx, MCS_DISCTL,
 				     0x02, 0x03, 0x1c, 0x10, 0x10);
@@ -414,40 +435,40 @@ static void s6e63m0_init(struct s6e63m0 *ctx)
 
 	s6e63m0_dcs_write_seq_static(ctx, MCS_SRCCTL,
 				     0x00, 0x8e, 0x07);
-	s6e63m0_dcs_write_seq_static(ctx, 0xb3, 0x6c);
+	s6e63m0_dcs_write_seq_static(ctx, MCS_PENTILE_1, 0x6c);
 
-	s6e63m0_dcs_write_seq_static(ctx, 0xb5,
+	s6e63m0_dcs_write_seq_static(ctx, MCS_GAMMA_DELTA_Y_RED,
 				     0x2c, 0x12, 0x0c, 0x0a, 0x10, 0x0e, 0x17,
 				     0x13, 0x1f, 0x1a, 0x2a, 0x24, 0x1f, 0x1b,
 				     0x1a, 0x17, 0x2b, 0x26, 0x22, 0x20, 0x3a,
 				     0x34, 0x30, 0x2c, 0x29, 0x26, 0x25, 0x23,
 				     0x21, 0x20, 0x1e, 0x1e);
 
-	s6e63m0_dcs_write_seq_static(ctx, 0xb6,
+	s6e63m0_dcs_write_seq_static(ctx, MCS_GAMMA_DELTA_X_RED,
 				     0x00, 0x00, 0x11, 0x22, 0x33, 0x44, 0x44,
 				     0x44, 0x55, 0x55, 0x66, 0x66, 0x66, 0x66,
 				     0x66, 0x66);
 
-	s6e63m0_dcs_write_seq_static(ctx, 0xb7,
+	s6e63m0_dcs_write_seq_static(ctx, MCS_GAMMA_DELTA_Y_GREEN,
 				     0x2c, 0x12, 0x0c, 0x0a, 0x10, 0x0e, 0x17,
 				     0x13, 0x1f, 0x1a, 0x2a, 0x24, 0x1f, 0x1b,
 				     0x1a, 0x17, 0x2b, 0x26, 0x22, 0x20, 0x3a,
 				     0x34, 0x30, 0x2c, 0x29, 0x26, 0x25, 0x23,
 				     0x21, 0x20, 0x1e, 0x1e);
 
-	s6e63m0_dcs_write_seq_static(ctx, 0xb8,
+	s6e63m0_dcs_write_seq_static(ctx, MCS_GAMMA_DELTA_X_GREEN,
 				     0x00, 0x00, 0x11, 0x22, 0x33, 0x44, 0x44,
 				     0x44, 0x55, 0x55, 0x66, 0x66, 0x66, 0x66,
 				     0x66, 0x66);
 
-	s6e63m0_dcs_write_seq_static(ctx, 0xb9,
+	s6e63m0_dcs_write_seq_static(ctx, MCS_GAMMA_DELTA_Y_BLUE,
 				     0x2c, 0x12, 0x0c, 0x0a, 0x10, 0x0e, 0x17,
 				     0x13, 0x1f, 0x1a, 0x2a, 0x24, 0x1f, 0x1b,
 				     0x1a, 0x17, 0x2b, 0x26, 0x22, 0x20, 0x3a,
 				     0x34, 0x30, 0x2c, 0x29, 0x26, 0x25, 0x23,
 				     0x21, 0x20, 0x1e, 0x1e);
 
-	s6e63m0_dcs_write_seq_static(ctx, 0xba,
+	s6e63m0_dcs_write_seq_static(ctx, MCS_GAMMA_DELTA_X_BLUE,
 				     0x00, 0x00, 0x11, 0x22, 0x33, 0x44, 0x44,
 				     0x44, 0x55, 0x55, 0x66, 0x66, 0x66, 0x66,
 				     0x66, 0x66);
@@ -704,6 +725,7 @@ int s6e63m0_probe(struct device *dev,
 	if (!ctx)
 		return -ENOMEM;
 
+	ctx->dsi_mode = dsi_mode;
 	ctx->dcs_read = dcs_read;
 	ctx->dcs_write = dcs_write;
 	dev_set_drvdata(dev, ctx);
-- 
2.27.0



