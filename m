Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EFC23BFDD
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 21:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgHDT2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 15:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgHDT2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 15:28:09 -0400
Received: from localhost.localdomain (unknown [194.230.155.117])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6539722BF3;
        Tue,  4 Aug 2020 19:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596569289;
        bh=sgnxQDxNFJhXCnpuKyxV9bhtCuQWJwff+93nPoham8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dmsVsNjWAT2k1Ta4zKuRcbRPUBQETmXvmHdU33Noci7gMhuYE6Kqexmr9wfROWGY
         U+lAFouZwjKWDazsCqCskeLE5nTguXJzcSI54IYC1Epvr2MjBgyonUnjgm2DNSE9Ew
         VOH5GaPCSFjNYccHAchT7iU0HuPMyJYVqcCit7mo=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Russell King <linux@armlinux.org.uk>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        patches@opensource.cirrus.com, linux-clk@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Cc:     Sergio Prado <sergio.prado@e-labworks.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Cedric Roux <sed@free.fr>, Lihua Yao <ylhuajnu@outlook.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 08/13] ARM: s3c24xx: fix missing system reset
Date:   Tue,  4 Aug 2020 21:26:49 +0200
Message-Id: <20200804192654.12783-9-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200804192654.12783-1-krzk@kernel.org>
References: <20200804192654.12783-1-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit f6361c6b3880 ("ARM: S3C24XX: remove separate restart code")
removed usage of the watchdog reset platform code in favor of the
Samsung SoC watchdog driver.  However the latter was not selected thus
S3C24xx platforms lost reset abilities.

Cc: <stable@vger.kernel.org>
Fixes: f6361c6b3880 ("ARM: S3C24XX: remove separate restart code")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fe95777af653..063018c387be 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -506,8 +506,10 @@ config ARCH_S3C24XX
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C_RTC if RTC_CLASS
 	select NEED_MACH_IO_H
+	select S3C2410_WATCHDOG
 	select SAMSUNG_ATAGS
 	select USE_OF
+	select WATCHDOG
 	help
 	  Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440, S3C2442, S3C2443
 	  and S3C2450 SoCs based systems, such as the Simtec Electronics BAST
-- 
2.17.1

