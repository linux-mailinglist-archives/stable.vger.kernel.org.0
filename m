Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DE38C969
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfHNCM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbfHNCMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C1220842;
        Wed, 14 Aug 2019 02:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748743;
        bh=ed986r5hXz2jFm/xnp0aJsVrHTaLCp8d/JzUrylEx+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXsyqBmgYNwltaXcARhC4/nzyfb994k1g9RMwWHuynKMKaStrE4k5rwtLbHeL+Tf9
         ton9HyJjuME0D9SkNmsrX2swy0ZbngTqtbjDZxs0QvrsqouHt/to3gZxkan8+GfeQD
         FCZv9K6ecfBDBuBmeRaLbLKCEzXN7Vs3YIhmtQ8Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.2 041/123] Staging: fbtft: Fix GPIO handling
Date:   Tue, 13 Aug 2019 22:09:25 -0400
Message-Id: <20190814021047.14828-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Sebastian Götte <linux@jaseg.net>

[ Upstream commit 92e3e884887c0d278042fbbb6f6c9b41d6addb71 ]

Commit c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor
interface") breaks GPIO handling. In several places, checks to only set
a GPIO if it was configured ended up backwards.
I have tested this fix. The fixed driver works with a ili9486
display connected to a raspberry pi via SPI.

Fixes: c440eee1a7a1d ("Staging: fbtft: Switch to the gpio descriptor interface")
Tested-by: Jan Sebastian Götte <linux@jaseg.net>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Jan Sebastian Götte <linux@jaseg.net>
Link: https://lore.kernel.org/r/75ada52f-afa1-08bc-d0ce-966fc1110e70@jaseg.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fb_bd663474.c  | 2 +-
 drivers/staging/fbtft/fb_ili9163.c   | 2 +-
 drivers/staging/fbtft/fb_ili9325.c   | 2 +-
 drivers/staging/fbtft/fb_s6d1121.c   | 2 +-
 drivers/staging/fbtft/fb_ssd1289.c   | 2 +-
 drivers/staging/fbtft/fb_ssd1331.c   | 4 ++--
 drivers/staging/fbtft/fb_upd161704.c | 2 +-
 drivers/staging/fbtft/fbtft-bus.c    | 2 +-
 drivers/staging/fbtft/fbtft-core.c   | 4 ++--
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/fbtft/fb_bd663474.c b/drivers/staging/fbtft/fb_bd663474.c
index b6c6d66e4eb1b..e2c7646588f8c 100644
--- a/drivers/staging/fbtft/fb_bd663474.c
+++ b/drivers/staging/fbtft/fb_bd663474.c
@@ -24,7 +24,7 @@
 
 static int init_display(struct fbtft_par *par)
 {
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	par->fbtftops.reset(par);
diff --git a/drivers/staging/fbtft/fb_ili9163.c b/drivers/staging/fbtft/fb_ili9163.c
index d609a2b67db9b..fd32376700e28 100644
--- a/drivers/staging/fbtft/fb_ili9163.c
+++ b/drivers/staging/fbtft/fb_ili9163.c
@@ -77,7 +77,7 @@ static int init_display(struct fbtft_par *par)
 {
 	par->fbtftops.reset(par);
 
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	write_reg(par, MIPI_DCS_SOFT_RESET); /* software reset */
diff --git a/drivers/staging/fbtft/fb_ili9325.c b/drivers/staging/fbtft/fb_ili9325.c
index b090e7ab6fdd6..85e54a10ed72c 100644
--- a/drivers/staging/fbtft/fb_ili9325.c
+++ b/drivers/staging/fbtft/fb_ili9325.c
@@ -85,7 +85,7 @@ static int init_display(struct fbtft_par *par)
 {
 	par->fbtftops.reset(par);
 
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	bt &= 0x07;
diff --git a/drivers/staging/fbtft/fb_s6d1121.c b/drivers/staging/fbtft/fb_s6d1121.c
index b3d0701880fe3..5a129b1352cc8 100644
--- a/drivers/staging/fbtft/fb_s6d1121.c
+++ b/drivers/staging/fbtft/fb_s6d1121.c
@@ -29,7 +29,7 @@ static int init_display(struct fbtft_par *par)
 {
 	par->fbtftops.reset(par);
 
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	/* Initialization sequence from Lib_UTFT */
diff --git a/drivers/staging/fbtft/fb_ssd1289.c b/drivers/staging/fbtft/fb_ssd1289.c
index bbf75f795234b..88a5b6925901d 100644
--- a/drivers/staging/fbtft/fb_ssd1289.c
+++ b/drivers/staging/fbtft/fb_ssd1289.c
@@ -28,7 +28,7 @@ static int init_display(struct fbtft_par *par)
 {
 	par->fbtftops.reset(par);
 
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	write_reg(par, 0x00, 0x0001);
diff --git a/drivers/staging/fbtft/fb_ssd1331.c b/drivers/staging/fbtft/fb_ssd1331.c
index 4cfe9f8535d0f..37622c9462aa7 100644
--- a/drivers/staging/fbtft/fb_ssd1331.c
+++ b/drivers/staging/fbtft/fb_ssd1331.c
@@ -81,7 +81,7 @@ static void write_reg8_bus8(struct fbtft_par *par, int len, ...)
 	va_start(args, len);
 
 	*buf = (u8)va_arg(args, unsigned int);
-	if (!par->gpio.dc)
+	if (par->gpio.dc)
 		gpiod_set_value(par->gpio.dc, 0);
 	ret = par->fbtftops.write(par, par->buf, sizeof(u8));
 	if (ret < 0) {
@@ -104,7 +104,7 @@ static void write_reg8_bus8(struct fbtft_par *par, int len, ...)
 			return;
 		}
 	}
-	if (!par->gpio.dc)
+	if (par->gpio.dc)
 		gpiod_set_value(par->gpio.dc, 1);
 	va_end(args);
 }
diff --git a/drivers/staging/fbtft/fb_upd161704.c b/drivers/staging/fbtft/fb_upd161704.c
index 564a38e344406..c77832ae5e5ba 100644
--- a/drivers/staging/fbtft/fb_upd161704.c
+++ b/drivers/staging/fbtft/fb_upd161704.c
@@ -26,7 +26,7 @@ static int init_display(struct fbtft_par *par)
 {
 	par->fbtftops.reset(par);
 
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	/* Initialization sequence from Lib_UTFT */
diff --git a/drivers/staging/fbtft/fbtft-bus.c b/drivers/staging/fbtft/fbtft-bus.c
index 2ea814d0dca5d..63c65dd67b175 100644
--- a/drivers/staging/fbtft/fbtft-bus.c
+++ b/drivers/staging/fbtft/fbtft-bus.c
@@ -135,7 +135,7 @@ int fbtft_write_vmem16_bus8(struct fbtft_par *par, size_t offset, size_t len)
 	remain = len / 2;
 	vmem16 = (u16 *)(par->info->screen_buffer + offset);
 
-	if (!par->gpio.dc)
+	if (par->gpio.dc)
 		gpiod_set_value(par->gpio.dc, 1);
 
 	/* non buffered write */
diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 9b07badf4c6ca..8fe2232442492 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -919,7 +919,7 @@ static int fbtft_init_display_dt(struct fbtft_par *par)
 		return -EINVAL;
 
 	par->fbtftops.reset(par);
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	while (p) {
@@ -1010,7 +1010,7 @@ int fbtft_init_display(struct fbtft_par *par)
 	}
 
 	par->fbtftops.reset(par);
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	i = 0;
-- 
2.20.1

