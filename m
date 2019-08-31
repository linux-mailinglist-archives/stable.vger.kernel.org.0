Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D6AA45B1
	for <lists+stable@lfdr.de>; Sat, 31 Aug 2019 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfHaSFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Aug 2019 14:05:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36150 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfHaSFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Aug 2019 14:05:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id p13so10683640wmh.1;
        Sat, 31 Aug 2019 11:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cg1fwu+MPCpI46o99kUNkk3DzcQuLSSfn5/pLPnlQmk=;
        b=cCG3ij4HsfNRBMeQSagh82b3Q6Pdr6zuOM9F+AM3QFjejedmyBrhGd+AV9x2Gq2Hom
         NX5CXWPhXX8vsQz77lsPbU2JztNpVBgJvBi1xwrQ3aoNWZ67sHsGg9kxrxn+CGy+4VPp
         R6xXPhYHfEOGG2aUZJqXbIn8Xzhea1nnH8oKFnSDd0YZ0UE39VRtvL2ymuvSWx1RqwQ6
         tFFaQhCbxa8n5iNNap36PlPAVUUJFn4A2cflOEqkVBV401AbpVy5CvBiyOFzUMyr2rRn
         ZVgO3E3qadGKak87yGbS1Hzlgj1Y+IijkhaTQs4W169pflSX1rtvKAXd/IKRX2PwpjRs
         PyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cg1fwu+MPCpI46o99kUNkk3DzcQuLSSfn5/pLPnlQmk=;
        b=gX4thH0l9eJxOxVhHkvpBaUkXzV8QpICRoqaHAjbGp4z7nw77g2Ak1qGuOR6KplvPn
         G2xt00P+0OJZ7wCsZjkVrHadhKz3GUJO4q+9I2DtOVafbRM+9xgmC2aPFeNTINhOQ/LZ
         bR8dKROhihaAd4S8NzCfPR/J5APMteIsnVL61FkUGSsyeAXpCGwzyD1/RaW8jEG367zt
         sTU6umGJ5tGdwMvbL0GWC3VzgPR2Gp4puHUVkm6cv85dgP1QZFLsys2gaop0HJV3YBhD
         MtlvEOETSH5l+wi822/ADD6q1+WhbONcP/UWbalBT5ebqNNKDHsMBCa1cnR+X0p1zVEs
         CcEg==
X-Gm-Message-State: APjAAAUC12WjGw+oxa9hOkEkDNug7TeMKrzCsnxtfUvrAEikw3j6B6ch
        MZaFo3T2BJD0APsyO18KfxE=
X-Google-Smtp-Source: APXvYqzaEIjD33uuFBMH28zOJch9FGQc20lyBYMjfo0iWKI8qyrhysZgJUwV0aYFwXnzbTGmPQZ2Fg==
X-Received: by 2002:a7b:ca5a:: with SMTP id m26mr24394720wml.134.1567274716535;
        Sat, 31 Aug 2019 11:05:16 -0700 (PDT)
Received: from giga-mm.localdomain ([195.245.49.151])
        by smtp.gmail.com with ESMTPSA id 20sm10471642wmj.45.2019.08.31.11.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 11:05:15 -0700 (PDT)
From:   Alexander Sverdlin <alexander.sverdlin@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-spi@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@armlinux.org.uk>,
        Lukasz Majewski <lukma@denx.de>, stable@vger.kernel.org
Subject: [PATCH] spi: ep93xx: Repair SPI CS lookup tables
Date:   Sat, 31 Aug 2019 20:04:02 +0200
Message-Id: <20190831180402.10008-1-alexander.sverdlin@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The actual device name of the SPI controller being registered on EP93xx is
"spi0" (as seen by gpiod_find_lookup_table()). This patch fixes all
relevant lookup tables and the following failure (seen on EDB9302):

ep93xx-spi ep93xx-spi.0: failed to register SPI master
ep93xx-spi: probe of ep93xx-spi.0 failed with error -22

Fixes: 1dfbf334f1236 ("spi: ep93xx: Convert to use CS GPIO descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
---
 arch/arm/mach-ep93xx/edb93xx.c       | 2 +-
 arch/arm/mach-ep93xx/simone.c        | 2 +-
 arch/arm/mach-ep93xx/ts72xx.c        | 4 ++--
 arch/arm/mach-ep93xx/vision_ep9307.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-ep93xx/edb93xx.c b/arch/arm/mach-ep93xx/edb93xx.c
index 1f0da76a39de..7b7280c21ee0 100644
--- a/arch/arm/mach-ep93xx/edb93xx.c
+++ b/arch/arm/mach-ep93xx/edb93xx.c
@@ -103,7 +103,7 @@ static struct spi_board_info edb93xx_spi_board_info[] __initdata = {
 };
 
 static struct gpiod_lookup_table edb93xx_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("A", 6, "cs", GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-ep93xx/simone.c b/arch/arm/mach-ep93xx/simone.c
index e2658e22bba1..8a53b74dc4b2 100644
--- a/arch/arm/mach-ep93xx/simone.c
+++ b/arch/arm/mach-ep93xx/simone.c
@@ -73,7 +73,7 @@ static struct spi_board_info simone_spi_devices[] __initdata = {
  * v1.3 parts will still work, since the signal on SFRMOUT is automatic.
  */
 static struct gpiod_lookup_table simone_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("A", 1, "cs", GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index 582e06e104fd..e0e1b11032f1 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -267,7 +267,7 @@ static struct spi_board_info bk3_spi_board_info[] __initdata = {
  * goes through CPLD
  */
 static struct gpiod_lookup_table bk3_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("F", 3, "cs", GPIO_ACTIVE_LOW),
 		{ },
@@ -316,7 +316,7 @@ static struct spi_board_info ts72xx_spi_devices[] __initdata = {
 };
 
 static struct gpiod_lookup_table ts72xx_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		/* DIO_17 */
 		GPIO_LOOKUP("F", 2, "cs", GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-ep93xx/vision_ep9307.c b/arch/arm/mach-ep93xx/vision_ep9307.c
index a88a1d807b32..cbcba3136d74 100644
--- a/arch/arm/mach-ep93xx/vision_ep9307.c
+++ b/arch/arm/mach-ep93xx/vision_ep9307.c
@@ -242,7 +242,7 @@ static struct spi_board_info vision_spi_board_info[] __initdata = {
 };
 
 static struct gpiod_lookup_table vision_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP_IDX("A", 6, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("A", 7, "cs", 1, GPIO_ACTIVE_LOW),
-- 
2.21.0

