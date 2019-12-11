Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEDB11B521
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbfLKPVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732088AbfLKPVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B6424658;
        Wed, 11 Dec 2019 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077681;
        bh=qimXf1b7cWkkRn9D6jNRqQJ/dsdCYDwr4DBZveKK1Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0LlndkS5juEYf2Cl8yypMl+Vb7SOg7QttSXmmmtjnLJm297qhZJbHSO7seq+7xcr
         z4rhZxNb0pLtvu7WAx9ih3gpxGiD1EUqyQW/CRYG5G7K7uXcNQrbjvrkRS8njx0JXx
         Phrh56Xfu3bEzw3nUeu7eAbvLHs4JxSDvOu8V9Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/243] ARM: debug: enable UART1 for socfpga Cyclone5
Date:   Wed, 11 Dec 2019 16:04:52 +0100
Message-Id: <20191211150347.905454150@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit f6628486c8489e91c513b62608f89ccdb745600d ]

Cyclone5 and Arria10 doesn't have the same memory map for UART1.

Split the SOCFPGA_UART1 into 2 options to allow debugging on UART1 for Cyclone5.

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig.debug | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index f95a90dfc282a..bee0ba1d1cfb7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1079,14 +1079,21 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on SOCFPGA(Cyclone 5 and Arria 5) based platforms.
 
-	config DEBUG_SOCFPGA_UART1
+	config DEBUG_SOCFPGA_ARRIA10_UART1
 		depends on ARCH_SOCFPGA
-		bool "Use SOCFPGA UART1 for low-level debug"
+		bool "Use SOCFPGA Arria10 UART1 for low-level debug"
 		select DEBUG_UART_8250
 		help
 		  Say Y here if you want kernel low-level debugging support
 		  on SOCFPGA(Arria 10) based platforms.
 
+	config DEBUG_SOCFPGA_CYCLONE5_UART1
+		depends on ARCH_SOCFPGA
+		bool "Use SOCFPGA Cyclone 5 UART1 for low-level debug"
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on SOCFPGA(Cyclone 5 and Arria 5) based platforms.
 
 	config DEBUG_SUN9I_UART0
 		bool "Kernel low-level debugging messages via sun9i UART0"
@@ -1647,7 +1654,8 @@ config DEBUG_UART_PHYS
 	default 0xfe800000 if ARCH_IOP32X
 	default 0xff690000 if DEBUG_RK32_UART2
 	default 0xffc02000 if DEBUG_SOCFPGA_UART0
-	default 0xffc02100 if DEBUG_SOCFPGA_UART1
+	default 0xffc02100 if DEBUG_SOCFPGA_ARRIA10_UART1
+	default 0xffc03000 if DEBUG_SOCFPGA_CYCLONE5_UART1
 	default 0xffd82340 if ARCH_IOP13XX
 	default 0xffe40000 if DEBUG_RCAR_GEN1_SCIF0
 	default 0xffe42000 if DEBUG_RCAR_GEN1_SCIF2
@@ -1754,7 +1762,8 @@ config DEBUG_UART_VIRT
 	default 0xfeb30c00 if DEBUG_KEYSTONE_UART0
 	default 0xfeb31000 if DEBUG_KEYSTONE_UART1
 	default 0xfec02000 if DEBUG_SOCFPGA_UART0
-	default 0xfec02100 if DEBUG_SOCFPGA_UART1
+	default 0xfec02100 if DEBUG_SOCFPGA_ARRIA10_UART1
+	default 0xfec03000 if DEBUG_SOCFPGA_CYCLONE5_UART1
 	default 0xfec12000 if (DEBUG_MVEBU_UART0 || DEBUG_MVEBU_UART0_ALTERNATE) && ARCH_MVEBU
 	default 0xfec12100 if DEBUG_MVEBU_UART1_ALTERNATE
 	default 0xfec10000 if DEBUG_SIRFATLAS7_UART0
@@ -1803,9 +1812,9 @@ config DEBUG_UART_8250_WORD
 	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
 	depends on DEBUG_UART_8250_SHIFT >= 2
 	default y if DEBUG_PICOXCELL_UART || \
-		DEBUG_SOCFPGA_UART0 || DEBUG_SOCFPGA_UART1 || \
-		DEBUG_KEYSTONE_UART0 || DEBUG_KEYSTONE_UART1 || \
-		DEBUG_ALPINE_UART0 || \
+		DEBUG_SOCFPGA_UART0 || DEBUG_SOCFPGA_ARRIA10_UART1 || \
+		DEBUG_SOCFPGA_CYCLONE5_UART1 || DEBUG_KEYSTONE_UART0 || \
+		DEBUG_KEYSTONE_UART1 || DEBUG_ALPINE_UART0 || \
 		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
 		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_BCM_IPROC_UART3 || \
 		DEBUG_BCM_KONA_UART || DEBUG_RK32_UART2
-- 
2.20.1



