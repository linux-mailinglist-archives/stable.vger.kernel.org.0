Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0189313C71
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhBHSGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235119AbhBHSCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:02:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3983864ECB;
        Mon,  8 Feb 2021 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807137;
        bh=MwE0dRe4FlkiHM4UEKZwi9NyT1H5uA6kVgZ45xrrRhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XabMr1QwJGKzQfPAvLkSR+Q02JW41Xwn9yW+y9iFm+AMxEolwaazADOhCXb2rh/Ip
         n5EncEqiPNWgZFc1ctphzvpnG2Go17pG4SqZU9trLWipG5TA3yiZwzlZ8DX2B1h1xc
         Kg4q/qAhBp4xUFZNb2PRxC7662dmx21IrJiRpMv5nuo96/aMni71o/nh0u6EEsHJ12
         h9UBSRZiSA5tBk7yvJwISSo+lGHcCPgOXEhg0t6hxiJ2fw0LqTS4fDLSun1R9el8OF
         CqP+V7ETDB69aXcBp5f15X05HwRtVb+HeGskvlyaIdFIAKjhcDvbhM02T3evefIXoM
         ONJl5AH25u45A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, x86@kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 36/36] x86/efi: Remove EFI PGD build time checks
Date:   Mon,  8 Feb 2021 12:58:06 -0500
Message-Id: <20210208175806.2091668-36-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 816ef8d7a2c4182e19bc06ab65751cb9e3951e94 ]

With CONFIG_X86_5LEVEL, CONFIG_UBSAN and CONFIG_UBSAN_UNSIGNED_OVERFLOW
enabled, clang fails the build with

  x86_64-linux-ld: arch/x86/platform/efi/efi_64.o: in function `efi_sync_low_kernel_mappings':
  efi_64.c:(.text+0x22c): undefined reference to `__compiletime_assert_354'

which happens due to -fsanitize=unsigned-integer-overflow being enabled:

  -fsanitize=unsigned-integer-overflow: Unsigned integer overflow, where
  the result of an unsigned integer computation cannot be represented
  in its type. Unlike signed integer overflow, this is not undefined
  behavior, but it is often unintentional. This sanitizer does not check
  for lossy implicit conversions performed before such a computation
  (see -fsanitize=implicit-conversion).

and that fires when the (intentional) EFI_VA_START/END defines overflow
an unsigned long, leading to the assertion expressions not getting
optimized away (on GCC they do)...

However, those checks are superfluous: the runtime services mapping
code already makes sure the ranges don't overshoot EFI_VA_END as the
EFI mapping range is hardcoded. On each runtime services call, it is
switched to the EFI-specific PGD and even if mappings manage to escape
that last PGD, this won't remain unnoticed for long.

So rip them out.

See https://github.com/ClangBuiltLinux/linux/issues/256 for more info.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: http://lkml.kernel.org/r/20210107223424.4135538-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/efi_64.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index e1e8d4e3a2139..8efd003540cae 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -115,31 +115,12 @@ void efi_sync_low_kernel_mappings(void)
 	pud_t *pud_k, *pud_efi;
 	pgd_t *efi_pgd = efi_mm.pgd;
 
-	/*
-	 * We can share all PGD entries apart from the one entry that
-	 * covers the EFI runtime mapping space.
-	 *
-	 * Make sure the EFI runtime region mappings are guaranteed to
-	 * only span a single PGD entry and that the entry also maps
-	 * other important kernel regions.
-	 */
-	MAYBE_BUILD_BUG_ON(pgd_index(EFI_VA_END) != pgd_index(MODULES_END));
-	MAYBE_BUILD_BUG_ON((EFI_VA_START & PGDIR_MASK) !=
-			(EFI_VA_END & PGDIR_MASK));
-
 	pgd_efi = efi_pgd + pgd_index(PAGE_OFFSET);
 	pgd_k = pgd_offset_k(PAGE_OFFSET);
 
 	num_entries = pgd_index(EFI_VA_END) - pgd_index(PAGE_OFFSET);
 	memcpy(pgd_efi, pgd_k, sizeof(pgd_t) * num_entries);
 
-	/*
-	 * As with PGDs, we share all P4D entries apart from the one entry
-	 * that covers the EFI runtime mapping space.
-	 */
-	BUILD_BUG_ON(p4d_index(EFI_VA_END) != p4d_index(MODULES_END));
-	BUILD_BUG_ON((EFI_VA_START & P4D_MASK) != (EFI_VA_END & P4D_MASK));
-
 	pgd_efi = efi_pgd + pgd_index(EFI_VA_END);
 	pgd_k = pgd_offset_k(EFI_VA_END);
 	p4d_efi = p4d_offset(pgd_efi, 0);
-- 
2.27.0

