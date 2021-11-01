Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18C34417F3
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhKAJlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233455AbhKAJjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A577C61360;
        Mon,  1 Nov 2021 09:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758847;
        bh=IWRUI0SyL1hEyhmCpWwl37mSrbmg1wKo4wvR1IQOjsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VPPXl6Tk7i2/3iu3qNhB4jZHEPZ34BtgpWu5HDkarlSDHiqnP3NWD84I1rlPL8yp
         1pzOiuQnE4RLmaO5EtwNGIt+6iNcJnkt1gopKMb6zjXvnjcda2vYYXuVq27C474udW
         5G80sH4xIvN+VInxUDmfGvJQhTDlm16GSxfuXKoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 76/77] riscv: Fix asan-stack clang build
Date:   Mon,  1 Nov 2021 10:18:04 +0100
Message-Id: <20211101082527.351745789@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexandre.ghiti@canonical.com>

commit 54c5639d8f507ebefa814f574cb6f763033a72a5 upstream.

Nathan reported that because KASAN_SHADOW_OFFSET was not defined in
Kconfig, it prevents asan-stack from getting disabled with clang even
when CONFIG_KASAN_STACK is disabled: fix this by defining the
corresponding config.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Fixes: 8ad8b72721d0 ("riscv: Add KASAN support")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig             |    6 ++++++
 arch/riscv/include/asm/kasan.h |    3 +--
 arch/riscv/mm/kasan_init.c     |    3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -138,6 +138,12 @@ config PAGE_OFFSET
 	default 0xffffffff80000000 if 64BIT && MAXPHYSMEM_2GB
 	default 0xffffffe000000000 if 64BIT && MAXPHYSMEM_128GB
 
+config KASAN_SHADOW_OFFSET
+	hex
+	depends on KASAN_GENERIC
+	default 0xdfffffc800000000 if 64BIT
+	default 0xffffffff if 32BIT
+
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
--- a/arch/riscv/include/asm/kasan.h
+++ b/arch/riscv/include/asm/kasan.h
@@ -14,8 +14,7 @@
 #define KASAN_SHADOW_START	KERN_VIRT_START /* 2^64 - 2^38 */
 #define KASAN_SHADOW_END	(KASAN_SHADOW_START + KASAN_SHADOW_SIZE)
 
-#define KASAN_SHADOW_OFFSET	(KASAN_SHADOW_END - (1ULL << \
-					(64 - KASAN_SHADOW_SCALE_SHIFT)))
+#define KASAN_SHADOW_OFFSET	_AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 
 void kasan_init(void);
 asmlinkage void kasan_early_init(void);
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -16,6 +16,9 @@ asmlinkage void __init kasan_early_init(
 	uintptr_t i;
 	pgd_t *pgd = early_pg_dir + pgd_index(KASAN_SHADOW_START);
 
+	BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=
+		KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
+
 	for (i = 0; i < PTRS_PER_PTE; ++i)
 		set_pte(kasan_early_shadow_pte + i,
 			mk_pte(virt_to_page(kasan_early_shadow_page),


