Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A35F396161
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhEaOkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233846AbhEaOha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 978FB613EA;
        Mon, 31 May 2021 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469105;
        bh=huqv71omi1BECCkJf1VlGI/oJMwMOR6S5cU6bVAEi9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BltzXlyIny+ujalmMBEd0XmMZGfPqDuBoGeRXvEnukaynFLmUt/i4wJPTwGy58/2S
         tbsMnWe223QWMap9XcBcK3pdZe+gtYCieeWxVpTGgYCbploLwuy7T0HYZzk/77vq8C
         Zi9ASbK3+cLjJF/MJBqK5V3jNEFL9gSOW/qnfk/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.12 072/296] KVM: arm64: Fix debug register indexing
Date:   Mon, 31 May 2021 15:12:07 +0200
Message-Id: <20210531130706.263089068@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
@@ -399,14 +399,14 @@ static bool trap_bvr(struct kvm_vcpu *vc
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -414,7 +414,7 @@ static bool trap_bvr(struct kvm_vcpu *vc
 static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -424,7 +424,7 @@ static int set_bvr(struct kvm_vcpu *vcpu
 static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -434,21 +434,21 @@ static int get_bvr(struct kvm_vcpu *vcpu
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
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -456,7 +456,7 @@ static bool trap_bcr(struct kvm_vcpu *vc
 static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -467,7 +467,7 @@ static int set_bcr(struct kvm_vcpu *vcpu
 static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -477,22 +477,22 @@ static int get_bcr(struct kvm_vcpu *vcpu
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
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write,
-		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg]);
+	trace_trap_reg(__func__, rd->CRm, p->is_write,
+		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm]);
 
 	return true;
 }
@@ -500,7 +500,7 @@ static bool trap_wvr(struct kvm_vcpu *vc
 static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -510,7 +510,7 @@ static int set_wvr(struct kvm_vcpu *vcpu
 static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -520,21 +520,21 @@ static int get_wvr(struct kvm_vcpu *vcpu
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
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -542,7 +542,7 @@ static bool trap_wcr(struct kvm_vcpu *vc
 static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -552,7 +552,7 @@ static int set_wcr(struct kvm_vcpu *vcpu
 static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -562,7 +562,7 @@ static int get_wcr(struct kvm_vcpu *vcpu
 static void reset_wcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
 }
 
 static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)


