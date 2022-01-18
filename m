Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77052491A20
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345489AbiARC6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37476 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348242AbiARCpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:45:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0128C6130B;
        Tue, 18 Jan 2022 02:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FB0C36AEB;
        Tue, 18 Jan 2022 02:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473904;
        bh=OQKY68uSZxyTkO1zyDzrFf7bb6/e1IwkJ1PbxxVpPVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKswW8xPyfMcJokh4cLZq3H2S0lCP2SvMJHEGuRgdFLbdojTTa/LNJaoZCjBkX6zJ
         nEGhOo+w/DqrDXSR3nQiboHZOJDbfsrZ539dWQVwXyuS2SikPv25TqO3Iv1+EBwNyl
         c89ENDjNZOLe+JqmOSZ1UyuWkP9yw9exNEFFGXf8F8LXxeVnxHxP1Qa3DCOULYlxKb
         b8OxJLJ9sJAkQqpI4geNEtvWQUPm2cUlIcA7+sXXzkguP29TZ1DBz8+iPCvUWv2JXb
         qPXFtOuT5ycH1licz+E7Kbg21BropinjOdW2mrTK/iZ/kno8jIir5wt3R/dd3stFqp
         WXd0QZGfXh3cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linus.walleij@linaro.org, daniel@thingy.jp, avolmat@me.com,
        krzysztof.kozlowski@canonical.com, romain.perier@gmail.com,
        eugen.hristev@microchip.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 14/73] ARM: imx: rename DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART
Date:   Mon, 17 Jan 2022 21:43:33 -0500
Message-Id: <20220118024432.1952028-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit b0100bce4ff82ec1ccd3c1f3d339fd2df6a81784 ]

Since commit 4b563a066611 ("ARM: imx: Remove imx21 support"), the config
DEBUG_IMX21_IMX27_UART is really only debug support for IMX27.

So, rename this option to DEBUG_IMX27_UART and adjust dependencies in
Kconfig and rename the definitions to IMX27 as further clean-up.

This issue was discovered with ./scripts/checkkconfigsymbols.py, which
reported that DEBUG_IMX21_IMX27_UART depends on the non-existing config
SOC_IMX21.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig.debug            | 14 +++++++-------
 arch/arm/include/debug/imx-uart.h | 18 +++++++++---------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8bcbd0cd739b5..5e2b44a9df18c 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -400,12 +400,12 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on i.MX25.
 
-	config DEBUG_IMX21_IMX27_UART
-		bool "i.MX21 and i.MX27 Debug UART"
-		depends on SOC_IMX21 || SOC_IMX27
+	config DEBUG_IMX27_UART
+		bool "i.MX27 Debug UART"
+		depends on SOC_IMX27
 		help
 		  Say Y here if you want kernel low-level debugging support
-		  on i.MX21 or i.MX27.
+		  on i.MX27.
 
 	config DEBUG_IMX28_UART
 		bool "i.MX28 Debug UART"
@@ -1472,7 +1472,7 @@ config DEBUG_IMX_UART_PORT
 	int "i.MX Debug UART Port Selection"
 	depends on DEBUG_IMX1_UART || \
 		   DEBUG_IMX25_UART || \
-		   DEBUG_IMX21_IMX27_UART || \
+		   DEBUG_IMX27_UART || \
 		   DEBUG_IMX31_UART || \
 		   DEBUG_IMX35_UART || \
 		   DEBUG_IMX50_UART || \
@@ -1529,12 +1529,12 @@ config DEBUG_LL_INCLUDE
 	default "debug/icedcc.S" if DEBUG_ICEDCC
 	default "debug/imx.S" if DEBUG_IMX1_UART || \
 				 DEBUG_IMX25_UART || \
-				 DEBUG_IMX21_IMX27_UART || \
+				 DEBUG_IMX27_UART || \
 				 DEBUG_IMX31_UART || \
 				 DEBUG_IMX35_UART || \
 				 DEBUG_IMX50_UART || \
 				 DEBUG_IMX51_UART || \
-				 DEBUG_IMX53_UART ||\
+				 DEBUG_IMX53_UART || \
 				 DEBUG_IMX6Q_UART || \
 				 DEBUG_IMX6SL_UART || \
 				 DEBUG_IMX6SX_UART || \
diff --git a/arch/arm/include/debug/imx-uart.h b/arch/arm/include/debug/imx-uart.h
index c8eb83d4b8964..3edbb3c5b42bf 100644
--- a/arch/arm/include/debug/imx-uart.h
+++ b/arch/arm/include/debug/imx-uart.h
@@ -11,13 +11,6 @@
 #define IMX1_UART_BASE_ADDR(n)	IMX1_UART##n##_BASE_ADDR
 #define IMX1_UART_BASE(n)	IMX1_UART_BASE_ADDR(n)
 
-#define IMX21_UART1_BASE_ADDR	0x1000a000
-#define IMX21_UART2_BASE_ADDR	0x1000b000
-#define IMX21_UART3_BASE_ADDR	0x1000c000
-#define IMX21_UART4_BASE_ADDR	0x1000d000
-#define IMX21_UART_BASE_ADDR(n)	IMX21_UART##n##_BASE_ADDR
-#define IMX21_UART_BASE(n)	IMX21_UART_BASE_ADDR(n)
-
 #define IMX25_UART1_BASE_ADDR	0x43f90000
 #define IMX25_UART2_BASE_ADDR	0x43f94000
 #define IMX25_UART3_BASE_ADDR	0x5000c000
@@ -26,6 +19,13 @@
 #define IMX25_UART_BASE_ADDR(n)	IMX25_UART##n##_BASE_ADDR
 #define IMX25_UART_BASE(n)	IMX25_UART_BASE_ADDR(n)
 
+#define IMX27_UART1_BASE_ADDR	0x1000a000
+#define IMX27_UART2_BASE_ADDR	0x1000b000
+#define IMX27_UART3_BASE_ADDR	0x1000c000
+#define IMX27_UART4_BASE_ADDR	0x1000d000
+#define IMX27_UART_BASE_ADDR(n)	IMX27_UART##n##_BASE_ADDR
+#define IMX27_UART_BASE(n)	IMX27_UART_BASE_ADDR(n)
+
 #define IMX31_UART1_BASE_ADDR	0x43f90000
 #define IMX31_UART2_BASE_ADDR	0x43f94000
 #define IMX31_UART3_BASE_ADDR	0x5000c000
@@ -112,10 +112,10 @@
 
 #ifdef CONFIG_DEBUG_IMX1_UART
 #define UART_PADDR	IMX_DEBUG_UART_BASE(IMX1)
-#elif defined(CONFIG_DEBUG_IMX21_IMX27_UART)
-#define UART_PADDR	IMX_DEBUG_UART_BASE(IMX21)
 #elif defined(CONFIG_DEBUG_IMX25_UART)
 #define UART_PADDR	IMX_DEBUG_UART_BASE(IMX25)
+#elif defined(CONFIG_DEBUG_IMX27_UART)
+#define UART_PADDR	IMX_DEBUG_UART_BASE(IMX27)
 #elif defined(CONFIG_DEBUG_IMX31_UART)
 #define UART_PADDR	IMX_DEBUG_UART_BASE(IMX31)
 #elif defined(CONFIG_DEBUG_IMX35_UART)
-- 
2.34.1

