Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC7B27C80A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgI2L6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730384AbgI2LmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D30FC2076A;
        Tue, 29 Sep 2020 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379723;
        bh=SPERwlclIXQwTDhY9S9VzGMn42+SabgQHJDdP2nrnVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArwhG489/aQahOUXdheP3okTZSVO5TPElefY78RdEKiCLHv4CrDw+mCqhNlOF21hj
         BPzzLcuzuE1cnd8jqISPFOVw5luMDIe6cuEB92wZ3lx3XUnJhudnHDrT5sc/M7s6GQ
         ivtApsTsn4csbzZNP7WzfJSw1jnoigWdxfOaOeWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 282/388] KVM: PPC: Book3S HV: Close race with page faults around memslot flushes
Date:   Tue, 29 Sep 2020 13:00:13 +0200
Message-Id: <20200929110024.107520055@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



