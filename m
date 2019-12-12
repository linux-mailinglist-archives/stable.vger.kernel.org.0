Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0771D11C99F
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfLLJk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728352AbfLLJk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:40:56 -0500
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B37B24654;
        Thu, 12 Dec 2019 09:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143655;
        bh=Rr7kCvNdPW3e2IBJnliH3eTMWWlqAlnaKNJfjBbxn3s=;
        h=From:To:Cc:Subject:Date:From;
        b=o/9lLUezdKlavsdvjIBXsTOvuw3E3zZTN9Ja5z0/TirEBSPaaZMc7xjY3+/teFHW3
         b0rQZzbv9qi+ZQsTvG7h3kcnTKxxC32C6lWbH5GKWBCQjcCsO/GB0vRo4HIWv22ja6
         CDlloQV5Yk05Dhr03Isp4flcMUL6DpXqTroiKHPM=
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Vijaya Kumar K <Vijaya.Kumar@cavium.com>
Subject: [PATCH] KVM: arm64: Ensure 'params' is initialised when looking up sys register
Date:   Thu, 12 Dec 2019 09:40:49 +0000
Message-Id: <20191212094049.12437-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
Fixes: 4b927b94d5df ("KVM: arm/arm64: vgic: Introduce find_reg_by_id()")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 46822afc57e0..01a515e0171e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2360,8 +2360,11 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
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
2.24.1.735.g03f4e72817-goog

