Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2244451A811
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346303AbiEDRHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355353AbiEDRER (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6854ECD2;
        Wed,  4 May 2022 09:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60BDC61701;
        Wed,  4 May 2022 16:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD934C385B0;
        Wed,  4 May 2022 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683173;
        bh=k/8Oplo43mu4djVxDNVjz+6avtQ/vUQIAwVKTqLIjg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU2iKinG6wDAIk5tunmpLCvlIHuW1k4cp8jO4bNM7oqazxZlpCmHxFuOddhXsU1am
         mr5NrULtZP/nYdytnLMdBUIRpRupu5E89oAoY42/tSz4+7noxKWTOzeNegIANlzTR1
         4Yc+mZua7vYo1vnen+gk/ZDnmuYg27lo37NPvSVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 038/177] pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config
Date:   Wed,  4 May 2022 18:43:51 +0200
Message-Id: <20220504153056.337925290@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ac875df4d854ab13d9c4af682a1837a1214fecec upstream.

The Samsung pinctrl drivers depend on OF_GPIO, which is part of GPIOLIB.
ARMv7 Exynos platform selects GPIOLIB and Samsung pinctrl drivers. ARMv8
Exynos selects only the latter leading to possible wrong configuration
on ARMv8 build:

  WARNING: unmet direct dependencies detected for PINCTRL_EXYNOS
    Depends on [n]: PINCTRL [=y] && OF_GPIO [=n] && (ARCH_EXYNOS [=y] || ARCH_S5PV210 || COMPILE_TEST [=y])
    Selected by [y]:
    - ARCH_EXYNOS [=y]

Always select the GPIOLIB from the Samsung pinctrl drivers to fix the
issue.  This requires removing of OF_GPIO dependency (to avoid recursive
dependency), so add dependency on OF for COMPILE_TEST cases.

Reported-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Fixes: eed6b3eb20b9 ("arm64: Split out platform options to separate Kconfig")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20220420141407.470955-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-exynos/Kconfig    |    1 -
 drivers/pinctrl/samsung/Kconfig |   11 ++++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -18,7 +18,6 @@ menuconfig ARCH_EXYNOS
 	select EXYNOS_PMU
 	select EXYNOS_SROM
 	select EXYNOS_PM_DOMAINS if PM_GENERIC_DOMAINS
-	select GPIOLIB
 	select HAVE_ARM_ARCH_TIMER if ARCH_EXYNOS5
 	select HAVE_ARM_SCU if SMP
 	select HAVE_S3C2410_I2C if I2C
--- a/drivers/pinctrl/samsung/Kconfig
+++ b/drivers/pinctrl/samsung/Kconfig
@@ -4,14 +4,13 @@
 #
 config PINCTRL_SAMSUNG
 	bool
-	depends on OF_GPIO
+	select GPIOLIB
 	select PINMUX
 	select PINCONF
 
 config PINCTRL_EXYNOS
 	bool "Pinctrl common driver part for Samsung Exynos SoCs"
-	depends on OF_GPIO
-	depends on ARCH_EXYNOS || ARCH_S5PV210 || COMPILE_TEST
+	depends on ARCH_EXYNOS || ARCH_S5PV210 || (COMPILE_TEST && OF)
 	select PINCTRL_SAMSUNG
 	select PINCTRL_EXYNOS_ARM if ARM && (ARCH_EXYNOS || ARCH_S5PV210)
 	select PINCTRL_EXYNOS_ARM64 if ARM64 && ARCH_EXYNOS
@@ -26,12 +25,10 @@ config PINCTRL_EXYNOS_ARM64
 
 config PINCTRL_S3C24XX
 	bool "Samsung S3C24XX SoC pinctrl driver"
-	depends on OF_GPIO
-	depends on ARCH_S3C24XX || COMPILE_TEST
+	depends on ARCH_S3C24XX || (COMPILE_TEST && OF)
 	select PINCTRL_SAMSUNG
 
 config PINCTRL_S3C64XX
 	bool "Samsung S3C64XX SoC pinctrl driver"
-	depends on OF_GPIO
-	depends on ARCH_S3C64XX || COMPILE_TEST
+	depends on ARCH_S3C64XX || (COMPILE_TEST && OF)
 	select PINCTRL_SAMSUNG


