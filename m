Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A49FD63D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfKOGWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbfKOGWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:46 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21E4B20803;
        Fri, 15 Nov 2019 06:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798964;
        bh=Rysc8aNVLGSoiLq482DmDiyQNFDDX2b34w7VFmJZhHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niJvySUipHYsK4DdzUuuzW7b9IygjRNNiTZdpbkKh6ad5GP+K8XuYmDoDg771+/Ud
         pteCjMVWU/nvBuJJKUA11J6S6ipjqnNPQsAOJRoZDUk3a2OgbUaFBk9VbBpX9dkC5M
         oQXVZP5ycv0+IB7D0qpix87262rgZtBSo0yqV/VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 24/31] KVM: x86: add tracepoints around __direct_map and FNAME(fetch)
Date:   Fri, 15 Nov 2019 14:20:53 +0800
Message-Id: <20191115062018.688564690@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 335e192a3fa415e1202c8b9ecdaaecd643f823cc upstream.

These are useful in debugging shadow paging.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.9:
 - Keep using PT_PRESENT_MASK to test page write permission
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.c         |   13 ++++-----
 arch/x86/kvm/mmutrace.h    |   59 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |    2 +
 3 files changed, 67 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -131,9 +131,6 @@ module_param(dbg, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-#define CREATE_TRACE_POINTS
-#include "mmutrace.h"
-
 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
@@ -193,8 +190,12 @@ static u64 __read_mostly shadow_mmio_mas
 static u64 __read_mostly shadow_present_mask;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
+static bool is_executable_pte(u64 spte);
 static void mmu_free_roots(struct kvm_vcpu *vcpu);
 
+#define CREATE_TRACE_POINTS
+#include "mmutrace.h"
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
 {
 	shadow_mmio_mask = mmio_mask;
@@ -2667,10 +2668,7 @@ static int mmu_set_spte(struct kvm_vcpu
 		ret = RET_PF_EMULATE;
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
-	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
-		 is_large_pte(*sptep)? "2MB" : "4kB",
-		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
-		 *sptep, sptep);
+	trace_kvm_mmu_set_spte(level, gfn, sptep);
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
@@ -2781,6 +2779,7 @@ static int __direct_map(struct kvm_vcpu
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return RET_PF_RETRY;
 
+	trace_kvm_mmu_spte_requested(gpa, level, pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -322,6 +322,65 @@ TRACE_EVENT(
 		  __entry->kvm_gen == __entry->spte_gen
 	)
 );
+
+TRACE_EVENT(
+	kvm_mmu_set_spte,
+	TP_PROTO(int level, gfn_t gfn, u64 *sptep),
+	TP_ARGS(level, gfn, sptep),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, spte)
+		__field(u64, sptep)
+		__field(u8, level)
+		/* These depend on page entry type, so compute them now.  */
+		__field(bool, r)
+		__field(bool, x)
+		__field(u8, u)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->spte = *sptep;
+		__entry->sptep = virt_to_phys(sptep);
+		__entry->level = level;
+		__entry->r = shadow_present_mask || (__entry->spte & PT_PRESENT_MASK);
+		__entry->x = is_executable_pte(__entry->spte);
+		__entry->u = shadow_user_mask ? !!(__entry->spte & shadow_user_mask) : -1;
+	),
+
+	TP_printk("gfn %llx spte %llx (%s%s%s%s) level %d at %llx",
+		  __entry->gfn, __entry->spte,
+		  __entry->r ? "r" : "-",
+		  __entry->spte & PT_PRESENT_MASK ? "w" : "-",
+		  __entry->x ? "x" : "-",
+		  __entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
+		  __entry->level, __entry->sptep
+	)
+);
+
+TRACE_EVENT(
+	kvm_mmu_spte_requested,
+	TP_PROTO(gpa_t addr, int level, kvm_pfn_t pfn),
+	TP_ARGS(addr, level, pfn),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, pfn)
+		__field(u8, level)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = addr >> PAGE_SHIFT;
+		__entry->pfn = pfn | (__entry->gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
+		__entry->level = level;
+	),
+
+	TP_printk("gfn %llx pfn %llx level %d",
+		  __entry->gfn, __entry->pfn, __entry->level
+	)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -626,6 +626,8 @@ static int FNAME(fetch)(struct kvm_vcpu
 
 	base_gfn = gw->gfn;
 
+	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
+
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
 		clear_sp_write_flooding_count(it.sptep);
 		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);


