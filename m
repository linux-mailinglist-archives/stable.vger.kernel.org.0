Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4612E66F8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633101AbgL1QTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732574AbgL1NOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A03920728;
        Mon, 28 Dec 2020 13:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161275;
        bh=jCp+JwIpP6X2aY59YOnzjdXT2rBbB85+9t/9NKusEIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgACAfjOqSp/uQxyO851L6ZaCT2wOLAtq7kj4vd0/sd5314R4oIA7Sf8Wff/euB6S
         8wk3TeUMW5N1Ll0rYg3dTfHNVl/0wvRdA51IIeM9e0B5F4CiS6bG0KMITqcDj2Kv7o
         xpVh/n9jO6sy7WqffzuSfHEQHjOpy+HH1EXZfqZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 160/242] watchdog: sirfsoc: Add missing dependency on HAS_IOMEM
Date:   Mon, 28 Dec 2020 13:49:25 +0100
Message-Id: <20201228124912.574769336@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index fa15a683ae2d4..529b0527bf2e2 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -620,6 +620,7 @@ config MOXART_WDT
 
 config SIRFSOC_WATCHDOG
 	tristate "SiRFSOC watchdog"
+	depends on HAS_IOMEM
 	depends on ARCH_SIRF || COMPILE_TEST
 	select WATCHDOG_CORE
 	default y
-- 
2.27.0



