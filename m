Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA6F26B527
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIOXhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbgIOOfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAA9F20732;
        Tue, 15 Sep 2020 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179931;
        bh=iMKgGkkyySPJuKBz2CISjrGxR8IfeoJD3N1HF3Ggsvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1SbbeEmgVnS8uIl61DscDG6F+jXsh8HtI4lCUEbXHzFkoIikUSPcLOs6+a7NzNHZ
         mXbLIk6Fm91sPOUPvl0lJHNP5Y526adRztznOz6/GTG6NT9ey4wRqbnE0WiBRG5ON2
         URe5IsxKNS6eOsjoOj8+AmByrl8B0T1DWhFOnOfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 041/177] KVM: arm64: Update page shift if stage 2 block mapping not supported
Date:   Tue, 15 Sep 2020 16:11:52 +0200
Message-Id: <20200915140655.606219656@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

[ Upstream commit 7b75cd5128421c673153efb1236705696a1a9812 ]

Commit 196f878a7ac2e (" KVM: arm/arm64: Signal SIGBUS when stage2 discovers
hwpoison memory") modifies user_mem_abort() to send a SIGBUS signal when
the fault IPA maps to a hwpoisoned page. Commit 1559b7583ff6 ("KVM:
arm/arm64: Re-check VMA on detecting a poisoned page") changed
kvm_send_hwpoison_signal() to use the page shift instead of the VMA because
at that point the code had already released the mmap lock, which means
userspace could have modified the VMA.

If userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
map the guest fault IPA using block mappings in stage 2. That is not always
possible, if, for example, userspace uses dirty page logging for the VM.
Update the page shift appropriately in those cases when we downgrade the
stage 2 entry from a block mapping to a page.

Fixes: 1559b7583ff6 ("KVM: arm/arm64: Re-check VMA on detecting a poisoned page")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Link: https://lore.kernel.org/r/20200901133357.52640-2-alexandru.elisei@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bd47f06739d6c..d1320f3f2b137 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1873,6 +1873,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
 		force_pte = true;
 		vma_pagesize = PAGE_SIZE;
+		vma_shift = PAGE_SHIFT;
 	}
 
 	/*
-- 
2.25.1



