Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85901469C06
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347379AbhLFPTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36650 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356007AbhLFPRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:17:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44C506131B;
        Mon,  6 Dec 2021 15:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D64C341C5;
        Mon,  6 Dec 2021 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803649;
        bh=MLE0ZFfMY8EyCcYz4aouMFKJQ+r1w69P3r2hfQLIFew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyI1HouUSARXAs6JaQc0/MqISkGeCwNL8hP82AgaYioGxYLZJSwqZi8p1UqThS+NZ
         2vqGRj0aWJduGTbt3Gx9XPGJhQazR2KycB1JwEnSBjJ+79z5ZrC7CfANO3SxmG0Yym
         fQ8CbDolCqrUfOLCu6+EBsILZDmtNS9Nz2VYqqiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 61/70] x86/64/mm: Map all kernel memory into trampoline_pgd
Date:   Mon,  6 Dec 2021 15:57:05 +0100
Message-Id: <20211206145554.026812020@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 51523ed1c26758de1af7e58730a656875f72f783 upstream.

The trampoline_pgd only maps the 0xfffffff000000000-0xffffffffffffffff
range of kernel memory (with 4-level paging). This range contains the
kernel's text+data+bss mappings and the module mapping space but not the
direct mapping and the vmalloc area.

This is enough to get the application processors out of real-mode, but
for code that switches back to real-mode the trampoline_pgd is missing
important parts of the address space. For example, consider this code
from arch/x86/kernel/reboot.c, function machine_real_restart() for a
64-bit kernel:

  #ifdef CONFIG_X86_32
  	load_cr3(initial_page_table);
  #else
  	write_cr3(real_mode_header->trampoline_pgd);

  	/* Exiting long mode will fail if CR4.PCIDE is set. */
  	if (boot_cpu_has(X86_FEATURE_PCID))
  		cr4_clear_bits(X86_CR4_PCIDE);
  #endif

  	/* Jump to the identity-mapped low memory code */
  #ifdef CONFIG_X86_32
  	asm volatile("jmpl *%0" : :
  		     "rm" (real_mode_header->machine_real_restart_asm),
  		     "a" (type));
  #else
  	asm volatile("ljmpl *%0" : :
  		     "m" (real_mode_header->machine_real_restart_asm),
  		     "D" (type));
  #endif

The code switches to the trampoline_pgd, which unmaps the direct mapping
and also the kernel stack. The call to cr4_clear_bits() will find no
stack and crash the machine. The real_mode_header pointer below points
into the direct mapping, and dereferencing it also causes a crash.

The reason this does not crash always is only that kernel mappings are
global and the CR3 switch does not flush those mappings. But if theses
mappings are not in the TLB already, the above code will crash before it
can jump to the real-mode stub.

Extend the trampoline_pgd to contain all kernel mappings to prevent
these crashes and to make code which runs on this page-table more
robust.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211202153226.22946-5-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/realmode/init.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -50,6 +50,7 @@ static void __init setup_real_mode(void)
 #ifdef CONFIG_X86_64
 	u64 *trampoline_pgd;
 	u64 efer;
+	int i;
 #endif
 
 	base = (unsigned char *)real_mode_header;
@@ -108,8 +109,17 @@ static void __init setup_real_mode(void)
 		trampoline_header->flags |= TH_FLAGS_SME_ACTIVE;
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
+
+	/* Map the real mode stub as virtual == physical */
 	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
-	trampoline_pgd[511] = init_top_pgt[511].pgd;
+
+	/*
+	 * Include the entirety of the kernel mapping into the trampoline
+	 * PGD.  This way, all mappings present in the normal kernel page
+	 * tables are usable while running on trampoline_pgd.
+	 */
+	for (i = pgd_index(__PAGE_OFFSET); i < PTRS_PER_PGD; i++)
+		trampoline_pgd[i] = init_top_pgt[i].pgd;
 #endif
 }
 


