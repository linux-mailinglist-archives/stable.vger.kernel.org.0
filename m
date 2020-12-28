Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292532E39F8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390411AbgL1Nae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390410AbgL1Nad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:30:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87A0821D94;
        Mon, 28 Dec 2020 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162218;
        bh=ALpvGakY8ZaPmf8tfK+hMeAlxu/pGB+/TwCGdvzls+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Af73H4Zhwh62bIIWc+B2qM9i91pKWbYkDBQUTTMhlTGzx1Vsz5AX3fk7JKnb+s2O5
         PEYIPPzAsnI8mS0NBZT6p55rBy0r31t5CHv6KtE7a4h8+kStFhB1VSu39lYnUPsqkh
         Glz6n76FyymI54SUVwLyGMg/u9LkrTqRqdhco7Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 228/346] watchdog: sirfsoc: Add missing dependency on HAS_IOMEM
Date:   Mon, 28 Dec 2020 13:49:07 +0100
Message-Id: <20201228124930.799234843@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8ae2511112d2e18bc7d324b77f965d34083a25a2 ]

If HAS_IOMEM is not defined and SIRFSOC_WATCHDOG is enabled,
the build fails with the following error.

drivers/watchdog/sirfsoc_wdt.o: in function `sirfsoc_wdt_probe':
sirfsoc_wdt.c:(.text+0x112):
	undefined reference to `devm_platform_ioremap_resource'

Reported-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Fixes: da2a68b3eb47 ("watchdog: Enable COMPILE_TEST where possible")
Link: https://lore.kernel.org/r/20201108162550.27660-2-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 709d4de11f40f..9feeb8e82d500 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -651,6 +651,7 @@ config MOXART_WDT
 
 config SIRFSOC_WATCHDOG
 	tristate "SiRFSOC watchdog"
+	depends on HAS_IOMEM
 	depends on ARCH_SIRF || COMPILE_TEST
 	select WATCHDOG_CORE
 	default y
-- 
2.27.0



