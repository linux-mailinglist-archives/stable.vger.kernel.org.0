Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF7328E18
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhCATYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:24:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235740AbhCATSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E279164F65;
        Mon,  1 Mar 2021 17:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620987;
        bh=dlY4BLn6+UidPiRxLe/XVxZrZt3pprnTgQu0Q7kvhHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nr5G64WWgYgIJGRvYfD3Ikmg0axA9E+5upSUWh6OsPyKTZkqWAMRIIAYwuo4M8ctA
         CIMQQVrs/rIfiVGXotZnXeCQGfNbXIsqFEa8KFD0zo+Kojh0SpckmZzyNYW9tIhFt9
         ES7om9V3UR3XSnyhwLPaLkosL6AvAU7HvIOeB38g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 352/775] clocksource/drivers/ixp4xx: Select TIMER_OF when needed
Date:   Mon,  1 Mar 2021 17:08:40 +0100
Message-Id: <20210301161219.021412215@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7a3b8758bd6e45f7b671723b5c9fa2b69d0787ae ]

Compile-testing the ixp4xx timer with CONFIG_OF enabled but
CONFIG_TIMER_OF disabled leads to a harmless warning:

arm-linux-gnueabi-ld: warning: orphan section `__timer_of_table' from `drivers/clocksource/timer-ixp4xx.o' being placed in section `__timer_of_table'

Move the select statement from the platform code into the driver
so it always gets enabled in configurations that rely on it.

Fixes: 40df14cc5cc0 ("clocksource/drivers/ixp4xx: Add OF initialization support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210103135955.3808976-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-ixp4xx/Kconfig | 1 -
 drivers/clocksource/Kconfig  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ixp4xx/Kconfig b/arch/arm/mach-ixp4xx/Kconfig
index f7211b57b1e78..165c184801e19 100644
--- a/arch/arm/mach-ixp4xx/Kconfig
+++ b/arch/arm/mach-ixp4xx/Kconfig
@@ -13,7 +13,6 @@ config MACH_IXP4XX_OF
 	select I2C
 	select I2C_IOP3XX
 	select PCI
-	select TIMER_OF
 	select USE_OF
 	help
 	  Say 'Y' here to support Device Tree-based IXP4xx platforms.
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 14c7c47124787..66be9ea69e332 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -79,6 +79,7 @@ config IXP4XX_TIMER
 	bool "Intel XScale IXP4xx timer driver" if COMPILE_TEST
 	depends on HAS_IOMEM
 	select CLKSRC_MMIO
+	select TIMER_OF if OF
 	help
 	  Enables support for the Intel XScale IXP4xx SoC timer.
 
-- 
2.27.0



