Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20BB466689
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347725AbhLBPhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 10:37:19 -0500
Received: from 8bytes.org ([81.169.241.247]:37312 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358975AbhLBPhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Dec 2021 10:37:18 -0500
Received: from cap.home.8bytes.org (p5b006edb.dip0.t-ipconnect.de [91.0.110.219])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 7975EE41;
        Thu,  2 Dec 2021 16:33:52 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH v4 4/4] x86/64/mm: Map all kernel memory into trampoline_pgd
Date:   Thu,  2 Dec 2021 16:32:26 +0100
Message-Id: <20211202153226.22946-5-joro@8bytes.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211202153226.22946-1-joro@8bytes.org>
References: <20211202153226.22946-1-joro@8bytes.org>
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
index 6d98609387ba..c5e29db02a46 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -98,6 +98,7 @@ static void __init setup_real_mode(void)
 #ifdef CONFIG_X86_64
 	u64 *trampoline_pgd;
 	u64 efer;
+	int i;
 #endif
 
 	base = (unsigned char *)real_mode_header;
@@ -154,8 +155,17 @@ static void __init setup_real_mode(void)
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
-- 
2.34.0

