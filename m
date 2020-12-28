Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6502E4041
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441650AbgL1OTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502151AbgL1OTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B125820731;
        Mon, 28 Dec 2020 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165150;
        bh=TWbu2r3Uhk3b7ljFSFzuvKyKwXb+PRqbbToS6v7JESw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJM1fHMnskT5QU5D8Q+kPIbJRoOAmpi5uDbJMGlrdgtxWWnVyaZyGRkZrBbyVgqLZ
         aCSJfZLSppHmje8YeWASd6WkhbhhDgNNy5SisZP1MtZrTlaC/Tnxqnr2t1Yoh2rn0P
         1f7MK84cooRl/HQ+otcmD0JW+PTwTt2iMAFBn/Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/717] watchdog: sirfsoc: Add missing dependency on HAS_IOMEM
Date:   Mon, 28 Dec 2020 13:47:07 +0100
Message-Id: <20201228125041.520197536@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index b3e8bdaa2a112..f8e9be65036ae 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -790,6 +790,7 @@ config MOXART_WDT
 
 config SIRFSOC_WATCHDOG
 	tristate "SiRFSOC watchdog"
+	depends on HAS_IOMEM
 	depends on ARCH_SIRF || COMPILE_TEST
 	select WATCHDOG_CORE
 	default y
-- 
2.27.0



