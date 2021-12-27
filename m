Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BA14800D9
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbhL0PvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239804AbhL0Pqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:46:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90CBC08EA71;
        Mon, 27 Dec 2021 07:42:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B6F61115;
        Mon, 27 Dec 2021 15:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE12C36AEA;
        Mon, 27 Dec 2021 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619770;
        bh=Iz5a0+mjhpOdCd0kaMQOvGR4kvYFUlYI6nvi3xw/uEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1kiGs8jBiZ7OrcBPp+D36WwVHe9ZLv9ORvGzQMdWVPk+/5BcQB8rq/uTqR2MOhzO
         jZsZZYySDCD+/cvtydM+ISrX07plzypzbo0GhwmuxbD3KEra5bNY0qg24chdq6BRGN
         FeAjaywIp9a7TngEhaz/NrqrZq8Qpsn9L7kYEGcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 064/128] x86/boot: Move EFI range reservation after cmdline parsing
Date:   Mon, 27 Dec 2021 16:30:39 +0100
Message-Id: <20211227151333.633719191@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@kernel.org>

commit 2f5b3514c33fecad4003ce0f22ca9691492d310b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -713,9 +713,6 @@ static void __init early_reserve_memory(
 
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


