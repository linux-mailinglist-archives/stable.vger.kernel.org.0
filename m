Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD52345BC16
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245462AbhKXMZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245091AbhKXMYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EC261100;
        Wed, 24 Nov 2021 12:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756118;
        bh=7ASz4s9MFKHWqv+yVY16d3CQA2XVH6e3T6lmo3g65W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2unToUKCHwmcKraquN8C8ILTJl4/rzHnemb6x2n9XG+kPPsVSNShhtgTiCTMmFxD2
         WreLuvZ9TjmnSLkXHgspu2A5U535J6uFeFPdZtpt5OCWa563YSwbRRlrKa3btGViT1
         phzSWS3e0V5d2UNDDKoD6zSscMjk9jhlbOY5/sTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-mips@vger.kernel.org,
        Paul Burton <paulburton@kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Ralf Baechle <ralf@linux-mips.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 179/207] mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set
Date:   Wed, 24 Nov 2021 12:57:30 +0100
Message-Id: <20211124115709.768575005@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5eeaafc8d69373c095e461bdb39e5c9b62228ac5 ]

Several header files need info on CONFIG_32BIT or CONFIG_64BIT,
but kconfig symbol BCM63XX does not provide that info. This leads
to many build errors, e.g.:

   arch/mips/include/asm/page.h:196:13: error: use of undeclared identifier 'CAC_BASE'
           return x - PAGE_OFFSET + PHYS_OFFSET;
   arch/mips/include/asm/mach-generic/spaces.h:91:23: note: expanded from macro 'PAGE_OFFSET'
   #define PAGE_OFFSET             (CAC_BASE + PHYS_OFFSET)
   arch/mips/include/asm/io.h:134:28: error: use of undeclared identifier 'CAC_BASE'
           return (void *)(address + PAGE_OFFSET - PHYS_OFFSET);
   arch/mips/include/asm/mach-generic/spaces.h:91:23: note: expanded from macro 'PAGE_OFFSET'
   #define PAGE_OFFSET             (CAC_BASE + PHYS_OFFSET)

arch/mips/include/asm/uaccess.h:82:10: error: use of undeclared identifier '__UA_LIMIT'
           return (__UA_LIMIT & (addr | (addr + size) | __ua_size(size))) == 0;

Selecting the SYS_HAS_CPU_BMIPS* symbols causes SYS_HAS_CPU_BMIPS to be
set, which then selects CPU_SUPPORT_32BIT_KERNEL, which causes
CONFIG_32BIT to be set. (a bit more indirect than v1 [RFC].)

Fixes: e7300d04bd08 ("MIPS: BCM63xx: Add support for the Broadcom BCM63xx family of SOCs.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: bcm-kernel-feedback-list@broadcom.com
Cc: linux-mips@vger.kernel.org
Cc: Paul Burton <paulburton@kernel.org>
Cc: Maxime Bizon <mbizon@freebox.fr>
Cc: Ralf Baechle <ralf@linux-mips.org>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3ab2a95673680..9708c319a7444 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -267,6 +267,9 @@ config BCM63XX
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
+	select SYS_HAS_CPU_BMIPS32_3300
+	select SYS_HAS_CPU_BMIPS4350
+	select SYS_HAS_CPU_BMIPS4380
 	select SWAP_IO_SPACE
 	select GPIOLIB
 	select HAVE_CLK
-- 
2.33.0



