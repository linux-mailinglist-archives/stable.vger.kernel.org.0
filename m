Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D31EF877
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 10:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbfKEJUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 04:20:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:41924 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbfKEJUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 04:20:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 01:20:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,270,1569308400"; 
   d="scan'208";a="353093772"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2019 01:20:25 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] KVM: X86: Dynamically allocating MSR number lists(msrs_to_save[], emulated_msrs[], msr_based_features[])
Date:   Tue,  5 Nov 2019 17:20:31 +0800
Message-Id: <20191105092031.8064-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The three msr number lists(msrs_to_save[], emulated_msrs[] and
msr_based_features[]) are global arrays of kvm.ko, which are
initialized/adjusted (copy supported MSRs forward to override the
unsupported MSRs) when installing kvm-{intel,amd}.ko, but it doesn't
reset these three arrays to their initial value when uninstalling
kvm-{intel,amd}.ko. Thus, at the next installation, kvm-{intel,amd}.ko
will initialize the modified arrays with some MSRs lost and some MSRs
duplicated.

So allocate and initialize these three MSR number lists dynamically when
installing kvm-{intel,amd}.ko and free them when uninstalling.

Cc: stable@vger.kernel.org
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/x86.c | 86 ++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f812719..08efcf6351cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1132,13 +1132,15 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
  *
- * This list is modified at module load time to reflect the
+ * The three msr number lists(msrs_to_save, emulated_msrs, msr_based_features)
+ * are allocated and initialized at module load time and freed at unload time.
+ * msrs_to_save is selected from the msrs_to_save_all to reflect the
  * capabilities of the host cpu. This capabilities test skips MSRs that are
- * kvm-specific. Those are put in emulated_msrs; filtering of emulated_msrs
+ * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
  * may depend on host virtualization features rather than host cpu features.
  */
 
-static u32 msrs_to_save[] = {
+const u32 msrs_to_save_all[] = {
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_STAR,
 #ifdef CONFIG_X86_64
@@ -1179,9 +1181,10 @@ static u32 msrs_to_save[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 };
 
+static u32 *msrs_to_save;
 static unsigned num_msrs_to_save;
 
-static u32 emulated_msrs[] = {
+const u32 emulated_msrs_all[] = {
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
 
+static u32 *emulated_msrs;
 static unsigned num_emulated_msrs;
 
 /*
  * List of msr numbers which are used to expose MSR-based features that
  * can be used by a hypervisor to validate requested CPU features.
  */
-static u32 msr_based_features[] = {
+const u32 msr_based_features_all[] = {
 	MSR_IA32_VMX_BASIC,
 	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
 	MSR_IA32_VMX_PINBASED_CTLS,
@@ -1270,6 +1274,7 @@ static u32 msr_based_features[] = {
 	MSR_IA32_ARCH_CAPABILITIES,
 };
 
+static u32 *msr_based_features;
 static unsigned int num_msr_based_features;
 
 static u64 kvm_get_arch_capabilities(void)
@@ -3311,11 +3316,11 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		if (n < msr_list.nmsrs)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
+		if (copy_to_user(user_msr_list->indices, msrs_to_save,
 				 num_msrs_to_save * sizeof(u32)))
 			goto out;
 		if (copy_to_user(user_msr_list->indices + num_msrs_to_save,
-				 &emulated_msrs,
+				 emulated_msrs,
 				 num_emulated_msrs * sizeof(u32)))
 			goto out;
 		r = 0;
@@ -3364,7 +3369,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		if (n < msr_list.nmsrs)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user(user_msr_list->indices, &msr_based_features,
+		if (copy_to_user(user_msr_list->indices, msr_based_features,
 				 num_msr_based_features * sizeof(u32)))
 			goto out;
 		r = 0;
@@ -5086,26 +5091,41 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	return r;
 }
 
-static void kvm_init_msr_list(void)
+static int kvm_init_msr_list(void)
 {
 	struct x86_pmu_capability x86_pmu;
 	u32 dummy[2];
 	unsigned i, j;
 
 	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
-			 "Please update the fixed PMCs in msrs_to_save[]");
+			 "Please update the fixed PMCs in msrs_to_saved_all[]");
 
 	perf_get_x86_pmu_capability(&x86_pmu);
 
-	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
-		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
+	msrs_to_save = kmalloc(sizeof(msrs_to_save_all),
+							GFP_KERNEL_ACCOUNT);
+	if (!msrs_to_save)
+		return -ENOMEM;
+
+	emulated_msrs = kmalloc(sizeof(emulated_msrs_all),
+							GFP_KERNEL_ACCOUNT);
+	if (!emulated_msrs)
+		goto free_msrs_to_save;
+
+	msr_based_features = kmalloc(sizeof(msr_based_features_all),
+							GFP_KERNEL_ACCOUNT);
+	if (!msr_based_features)
+		goto free_emulated_msrs;
+
+	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
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
@@ -5133,17 +5153,17 @@ static void kvm_init_msr_list(void)
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
@@ -5151,34 +5171,40 @@ static void kvm_init_msr_list(void)
 			break;
 		}
 
-		if (j < i)
-			msrs_to_save[j] = msrs_to_save[i];
+		if (j <= i)
+			msrs_to_save[j] = msrs_to_save_all[i];
 		j++;
 	}
 	num_msrs_to_save = j;
 
-	for (i = j = 0; i < ARRAY_SIZE(emulated_msrs); i++) {
-		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs[i]))
+	for (i = j = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
+		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
 			continue;
 
-		if (j < i)
-			emulated_msrs[j] = emulated_msrs[i];
+		if (j <= i)
+			emulated_msrs[j] = emulated_msrs_all[i];
 		j++;
 	}
 	num_emulated_msrs = j;
 
-	for (i = j = 0; i < ARRAY_SIZE(msr_based_features); i++) {
+	for (i = j = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
 		struct kvm_msr_entry msr;
 
-		msr.index = msr_based_features[i];
+		msr.index = msr_based_features_all[i];
 		if (kvm_get_msr_feature(&msr))
 			continue;
 
-		if (j < i)
-			msr_based_features[j] = msr_based_features[i];
+		if (j <= i)
+			msr_based_features[j] = msr_based_features_all[i];
 		j++;
 	}
 	num_msr_based_features = j;
+	return 0;
+free_emulated_msrs:
+	kfree(emulated_msrs);
+free_msrs_to_save:
+	kfree(msrs_to_save);
+	return -ENOMEM;
 }
 
 static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
@@ -9294,12 +9320,14 @@ int kvm_arch_hardware_setup(void)
 		kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
 	}
 
-	kvm_init_msr_list();
-	return 0;
+	return kvm_init_msr_list();
 }
 
 void kvm_arch_hardware_unsetup(void)
 {
+	kfree(msr_based_features);
+	kfree(emulated_msrs);
+	kfree(msrs_to_save);
 	kvm_x86_ops->hardware_unsetup();
 }
 
-- 
2.17.1

