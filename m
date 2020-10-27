Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CD729BAF5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802745AbgJ0PvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802112AbgJ0Ppj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C6D22202;
        Tue, 27 Oct 2020 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813538;
        bh=viKBnEiXkk4rep8U6Ht4e9I70DxQdVOif0fayC6RNXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+EshRLoCRU+Avml+LOXBkF2X7J122K/dBnkRuskHCdrxCWUJd7ppiQfU8qkA4//Y
         NNk3lzX6Sb7WeMQv4RYL/jEPXnxR2vas/FMW5zA2ieDGlkiRyxIOlvnMddABcqa9sJ
         16LsnM/yevsNznpc1vx2X5Twzn3Y7nzTwDUd7t4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 586/757] ARM: s3c24xx: fix mmc gpio lookup tables
Date:   Tue, 27 Oct 2020 14:53:56 +0100
Message-Id: <20201027135518.019025146@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3af4e8774b6d03683932b0961998e01355bccd74 ]

The gpio controller names differ between s3c24xx and s3c64xx,
and it seems that these all got the wrong names, using GPx instead
of GPIOx.

Fixes: d2951dfa070d ("mmc: s3cmci: Use the slot GPIO descriptor")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20200806182059.2431-3-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-s3c24xx/mach-at2440evb.c | 2 +-
 arch/arm/mach-s3c24xx/mach-h1940.c     | 4 ++--
 arch/arm/mach-s3c24xx/mach-mini2440.c  | 4 ++--
 arch/arm/mach-s3c24xx/mach-n30.c       | 4 ++--
 arch/arm/mach-s3c24xx/mach-rx1950.c    | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/mach-at2440evb.c b/arch/arm/mach-s3c24xx/mach-at2440evb.c
index 58c5ef3cf1d7e..2d370f7f75fa2 100644
--- a/arch/arm/mach-s3c24xx/mach-at2440evb.c
+++ b/arch/arm/mach-s3c24xx/mach-at2440evb.c
@@ -143,7 +143,7 @@ static struct gpiod_lookup_table at2440evb_mci_gpio_table = {
 	.dev_id = "s3c2410-sdi",
 	.table = {
 		/* Card detect S3C2410_GPG(10) */
-		GPIO_LOOKUP("GPG", 10, "cd", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOG", 10, "cd", GPIO_ACTIVE_LOW),
 		{ },
 	},
 };
diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index f4710052843ac..3601c7abe69dc 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -468,9 +468,9 @@ static struct gpiod_lookup_table h1940_mmc_gpio_table = {
 	.dev_id = "s3c2410-sdi",
 	.table = {
 		/* Card detect S3C2410_GPF(5) */
-		GPIO_LOOKUP("GPF", 5, "cd", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOF", 5, "cd", GPIO_ACTIVE_LOW),
 		/* Write protect S3C2410_GPH(8) */
-		GPIO_LOOKUP("GPH", 8, "wp", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOH", 8, "wp", GPIO_ACTIVE_LOW),
 		{ },
 	},
 };
diff --git a/arch/arm/mach-s3c24xx/mach-mini2440.c b/arch/arm/mach-s3c24xx/mach-mini2440.c
index 2357494483118..5729bf07a6232 100644
--- a/arch/arm/mach-s3c24xx/mach-mini2440.c
+++ b/arch/arm/mach-s3c24xx/mach-mini2440.c
@@ -244,9 +244,9 @@ static struct gpiod_lookup_table mini2440_mmc_gpio_table = {
 	.dev_id = "s3c2410-sdi",
 	.table = {
 		/* Card detect S3C2410_GPG(8) */
-		GPIO_LOOKUP("GPG", 8, "cd", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOG", 8, "cd", GPIO_ACTIVE_LOW),
 		/* Write protect S3C2410_GPH(8) */
-		GPIO_LOOKUP("GPH", 8, "wp", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("GPIOH", 8, "wp", GPIO_ACTIVE_HIGH),
 		{ },
 	},
 };
diff --git a/arch/arm/mach-s3c24xx/mach-n30.c b/arch/arm/mach-s3c24xx/mach-n30.c
index 998ccff3c174b..ed993bc666351 100644
--- a/arch/arm/mach-s3c24xx/mach-n30.c
+++ b/arch/arm/mach-s3c24xx/mach-n30.c
@@ -389,9 +389,9 @@ static struct gpiod_lookup_table n30_mci_gpio_table = {
 	.dev_id = "s3c2410-sdi",
 	.table = {
 		/* Card detect S3C2410_GPF(1) */
-		GPIO_LOOKUP("GPF", 1, "cd", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOF", 1, "cd", GPIO_ACTIVE_LOW),
 		/* Write protect S3C2410_GPG(10) */
-		GPIO_LOOKUP("GPG", 10, "wp", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOG", 10, "wp", GPIO_ACTIVE_LOW),
 		{ },
 	},
 };
diff --git a/arch/arm/mach-s3c24xx/mach-rx1950.c b/arch/arm/mach-s3c24xx/mach-rx1950.c
index fde98b175c752..c0a06f123cfea 100644
--- a/arch/arm/mach-s3c24xx/mach-rx1950.c
+++ b/arch/arm/mach-s3c24xx/mach-rx1950.c
@@ -571,9 +571,9 @@ static struct gpiod_lookup_table rx1950_mmc_gpio_table = {
 	.dev_id = "s3c2410-sdi",
 	.table = {
 		/* Card detect S3C2410_GPF(5) */
-		GPIO_LOOKUP("GPF", 5, "cd", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOF", 5, "cd", GPIO_ACTIVE_LOW),
 		/* Write protect S3C2410_GPH(8) */
-		GPIO_LOOKUP("GPH", 8, "wp", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("GPIOH", 8, "wp", GPIO_ACTIVE_LOW),
 		{ },
 	},
 };
-- 
2.25.1



