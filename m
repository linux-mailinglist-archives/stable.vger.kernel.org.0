Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5C89E15A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbfH0IAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbfH0IAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:00:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1215321881;
        Tue, 27 Aug 2019 08:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892851;
        bh=dgHXCG99BbGflJzbvIbU4TrzseN4PJlHozqQ2+cqvng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zln5XOtOso7uGp29gD68bGj2fX5mwJYpwExPFiHuguqCmaRsLDxkmqklrxPA/rTj6
         4P/UQe+iIh/axppjbvjUpcjefbz/NP5vPAiFE05BpXC6ehNS0rlvmoVg7hnpp7UNqA
         aHtghwS9XDEWAKT0n/a1M9ryU0Xvm/T6gSaqP9oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 036/162] Staging: fbtft: Fix GPIO handling
Date:   Tue, 27 Aug 2019 09:49:24 +0200
Message-Id: <20190827072739.532505195@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index bc750250ccd6c..5127de922f6a2 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -916,7 +916,7 @@ static int fbtft_init_display_dt(struct fbtft_par *par)
 		return -EINVAL;
 
 	par->fbtftops.reset(par);
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	while (p) {
@@ -1007,7 +1007,7 @@ int fbtft_init_display(struct fbtft_par *par)
 	}
 
 	par->fbtftops.reset(par);
-	if (!par->gpio.cs)
+	if (par->gpio.cs)
 		gpiod_set_value(par->gpio.cs, 0);  /* Activate chip */
 
 	i = 0;
-- 
2.20.1



