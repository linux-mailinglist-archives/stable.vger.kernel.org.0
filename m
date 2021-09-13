Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E298840966D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbhIMOvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346945AbhIMOrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:47:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B002B63233;
        Mon, 13 Sep 2021 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541547;
        bh=UFT6MBapqXV9h9DMkaVCdmLDjLLWejZRghtRFrPmvsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyUn/IrZg61vAoC9bfcjd/td25j5K5t59+Ovw4euwYrw1CL3RjwLmyDQIJLYVc13+
         r8mpISvUFNzg9hl2IJQysyzCeWS4A29olJirc7rhqV5EvSEvK8QewyOe+vfw6MuVC2
         27r8cOhFb4z4XkFlxjeAU8rsn0KWYRXh3Z1LksWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 313/334] KVM: x86: clamp host mapping level to max_level in kvm_mmu_max_mapping_level
Date:   Mon, 13 Sep 2021 15:16:07 +0200
Message-Id: <20210913131124.007245104@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit ec607a564f70519b340f7eb4cfc0f4a6b55285ac upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2846,6 +2846,7 @@ int kvm_mmu_max_mapping_level(struct kvm
 			      kvm_pfn_t pfn, int max_level)
 {
 	struct kvm_lpage_info *linfo;
+	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -2857,7 +2858,8 @@ int kvm_mmu_max_mapping_level(struct kvm
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	return host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	return min(host_level, max_level);
 }
 
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
@@ -2881,17 +2883,12 @@ int kvm_mmu_hugepage_adjust(struct kvm_v
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


