Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BAC40623E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbhIJApC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231462AbhIJAVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52D07610A3;
        Fri, 10 Sep 2021 00:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233191;
        bh=ZCjjhDPW4hbvxCl8WPvpItKvzm7Kyi1xKV2fbxD9wyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXEJGC3pjcNyhOHsnrzBNMmk49G0He3EHoCa1+Ltp0LeiJr8y2yG6N+3JHowVWXZb
         uqpWBgF8qukSTOxenZf4zrG1D7YP9cGnSEpIz1aq0O+1t85UDh6B5ihK7R2Qn3d/CR
         Q9eZNKprg6t0LYvpKzdSxXX2A37uzQLZSHvlnb6EL7DCyb5CCSJUGJQkt8TD2BCC5I
         /LH4gpuOqeH8ZXD3CUuNrenlj2M5MY//vUeZpp3RShb1z21DyF3T+SvtqPu4rx85S/
         QSX/xR7Z/EdfsBd9LRDMEzBM8wjCfld2LIOIvxhPD9k7IoOtsCYiUm4WkCQuKnzOS8
         9MNw2VBUgOcBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.13 64/88] KVM: PPC: Book3S HV P9: Fixes for TM softpatch interrupt NIP
Date:   Thu,  9 Sep 2021 20:17:56 -0400
Message-Id: <20210910001820.174272-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 4782e0cd0d184d727ad3b0cfe20d1d44d9f98239 ]

The softpatch interrupt sets HSRR0 to the faulting instruction +4, so
it should subtract 4 for the faulting instruction address in the case
it is a TM softpatch interrupt (the instruction was not executed) and
it was not emulated.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210811160134.904987-4-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_tm.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index cc90b8b82329..e7c36f8bf205 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -46,6 +46,15 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 	u64 newmsr, bescr;
 	int ra, rs;
 
+	/*
+	 * The TM softpatch interrupt sets NIP to the instruction following
+	 * the faulting instruction, which is not executed. Rewind nip to the
+	 * faulting instruction so it looks like a normal synchronous
+	 * interrupt, then update nip in the places where the instruction is
+	 * emulated.
+	 */
+	vcpu->arch.regs.nip -= 4;
+
 	/*
 	 * rfid, rfebb, and mtmsrd encode bit 31 = 0 since it's a reserved bit
 	 * in these instructions, so masking bit 31 out doesn't change these
@@ -67,7 +76,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 			       (newmsr & MSR_TM)));
 		newmsr = sanitize_msr(newmsr);
 		vcpu->arch.shregs.msr = newmsr;
-		vcpu->arch.cfar = vcpu->arch.regs.nip - 4;
+		vcpu->arch.cfar = vcpu->arch.regs.nip;
 		vcpu->arch.regs.nip = vcpu->arch.shregs.srr0;
 		return RESUME_GUEST;
 
@@ -100,7 +109,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.bescr = bescr;
 		msr = (msr & ~MSR_TS_MASK) | MSR_TS_T;
 		vcpu->arch.shregs.msr = msr;
-		vcpu->arch.cfar = vcpu->arch.regs.nip - 4;
+		vcpu->arch.cfar = vcpu->arch.regs.nip;
 		vcpu->arch.regs.nip = vcpu->arch.ebbrr;
 		return RESUME_GUEST;
 
@@ -116,6 +125,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		newmsr = (newmsr & ~MSR_LE) | (msr & MSR_LE);
 		newmsr = sanitize_msr(newmsr);
 		vcpu->arch.shregs.msr = newmsr;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 
 	/* ignore bit 31, see comment above */
@@ -152,6 +162,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 				msr = (msr & ~MSR_TS_MASK) | MSR_TS_S;
 		}
 		vcpu->arch.shregs.msr = msr;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 
 	/* ignore bit 31, see comment above */
@@ -189,6 +200,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
 			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr &= ~MSR_TS_MASK;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 
 	/* ignore bit 31, see comment above */
@@ -220,6 +232,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
 			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr = msr | MSR_TS_S;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 	}
 
-- 
2.30.2

