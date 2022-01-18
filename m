Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEE14917B5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347738AbiARCmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45732 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244545AbiARCfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:35:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66C04B8123A;
        Tue, 18 Jan 2022 02:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64913C36AEB;
        Tue, 18 Jan 2022 02:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473346;
        bh=WW9YieQwk2clGKAZBRP8Uji/4Smq/3oUwh7LfdiSjSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovzfwy3KhFp4IqKnlfriSXvI77GDEIYLgtvrzqyNtMWkQh0uhPgGn7ScjZc5FCeQI
         j+0r8v7Optg6zNnl3lNEbOCDewjbEpH7K0VLxgQZUoi99GQoOWK39io9zvib4ha2MO
         DCOpZO6y9xi5ln094f3gXSJq/CBQsSGzK5MZnoQyal9ypGBEYCJrpBbenVTf6QrZIj
         QP2mZ5s2DkPmSyw7XeY7TH/pMx6yQBnu1jMJD9GPJ+FHtX3GslH59O9kPd34GDX1s+
         sl2WU2wZu7uPv0Ds6qA9z4/fcUqAp9hwknW76raDEAwnuiJ0KTXK617lRhEhKRYoKO
         lAkz9Y8NO9Fhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, pbonzini@redhat.com, hpa@zytor.com,
        seanjc@google.com, paul.gortmaker@windriver.com,
        thomas.lendacky@amd.com, rppt@kernel.org,
        akpm@linux-foundation.org, brijesh.singh@amd.com
Subject: [PATCH AUTOSEL 5.15 080/188] x86/mm: Flush global TLB when switching to trampoline page-table
Date:   Mon, 17 Jan 2022 21:30:04 -0500
Message-Id: <20220118023152.1948105-80-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 71d5049b053876afbde6c3273250b76935494ab2 ]

Move the switching code into a function so that it can be re-used and
add a global TLB flush. This makes sure that usage of memory which is
not mapped in the trampoline page-table is reliably caught.

Also move the clearing of CR4.PCIDE before the CR3 switch because the
cr4_clear_bits() function will access data not mapped into the
trampoline page-table.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211202153226.22946-4-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/realmode.h |  1 +
 arch/x86/kernel/reboot.c        | 12 ++----------
 arch/x86/realmode/init.c        | 26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 5db5d083c8732..331474b150f16 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -89,6 +89,7 @@ static inline void set_real_mode_mem(phys_addr_t mem)
 }
 
 void reserve_real_mode(void);
+void load_trampoline_pgtable(void);
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0a40df66a40de..fa700b46588e0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -113,17 +113,9 @@ void __noreturn machine_real_restart(unsigned int type)
 	spin_unlock(&rtc_lock);
 
 	/*
-	 * Switch back to the initial page table.
+	 * Switch to the trampoline page table.
 	 */
-#ifdef CONFIG_X86_32
-	load_cr3(initial_page_table);
-#else
-	write_cr3(real_mode_header->trampoline_pgd);
-
-	/* Exiting long mode will fail if CR4.PCIDE is set. */
-	if (boot_cpu_has(X86_FEATURE_PCID))
-		cr4_clear_bits(X86_CR4_PCIDE);
-#endif
+	load_trampoline_pgtable();
 
 	/* Jump to the identity-mapped low memory code */
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index d3eee1ebcf1d5..1d20ed4b28729 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -17,6 +17,32 @@ u32 *trampoline_cr4_features;
 /* Hold the pgd entry used on booting additional CPUs */
 pgd_t trampoline_pgd_entry;
 
+void load_trampoline_pgtable(void)
+{
+#ifdef CONFIG_X86_32
+	load_cr3(initial_page_table);
+#else
+	/*
+	 * This function is called before exiting to real-mode and that will
+	 * fail with CR4.PCIDE still set.
+	 */
+	if (boot_cpu_has(X86_FEATURE_PCID))
+		cr4_clear_bits(X86_CR4_PCIDE);
+
+	write_cr3(real_mode_header->trampoline_pgd);
+#endif
+
+	/*
+	 * The CR3 write above will not flush global TLB entries.
+	 * Stale, global entries from previous page tables may still be
+	 * present.  Flush those stale entries.
+	 *
+	 * This ensures that memory accessed while running with
+	 * trampoline_pgd is *actually* mapped into trampoline_pgd.
+	 */
+	__flush_tlb_all();
+}
+
 void __init reserve_real_mode(void)
 {
 	phys_addr_t mem;
-- 
2.34.1

