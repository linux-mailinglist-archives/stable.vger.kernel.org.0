Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02A1364349
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240317AbhDSNQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237772AbhDSNOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11692613AF;
        Mon, 19 Apr 2021 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837984;
        bh=+3hBp5pRWVmEPLkF1yWRCfRNBBXT6OmojnJ8bht5ddQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rj+NxCfmsU0HXgs3PuLVN1bhe0nRx1skQzhLKBHU63PC8Md+Hi3u5wQhAkl2o968O
         N3iX7+Qvgc3LBjj0OO5J4k1AXRcqp+ZFzwzqWEPPLG8HWIonPpife17knunNG4qpBX
         W2rsKiGV8fXCKRom6wKE53cC8TROLObb1RVp4ItU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 104/122] ARM: 9063/1: mm: reduce maximum number of CPUs if DEBUG_KMAP_LOCAL is enabled
Date:   Mon, 19 Apr 2021 15:06:24 +0200
Message-Id: <20210419130533.692260411@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit d624833f5984d484c5e3196f34b926f9e71dafee ]

The debugging code for kmap_local() doubles the number of per-CPU fixmap
slots allocated for kmap_local(), in order to use half of them as guard
regions. This causes the fixmap region to grow downwards beyond the start
of its reserved window if the supported number of CPUs is large, and collide
with the newly added virtual DT mapping right below it, which is obviously
not good.

One manifestation of this is EFI boot on a kernel built with NR_CPUS=32
and CONFIG_DEBUG_KMAP_LOCAL=y, which may pass the FDT in highmem, resulting
in block entries below the fixmap region that the fixmap code misidentifies
as fixmap table entries, and subsequently tries to dereference using a
phys-to-virt translation that is only valid for lowmem. This results in a
cryptic splat such as the one below.

  ftrace: allocating 45548 entries in 89 pages
  8<--- cut here ---
  Unable to handle kernel paging request at virtual address fc6006f0
  pgd = (ptrval)
  [fc6006f0] *pgd=80000040207003, *pmd=00000000
  Internal error: Oops: a06 [#1] SMP ARM
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper Not tainted 5.11.0+ #382
  Hardware name: Generic DT based system
  PC is at cpu_ca15_set_pte_ext+0x24/0x30
  LR is at __set_fixmap+0xe4/0x118
  pc : [<c041ac9c>]    lr : [<c04189d8>]    psr: 400000d3
  sp : c1601ed8  ip : 00400000  fp : 00800000
  r10: 0000071f  r9 : 00421000  r8 : 00c00000
  r7 : 00c00000  r6 : 0000071f  r5 : ffade000  r4 : 4040171f
  r3 : 00c00000  r2 : 4040171f  r1 : c041ac78  r0 : fc6006f0
  Flags: nZcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
  Control: 30c5387d  Table: 40203000  DAC: 00000001
  Process swapper (pid: 0, stack limit = 0x(ptrval))

So let's limit CONFIG_NR_CPUS to 16 when CONFIG_DEBUG_KMAP_LOCAL=y. Also,
fix the BUILD_BUG_ON() check that was supposed to catch this, by checking
whether the region grows below the start address rather than above the end
address.

Fixes: 2a15ba82fa6ca3f3 ("ARM: highmem: Switch to generic kmap atomic")
Reported-by: Peter Robinson <pbrobinson@gmail.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig  | 8 +++++++-
 arch/arm/mm/mmu.c | 3 +--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 138248999df7..3d2c684eab77 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1310,9 +1310,15 @@ config KASAN_SHADOW_OFFSET
 
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
-	range 2 32
+	range 2 16 if DEBUG_KMAP_LOCAL
+	range 2 32 if !DEBUG_KMAP_LOCAL
 	depends on SMP
 	default "4"
+	help
+	  The maximum number of CPUs that the kernel can support.
+	  Up to 32 CPUs can be supported, or up to 16 if kmap_local()
+	  debugging is enabled, which uses half of the per-CPU fixmap
+	  slots as guard regions.
 
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index c06ebfbc48c4..56c7954cb626 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -388,8 +388,7 @@ void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 	pte_t *pte = pte_offset_fixmap(pmd_off_k(vaddr), vaddr);
 
 	/* Make sure fixmap region does not exceed available allocation. */
-	BUILD_BUG_ON(FIXADDR_START + (__end_of_fixed_addresses * PAGE_SIZE) >
-		     FIXADDR_END);
+	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) < FIXADDR_START);
 	BUG_ON(idx >= __end_of_fixed_addresses);
 
 	/* we only support device mappings until pgprot_kernel has been set */
-- 
2.30.2



