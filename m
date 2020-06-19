Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5462E20163A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394820AbgFSQ2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389560AbgFSOzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:55:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636E02184D;
        Fri, 19 Jun 2020 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578512;
        bh=qIao0QBEb9ME5+XNSuBEiPtwZQCC1coiaR2yF6h8UA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOaWQueKWxXy2UI3sPOmJKAw6nLYYxe8xsM4Rip15ePMqr1pdjU3LjOFMaMXz/VVW
         k2Qm3KjX/60aLba4/Qki/aMX9vZAFgKxhRRTO9DEsxHSSuQaqy4utqES8ey4VZ62eX
         itLI1NjeyWnhaHXmsFbmaNzdRX14gFuP67bE+Hxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jue Wang <juew@google.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 049/267] x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned
Date:   Fri, 19 Jun 2020 16:30:34 +0200
Message-Id: <20200619141651.239483076@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit 17fae1294ad9d711b2c3dd0edef479d40c76a5e8 upstream.

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jue Wang <juew@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200520163546.GA7977@agluck-desk2.amr.corp.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/include/asm/set_memory.h |   19 +++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c  |   11 +++++++++--
 include/linux/set_memory.h        |    2 +-
 3 files changed, 23 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -90,28 +90,35 @@ void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 
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
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -535,6 +535,13 @@ bool mce_is_memory_error(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_is_memory_error);
 
+static bool whole_page(struct mce *m)
+{
+	if (!mca_cfg.ser || !(m->status & MCI_STATUS_MISCV))
+		return true;
+	return MCI_MISC_ADDR_LSB(m->misc) >= PAGE_SHIFT;
+}
+
 bool mce_is_correctable(struct mce *m)
 {
 	if (m->cpuvendor == X86_VENDOR_AMD && m->status & MCI_STATUS_DEFERRED)
@@ -600,7 +607,7 @@ static int srao_decode_notifier(struct n
 	if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
 		pfn = mce->addr >> PAGE_SHIFT;
 		if (!memory_failure(pfn, 0))
-			set_mce_nospec(pfn);
+			set_mce_nospec(pfn, whole_page(mce));
 	}
 
 	return NOTIFY_OK;
@@ -1101,7 +1108,7 @@ static int do_memory_failure(struct mce
 	if (ret)
 		pr_err("Memory error not recovered");
 	else
-		set_mce_nospec(m->addr >> PAGE_SHIFT);
+		set_mce_nospec(m->addr >> PAGE_SHIFT, whole_page(m));
 	return ret;
 }
 
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -18,7 +18,7 @@ static inline int set_memory_nx(unsigned
 #endif
 
 #ifndef set_mce_nospec
-static inline int set_mce_nospec(unsigned long pfn)
+static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	return 0;
 }


