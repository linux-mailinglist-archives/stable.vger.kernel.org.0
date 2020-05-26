Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874081E2F91
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390380AbgEZT45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390336AbgEZT45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 15:56:57 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6D0C03E96D;
        Tue, 26 May 2020 12:56:57 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jdfgv-0004E3-Rv; Tue, 26 May 2020 21:56:49 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 3BD2B1C00FA;
        Tue, 26 May 2020 21:56:49 +0200 (CEST)
Date:   Tue, 26 May 2020 19:56:49 -0000
From:   "tip-bot2 for Tony Luck" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/core] x86/{mce,mm}: Unmap the entire page if the whole page
 is affected and poisoned
Cc:     Jue Wang <juew@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200520163546.GA7977@agluck-desk2.amr.corp.intel.com>
References: <20200520163546.GA7977@agluck-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Message-ID: <159052300906.17951.14977486527069637505.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/core branch of tip:

Commit-ID:     be69f6c5cd38c457c22f6e718077f6524437369d
Gitweb:        https://git.kernel.org/tip/be69f6c5cd38c457c22f6e718077f6524437369d
Author:        Tony Luck <tony.luck@intel.com>
AuthorDate:    Wed, 20 May 2020 09:35:46 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 25 May 2020 22:37:41 +02:00

x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned

An interesting thing happened when a guest Linux instance took a machine
check. The VMM unmapped the bad page from guest physical space and
passed the machine check to the guest.

Linux took all the normal actions to offline the page from the process
that was using it. But then guest Linux crashed because it said there
was a second machine check inside the kernel with this stack trace:

do_memory_failure
    set_mce_nospec
         set_memory_uc
              _set_memory_uc
                   change_page_attr_set_clr
                        cpa_flush
                             clflush_cache_range_opt

This was odd, because a CLFLUSH instruction shouldn't raise a machine
check (it isn't consuming the data). Further investigation showed that
the VMM had passed in another machine check because is appeared that the
guest was accessing the bad page.

Fix is to check the scope of the poison by checking the MCi_MISC register.
If the entire page is affected, then unmap the page. If only part of the
page is affected, then mark the page as uncacheable.

This assumes that VMMs will do the logical thing and pass in the "whole
page scope" via the MCi_MISC register (since they unmapped the entire
page).

  [ bp: Adjust to x86/entry changes. ]

Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
Reported-by: Jue Wang <juew@google.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Jue Wang <juew@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200520163546.GA7977@agluck-desk2.amr.corp.intel.com
---
 arch/x86/include/asm/set_memory.h | 19 +++++++++++++------
 arch/x86/kernel/cpu/mce/core.c    | 18 ++++++++++++++----
 include/linux/sched.h             |  4 +++-
 include/linux/set_memory.h        |  2 +-
 4 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index ec2c0a0..5948218 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -86,28 +86,35 @@ int set_direct_map_default_noflush(struct page *page);
 extern int kernel_set_to_readonly;
 
 #ifdef CONFIG_X86_64
-static inline int set_mce_nospec(unsigned long pfn)
+/*
+ * Prevent speculative access to the page by either unmapping
+ * it (if we do not require access to any part of the page) or
+ * marking it uncacheable (if we want to try to retrieve data
+ * from non-poisoned lines in the page).
+ */
+static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	unsigned long decoy_addr;
 	int rc;
 
 	/*
-	 * Mark the linear address as UC to make sure we don't log more
-	 * errors because of speculative access to the page.
 	 * We would like to just call:
-	 *      set_memory_uc((unsigned long)pfn_to_kaddr(pfn), 1);
+	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
 	 * but doing that would radically increase the odds of a
 	 * speculative access to the poison page because we'd have
 	 * the virtual address of the kernel 1:1 mapping sitting
 	 * around in registers.
 	 * Instead we get tricky.  We create a non-canonical address
 	 * that looks just like the one we want, but has bit 63 flipped.
-	 * This relies on set_memory_uc() properly sanitizing any __pa()
+	 * This relies on set_memory_XX() properly sanitizing any __pa()
 	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
 	 */
 	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
 
-	rc = set_memory_uc(decoy_addr, 1);
+	if (unmap)
+		rc = set_memory_np(decoy_addr, 1);
+	else
+		rc = set_memory_uc(decoy_addr, 1);
 	if (rc)
 		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
 	return rc;
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index ffee8a2..753bc77 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -520,6 +520,14 @@ bool mce_is_memory_error(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_is_memory_error);
 
+static bool whole_page(struct mce *m)
+{
+	if (!mca_cfg.ser || !(m->status & MCI_STATUS_MISCV))
+		return true;
+
+	return MCI_MISC_ADDR_LSB(m->misc) >= PAGE_SHIFT;
+}
+
 bool mce_is_correctable(struct mce *m)
 {
 	if (m->cpuvendor == X86_VENDOR_AMD && m->status & MCI_STATUS_DEFERRED)
@@ -573,7 +581,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
 
 	pfn = mce->addr >> PAGE_SHIFT;
 	if (!memory_failure(pfn, 0)) {
-		set_mce_nospec(pfn);
+		set_mce_nospec(pfn, whole_page(mce));
 		mce->kflags |= MCE_HANDLED_UC;
 	}
 
@@ -1173,11 +1181,12 @@ static void kill_me_maybe(struct callback_head *cb)
 	int flags = MF_ACTION_REQUIRED;
 
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
-	if (!(p->mce_status & MCG_STATUS_RIPV))
+
+	if (!p->mce_ripv)
 		flags |= MF_MUST_KILL;
 
 	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, flags)) {
-		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
+		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
 		return;
 	}
 
@@ -1331,7 +1340,8 @@ void noinstr do_machine_check(struct pt_regs *regs)
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
 		current->mce_addr = m.addr;
-		current->mce_status = m.mcgstatus;
+		current->mce_ripv = !!(m.mcgstatus & MCG_STATUS_RIPV);
+		current->mce_whole_page = whole_page(&m);
 		current->mce_kill_me.func = kill_me_maybe;
 		if (kill_it)
 			current->mce_kill_me.func = kill_me_now;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1d68ee3..6293fc2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1304,7 +1304,9 @@ struct task_struct {
 
 #ifdef CONFIG_X86_MCE
 	u64				mce_addr;
-	u64				mce_status;
+	__u64				mce_ripv : 1,
+					mce_whole_page : 1,
+					__mce_reserved : 62;
 	struct callback_head		mce_kill_me;
 #endif
 
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 86281ac..860e0f8 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -26,7 +26,7 @@ static inline int set_direct_map_default_noflush(struct page *page)
 #endif
 
 #ifndef set_mce_nospec
-static inline int set_mce_nospec(unsigned long pfn)
+static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	return 0;
 }
