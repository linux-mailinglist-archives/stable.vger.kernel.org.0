Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1437D6322C7
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKUMpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiKUMpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:45:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2833DBF829
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8088B80F99
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBEFC433C1;
        Mon, 21 Nov 2022 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034733;
        bh=nnDM22hrkYNyjutHwPjps7bpWJiymM6HRskGngHhuYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgJb8RiBkec8JvZ+5EiPRsnK3q1VT8HWBG6VhqZ71TD/OWmPbUKzBdReH5WjgntxU
         6vU9DiToSz8NLA8krRWyyE1jXzjiHRu87FCy2iCsFgb8xxpxyLvKFP8apftsFa7lND
         tK9nKLEGoGuSQuCzmwOf7t9scdRraHoJ/OksHNvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 25/34] KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
Date:   Mon, 21 Nov 2022 13:43:47 +0100
Message-Id: <20221121124151.797014474@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit fc02735b14fff8c6678b521d324ade27b1a3d4cf upstream.

On eIBRS systems, the returns in the vmexit return path from
__vmx_vcpu_run() to vmx_vcpu_run() are exposed to RSB poisoning attacks.

Fix that by moving the post-vmexit spec_ctrl handling to immediately
after the vmexit.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust for the fact that vmexit is in inline assembly ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    3 +-
 arch/x86/kernel/cpu/bugs.c           |    4 +++
 arch/x86/kvm/vmx.c                   |   46 ++++++++++++++++++++++++++++++-----
 3 files changed, 46 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -271,7 +271,7 @@ extern char __indirect_thunk_end[];
  * retpoline and IBRS mitigations for Spectre v2 need this; only on future
  * CPUs with IBRS_ALL *might* it be avoided.
  */
-static inline void vmexit_fill_RSB(void)
+static __always_inline void vmexit_fill_RSB(void)
 {
 #ifdef CONFIG_RETPOLINE
 	unsigned long loops;
@@ -306,6 +306,7 @@ static inline void indirect_branch_predi
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern u64 x86_spec_ctrl_current;
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -185,6 +185,10 @@ void __init check_bugs(void)
 #endif
 }
 
+/*
+ * NOTE: For VMX, this function is not called in the vmexit path.
+ * It uses vmx_spec_ctrl_restore_host() instead.
+ */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10760,10 +10760,31 @@ static void vmx_update_hv_timer(struct k
 	vmx->loaded_vmcs->hv_timer_armed = false;
 }
 
+u64 __always_inline vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx)
+{
+	u64 guestval, hostval = this_cpu_read(x86_spec_ctrl_current);
+
+	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
+		return 0;
+
+	guestval = __rdmsr(MSR_IA32_SPEC_CTRL);
+
+	/*
+	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 */
+	if (guestval != hostval)
+		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
+
+	barrier_nospec();
+
+	return guestval;
+}
+
 static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4, evmcs_rsp;
+	u64 spec_ctrl;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -10989,6 +11010,24 @@ static void __noclone vmx_vcpu_run(struc
 #endif
 	      );
 
+	/*
+	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
+	 * the first unbalanced RET after vmexit!
+	 *
+	 * For retpoline, RSB filling is needed to prevent poisoned RSB entries
+	 * and (in some cases) RSB underflow.
+	 *
+	 * eIBRS has its own protection against poisoned RSB, so it doesn't
+	 * need the RSB filling sequence.  But it does need to be enabled
+	 * before the first unbalanced RET.
+	 *
+	 * So no RETs before vmx_spec_ctrl_restore_host() below.
+	 */
+	vmexit_fill_RSB();
+
+	/* Save this for below */
+	spec_ctrl = vmx_spec_ctrl_restore_host(vmx);
+
 	vmx_enable_fb_clear(vmx);
 
 	/*
@@ -11007,12 +11046,7 @@ static void __noclone vmx_vcpu_run(struc
 	 * save it.
 	 */
 	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
-		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
-
-	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
-
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
+		vmx->spec_ctrl = spec_ctrl;
 
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))


