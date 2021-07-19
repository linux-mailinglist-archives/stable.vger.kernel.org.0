Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A723CCFF2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhGSIXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235789AbhGSIXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 925A661285;
        Mon, 19 Jul 2021 08:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626684965;
        bh=CiKQ7DMna5I32NJXiyt9hcjhSmn/Y1Ni92K0YFWQaFU=;
        h=Subject:To:Cc:From:Date:From;
        b=01RaLQsOJCJUCtS6GEpimChykZNUUsDRw28hKxyz3sxOKICMvw6id4WFAFPWiP6TZ
         Qfxgs8hgYCb1XOjH6A2lKC7X6Kdf03U8tzZdbxXKB01oKsoS3HKbSEJP09v4Kd4J9k
         XXLo1kqfCM6RUMciRhHVW/T8Xgmz0qU+AjLUfEE8=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Do not apply HPA (memory encryption) mask to" failed to apply to 4.14-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 10:53:12 +0200
Message-ID: <162668479216129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fc9bf2e087efcd81bda2e52d09616d2a1bf982a8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 23 Jun 2021 16:05:49 -0700
Subject: [PATCH] KVM: x86/mmu: Do not apply HPA (memory encryption) mask to
 GPAs

Ignore "dynamic" host adjustments to the physical address mask when
generating the masks for guest PTEs, i.e. the guest PA masks.  The host
physical address space and guest physical address space are two different
beasts, e.g. even though SEV's C-bit is the same bit location for both
host and guest, disabling SME in the host (which clears shadow_me_mask)
does not affect the guest PTE->GPA "translation".

For non-SEV guests, not dropping bits is the correct behavior.  Assuming
KVM and userspace correctly enumerate/configure guest MAXPHYADDR, bits
that are lost as collateral damage from memory encryption are treated as
reserved bits, i.e. KVM will never get to the point where it attempts to
generate a gfn using the affected bits.  And if userspace wants to create
a bogus vCPU, then userspace gets to deal with the fallout of hardware
doing odd things with bad GPAs.

For SEV guests, not dropping the C-bit is technically wrong, but it's a
moot point because KVM can't read SEV guest's page tables in any case
since they're always encrypted.  Not to mention that the current KVM code
is also broken since sme_me_mask does not have to be non-zero for SEV to
be supported by KVM.  The proper fix would be to teach all of KVM to
correctly handle guest private memory, but that's a task for the future.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210623230552.4027702-5-seanjc@google.com>
[Use a new header instead of adding header guards to paging_tmpl.h. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 00732757cc60..b888385d1933 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -53,6 +53,8 @@
 #include <asm/kvm_page_track.h>
 #include "trace.h"
 
+#include "paging.h"
+
 extern bool itlb_multihit_kvm_mitigation;
 
 int __read_mostly nx_huge_pages = -1;
diff --git a/arch/x86/kvm/mmu/paging.h b/arch/x86/kvm/mmu/paging.h
new file mode 100644
index 000000000000..de8ab323bb70
--- /dev/null
+++ b/arch/x86/kvm/mmu/paging.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Shadow paging constants/helpers that don't need to be #undef'd. */
+#ifndef __KVM_X86_PAGING_H
+#define __KVM_X86_PAGING_H
+
+#define GUEST_PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#define PT64_LVL_ADDR_MASK(level) \
+	(GUEST_PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#define PT64_LVL_OFFSET_MASK(level) \
+	(GUEST_PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#endif /* __KVM_X86_PAGING_H */
+
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 490a028ddabe..ee044d357b5f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -24,7 +24,7 @@
 	#define pt_element_t u64
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
-	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
+	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
@@ -57,7 +57,7 @@
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
-	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
+	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 7a5ce9314107..eb7b227fc6cf 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -38,12 +38,6 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 #else
 #define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #endif
-#define PT64_LVL_ADDR_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
-#define PT64_LVL_OFFSET_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
 
 #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
 			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)

