Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03803A8498
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhFOPvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231894AbhFOPvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AE7161627;
        Tue, 15 Jun 2021 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772141;
        bh=kF4zBKcwr4HBN28XG9lW+7/RnP8jeBE2vkThs8tkUp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+8GyQf7p2/B6SLhrTHApfO5UfEWh9onkpl6cFlaFpNk/SPMsh817rWIhHsQBZMLw
         zbQumwWJOmL/IsqM+JveFAevPNEtvQp285gW7A0oUMcnlIUgTDDcQCqWffTZumPf4Q
         2ahXzNpW5n5BaIkGsz1fVNrQ6lvVgrqu236NHcp3W7aD2f9AvnU/ZQN4ozR1M/sKQ/
         raAnFrHwu526Cs9SzYlV/Vd5qiCdEjEaPCNoe+ZQALvFG9n5RwbOD5nxGgx0TiXbXU
         RtoFLRDtfFsettAx1lHaZmvpLl/hRYOR67QaueB0B6xRL6PA6KA7Z0xi+lBCyaJ0kj
         bkAQiJ8ffwIyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Artemiy Margaritov <artemiy.margaritov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 29/33] kvm: avoid speculation-based attacks from out-of-range memslot accesses
Date:   Tue, 15 Jun 2021 11:48:20 -0400
Message-Id: <20210615154824.62044-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit da27a83fd6cc7780fea190e1f5c19e87019da65c ]

KVM's mechanism for accessing guest memory translates a guest physical
address (gpa) to a host virtual address using the right-shifted gpa
(also known as gfn) and a struct kvm_memory_slot.  The translation is
performed in __gfn_to_hva_memslot using the following formula:

      hva = slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE

It is expected that gfn falls within the boundaries of the guest's
physical memory.  However, a guest can access invalid physical addresses
in such a way that the gfn is invalid.

__gfn_to_hva_memslot is called from kvm_vcpu_gfn_to_hva_prot, which first
retrieves a memslot through __gfn_to_memslot.  While __gfn_to_memslot
does check that the gfn falls within the boundaries of the guest's
physical memory or not, a CPU can speculate the result of the check and
continue execution speculatively using an illegal gfn. The speculation
can result in calculating an out-of-bounds hva.  If the resulting host
virtual address is used to load another guest physical address, this
is effectively a Spectre gadget consisting of two consecutive reads,
the second of which is data dependent on the first.

Right now it's not clear if there are any cases in which this is
exploitable.  One interesting case was reported by the original author
of this patch, and involves visiting guest page tables on x86.  Right
now these are not vulnerable because the hva read goes through get_user(),
which contains an LFENCE speculation barrier.  However, there are
patches in progress for x86 uaccess.h to mask kernel addresses instead of
using LFENCE; once these land, a guest could use speculation to read
from the VMM's ring 3 address space.  Other architectures such as ARM
already use the address masking method, and would be susceptible to
this same kind of data-dependent access gadgets.  Therefore, this patch
proactively protects from these attacks by masking out-of-bounds gfns
in __gfn_to_hva_memslot, which blocks speculation of invalid hvas.

Sean Christopherson noted that this patch does not cover
kvm_read_guest_offset_cached.  This however is limited to a few bytes
past the end of the cache, and therefore it is unlikely to be useful in
the context of building a chain of data dependent accesses.

Reported-by: Artemiy Margaritov <artemiy.margaritov@gmail.com>
Co-developed-by: Artemiy Margaritov <artemiy.margaritov@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kvm_host.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 99dccea4293c..5520d3a97c2e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1118,7 +1118,15 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 static inline unsigned long
 __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
+	/*
+	 * The index was checked originally in search_memslots.  To avoid
+	 * that a malicious guest builds a Spectre gadget out of e.g. page
+	 * table walks, do not let the processor speculate loads outside
+	 * the guest's registered memslots.
+	 */
+	unsigned long offset = array_index_nospec(gfn - slot->base_gfn,
+						  slot->npages);
+	return slot->userspace_addr + offset * PAGE_SIZE;
 }
 
 static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
-- 
2.30.2

