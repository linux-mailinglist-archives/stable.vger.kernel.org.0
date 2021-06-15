Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC1D3A8524
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhFOPxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhFOPwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED3316187E;
        Tue, 15 Jun 2021 15:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772206;
        bh=RJU0yya9VDuRe2yngyEVAK81ztc5DKJHve/5OBEtHF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CS5LvW+K/fKtkBNLor7lE61TqJb/5lYfsMkbdk7XsAIb1DqS4vPXnnnQ4QganK+fg
         Kjflh9XoFLoProTImllMRr9hpv0P1UlYUrnySaWBhL1/aA+2TEIxXvNI01dvKs9A9H
         GzQYmB7GbfAWKzdTJV4dhtucXlZlF2lxR8PJ6Qy4fcb4+tmddvmtTI3GuoE1HbxkRp
         B99vWClEqH+pV0q4NKya2np6Em499bOyiKHpBD2RB0REwv9XGqLFnD8t0AJZARWXCE
         pJSrkYrYchpCPzP0njFfc13O674a2s0iXmnUHLS28eX2TqG0LvRWgbtF4hMiFzonVD
         Ey1/pXMQdpXew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Artemiy Margaritov <artemiy.margaritov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/15] kvm: avoid speculation-based attacks from out-of-range memslot accesses
Date:   Tue, 15 Jun 2021 11:49:45 -0400
Message-Id: <20210615154948.62711-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154948.62711-1-sashal@kernel.org>
References: <20210615154948.62711-1-sashal@kernel.org>
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
index 0ec4ec428b9b..6c29afb76070 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1045,7 +1045,15 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
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

