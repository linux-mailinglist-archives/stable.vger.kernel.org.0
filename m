Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B139445127A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346669AbhKOTgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244758AbhKOTR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA64A6332A;
        Mon, 15 Nov 2021 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000615;
        bh=ryhugm6YOSgDg7V3f8kVg1/oyRfP583n+gJijgEa7Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gb8je9zMsX3tcQJ35lai0Zq40/5eUTzmp7/UjD3Zf3shfyA2j+1EHfsNG8u/zq9/n
         xfM/NphOkoNS5X4hdPiR25czqcfXSHfj2Aqe8Bp+YBHONkgINsBaGiZLzxyG1QQSk1
         UgR8KkFJ4yQuM5XAv4Ta2QHKZqo6coh3O97+61cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 709/849] ar7: fix kernel builds for compiler test
Date:   Mon, 15 Nov 2021 18:03:12 +0100
Message-Id: <20211115165444.239361430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 71cf3f503f16b..c7be7dd56cde8 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1690,7 +1690,7 @@ config SIBYTE_WDOG
 
 config AR7_WDT
 	tristate "TI AR7 Watchdog Timer"
-	depends on AR7 || (MIPS && COMPILE_TEST)
+	depends on AR7 || (MIPS && 32BIT && COMPILE_TEST)
 	help
 	  Hardware driver for the TI AR7 Watchdog Timer.
 
-- 
2.33.0



