Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A97A45C0A0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343804AbhKXNJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348260AbhKXNJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9873661213;
        Wed, 24 Nov 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757607;
        bh=nrPkeaf8lbhM5YeqOYDoO6Den0Txo0b+K2mTz4Z+nYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/T+Imwn/6Of3LDU9beLMXUTDX1CjVC7f/xwtJiKdnh/0ydEPmYUp19DijsPCTx7p
         RGfOxkIgmrcL7WEIazm9+QiW12P3qexCQrUjp993kLTG+8qWLFAnLdAizLrZxifP13
         Ge9bII2+9m6HHF1fDtDG7ql4KMBYIaPwtqcR9ARQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/323] ar7: fix kernel builds for compiler test
Date:   Wed, 24 Nov 2021 12:56:46 +0100
Message-Id: <20211124115726.227830404@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index fa7f4c61524d9..92fdc7dc2ede5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1524,7 +1524,7 @@ config SIBYTE_WDOG
 
 config AR7_WDT
 	tristate "TI AR7 Watchdog Timer"
-	depends on AR7 || (MIPS && COMPILE_TEST)
+	depends on AR7 || (MIPS && 32BIT && COMPILE_TEST)
 	help
 	  Hardware driver for the TI AR7 Watchdog Timer.
 
-- 
2.33.0



