Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F96BB219
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjCOMc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbjCOMcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:32:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5FD8E3C3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EDD1B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F2BC433D2;
        Wed, 15 Mar 2023 12:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883509;
        bh=oAj3a8zBdQPL1iksqqE1IHK07xHEVszduSq/Z6/7/Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BdzndavkEY0Dl+UNUDXnCl/Ap30TpFgydNYBjReV3IjtBUt1sTs6PG4Q+CIQJfjD
         BJiXPT9//UGjH1wFCF7XuX/7QXrJGRwMJF9hdZY9Am6SgGQ85VTLVd14OyrUSlaswm
         CJ5woF7SM5GG7Ngh9rYcMD+XJUlkfuqHLbqcJ7xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/143] KVM: VMX: Reset eVMCS controls in VP assist page during hardware disabling
Date:   Wed, 15 Mar 2023 13:11:52 +0100
Message-Id: <20230315115741.296683455@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2916b70fc342719f570640de07251b7f91feebdb ]

Reset the eVMCS controls in the per-CPU VP assist page during hardware
disabling instead of waiting until kvm-intel's module exit.  The controls
are activated if and only if KVM creates a VM, i.e. don't need to be
reset if hardware is never enabled.

Doing the reset during hardware disabling will naturally fix a potential
NULL pointer deref bug once KVM disables CPU hotplug while enabling and
disabling hardware (which is necessary to fix a variety of bugs).  If the
kernel is running as the root partition, the VP assist page is unmapped
during CPU hot unplug, and so KVM's clearing of the eVMCS controls needs
to occur with CPU hot(un)plug disabled, otherwise KVM could attempt to
write to a CPU's VP assist page after it's unmapped.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20221130230934.1014142-11-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 50 +++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f5c1cb7cec8a7..87874b22ba4bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -551,6 +551,33 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void hv_reset_evmcs(void)
+{
+	struct hv_vp_assist_page *vp_ap;
+
+	if (!static_branch_unlikely(&enable_evmcs))
+		return;
+
+	/*
+	 * KVM should enable eVMCS if and only if all CPUs have a VP assist
+	 * page, and should reject CPU onlining if eVMCS is enabled the CPU
+	 * doesn't have a VP assist page allocated.
+	 */
+	vp_ap = hv_get_vp_assist_page(smp_processor_id());
+	if (WARN_ON_ONCE(!vp_ap))
+		return;
+
+	/*
+	 * Reset everything to support using non-enlightened VMCS access later
+	 * (e.g. when we reload the module with enlightened_vmcs=0)
+	 */
+	vp_ap->nested_control.features.directhypercall = 0;
+	vp_ap->current_nested_vmcs = 0;
+	vp_ap->enlighten_vmentry = 0;
+}
+
+#else /* IS_ENABLED(CONFIG_HYPERV) */
+static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 /*
@@ -2501,6 +2528,8 @@ static void vmx_hardware_disable(void)
 	if (cpu_vmxoff())
 		kvm_spurious_fault();
 
+	hv_reset_evmcs();
+
 	intel_pt_handle_vmx(0);
 }
 
@@ -8437,27 +8466,8 @@ static void vmx_exit(void)
 	kvm_exit();
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs)) {
-		int cpu;
-		struct hv_vp_assist_page *vp_ap;
-		/*
-		 * Reset everything to support using non-enlightened VMCS
-		 * access later (e.g. when we reload the module with
-		 * enlightened_vmcs=0)
-		 */
-		for_each_online_cpu(cpu) {
-			vp_ap =	hv_get_vp_assist_page(cpu);
-
-			if (!vp_ap)
-				continue;
-
-			vp_ap->nested_control.features.directhypercall = 0;
-			vp_ap->current_nested_vmcs = 0;
-			vp_ap->enlighten_vmentry = 0;
-		}
-
+	if (static_branch_unlikely(&enable_evmcs))
 		static_branch_disable(&enable_evmcs);
-	}
 #endif
 	vmx_cleanup_l1d_flush();
 
-- 
2.39.2



