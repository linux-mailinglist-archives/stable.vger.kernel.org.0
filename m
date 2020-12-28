Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C966C2E4071
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392034AbgL1OTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392031AbgL1OTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5BB3229C4;
        Mon, 28 Dec 2020 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165147;
        bh=NxB4p1Y2rEVXI0bWk37gLU9g3oSKskovcdtgtfkeicE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6OvenJBaJ1BH1anvC7040Z1giPDpyjFvQmjdhKccYbXpdpM8uHTmdMTofFxdd0j+
         j3M42KjZ5V5RIDePSPqZ1XILWUPm1RU6WMVwqPThB7vr6QPzLLBS3pnIuvOb62+HtR
         2k9osCB534PK1HACp5QrKx4RzQbUx88S2fThY9lQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 428/717] watchdog: armada_37xx: Add missing dependency on HAS_IOMEM
Date:   Mon, 28 Dec 2020 13:47:06 +0100
Message-Id: <20201228125041.471941480@linuxfoundation.org>
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

[ Upstream commit 7f6f1dfb2dcbe5d2bfa213f2df5d74c147cd5954 ]

The following kbuild warning is seen on a system without HAS_IOMEM.

WARNING: unmet direct dependencies detected for MFD_SYSCON
  Depends on [n]: HAS_IOMEM [=n]
  Selected by [y]:
  - ARMADA_37XX_WATCHDOG [=y] && WATCHDOG [=y] && (ARCH_MVEBU || COMPILE_TEST

This results in a subsequent compile error.

drivers/watchdog/armada_37xx_wdt.o: in function `armada_37xx_wdt_probe':
armada_37xx_wdt.c:(.text+0xdc): undefined reference to `devm_ioremap'

Add the missing dependency.

Reported-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Fixes: 54e3d9b518c8 ("watchdog: Add support for Armada 37xx CPU watchdog")
Link: https://lore.kernel.org/r/20201108162550.27660-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index fd7968635e6df..b3e8bdaa2a112 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -386,6 +386,7 @@ config ARM_SBSA_WATCHDOG
 config ARMADA_37XX_WATCHDOG
 	tristate "Armada 37xx watchdog"
 	depends on ARCH_MVEBU || COMPILE_TEST
+	depends on HAS_IOMEM
 	select MFD_SYSCON
 	select WATCHDOG_CORE
 	help
-- 
2.27.0



