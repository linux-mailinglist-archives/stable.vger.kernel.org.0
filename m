Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB042E4335
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407434AbgL1PeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406872AbgL1Nv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A9B2064B;
        Mon, 28 Dec 2020 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163471;
        bh=cDRDiNUiAz22bBLFYws8YvUnvtciL92IYlOIDYofWe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+BKw8ToCbi2zS9nQN666bxTKajxKvY187Be37D/+F7Da7QMtIaryMXtOuyOY194H
         IC45L7Vsq91owBtJqr3CkYJmb40naKCVkP7pt6gohjNY3dz3x+4L5zoDYtdgnDgZY+
         EQTg5gQ4b0q5uVy6o5piWAX5Qb8a1+wpYqSFqXMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 297/453] watchdog: coh901327: add COMMON_CLK dependency
Date:   Mon, 28 Dec 2020 13:48:53 +0100
Message-Id: <20201228124951.496227175@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 6cdffbdaf98a5..1aa42e879e633 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -618,7 +618,7 @@ config SUNXI_WATCHDOG
 
 config COH901327_WATCHDOG
 	bool "ST-Ericsson COH 901 327 watchdog"
-	depends on ARCH_U300 || (ARM && COMPILE_TEST)
+	depends on ARCH_U300 || (ARM && COMMON_CLK && COMPILE_TEST)
 	default y if MACH_U300
 	select WATCHDOG_CORE
 	help
-- 
2.27.0



