Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A55CCA5CE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404487AbfJCQgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404481AbfJCQgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24DEA2086A;
        Thu,  3 Oct 2019 16:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120610;
        bh=8tx1cmlgn/5Ir9ZkuLOgpbwC/C5FkNxh9n5gZLs1odc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z953ry2Op3et4EQ8mwckUs5yI67o43hxiJJqyCyDB4pkHBue6raxZIY1/wkeEULDW
         z4bflxTJCZ1fT1SjZNi2N+QrumGBGUnWhp73WGx8AU1TUbYyllE/b1AH77Dco/ONGY
         99DfTl4/Q0SuFLjhNEoRtCPtI9vq87xzG4ava4dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lukasz Majewski <lukma@denx.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.2 248/313] spi: ep93xx: Repair SPI CS lookup tables
Date:   Thu,  3 Oct 2019 17:53:46 +0200
Message-Id: <20191003154557.473861482@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@gmail.com>

commit 4fbc485324d2975c54201091dfad0a7dd4902324 upstream.

The actual device name of the SPI controller being registered on EP93xx is
"spi0" (as seen by gpiod_find_lookup_table()). This patch fixes all
relevant lookup tables and the following failure (seen on EDB9302):

ep93xx-spi ep93xx-spi.0: failed to register SPI master
ep93xx-spi: probe of ep93xx-spi.0 failed with error -22

Fixes: 1dfbf334f1236 ("spi: ep93xx: Convert to use CS GPIO descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Lukasz Majewski <lukma@denx.de>
Link: https://lore.kernel.org/r/20190831180402.10008-1-alexander.sverdlin@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-ep93xx/edb93xx.c       |    2 +-
 arch/arm/mach-ep93xx/simone.c        |    2 +-
 arch/arm/mach-ep93xx/ts72xx.c        |    4 ++--
 arch/arm/mach-ep93xx/vision_ep9307.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/mach-ep93xx/edb93xx.c
+++ b/arch/arm/mach-ep93xx/edb93xx.c
@@ -103,7 +103,7 @@ static struct spi_board_info edb93xx_spi
 };
 
 static struct gpiod_lookup_table edb93xx_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("A", 6, "cs", GPIO_ACTIVE_LOW),
 		{ },
--- a/arch/arm/mach-ep93xx/simone.c
+++ b/arch/arm/mach-ep93xx/simone.c
@@ -73,7 +73,7 @@ static struct spi_board_info simone_spi_
  * v1.3 parts will still work, since the signal on SFRMOUT is automatic.
  */
 static struct gpiod_lookup_table simone_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("A", 1, "cs", GPIO_ACTIVE_LOW),
 		{ },
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -267,7 +267,7 @@ static struct spi_board_info bk3_spi_boa
  * goes through CPLD
  */
 static struct gpiod_lookup_table bk3_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("F", 3, "cs", GPIO_ACTIVE_LOW),
 		{ },
@@ -316,7 +316,7 @@ static struct spi_board_info ts72xx_spi_
 };
 
 static struct gpiod_lookup_table ts72xx_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		/* DIO_17 */
 		GPIO_LOOKUP("F", 2, "cs", GPIO_ACTIVE_LOW),
--- a/arch/arm/mach-ep93xx/vision_ep9307.c
+++ b/arch/arm/mach-ep93xx/vision_ep9307.c
@@ -242,7 +242,7 @@ static struct spi_board_info vision_spi_
 };
 
 static struct gpiod_lookup_table vision_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP_IDX("A", 6, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("A", 7, "cs", 1, GPIO_ACTIVE_LOW),


