Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3CF328890
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbhCARmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238644AbhCAReg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:34:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9D9564F35;
        Mon,  1 Mar 2021 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617652;
        bh=u22aOlnTLiKDhSIJY60eBG3c2QT+NcV/9D96rE3tLwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLQf7FMj1bVirSSX3ih1SkUQUTKIdJXo+JCr8IcpKNm3nsXjs7o4ZUV09MtNC2Yci
         1BTWnmwceptZ3+eTXrRxGENDfEpV38M9N7bkwN2gf23Q5OmtyfYV3vsPy7ZVfoSvzr
         0Ox0xdjz1Zo//P1xewRzlESrL9tbIqSFuqfo95OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/340] clocksource/drivers/ixp4xx: Select TIMER_OF when needed
Date:   Mon,  1 Mar 2021 17:11:32 +0100
Message-Id: <20210301161055.599195431@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index f35a53ce8988a..3bb5625504e2f 100644
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



