Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE062E4334
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407416AbgL1PeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406996AbgL1Nvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B278422583;
        Mon, 28 Dec 2020 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163497;
        bh=XIG99wlLuSWAzplSFGVgPNsD9YUdgX+1UxASERezjs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRx3Zid3eNXkaIKtUrpTI8xRttk6Rh04dJLGj1QieiCGIHlDEjMckcmk35nYs8iUc
         wc7ysgixoXwXjHzfTybvYSjPj42a8p2Ofxrqny7VdD3FRCLnxuqZ1GmFwqCrWl9J9E
         Vn44NugIoaBDDG8hSTs8gDc8PiGHm+MqNe4GpgCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 276/453] watchdog: sirfsoc: Add missing dependency on HAS_IOMEM
Date:   Mon, 28 Dec 2020 13:48:32 +0100
Message-Id: <20201228124950.506111191@linuxfoundation.org>
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
index fce2f5e3ac51d..6cdffbdaf98a5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -775,6 +775,7 @@ config MOXART_WDT
 
 config SIRFSOC_WATCHDOG
 	tristate "SiRFSOC watchdog"
+	depends on HAS_IOMEM
 	depends on ARCH_SIRF || COMPILE_TEST
 	select WATCHDOG_CORE
 	default y
-- 
2.27.0



