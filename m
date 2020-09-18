Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59C26F202
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgIRCz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgIRCHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7380F23A31;
        Fri, 18 Sep 2020 02:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394825;
        bh=SPERwlclIXQwTDhY9S9VzGMn42+SabgQHJDdP2nrnVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rO7WPuTZ/yUzvg9shwPlE0akOMvDAHC4/R1DGcEMDLKFfYVc6hvHJ2y7HIv1rFh7l
         1n7s+70jVctX0/NoThT8uncUrTZdJ8C5mQ1svngMo4fNhMyY2GDoLeXo1cRpncqm3O
         LMziZvv18gnNC+a0IyQHYvA1dHhDfycxu4/+3ZDs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 290/330] KVM: PPC: Book3S HV: Close race with page faults around memslot flushes
Date:   Thu, 17 Sep 2020 22:00:30 -0400
Message-Id: <20200918020110.2063155-290-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

[ Upstream commit 11362b1befeadaae4d159a8cddcdaf6b8afe08f9 ]

There is a potential race condition between hypervisor page faults
and flushing a memslot.  It is possible for a page fault to read the
memslot before a memslot is updated and then write a PTE to the
partition-scoped page tables after kvmppc_radix_flush_memslot has
completed.  (Note that this race has never been explicitly observed.)

To close this race, it is sufficient to increment the MMU sequence
number while the kvm->mmu_lock is held.  That will cause
mmu_notifier_retry() to return true, and the page fault will then
return to the guest without inserting a PTE.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index da8375437d161..9d73448354698 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1104,6 +1104,11 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 					 kvm->arch.lpid);
 		gpa += PAGE_SIZE;
 	}
+	/*
+	 * Increase the mmu notifier sequence number to prevent any page
+	 * fault that read the memslot earlier from writing a PTE.
+	 */
+	kvm->mmu_notifier_seq++;
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.25.1

