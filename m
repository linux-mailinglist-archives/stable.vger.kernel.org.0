Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44501408A29
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbhIML25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:32946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238710AbhIML25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:28:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 448C660F44;
        Mon, 13 Sep 2021 11:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532461;
        bh=tFJOjiwe30XDT7jV2TPt0m6Tz6GqyOKI4bNEhDMME/g=;
        h=Subject:To:Cc:From:Date:From;
        b=tCVwDuIodL0zXxSY1BJNEogEqk0Qp6Uz/N+Y3dr6MMQwEw7Shz2gBsx8SUhu8r9j2
         8P8TAGlWEbb68yau3I2rSZCHXtsTLPj6ElRkj/ym1wFec4tgbQK1ulO4ubBHPZQUgV
         aFw+amZPKh9JehH5mONk5CQqqREjt4Z9jRAeWvUA=
Subject: FAILED: patch "[PATCH] KVM: x86: clamp host mapping level to max_level in" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:27:39 +0200
Message-ID: <1631532459169223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ec607a564f70519b340f7eb4cfc0f4a6b55285ac Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 6 Aug 2021 07:05:58 -0400
Subject: [PATCH] KVM: x86: clamp host mapping level to max_level in
 kvm_mmu_max_mapping_level

This change started as a way to make kvm_mmu_hugepage_adjust a bit simpler,
but it does fix two bugs as well.

One bug is in zapping collapsible PTEs.  If a large page size is
disallowed but not all of them, kvm_mmu_max_mapping_level will return the
host mapping level and the small PTEs will be zapped up to that level.
However, if e.g. 1GB are prohibited, we can still zap 4KB mapping and
preserve the 2MB ones. This can happen for example when NX huge pages
are in use.

The second would happen when userspace backs guest memory
with a 1gb hugepage but only assign a subset of the page to
the guest.  1gb pages would be disallowed by the memslot, but
not 2mb.  kvm_mmu_max_mapping_level() would fall through to the
host_pfn_mapping_level() logic, see the 1gb hugepage, and map the whole
thing into the guest.

Fixes: 2f57b7051fe8 ("KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to max_level")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 54cb15e4b550..bfd2705a7291 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2910,6 +2910,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      kvm_pfn_t pfn, int max_level)
 {
 	struct kvm_lpage_info *linfo;
+	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -2921,7 +2922,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	return host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	return min(host_level, max_level);
 }
 
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
@@ -2945,17 +2947,12 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PG_LEVEL_4K;
 
-	level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
-	if (level == PG_LEVEL_4K)
-		return level;
-
-	*req_level = level = min(level, max_level);
-
 	/*
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	if (huge_page_disallowed)
+	*req_level = level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
+	if (level == PG_LEVEL_4K || huge_page_disallowed)
 		return PG_LEVEL_4K;
 
 	/*

