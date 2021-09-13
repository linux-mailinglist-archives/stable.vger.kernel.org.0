Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422A040888F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbhIMJyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbhIMJx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 05:53:59 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB37C061574;
        Mon, 13 Sep 2021 02:52:43 -0700 (PDT)
Received: from cap.home.8bytes.org (p549ada98.dip0.t-ipconnect.de [84.154.218.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id D045A7F;
        Mon, 13 Sep 2021 11:52:40 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, jroedel@suse.de, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, joro@8bytes.org,
        stable@vger.kernel.org
Subject: [PATCH] x86/64/mm: Map all kernel memory into trampoline_pgd
Date:   Mon, 13 Sep 2021 11:52:36 +0200
Message-Id: <20210913095236.24937-1-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The trampoline_pgd only maps the 0xfffffff000000000-0xffffffffffffffff
range of kernel memory (with 4-level paging). This range contains the
kernels text+data+bss mappings and the module mapping space, but not the
direct mapping and the vmalloc area.

This is enough to get an application processors out of real-mode, but
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

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/realmode/init.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 31b5856010cb..7a08c96cb42a 100644
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
+	/*
+	 * Map all of kernel memory into the trampoline PGD so that it includes
+	 * the direct mapping and vmalloc space. This is needed to keep the
+	 * stack and real_mode_header mapped when switching to this page table.
+	 */
+	for (i = pgd_index(__PAGE_OFFSET); i < PTRS_PER_PGD; i++)
+		trampoline_pgd[i] = init_top_pgt[i].pgd;
+
+	/* Map the real mode stub as virtual == physical */
 	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
-	trampoline_pgd[511] = init_top_pgt[511].pgd;
 #endif
 
 	sme_sev_setup_real_mode(trampoline_header);
-- 
2.33.0

