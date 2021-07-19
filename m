Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71DA3CE1BC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbhGSP12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348182AbhGSPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAF206142B;
        Mon, 19 Jul 2021 16:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710563;
        bh=zIGfG06+KhaZCQC0pseDI72UWBmbJVughRhV+YTe3zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvOudeoxmJqSU3advmaGmp8FkqdFccZiTBwco/IHA+ZDUTIUMIxK6cel+7JPnsAJk
         NyDiNnBDMZaMhy5kfhEZ03ZZBLXFfuAmp1WIyxxvhx7XXRkEj7eumgdF+bbDwU+/fs
         Hpbi5oQzgsF2TBvY4gSGzurFf2AMiT4AgcQ6609E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 008/351] KVM: x86/mmu: Do not apply HPA (memory encryption) mask to GPAs
Date:   Mon, 19 Jul 2021 16:49:14 +0200
Message-Id: <20210719144944.803639766@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit fc9bf2e087efcd81bda2e52d09616d2a1bf982a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c         |    2 ++
 arch/x86/kvm/mmu/paging.h      |   14 ++++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h |    4 ++--
 arch/x86/kvm/mmu/spte.h        |    6 ------
 4 files changed, 18 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/paging.h

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -53,6 +53,8 @@
 #include <asm/kvm_page_track.h>
 #include "trace.h"
 
+#include "paging.h"
+
 extern bool itlb_multihit_kvm_mitigation;
 
 static int __read_mostly nx_huge_pages = -1;
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
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -38,12 +38,6 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK =
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


