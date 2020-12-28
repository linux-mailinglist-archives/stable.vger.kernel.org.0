Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C048F2E42F2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407078AbgL1NwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732924AbgL1NwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D914522B3A;
        Mon, 28 Dec 2020 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163494;
        bh=xtwErc92apbIPu+vmfTgSlDBGkFrb9YpNevCU4PVMYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFICol/0cEjAiBWF8yWz119sDjTLy3aTVNCEJAzci91MGRv9epAuLCoAXO3w3Tg5g
         VJy2Ibr+vsz42O38Q+POk6igaZdBx7Vktmm69krqD4Z3Q7HQTe9+qsfSbR4paVOmhC
         SojmN3QDszIs8wcgvHQtI4ts86RMIr1Mcdu+PznQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 275/453] watchdog: armada_37xx: Add missing dependency on HAS_IOMEM
Date:   Mon, 28 Dec 2020 13:48:31 +0100
Message-Id: <20201228124950.460145466@linuxfoundation.org>
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
index e2745f6861960..fce2f5e3ac51d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -374,6 +374,7 @@ config ARM_SBSA_WATCHDOG
 config ARMADA_37XX_WATCHDOG
 	tristate "Armada 37xx watchdog"
 	depends on ARCH_MVEBU || COMPILE_TEST
+	depends on HAS_IOMEM
 	select MFD_SYSCON
 	select WATCHDOG_CORE
 	help
-- 
2.27.0



