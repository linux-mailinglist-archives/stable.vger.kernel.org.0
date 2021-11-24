Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F4145BE56
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345105AbhKXMql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:46:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245111AbhKXMof (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 887BD6112D;
        Wed, 24 Nov 2021 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756779;
        bh=kuNRFLuFI4JKMxSrRUGiXI1TdieIqxuR82ZoA7kz+JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BJkJ+sKdEgO2Hh6yucWe9OsmNi9PDaXE4/QorZsK0yIO25u8m/IDFPbN8WDTOWB1
         o5+2JmvADh+w4qMhj4RAkgUPDy/2p0fj8oOOQksbOdJtDPfyA+bKPXKlm4m/s1M+/Z
         rjyCMzupt2Qa13pKuHNamX6OBPfWvvkQdFsAhizU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 176/251] ar7: fix kernel builds for compiler test
Date:   Wed, 24 Nov 2021 12:56:58 +0100
Message-Id: <20211124115716.386662570@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 28b7ee33a2122569ac065cad578bf23f50cc65c3 ]

TI AR7 Watchdog Timer is only build for 32bit.

Avoid error like:
In file included from drivers/watchdog/ar7_wdt.c:29:
./arch/mips/include/asm/mach-ar7/ar7.h: In function ‘ar7_is_titan’:
./arch/mips/include/asm/mach-ar7/ar7.h:111:24: error: implicit declaration of function ‘KSEG1ADDR’; did you mean ‘CKSEG1ADDR’? [-Werror=implicit-function-declaration]
  111 |  return (readl((void *)KSEG1ADDR(AR7_REGS_GPIO + 0x24)) & 0xffff) ==
      |                        ^~~~~~~~~
      |                        CKSEG1ADDR

Fixes: da2a68b3eb47 ("watchdog: Enable COMPILE_TEST where possible")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210907024904.4127611-1-liu.yun@linux.dev
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index de228669a2c8b..8cb663ecbacc6 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1499,7 +1499,7 @@ config SIBYTE_WDOG
 
 config AR7_WDT
 	tristate "TI AR7 Watchdog Timer"
-	depends on AR7 || (MIPS && COMPILE_TEST)
+	depends on AR7 || (MIPS && 32BIT && COMPILE_TEST)
 	help
 	  Hardware driver for the TI AR7 Watchdog Timer.
 
-- 
2.33.0



