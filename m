Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526DA1D0EBB
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733297AbgEMJts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732755AbgEMJtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC0F20753;
        Wed, 13 May 2020 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363387;
        bh=8u0uR8nHmxO7TvSZjRQlwHVFGFWaYwihMzFHuBPVzZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKr8/zQdK2RGykJhw/zhgTlDCFtJIrm/i/Ly2LXsVJgG6wIGPWmOZgJK8oqwn8lp4
         EGmzkaadR7brUpLPK/MpDVzxUGdH66UoUYDgmZc5O91qVzswNmGcfib/f2BZ0xQ4xP
         upeylKxcczbdbuEWf82OcN3nvkWoXQPo65knstAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 54/90] KVM: arm64: Fix 32bit PC wrap-around
Date:   Wed, 13 May 2020 11:44:50 +0200
Message-Id: <20200513094414.492761851@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 0225fd5e0a6a32af7af0aefac45c8ebf19dc5183 upstream.

In the unlikely event that a 32bit vcpu traps into the hypervisor
on an instruction that is located right at the end of the 32bit
range, the emulation of that instruction is going to increment
PC past the 32bit range. This isn't great, as userspace can then
observe this value and get a bit confused.

Conversly, userspace can do things like (in the context of a 64bit
guest that is capable of 32bit EL0) setting PSTATE to AArch64-EL0,
set PC to a 64bit value, change PSTATE to AArch32-USR, and observe
that PC hasn't been truncated. More confusion.

Fix both by:
- truncating PC increments for 32bit guests
- sanitizing all 32bit regs every time a core reg is changed by
  userspace, and that PSTATE indicates a 32bit mode.

Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/guest.c     |    7 +++++++
 virt/kvm/arm/hyp/aarch32.c |    8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -202,6 +202,13 @@ static int set_core_reg(struct kvm_vcpu
 	}
 
 	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
+
+	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
+		int i;
+
+		for (i = 0; i < 16; i++)
+			*vcpu_reg32(vcpu, i) = (u32)*vcpu_reg32(vcpu, i);
+	}
 out:
 	return err;
 }
--- a/virt/kvm/arm/hyp/aarch32.c
+++ b/virt/kvm/arm/hyp/aarch32.c
@@ -125,12 +125,16 @@ static void __hyp_text kvm_adjust_itstat
  */
 void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
 {
+	u32 pc = *vcpu_pc(vcpu);
 	bool is_thumb;
 
 	is_thumb = !!(*vcpu_cpsr(vcpu) & PSR_AA32_T_BIT);
 	if (is_thumb && !is_wide_instr)
-		*vcpu_pc(vcpu) += 2;
+		pc += 2;
 	else
-		*vcpu_pc(vcpu) += 4;
+		pc += 4;
+
+	*vcpu_pc(vcpu) = pc;
+
 	kvm_adjust_itstate(vcpu);
 }


