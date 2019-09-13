Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFD9B1F5D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390277AbfIMNSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390291AbfIMNSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:48 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD594214AE;
        Fri, 13 Sep 2019 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380727;
        bh=Kv2/TiHMHLI5WUFbpnZnFe/F5UtlRvcvzYvsfGGuLw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOvrdosuPW44J1F9BlB6dLw7SytV0JG5e7Hs0tmVQZePa+iaRIGhqB/6yBCimMegk
         ZM9GFhxz7LIqTrBZcJCVoETnKxW8Gs/CoBas7QhgSlqEE3wjfVYAeqIwKTtdljAouM
         bGbv0rD9C6dTo8riHRIr61v7S3dvAOafbgm6JRsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/190] KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation
Date:   Fri, 13 Sep 2019 14:06:52 +0100
Message-Id: <20190913130612.468446329@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3fefd1cd95df04da67c83c1cb93b663f04b3324f ]

When emulating tsr, treclaim and trechkpt, we incorrectly set CR0. The
code currently sets:
    CR0 <- 00 || MSR[TS]
but according to the ISA it should be:
    CR0 <-  0 || MSR[TS] || 0

This fixes the bit shift to put the bits in the correct location.

This is a data integrity issue as CR0 is corrupted.

Fixes: 4bb3c7a0208f ("KVM: PPC: Book3S HV: Work around transactional memory bugs in POWER9")
Cc: stable@vger.kernel.org # v4.17+
Tested-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_tm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index 888e2609e3f15..31cd0f327c8a2 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -131,7 +131,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		}
 		/* Set CR0 to indicate previous transactional state */
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
-			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
+			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		/* L=1 => tresume, L=0 => tsuspend */
 		if (instr & (1 << 21)) {
 			if (MSR_TM_SUSPENDED(msr))
@@ -175,7 +175,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 
 		/* Set CR0 to indicate previous transactional state */
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
-			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
+			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr &= ~MSR_TS_MASK;
 		return RESUME_GUEST;
 
@@ -205,7 +205,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 
 		/* Set CR0 to indicate previous transactional state */
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
-			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
+			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr = msr | MSR_TS_S;
 		return RESUME_GUEST;
 	}
-- 
2.20.1



