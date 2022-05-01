Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A31516689
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 19:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiEARQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 13:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiEARQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 13:16:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB35C580D0
        for <stable@vger.kernel.org>; Sun,  1 May 2022 10:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF0A9B80E91
        for <stable@vger.kernel.org>; Sun,  1 May 2022 17:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA1EC385AA;
        Sun,  1 May 2022 17:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651425209;
        bh=ay+6afZo8WD3HxzaJexfMj8eIGAkQXprxmAblM4g/lA=;
        h=Subject:To:Cc:From:Date:From;
        b=uGoMmK8LMqjTgfvepuyuItBxkFfHxZeKFicfbTm0Zida1Q2rWqu1wx7+40dF1Co4T
         npNTLtsNFJ2lml2ceOrhiJwwrbPFALVO1YYb+Z/IJa7cJxY2azMf8cEWwT214RX+Jz
         lHPOGQ8QF3qj81UHmXcEFyybrnPqN/4t8Pbl3gZ8=
Subject: FAILED: patch "[PATCH] pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config" failed to apply to 5.4-stable tree
To:     krzysztof.kozlowski@linaro.org, arnd@arndb.de,
        fazilyildiran@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 19:13:22 +0200
Message-ID: <1651425202250211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ac875df4d854ab13d9c4af682a1837a1214fecec Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 20 Apr 2022 16:14:07 +0200
Subject: [PATCH] pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config

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

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index f7d993628cb7..a9c1efcf7c9c 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -17,7 +17,6 @@ menuconfig ARCH_EXYNOS
 	select EXYNOS_PMU
 	select EXYNOS_SROM
 	select EXYNOS_PM_DOMAINS if PM_GENERIC_DOMAINS
-	select GPIOLIB
 	select HAVE_ARM_ARCH_TIMER if ARCH_EXYNOS5
 	select HAVE_ARM_SCU if SMP
 	select PINCTRL
diff --git a/drivers/pinctrl/samsung/Kconfig b/drivers/pinctrl/samsung/Kconfig
index dfd805e76862..7b0576f71376 100644
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

