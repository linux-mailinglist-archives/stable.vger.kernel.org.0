Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3205141C779
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 16:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344803AbhI2O5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 10:57:13 -0400
Received: from 8bytes.org ([81.169.241.247]:41198 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344808AbhI2O5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 10:57:12 -0400
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 8AD32105D;
        Wed, 29 Sep 2021 16:55:24 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <jroedel@suse.de>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 4/4] x86/64/mm: Map all kernel memory into trampoline_pgd
Date:   Wed, 29 Sep 2021 16:55:01 +0200
Message-Id: <20210929145501.4612-5-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929145501.4612-1-joro@8bytes.org>
References: <20210929145501.4612-1-joro@8bytes.org>
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
index 0cfe1046cec9..792cb9ca9b29 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -91,6 +91,7 @@ static void __init setup_real_mode(void)
 #ifdef CONFIG_X86_64
 	u64 *trampoline_pgd;
 	u64 efer;
+	int i;
 #endif
 
 	base = (unsigned char *)real_mode_header;
@@ -147,8 +148,17 @@ static void __init setup_real_mode(void)
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

