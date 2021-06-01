Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010E439773C
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhFAPyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 11:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhFAPyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 11:54:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC14C6108D;
        Tue,  1 Jun 2021 15:52:50 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lo6hE-004qrK-Nb; Tue, 01 Jun 2021 16:52:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Ricardo Koller <ricarkol@google.com>
Subject: [PATCH][4.19-stable] KVM: arm64: Fix debug register indexing
Date:   Tue,  1 Jun 2021 16:52:40 +0100
Message-Id: <20210601155240.115730-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: stable@vger.kernel.org, gregkh@linuxfoundation.org, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit cb853ded1d25e5b026ce115dbcde69e3d7e2e831 upstream.

Commit 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on
reset") flipped the register number to 0 for all the debug registers
in the sysreg table, hereby indicating that these registers live
in a separate shadow structure.

However, the author of this patch failed to realise that all the
accessors are using that particular index instead of the register
encoding, resulting in all the registers hitting index 0. Not quite
a valid implementation of the architecture...

Address the issue by fixing all the accessors to use the CRm field
of the encoding, which contains the debug register index.

Fixes: 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on reset")
Reported-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/sys_regs.c | 42 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fe97b2ad82b9..98e8bc919583 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -426,14 +426,14 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -441,7 +441,7 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -451,7 +451,7 @@ static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -461,21 +461,21 @@ static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_bvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = rd->val;
 }
 
 static bool trap_bcr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -483,7 +483,7 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -494,7 +494,7 @@ static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -504,22 +504,22 @@ static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_bcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = rd->val;
 }
 
 static bool trap_wvr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write,
-		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg]);
+	trace_trap_reg(__func__, rd->CRm, p->is_write,
+		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm]);
 
 	return true;
 }
@@ -527,7 +527,7 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
 static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -537,7 +537,7 @@ static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -547,21 +547,21 @@ static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_wvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = rd->val;
 }
 
 static bool trap_wcr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -569,7 +569,7 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -579,7 +579,7 @@ static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -589,7 +589,7 @@ static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_wcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
 }
 
 static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-- 
2.30.2

