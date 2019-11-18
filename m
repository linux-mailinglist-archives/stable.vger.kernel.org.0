Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6DE10080D
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKRPW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:22:28 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:53725 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfKRPW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:22:28 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 66D5468A;
        Mon, 18 Nov 2019 10:22:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 10:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=V3HsKX
        5HXQWUCfpiEPL2+KduKdsmhWzXrMOXbIRD/l4=; b=mlUAKA54VWhrx0k8X0aRDV
        J7UVoqZ7ypGIBY+dXNLPxwPDHwIfjZCwWYilZpEZEdl3tP3OPSTs3XtqNadP9vLB
        q+Ui+R7v5ox817DLdCXkZKgQGkU0SEIeu5zfa3SlQD/87pSi1xtYUFtVdvG/B6h2
        y3uW2zeqi7ITp4uGp8dVslt7vRV/F9JMD5vPi7l47ebGjKbQ9VrvwE2hTd3mGGUk
        o4Chv7Chf7V/oP8RvOFoEzrP2aSSWL6FeM+aRp4TQTwKM5awIUDFzYpq3rR9wLdz
        LeGClaK6jlrucBGCTN9SQAwFrMkMbuO8DLrOWY0/WzQOYM8vnZJxMQZoqPcy81Xg
        ==
X-ME-Sender: <xms:MrfSXaamkKykkLrtp4KbaaAeqJPxRu1uFVCcz7VwH_w4jmfKGhFrSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegiedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:MrfSXYkMc5SmOE078Jk6Hx8Ujc0TO3b8F3xHi7XtphNSygkVlliwFw>
    <xmx:MrfSXUHHoQJDHM8yFOdLeHUjOlJTggWPn6QS-gdAHA0X2-m1Zk3dwQ>
    <xmx:MrfSXc76aVOeNxwA0YVl2OrjjXU6g6fvZ8dPEfnlraWApKog9BKSAA>
    <xmx:M7fSXXmT6LGfVtvmRN-vgpLtqo9Nw0fPkjvGw5JtOU-ROznsXd5NbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E7C78005B;
        Mon, 18 Nov 2019 10:22:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: X86: Fix initialization of MSR lists" failed to apply to 4.4-stable tree
To:     chenyi.qiang@intel.com, pbonzini@redhat.com, xiaoyao.li@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:22:20 +0100
Message-ID: <1574090540102131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a5ee6edb42e0bb487954806d34877995b6b8d59 Mon Sep 17 00:00:00 2001
From: Chenyi Qiang <chenyi.qiang@intel.com>
Date: Wed, 6 Nov 2019 14:35:20 +0800
Subject: [PATCH] KVM: X86: Fix initialization of MSR lists

The three MSR lists(msrs_to_save[], emulated_msrs[] and
msr_based_features[]) are global arrays of kvm.ko, which are
adjusted (copy supported MSRs forward to override the unsupported MSRs)
when insmod kvm-{intel,amd}.ko, but it doesn't reset these three arrays
to their initial value when rmmod kvm-{intel,amd}.ko. Thus, at the next
installation, kvm-{intel,amd}.ko will do operations on the modified
arrays with some MSRs lost and some MSRs duplicated.

So define three constant arrays to hold the initial MSR lists and
initialize msrs_to_save[], emulated_msrs[] and msr_based_features[]
based on the constant arrays.

Cc: stable@vger.kernel.org
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
[Remove now useless conditionals. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f812719..8c8a5e20ea06 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1132,13 +1132,15 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
  *
- * This list is modified at module load time to reflect the
+ * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
+ * extract the supported MSRs from the related const lists.
+ * msrs_to_save is selected from the msrs_to_save_all to reflect the
  * capabilities of the host cpu. This capabilities test skips MSRs that are
- * kvm-specific. Those are put in emulated_msrs; filtering of emulated_msrs
+ * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
  * may depend on host virtualization features rather than host cpu features.
  */
 
-static u32 msrs_to_save[] = {
+static const u32 msrs_to_save_all[] = {
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_STAR,
 #ifdef CONFIG_X86_64
@@ -1179,9 +1181,10 @@ static u32 msrs_to_save[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 };
 
+static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
 static unsigned num_msrs_to_save;
 
-static u32 emulated_msrs[] = {
+static const u32 emulated_msrs_all[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
@@ -1220,7 +1223,7 @@ static u32 emulated_msrs[] = {
 	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
 	 * We always support the "true" VMX control MSRs, even if the host
 	 * processor does not, so I am putting these registers here rather
-	 * than in msrs_to_save.
+	 * than in msrs_to_save_all.
 	 */
 	MSR_IA32_VMX_BASIC,
 	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
@@ -1239,13 +1242,14 @@ static u32 emulated_msrs[] = {
 	MSR_KVM_POLL_CONTROL,
 };
 
+static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
 static unsigned num_emulated_msrs;
 
 /*
  * List of msr numbers which are used to expose MSR-based features that
  * can be used by a hypervisor to validate requested CPU features.
  */
-static u32 msr_based_features[] = {
+static const u32 msr_based_features_all[] = {
 	MSR_IA32_VMX_BASIC,
 	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
 	MSR_IA32_VMX_PINBASED_CTLS,
@@ -1270,6 +1274,7 @@ static u32 msr_based_features[] = {
 	MSR_IA32_ARCH_CAPABILITIES,
 };
 
+static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
 static unsigned int num_msr_based_features;
 
 static u64 kvm_get_arch_capabilities(void)
@@ -5090,22 +5095,22 @@ static void kvm_init_msr_list(void)
 {
 	struct x86_pmu_capability x86_pmu;
 	u32 dummy[2];
-	unsigned i, j;
+	unsigned i;
 
 	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
-			 "Please update the fixed PMCs in msrs_to_save[]");
+			 "Please update the fixed PMCs in msrs_to_saved_all[]");
 
 	perf_get_x86_pmu_capability(&x86_pmu);
 
-	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
-		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
+	for (i = 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
+		if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
 			continue;
 
 		/*
 		 * Even MSRs that are valid in the host may not be exposed
 		 * to the guests in some cases.
 		 */
-		switch (msrs_to_save[i]) {
+		switch (msrs_to_save_all[i]) {
 		case MSR_IA32_BNDCFGS:
 			if (!kvm_mpx_supported())
 				continue;
@@ -5133,17 +5138,17 @@ static void kvm_init_msr_list(void)
 			break;
 		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
 			if (!kvm_x86_ops->pt_supported() ||
-				msrs_to_save[i] - MSR_IA32_RTIT_ADDR0_A >=
+				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
-			if (msrs_to_save[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
+			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
-			if (msrs_to_save[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
+			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 		}
@@ -5151,34 +5156,25 @@ static void kvm_init_msr_list(void)
 			break;
 		}
 
-		if (j < i)
-			msrs_to_save[j] = msrs_to_save[i];
-		j++;
+		msrs_to_save[num_msrs_to_save++] = msrs_to_save_all[i];
 	}
-	num_msrs_to_save = j;
 
-	for (i = j = 0; i < ARRAY_SIZE(emulated_msrs); i++) {
-		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs[i]))
+	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
+		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
 			continue;
 
-		if (j < i)
-			emulated_msrs[j] = emulated_msrs[i];
-		j++;
+		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
 	}
-	num_emulated_msrs = j;
 
-	for (i = j = 0; i < ARRAY_SIZE(msr_based_features); i++) {
+	for (i = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
 		struct kvm_msr_entry msr;
 
-		msr.index = msr_based_features[i];
+		msr.index = msr_based_features_all[i];
 		if (kvm_get_msr_feature(&msr))
 			continue;
 
-		if (j < i)
-			msr_based_features[j] = msr_based_features[i];
-		j++;
+		msr_based_features[num_msr_based_features++] = msr_based_features_all[i];
 	}
-	num_msr_based_features = j;
 }
 
 static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,

