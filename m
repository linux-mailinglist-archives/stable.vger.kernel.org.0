Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A940C48039B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhL0TEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhL0TEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236C9C06173E;
        Mon, 27 Dec 2021 11:04:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5C0DB81145;
        Mon, 27 Dec 2021 19:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D00C36AE7;
        Mon, 27 Dec 2021 19:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631858;
        bh=e0BQyzPptGp3FcSe5i3ujPFSYB+mDQbfz8+WAqtd7gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PElhGizqbYubREgwlieGmXMoTU51dz3VEHElwOsUNjCm3mOzui0RPgFpK3mZMijjy
         onl6ju9xI9G0wHLshoi016GjNdQqxUTox1sAr0mUKAQBSkd/pRQJNSNGRt43ptmK1L
         wXAwAG/2dfJItGGVIOcLfGeNsFzrsTkjVzmiRSWI6n9wyl0pfCXB167teK+lMmNEGS
         dRK0pd8nKELFGKNc7QxehXsy8T9GTs1C8yxaFFCtFzjZ666VmfUsLfJ+PZuXaDggm1
         Yqp9aNTgxL2KOA6vwCp2BarkRVPdFEcjGxmDFe0rFxBC3TGgxoKx6pl4txXmRI3NKw
         rcsu59G+NMbFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Rapoport <rppt@kernel.org>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, akpm@linux-foundation.org,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        andriy.shevchenko@linux.intel.com, jgross@suse.com
Subject: [PATCH AUTOSEL 5.15 14/26] x86/boot: Move EFI range reservation after cmdline parsing
Date:   Mon, 27 Dec 2021 14:03:15 -0500
Message-Id: <20211227190327.1042326-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@kernel.org>

[ Upstream commit 2f5b3514c33fecad4003ce0f22ca9691492d310b ]

The memory reservation in arch/x86/platform/efi/efi.c depends on at
least two command line parameters. Put it back later in the boot process
and move efi_memblock_x86_reserve_range() out of early_memory_reserve().

An attempt to fix this was done in

  8d48bf8206f7 ("x86/boot: Pull up cmdline preparation and early param parsing")

but that caused other troubles so it got reverted.

The bug this is addressing is:

Dan reports that Anjaneya Chagam can no longer use the efi=nosoftreserve
kernel command line parameter to suppress "soft reservation" behavior.

This is due to the fact that the following call-chain happens at boot:

  early_reserve_memory
  |-> efi_memblock_x86_reserve_range
      |-> efi_fake_memmap_early

which does

        if (!efi_soft_reserve_enabled())
                return;

and that would have set EFI_MEM_NO_SOFT_RESERVE after having parsed
"nosoftreserve".

However, parse_early_param() gets called *after* it, leading to the boot
cmdline not being taken into account.

See also https://lore.kernel.org/r/e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com

  [ bp: Turn into a proper patch. ]

Signed-off-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211213112757.2612-4-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 40ed44ead0631..48596f9fddf45 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -713,9 +713,6 @@ static void __init early_reserve_memory(void)
 
 	early_reserve_initrd();
 
-	if (efi_enabled(EFI_BOOT))
-		efi_memblock_x86_reserve_range();
-
 	memblock_x86_reserve_range_setup_data();
 
 	reserve_ibft_region();
@@ -890,6 +887,9 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	if (efi_enabled(EFI_BOOT))
+		efi_memblock_x86_reserve_range();
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux
-- 
2.34.1

