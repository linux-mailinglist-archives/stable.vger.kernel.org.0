Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5D6452192
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245519AbhKPBF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245531AbhKOTUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE52A63270;
        Mon, 15 Nov 2021 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001382;
        bh=VQ5hzpNcE9ZYQViKaAqTm8gqxzSPj14C4vI+ipa9Ayg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZP6pPzWXQI+isVQASIT7jHlu8yh3BTFNSg7/l1tdge08QmQ3ZGdM8ZtBqAZ0d5F74
         /BHYYqLjzJ94VP7yC4/e6AE9v8z/c1plkyIJ3u+fBKEW3aKjvlCN0gW0d8yDuHVnX2
         +Ds3dKSq062Qp6bTzvaKID20TLbKPT2W1e/TcLZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 125/917] KVM: nVMX: Handle dynamic MSR intercept toggling
Date:   Mon, 15 Nov 2021 17:53:40 +0100
Message-Id: <20211115165432.995988215@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 67f4b9969c305be515e47f809ecacfd86bd20a9c upstream.

Always check vmcs01's MSR bitmap when merging L0 and L1 bitmaps for L2,
and always update the relevant bits in vmcs02.  This fixes two distinct,
but intertwined bugs related to dynamic MSR bitmap modifications.

The first issue is that KVM fails to enable MSR interception in vmcs02
for the FS/GS base MSRs if L1 first runs L2 with interception disabled,
and later enables interception.

The second issue is that KVM fails to honor userspace MSR filtering when
preparing vmcs02.

Fix both issues simultaneous as fixing only one of the issues (doesn't
matter which) would create a mess that no one should have to bisect.
Fixing only the first bug would exacerbate the MSR filtering issue as
userspace would see inconsistent behavior depending on the whims of L1.
Fixing only the second bug (MSR filtering) effectively requires fixing
the first, as the nVMX code only knows how to transition vmcs02's
bitmap from 1->0.

Move the various accessor/mutators that are currently buried in vmx.c
into vmx.h so that they can be shared by the nested code.

Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
Fixes: d69129b4e46a ("KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02 when possible")
Cc: stable@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211109013047.2041518-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |  103 ++++++++++++++++++++--------------------------
 arch/x86/kvm/vmx/vmx.c    |   55 ------------------------
 arch/x86/kvm/vmx/vmx.h    |   63 ++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+), 110 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -524,29 +524,6 @@ static int nested_vmx_check_tpr_shadow_c
 }
 
 /*
- * Check if MSR is intercepted for L01 MSR bitmap.
- */
-static bool msr_write_intercepted_l01(struct kvm_vcpu *vcpu, u32 msr)
-{
-	unsigned long *msr_bitmap;
-	int f = sizeof(unsigned long);
-
-	if (!cpu_has_vmx_msr_bitmap())
-		return true;
-
-	msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
-
-	if (msr <= 0x1fff) {
-		return !!test_bit(msr, msr_bitmap + 0x800 / f);
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		return !!test_bit(msr, msr_bitmap + 0xc00 / f);
-	}
-
-	return true;
-}
-
-/*
  * If a msr is allowed by L0, we should check whether it is allowed by L1.
  * The corresponding bit will be cleared unless both of L0 and L1 allow it.
  */
@@ -599,6 +576,34 @@ static inline void enable_x2apic_msr_int
 	}
 }
 
+#define BUILD_NVMX_MSR_INTERCEPT_HELPER(rw)					\
+static inline									\
+void nested_vmx_set_msr_##rw##_intercept(struct vcpu_vmx *vmx,			\
+					 unsigned long *msr_bitmap_l1,		\
+					 unsigned long *msr_bitmap_l0, u32 msr)	\
+{										\
+	if (vmx_test_msr_bitmap_##rw(vmx->vmcs01.msr_bitmap, msr) ||		\
+	    vmx_test_msr_bitmap_##rw(msr_bitmap_l1, msr))			\
+		vmx_set_msr_bitmap_##rw(msr_bitmap_l0, msr);			\
+	else									\
+		vmx_clear_msr_bitmap_##rw(msr_bitmap_l0, msr);			\
+}
+BUILD_NVMX_MSR_INTERCEPT_HELPER(read)
+BUILD_NVMX_MSR_INTERCEPT_HELPER(write)
+
+static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
+						    unsigned long *msr_bitmap_l1,
+						    unsigned long *msr_bitmap_l0,
+						    u32 msr, int types)
+{
+	if (types & MSR_TYPE_R)
+		nested_vmx_set_msr_read_intercept(vmx, msr_bitmap_l1,
+						  msr_bitmap_l0, msr);
+	if (types & MSR_TYPE_W)
+		nested_vmx_set_msr_write_intercept(vmx, msr_bitmap_l1,
+						   msr_bitmap_l0, msr);
+}
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -606,10 +611,11 @@ static inline void enable_x2apic_msr_int
 static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 						 struct vmcs12 *vmcs12)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int msr;
 	unsigned long *msr_bitmap_l1;
-	unsigned long *msr_bitmap_l0 = to_vmx(vcpu)->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map *map = &to_vmx(vcpu)->nested.msr_bitmap_map;
+	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
+	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -660,44 +666,27 @@ static inline bool nested_vmx_prepare_ms
 		}
 	}
 
-	/* KVM unconditionally exposes the FS/GS base MSRs to L1. */
+	/*
+	 * Always check vmcs01's bitmap to honor userspace MSR filters and any
+	 * other runtime changes to vmcs01's bitmap, e.g. dynamic pass-through.
+	 */
 #ifdef CONFIG_X86_64
-	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
-					     MSR_FS_BASE, MSR_TYPE_RW);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_FS_BASE, MSR_TYPE_RW);
 
-	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
-					     MSR_GS_BASE, MSR_TYPE_RW);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_GS_BASE, MSR_TYPE_RW);
 
-	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
-					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
 #endif
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
 
-	/*
-	 * Checking the L0->L1 bitmap is trying to verify two things:
-	 *
-	 * 1. L0 gave a permission to L1 to actually passthrough the MSR. This
-	 *    ensures that we do not accidentally generate an L02 MSR bitmap
-	 *    from the L12 MSR bitmap that is too permissive.
-	 * 2. That L1 or L2s have actually used the MSR. This avoids
-	 *    unnecessarily merging of the bitmap if the MSR is unused. This
-	 *    works properly because we only update the L01 MSR bitmap lazily.
-	 *    So even if L0 should pass L1 these MSRs, the L01 bitmap is only
-	 *    updated to reflect this when L1 (or its L2s) actually write to
-	 *    the MSR.
-	 */
-	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL))
-		nested_vmx_disable_intercept_for_msr(
-					msr_bitmap_l1, msr_bitmap_l0,
-					MSR_IA32_SPEC_CTRL,
-					MSR_TYPE_R | MSR_TYPE_W);
-
-	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD))
-		nested_vmx_disable_intercept_for_msr(
-					msr_bitmap_l1, msr_bitmap_l0,
-					MSR_IA32_PRED_CMD,
-					MSR_TYPE_W);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
 
-	kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	return true;
 }
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -771,22 +771,11 @@ void vmx_update_exception_bitmap(struct
  */
 static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 {
-	unsigned long *msr_bitmap;
-	int f = sizeof(unsigned long);
-
 	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
-	msr_bitmap = vmx->loaded_vmcs->msr_bitmap;
-
-	if (msr <= 0x1fff) {
-		return !!test_bit(msr, msr_bitmap + 0x800 / f);
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		return !!test_bit(msr, msr_bitmap + 0xc00 / f);
-	}
-
-	return true;
+	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
+					 MSR_IA32_SPEC_CTRL);
 }
 
 static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
@@ -3695,46 +3684,6 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__clear_bit(msr, msr_bitmap + 0x000 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
-}
-
-static void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__clear_bit(msr, msr_bitmap + 0x800 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
-}
-
-static void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__set_bit(msr, msr_bitmap + 0x000 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
-}
-
-static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__set_bit(msr, msr_bitmap + 0x800 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
-}
-
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -400,6 +400,69 @@ static inline void vmx_set_intercept_for
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+static inline bool vmx_test_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		return test_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		return test_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+	return true;
+}
+
+static inline bool vmx_test_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		return test_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		return test_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+	return true;
+}
+
+static inline void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__clear_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+}
+
+static inline void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__clear_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+}
+
+static inline void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__set_bit(msr, msr_bitmap + 0x000 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
+}
+
+static inline void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
+{
+	int f = sizeof(unsigned long);
+
+	if (msr <= 0x1fff)
+		__set_bit(msr, msr_bitmap + 0x800 / f);
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
+		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+}
+
+
 static inline u8 vmx_get_rvi(void)
 {
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;


