Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637EC3CE407
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347928AbhGSPlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348725AbhGSPf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E8E61621;
        Mon, 19 Jul 2021 16:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711255;
        bh=DhNr/YIHnr2doWNV2z18T/NAGpuzYzIlt4aNAxgXud0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pyc3bLfG7XBA9ECKBOieMnTsuZXvytO8BUBO5sBJUUC9FcpEwFzytkz8E+wlnyjId
         eleLygUJaxiFHIKIFHxwYVU9bg7u0dyDQ3zl4WLpLCWGGm4xOuszqFnSoc0Y7ot6cM
         C+RsuU/z7c0T27ZF46yQ8vIolUKkuewFamAwshdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.13 286/351] rtc: bd70528: fix BD71815 watchdog dependency
Date:   Mon, 19 Jul 2021 16:53:52 +0200
Message-Id: <20210719144954.495231762@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b0ddc5b170058a9ed3c9f031501d735a4eb8ee89 ]

The added Kconfig dependency is slightly incorrect, which can
lead to a link failure when the watchdog is a loadable module:

arm-linux-gnueabi-ld: drivers/rtc/rtc-bd70528.o: in function `bd70528_set_rtc_based_timers':
rtc-bd70528.c:(.text+0x6cc): undefined reference to `bd70528_wdt_set'
arm-linux-gnueabi-ld: drivers/rtc/rtc-bd70528.o: in function `bd70528_set_time':
rtc-bd70528.c:(.text+0xaa0): undefined reference to `bd70528_wdt_lock'
arm-linux-gnueabi-ld: rtc-bd70528.c:(.text+0xab8): undefined reference to `bd70528_wdt_unlock'
arm-linux-gnueabi-ld: drivers/rtc/rtc-bd70528.o: in function `bd70528_alm_enable':
rtc-bd70528.c:(.text+0xfc0): undefined reference to `bd70528_wdt_lock'
arm-linux-gnueabi-ld: rtc-bd70528.c:(.text+0x1030): undefined reference to `bd70528_wdt_unlock'

The problem is that it allows to be built-in if MFD_ROHM_BD71828
is built-in, even when the watchdog is a loadable module.

Rework this so that having the watchdog as a loadable module always
forces the rtc to be a module as well instead of built-in,
regardless of bd71828.

Fixes: c56dc069f268 ("rtc: bd70528: Support RTC on ROHM BD71815")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210422151545.2403356-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index d8c13fded164..914497abeef9 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -502,7 +502,8 @@ config RTC_DRV_M41T80_WDT
 
 config RTC_DRV_BD70528
 	tristate "ROHM BD70528, BD71815 and BD71828 PMIC RTC"
-	depends on MFD_ROHM_BD71828 || MFD_ROHM_BD70528 && (BD70528_WATCHDOG || !BD70528_WATCHDOG)
+	depends on MFD_ROHM_BD71828 || MFD_ROHM_BD70528
+	depends on BD70528_WATCHDOG || !BD70528_WATCHDOG
 	help
 	  If you say Y here you will get support for the RTC
 	  block on ROHM BD70528, BD71815 and BD71828 Power Management IC.
-- 
2.30.2



