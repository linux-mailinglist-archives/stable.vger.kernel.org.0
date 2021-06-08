Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9B13A0259
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhFHTDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237640AbhFHTBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1420A6191A;
        Tue,  8 Jun 2021 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177865;
        bh=Ocksm3Y5y5AKQoKWtY45GXWlqtPVzEnA46wVNVAMD4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSJalbgwnKocNeIZIUBQJNi7kM6ADmF4Ed7g1lYFTWVKrtiDfa1V44Yaw5oGFpe/3
         Se1noxwFQJxtecJ8WAuElIr88+U9FMUVZztd9sE+YysrfuBpt/IxIDZDXXPMWRbRjd
         AkG1rX4/Nm2Z2LIwhLsFpdyXHNNRAcY8Nby2iZj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 129/137] KVM: arm64: Fix debug register indexing
Date:   Tue,  8 Jun 2021 20:27:49 +0200
Message-Id: <20210608175946.752447869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -464,14 +464,14 @@ static bool trap_bvr(struct kvm_vcpu *vc
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
@@ -479,7 +479,7 @@ static bool trap_bvr(struct kvm_vcpu *vc
 static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -489,7 +489,7 @@ static int set_bvr(struct kvm_vcpu *vcpu
 static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -499,21 +499,21 @@ static int get_bvr(struct kvm_vcpu *vcpu
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
@@ -521,7 +521,7 @@ static bool trap_bcr(struct kvm_vcpu *vc
 static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -532,7 +532,7 @@ static int set_bcr(struct kvm_vcpu *vcpu
 static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -542,22 +542,22 @@ static int get_bcr(struct kvm_vcpu *vcpu
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
@@ -565,7 +565,7 @@ static bool trap_wvr(struct kvm_vcpu *vc
 static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -575,7 +575,7 @@ static int set_wvr(struct kvm_vcpu *vcpu
 static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -585,21 +585,21 @@ static int get_wvr(struct kvm_vcpu *vcpu
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
@@ -607,7 +607,7 @@ static bool trap_wcr(struct kvm_vcpu *vc
 static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -617,7 +617,7 @@ static int set_wcr(struct kvm_vcpu *vcpu
 static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -627,7 +627,7 @@ static int get_wcr(struct kvm_vcpu *vcpu
 static void reset_wcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
 }
 
 static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)


