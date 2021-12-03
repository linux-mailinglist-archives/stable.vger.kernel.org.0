Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4243546747F
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 11:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351320AbhLCKIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 05:08:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54122 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350895AbhLCKIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 05:08:10 -0500
Date:   Fri, 03 Dec 2021 10:04:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638525884;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3/eO0R/lBVGHYQRY2MVtI75vrN28oVSvaZP9PGsevs=;
        b=uvQPIsbFD+5ElitLga/IA9qScSjaQHz3IPRmtQSvd4TSddv35R0jC5Con5QOhtNPUeizbc
        DwVzW8MSs5eDBgZtbvdX1BON+UZSVZlSNujYVBF7oY1blQqfNzVRj+nOLcT9LY0NHC+qt6
        TZR9xqRkq5JgwP5wOuXUku9U3DtJCsVkokHm+F5qZzG6ZqucuAqTwvlGbMg8QKudMgL0NZ
        CSufXe70g+nNBL81ihKRr2iXxGcyxXIeTZtINaYR82MkezFQA6Dt2odHizTRQTCENE0bpk
        /8r6DgEJxPQBZIzOtLAv7aciDHRUVhwXaV0pa+H40U2bJDbIaomxLGHi+1VOLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638525884;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3/eO0R/lBVGHYQRY2MVtI75vrN28oVSvaZP9PGsevs=;
        b=py5d7wQ3+joZq+kWHP0fapAjSHiKa+uGXseNlGWmJwTSuukyALSLTAUg8jB2xY7QfXashN
        z+kKIetcknpZUAAA==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/64/mm: Map all kernel memory into trampoline_pgd
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211202153226.22946-5-joro@8bytes.org>
References: <20211202153226.22946-5-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <163852588365.11128.1827426019231141785.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     51523ed1c26758de1af7e58730a656875f72f783
Gitweb:        https://git.kernel.org/tip/51523ed1c26758de1af7e58730a656875f72f783
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Thu, 02 Dec 2021 16:32:26 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 03 Dec 2021 09:11:43 +01:00

x86/64/mm: Map all kernel memory into trampoline_pgd

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
---
 arch/x86/realmode/init.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 4a3da75..38d24d2 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -72,6 +72,7 @@ static void __init setup_real_mode(void)
 #ifdef CONFIG_X86_64
 	u64 *trampoline_pgd;
 	u64 efer;
+	int i;
 #endif
 
 	base = (unsigned char *)real_mode_header;
@@ -128,8 +129,17 @@ static void __init setup_real_mode(void)
 	trampoline_header->flags = 0;
 
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
 
 	sme_sev_setup_real_mode(trampoline_header);
