Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC16C167864
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgBUIsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgBUHrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:47:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2897120801;
        Fri, 21 Feb 2020 07:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271239;
        bh=WqaG5AzvhJERv+jxrahx7FcSznI7YlI6rgAoKinkqlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HioetwjL12PpoMCB9PwW1KiShGVk2F63TT6D5uDklzePFV6tRNjvzZ33nWgGutcvK
         kPFXM8jLBCsdT162Ht3528YqQHg3l2RYxofrm55XU+RkovZ/HhSPVJLWgaMSM8COF3
         GtDeaDXnPsVrWpucpv9AQpGUeoDmq0LB3zRxHPoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        kbuild test robot <lkp@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 091/399] rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed
Date:   Fri, 21 Feb 2020 08:36:56 +0100
Message-Id: <20200221072411.186325710@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 34719de919af07682861cb0fa2bcf64da33ecf44 ]

Merely enabling I2C and RTC selects REGMAP_I2C and REGMAP_SPI, even when
no driver needs it.  While the former can be moduler, the latter cannot,
and thus becomes built-in.

Fix this by moving the select statements for REGMAP_I2C and REGMAP_SPI
from the RTC_I2C_AND_SPI helper to the individual drivers that depend on
it.

Note that the comment for RTC_I2C_AND_SPI refers to SND_SOC_I2C_AND_SPI
for more information, but the latter does not select REGMAP_{I2C,SPI}
itself, and defers that to the individual drivers, too.

Fixes: 080481f54ef62121 ("rtc: merge ds3232 and ds3234")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: kbuild test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20200112171349.22268-1-geert@linux-m68k.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index d77515d8382c7..738fa07188409 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -848,14 +848,14 @@ config RTC_I2C_AND_SPI
 	default m if I2C=m
 	default y if I2C=y
 	default y if SPI_MASTER=y
-	select REGMAP_I2C if I2C
-	select REGMAP_SPI if SPI_MASTER
 
 comment "SPI and I2C RTC drivers"
 
 config RTC_DRV_DS3232
 	tristate "Dallas/Maxim DS3232/DS3234"
 	depends on RTC_I2C_AND_SPI
+	select REGMAP_I2C if I2C
+	select REGMAP_SPI if SPI_MASTER
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS3232 and DS3234 real-time clock chips. If an interrupt is associated
@@ -875,6 +875,8 @@ config RTC_DRV_DS3232_HWMON
 config RTC_DRV_PCF2127
 	tristate "NXP PCF2127"
 	depends on RTC_I2C_AND_SPI
+	select REGMAP_I2C if I2C
+	select REGMAP_SPI if SPI_MASTER
 	select WATCHDOG_CORE if WATCHDOG
 	help
 	  If you say yes here you get support for the NXP PCF2127/29 RTC
@@ -891,6 +893,8 @@ config RTC_DRV_PCF2127
 config RTC_DRV_RV3029C2
 	tristate "Micro Crystal RV3029/3049"
 	depends on RTC_I2C_AND_SPI
+	select REGMAP_I2C if I2C
+	select REGMAP_SPI if SPI_MASTER
 	help
 	  If you say yes here you get support for the Micro Crystal
 	  RV3029 and RV3049 RTC chips.
-- 
2.20.1



