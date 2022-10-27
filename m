Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEAF6103D3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbiJ0VD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiJ0VDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:03:09 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E6E8113F;
        Thu, 27 Oct 2022 13:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904147; x=1698440147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Cs85r/tiZzvWU/gz/JrupVz29DrVtkPA7hqAoJeeRb4=;
  b=MwEjb6XxqNlgjpqvYws0NzdKUUG7PEZy4TN/uNZWJvrx8TcaaIBD3Qr5
   wWFkIb8FIvlNTDR99NpQWByIxoHBfBDhcbw2ewB7xdt6jgJrxXOeY4xGX
   aOYMpfIs4WobtzxiYcshOWaiQBf39JDv6ZMqZ4vwFRdmH1x/TdroFFM0O
   w=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="260700395"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:55:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com (Postfix) with ESMTPS id DF0ADA282F;
        Thu, 27 Oct 2022 20:55:43 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:55:42 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.14) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:55:42 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 25/34] KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
Date:   Thu, 27 Oct 2022 13:55:30 -0700
Message-ID: <20221027205533.17873-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027204801.13146-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D34UWA002.ant.amazon.com (10.43.160.245) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ bp: Adjust for the fact that vmexit is in inline assembly ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/x86/include/asm/nospec-branch.h |  3 +-
 arch/x86/kernel/cpu/bugs.c           |  4 +++
 arch/x86/kvm/vmx.c                   | 45 ++++++++++++++++++++++++----
 3 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index c7cbad1ec034..2d6d5bac4997 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -257,7 +257,7 @@ extern char __indirect_thunk_end[];
  * retpoline and IBRS mitigations for Spectre v2 need this; only on future
  * CPUs with IBRS_ALL *might* it be avoided.
  */
-static inline void vmexit_fill_RSB(void)
+static __always_inline void vmexit_fill_RSB(void)
 {
 #ifdef CONFIG_RETPOLINE
 	unsigned long loops;
@@ -292,6 +292,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern u64 x86_spec_ctrl_current;
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 5f805013b7f4..1fde42e5be6e 100644
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
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 48b40e160e27..539720a8e094 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -9770,10 +9770,31 @@ static void vmx_arm_hv_timer(struct kvm_vcpu *vcpu)
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, delta_tsc);
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
 	unsigned long debugctlmsr, cr3, cr4;
+	u64 spec_ctrl;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() &&
@@ -9967,6 +9988,23 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		, "eax", "ebx", "edi", "esi"
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
 
 	vmx_enable_fb_clear(vmx);
 
@@ -9986,12 +10024,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
 	if (debugctlmsr)
-- 
2.17.1

