Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD6A4063B7
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhIJAsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234887AbhIJAZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58CF7611BD;
        Fri, 10 Sep 2021 00:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233434;
        bh=5JvGoTk0bVJqcXRdWgUGKgDPXnbnAWGiY5RWyzF2/UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOzM7Tp1Jyf8rIz2ocfsHJPNGbS+jeR7UZVSGxO/umzQrXTfBoE/3a5lC1tBt/6+t
         7zv4E8Y5trKBnwAPEa20W0+PAJlFMlFXfKhrymnPJUMfcCPK6/xN1eeM8dlZgl1866
         Ztb3q+JsqIwB4aW7dayrAlmBsQ4XL/Oq05EDAPSKhHu2u0FAYTZ/BKvymj8gRi46wi
         1ac4ybAN6TkfDIi8ctBwdQ7rkM9NOvAY8+Gqc/+3+lNnMyMEPkMCp5QQn+hhtOjfm0
         gqCf7e8ELeIryJTUlcnkvCFy4dvlx57BfRqzjDQepZQcfz7A7TzV60XTyXbhDANR8O
         +oSkdtUUxTGvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 11/17] KVM: PPC: Book3S HV: Initialise vcpu MSR with MSR_ME
Date:   Thu,  9 Sep 2021 20:23:32 -0400
Message-Id: <20210910002338.176677-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002338.176677-1-sashal@kernel.org>
References: <20210910002338.176677-1-sashal@kernel.org>
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
index 5cf1392dff96..cb02a0e434dd 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1748,6 +1748,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
 	spin_lock_init(&vcpu->arch.vpa_update_lock);
 	spin_lock_init(&vcpu->arch.tbacct_lock);
 	vcpu->arch.busy_preempt = TB_NIL;
+	vcpu->arch.shregs.msr = MSR_ME;
 	vcpu->arch.intr_msr = MSR_SF | MSR_ME;
 
 	kvmppc_mmu_book3s_hv_init(vcpu);
-- 
2.30.2

