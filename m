Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E012E3A0F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390920AbgL1Nbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390914AbgL1Nbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FD342063A;
        Mon, 28 Dec 2020 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162263;
        bh=hkzgwEg1qwZVnb6QJyZ+P4jfPhQ6upQiXNJsOzx6/wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdWieSvL7kIAseqNZygetaVzCyPgbvy/8rPcODx6r4MjFAkmJM5goXLbHvZ2rAvxk
         xrShIgCb8vCjSqhIZQ1n5r6s3iiFEypWYNmGfivS1wDrLoNZCacbmsj7+bfnxBC4lV
         d8a779LRKgTmZ9GCDBuynANM7wa+4MooAygGPTxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/346] watchdog: coh901327: add COMMON_CLK dependency
Date:   Mon, 28 Dec 2020 13:49:22 +0100
Message-Id: <20201228124931.519376229@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 36c47df85ee8e1f8a35366ac11324f8875de00eb ]

clang produces a build failure in configurations without COMMON_CLK
when a timeout calculation goes wrong:

arm-linux-gnueabi-ld: drivers/watchdog/coh901327_wdt.o: in function `coh901327_enable':
coh901327_wdt.c:(.text+0x50): undefined reference to `__bad_udelay'

Add a Kconfig dependency to only do build testing when COMMON_CLK
is enabled.

Fixes: da2a68b3eb47 ("watchdog: Enable COMPILE_TEST where possible")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201203223358.1269372-1-arnd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9feeb8e82d500..fa7f4c61524d9 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -515,7 +515,7 @@ config SUNXI_WATCHDOG
 
 config COH901327_WATCHDOG
 	bool "ST-Ericsson COH 901 327 watchdog"
-	depends on ARCH_U300 || (ARM && COMPILE_TEST)
+	depends on ARCH_U300 || (ARM && COMMON_CLK && COMPILE_TEST)
 	default y if MACH_U300
 	select WATCHDOG_CORE
 	help
-- 
2.27.0



