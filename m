Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD885157733
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgBJM6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729964AbgBJMlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:20 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EA38208C4;
        Mon, 10 Feb 2020 12:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338480;
        bh=eYXmOwNCdLxVYJ3OV2cK6whMis/2QSDEOWNYwo5SnMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OY8R51JP9cHaJ4x+2bDVRP8DdBeF6IXZ5tDudkK3hgtrHUlWWcqHB+qZ3R/Fv9mP7
         H1tbJlw3wjFpMjRcYj7RqEzai3PiNdLI0mhjhYl22qeOVu7O48VtEYOBAJVwtJX8Vs
         wP9Ho6hEKqBZHQHVon8GpEwMMMi/B04E50kkBJNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 256/367] KVM: x86: Ensure guests FPU state is loaded when accessing for emulation
Date:   Mon, 10 Feb 2020 04:32:49 -0800
Message-Id: <20200210122448.057319712@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit a7baead7e312f5a05381d68585fb6dc68e19e90f upstream.

Lock the FPU regs and reload the current thread's FPU state, which holds
the guest's FPU state, to the CPU registers if necessary prior to
accessing guest FPU state as part of emulation.  kernel_fpu_begin() can
be called from softirq context, therefore KVM must ensure softirqs are
disabled (locking the FPU regs disables softirqs) when touching CPU FPU
state.

Note, for all intents and purposes this reverts commit 6ab0b9feb82a7
("x86,kvm: remove KVM emulator get_fpu / put_fpu"), but at the time it
was applied, removing get/put_fpu() was correct.  The re-introduction
of {get,put}_fpu() is necessitated by the deferring of FPU state load.

Fixes: 5f409e20b7945 ("x86/fpu: Defer FPU state load until return to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -22,6 +22,7 @@
 #include "kvm_cache_regs.h"
 #include <asm/kvm_emulate.h>
 #include <linux/stringify.h>
+#include <asm/fpu/api.h>
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
 
@@ -1075,8 +1076,23 @@ static void fetch_register_operand(struc
 	}
 }
 
+static void emulator_get_fpu(void)
+{
+	fpregs_lock();
+
+	fpregs_assert_state_consistent();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+}
+
+static void emulator_put_fpu(void)
+{
+	fpregs_unlock();
+}
+
 static void read_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movdqa %%xmm0, %0" : "=m"(*data)); break;
 	case 1: asm("movdqa %%xmm1, %0" : "=m"(*data)); break;
@@ -1098,11 +1114,13 @@ static void read_sse_reg(struct x86_emul
 #endif
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static void write_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
 			  int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movdqa %0, %%xmm0" : : "m"(*data)); break;
 	case 1: asm("movdqa %0, %%xmm1" : : "m"(*data)); break;
@@ -1124,10 +1142,12 @@ static void write_sse_reg(struct x86_emu
 #endif
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static void read_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movq %%mm0, %0" : "=m"(*data)); break;
 	case 1: asm("movq %%mm1, %0" : "=m"(*data)); break;
@@ -1139,10 +1159,12 @@ static void read_mmx_reg(struct x86_emul
 	case 7: asm("movq %%mm7, %0" : "=m"(*data)); break;
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static void write_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movq %0, %%mm0" : : "m"(*data)); break;
 	case 1: asm("movq %0, %%mm1" : : "m"(*data)); break;
@@ -1154,6 +1176,7 @@ static void write_mmx_reg(struct x86_emu
 	case 7: asm("movq %0, %%mm7" : : "m"(*data)); break;
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static int em_fninit(struct x86_emulate_ctxt *ctxt)
@@ -1161,7 +1184,9 @@ static int em_fninit(struct x86_emulate_
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
+	emulator_get_fpu();
 	asm volatile("fninit");
+	emulator_put_fpu();
 	return X86EMUL_CONTINUE;
 }
 
@@ -1172,7 +1197,9 @@ static int em_fnstcw(struct x86_emulate_
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
+	emulator_get_fpu();
 	asm volatile("fnstcw %0": "+m"(fcw));
+	emulator_put_fpu();
 
 	ctxt->dst.val = fcw;
 
@@ -1186,7 +1213,9 @@ static int em_fnstsw(struct x86_emulate_
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
+	emulator_get_fpu();
 	asm volatile("fnstsw %0": "+m"(fsw));
+	emulator_put_fpu();
 
 	ctxt->dst.val = fsw;
 
@@ -4092,8 +4121,12 @@ static int em_fxsave(struct x86_emulate_
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
+	emulator_get_fpu();
+
 	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_state));
 
+	emulator_put_fpu();
+
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
@@ -4136,6 +4169,8 @@ static int em_fxrstor(struct x86_emulate
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
+	emulator_get_fpu();
+
 	if (size < __fxstate_size(16)) {
 		rc = fxregs_fixup(&fx_state, size);
 		if (rc != X86EMUL_CONTINUE)
@@ -4151,6 +4186,8 @@ static int em_fxrstor(struct x86_emulate
 		rc = asm_safe("fxrstor %[fx]", : [fx] "m"(fx_state));
 
 out:
+	emulator_put_fpu();
+
 	return rc;
 }
 
@@ -5465,7 +5502,9 @@ static int flush_pending_x87_faults(stru
 {
 	int rc;
 
+	emulator_get_fpu();
 	rc = asm_safe("fwait");
+	emulator_put_fpu();
 
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return emulate_exception(ctxt, MF_VECTOR, 0, false);


