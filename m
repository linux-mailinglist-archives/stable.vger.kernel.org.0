Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B123A40910A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245153AbhIMN5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343608AbhIMNzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC2A961881;
        Mon, 13 Sep 2021 13:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540153;
        bh=M9TyqKf147UjgYaUzTNPsRL9EOOPe/XQokuRChA1r5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fv0FGPXjMw7JzWMbUFRlGN5R5S4pgHM1YrzRDsQOoMn11uOxoHn1LbCsGXJfNUd5L
         ZS0A5cIcMr6mmF8q5oQR5WaXrQ8d136vssDFv6Djav/886VDOcEpO+CZDBs2P442fb
         QXvQ73CFeF8GF7MeQSbplMxuWUk2CePX9yafYD9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 056/300] m68k: Fix invalid RMW_INSNS on CPUs that lack CAS
Date:   Mon, 13 Sep 2021 15:11:57 +0200
Message-Id: <20210913131111.249870408@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index f4d23977d2a5..1127d64b6c1d 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -26,6 +26,7 @@ config COLDFIRE
 	bool "Coldfire CPU family support"
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_MULDIV64
 	select GENERIC_CSUM
 	select GPIOLIB
@@ -39,6 +40,7 @@ config M68000
 	bool
 	depends on !MMU
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_MULDIV64
 	select CPU_HAS_NO_UNALIGNED
 	select GENERIC_CSUM
@@ -54,6 +56,7 @@ config M68000
 config MCPU32
 	bool
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_UNALIGNED
 	select CPU_NO_EFFICIENT_FFS
 	help
@@ -383,7 +386,7 @@ config ADVANCED
 
 config RMW_INSNS
 	bool "Use read-modify-write instructions"
-	depends on ADVANCED
+	depends on ADVANCED && !CPU_HAS_NO_CAS
 	help
 	  This allows to use certain instructions that work with indivisible
 	  read-modify-write bus cycles. While this is faster than the
@@ -459,6 +462,9 @@ config NODES_SHIFT
 config CPU_HAS_NO_BITFIELDS
 	bool
 
+config CPU_HAS_NO_CAS
+	bool
+
 config CPU_HAS_NO_MULDIV64
 	bool
 
-- 
2.30.2



