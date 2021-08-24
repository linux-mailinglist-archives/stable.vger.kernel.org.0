Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71E3F64A7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhHXRGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239447AbhHXREN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:04:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 350E761504;
        Tue, 24 Aug 2021 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824362;
        bh=7LT+nx/dIKLhNd/Qmc4r+zgDxsSsAeE6SPr2ZjKoexw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8NM0+rAATDQG/d2YF+jHiz3RIDbtWhPBTlhjTRcupN6PF9AO5ac50HQFtd6O+Jfl
         HbfQuwAZ57BZDIIhY6NmJk/AMjBksrA8RTMcr539YXzYJsz7MunzWV776RO8HW3tuo
         zBHs1wY/cdWZqxsr0J6qZnNxuEKhMCQCo4v5ld+uQfhKVsKJ6nj1zu+kCx5xCghsMG
         5/ZkVoNt1bQeoLaXu86fRAES1dlh6zGV5pTN4XaYopHu6Ye4cXyirHHCUwc71DEZS8
         VCAd9vKjA2ifrCgADQp42JaqDzLolNM7CMBpxxTKN5nLrDC2o4w+fjZmX/LwcTDv8M
         XkDoZxfQo7OXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Huang <wei.huang2@amd.com>, Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/98] KVM: x86: Factor out x86 instruction emulation with decoding
Date:   Tue, 24 Aug 2021 12:57:42 -0400
Message-Id: <20210824165908.709932-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Huang <wei.huang2@amd.com>

[ Upstream commit 4aa2691dcbd38ce1c461188799d863398dd2865d ]

Move the instruction decode part out of x86_emulate_instruction() for it
to be used in other places. Also kvm_clear_exception_queue() is moved
inside the if-statement as it doesn't apply when KVM are coming back from
userspace.

Co-developed-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Message-Id: <20210126081831.570253-2-wei.huang2@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++-----------------
 arch/x86/kvm/x86.h |  2 ++
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ab42cdcb8a4..d5e25bf51f47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7338,6 +7338,42 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+/*
+ * Decode to be emulated instruction. Return EMULATION_OK if success.
+ */
+int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+				    void *insn, int insn_len)
+{
+	int r = EMULATION_OK;
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	init_emulate_ctxt(vcpu);
+
+	/*
+	 * We will reenter on the same instruction since we do not set
+	 * complete_userspace_io. This does not handle watchpoints yet,
+	 * those would be handled in the emulate_ops.
+	 */
+	if (!(emulation_type & EMULTYPE_SKIP) &&
+	    kvm_vcpu_check_breakpoint(vcpu, &r))
+		return r;
+
+	ctxt->interruptibility = 0;
+	ctxt->have_exception = false;
+	ctxt->exception.vector = -1;
+	ctxt->perm_ok = false;
+
+	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
+
+	r = x86_decode_insn(ctxt, insn, insn_len);
+
+	trace_kvm_emulate_insn_start(vcpu);
+	++vcpu->stat.insn_emulation;
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(x86_decode_emulated_instruction);
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len)
 {
@@ -7357,32 +7393,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 */
 	write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
-	kvm_clear_exception_queue(vcpu);
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
-		init_emulate_ctxt(vcpu);
-
-		/*
-		 * We will reenter on the same instruction since
-		 * we do not set complete_userspace_io.  This does not
-		 * handle watchpoints yet, those would be handled in
-		 * the emulate_ops.
-		 */
-		if (!(emulation_type & EMULTYPE_SKIP) &&
-		    kvm_vcpu_check_breakpoint(vcpu, &r))
-			return r;
-
-		ctxt->interruptibility = 0;
-		ctxt->have_exception = false;
-		ctxt->exception.vector = -1;
-		ctxt->perm_ok = false;
-
-		ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-
-		r = x86_decode_insn(ctxt, insn, insn_len);
+		kvm_clear_exception_queue(vcpu);
 
-		trace_kvm_emulate_insn_start(vcpu);
-		++vcpu->stat.insn_emulation;
+		r = x86_decode_emulated_instruction(vcpu, emulation_type,
+						    insn, insn_len);
 		if (r != EMULATION_OK)  {
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
 			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2249a7d7ca27..2bff44f1efec 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -272,6 +272,8 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
+int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+				    void *insn, int insn_len);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
-- 
2.30.2

