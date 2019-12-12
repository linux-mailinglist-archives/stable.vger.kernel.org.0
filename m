Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D824611D3E4
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 18:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbfLLR2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 12:28:52 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:47958 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730168AbfLLR2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 12:28:51 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifSGa-00069s-F9; Thu, 12 Dec 2019 18:28:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>, Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH 7/8] KVM: arm64: Ensure 'params' is initialised when looking up sys register
Date:   Thu, 12 Dec 2019 17:28:23 +0000
Message-Id: <20191212172824.11523-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212172824.11523-1-maz@kernel.org>
References: <20191212172824.11523-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, alexandru.elisei@arm.com, ard.biesheuvel@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, james.morse@arm.com, justin.he@arm.com, mark.rutland@arm.com, linmiaohe@huawei.com, steven.price@arm.com, will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

Commit 4b927b94d5df ("KVM: arm/arm64: vgic: Introduce find_reg_by_id()")
introduced 'find_reg_by_id()', which looks up a system register only if
the 'id' index parameter identifies a valid system register. As part of
the patch, existing callers of 'find_reg()' were ported over to the new
interface, but this breaks 'index_to_sys_reg_desc()' in the case that the
initial lookup in the vCPU target table fails because we will then call
into 'find_reg()' for the system register table with an uninitialised
'param' as the key to the lookup.

GCC 10 is bright enough to spot this (amongst a tonne of false positives,
but hey!):

  | arch/arm64/kvm/sys_regs.c: In function ‘index_to_sys_reg_desc.part.0.isra’:
  | arch/arm64/kvm/sys_regs.c:983:33: warning: ‘params.Op2’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  |   983 |   (u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2);
  | [...]

Revert the hunk of 4b927b94d5df which breaks 'index_to_sys_reg_desc()' so
that the old behaviour of checking the index upfront is restored.

Fixes: 4b927b94d5df ("KVM: arm/arm64: vgic: Introduce find_reg_by_id()")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191212094049.12437-1-will@kernel.org
---
 arch/arm64/kvm/sys_regs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bd2ac3796d8d..d78b726d4722 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2364,8 +2364,11 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
 		return NULL;
 
+	if (!index_to_params(id, &params))
+		return NULL;
+
 	table = get_target_table(vcpu->arch.target, true, &num);
-	r = find_reg_by_id(id, &params, table, num);
+	r = find_reg(&params, table, num);
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
-- 
2.20.1

