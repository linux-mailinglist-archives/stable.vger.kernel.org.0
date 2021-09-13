Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F78408E45
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbhIMNcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhIMNa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E13BF61351;
        Mon, 13 Sep 2021 13:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539497;
        bh=BIpFGWF8YM7OnSCUVmiH5C+8zoWKit9sO6/x30gy4T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLwLn9lRMt63YI8IYk6eTb5dPeBS7wsmFIbTWITTkzTRh1vg3+HyvYkqtN9ThNsRo
         YM9397qyDsPXOWf3V4vqlnFJbBSeX7fSGXyTcBf2usMv+w3L/Hc5RUyh4ocSzzpwb6
         Y5JEpNtlcUZ7ZeOmRODjjQjD9dU9gPIJ47v/lJvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/236] m68k: Fix invalid RMW_INSNS on CPUs that lack CAS
Date:   Mon, 13 Sep 2021 15:12:32 +0200
Message-Id: <20210913131101.948106276@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 2189e928b62e91d8efbc9826ae7c0968f0d55790 ]

When enabling CONFIG_RMW_INSNS in e.g. a Coldfire build:

    {standard input}:3068: Error: invalid instruction for this architecture; needs 68020 or higher (68020 [68k, 68ec020], 68030 [68ec030], 68040 [68ec040], 68060 [68ec060]) -- statement `casl %d4,%d0,(%a6)' ignored

Fix this by (a) adding a new config symbol to track if support for any
CPU that lacks the CAS instruction is enabled, and (b) making
CONFIG_RMW_INSNS depend on the new symbol not being set.

Fixes: 0e152d80507b75c0 ("m68k: reorganize Kconfig options to improve mmu/non-mmu selections")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210725104413.318932-1-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.cpu | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 694c4fca9f5d..c17205da47fe 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -25,6 +25,7 @@ config COLDFIRE
 	bool "Coldfire CPU family support"
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_MULDIV64
 	select GENERIC_CSUM
 	select GPIOLIB
@@ -38,6 +39,7 @@ config M68000
 	bool "MC68000"
 	depends on !MMU
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_MULDIV64
 	select CPU_HAS_NO_UNALIGNED
 	select GENERIC_CSUM
@@ -53,6 +55,7 @@ config M68000
 config MCPU32
 	bool
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_UNALIGNED
 	select CPU_NO_EFFICIENT_FFS
 	help
@@ -357,7 +360,7 @@ config ADVANCED
 
 config RMW_INSNS
 	bool "Use read-modify-write instructions"
-	depends on ADVANCED
+	depends on ADVANCED && !CPU_HAS_NO_CAS
 	help
 	  This allows to use certain instructions that work with indivisible
 	  read-modify-write bus cycles. While this is faster than the
@@ -411,6 +414,9 @@ config NODES_SHIFT
 config CPU_HAS_NO_BITFIELDS
 	bool
 
+config CPU_HAS_NO_CAS
+	bool
+
 config CPU_HAS_NO_MULDIV64
 	bool
 
-- 
2.30.2



