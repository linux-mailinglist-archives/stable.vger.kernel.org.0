Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C484063A1
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242015AbhIJAsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234837AbhIJAYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34A516103E;
        Fri, 10 Sep 2021 00:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233407;
        bh=OKN9nBIt8sP7ZjXyu9TrVJz2Ewb9xOqIY1Cc+94KNWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pym2bJioxK0ZbmADZpPb4TLRYkk3PuI7rFLIHfpR6wQCGsGv+Iwn2Hppfmyxcesbo
         3pF5pC+ziSvOvBzMHWTsMJ0oxRzUHPmKgL95a2bno+k6EjX7/05WGuiA8SjHBfCH69
         lQR2eL3sbo6ENg1UuL+k7yd7sLVISwoNbsESZ7QLWEUXTHD7dSApg1HWFBDJ9dbY/S
         a6UTrpRWIAHNFKtqBaPWZ7+9dVfBorsK0soO8xYrCtCtDQxrjrv9Ql75naXmj8wm81
         XILK8JRqFGSWe3/+28dOsViBcAlaDmOK/6tkdHn4wlNEoQZOy7nfISQ3up9h6jzxJ7
         DYkIZckxoIDww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 12/19] KVM: PPC: Book3S HV: Initialise vcpu MSR with MSR_ME
Date:   Thu,  9 Sep 2021 20:23:02 -0400
Message-Id: <20210910002309.176412-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit fd42b7b09c602c904452c0c3e5955ca21d8e387a ]

It is possible to create a VCPU without setting the MSR before running
it, which results in a warning in kvmhv_vcpu_entry_p9() that MSR_ME is
not set. This is pretty harmless because the MSR_ME bit is added to
HSRR1 before HRFID to guest, and a normal qemu guest doesn't hit it.

Initialise the vcpu MSR with MSR_ME set.

Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210811160134.904987-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e4f81f014206..2996d41f5df0 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1959,6 +1959,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
 	spin_lock_init(&vcpu->arch.vpa_update_lock);
 	spin_lock_init(&vcpu->arch.tbacct_lock);
 	vcpu->arch.busy_preempt = TB_NIL;
+	vcpu->arch.shregs.msr = MSR_ME;
 	vcpu->arch.intr_msr = MSR_SF | MSR_ME;
 
 	/*
-- 
2.30.2

