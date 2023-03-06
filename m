Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2106AC86D
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 17:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCFQoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 11:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCFQns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 11:43:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03FF1ADF9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 08:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6316861022
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 16:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E467C433EF;
        Mon,  6 Mar 2023 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678118891;
        bh=zsc6ikZLK/VTbBbRz0a9P9fTEUL12XBfUt9co1DsLG0=;
        h=Subject:To:Cc:From:Date:From;
        b=HFnM24OVnOg1BQiQELFfHlmy6DNPhuhtnlxYFipxQLi58Rhm6YOS+jNRKMptharVj
         sHmtPTaJFzGOR7EQfe3BfCw3JTrosFhXfAE2S4vHTt9dvJ0zOKllPVXRrRHdipaGpg
         2Vw0PONDdvyMVWF19AKiKOmXewWTw7UKQAgPc8D8=
Subject: FAILED: patch "[PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs" failed to apply to 5.15-stable tree
To:     alexandru.matei@uipath.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 17:08:09 +0100
Message-ID: <16781188891829@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 93827a0a36396f2fd6368a54a020f420c8916e9b
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781188891829@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

93827a0a3639 ("KVM: VMX: Fix crash due to uninitialized current_vmcs")
3cd7cd8a62e6 ("Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 93827a0a36396f2fd6368a54a020f420c8916e9b Mon Sep 17 00:00:00 2001
From: Alexandru Matei <alexandru.matei@uipath.com>
Date: Tue, 24 Jan 2023 00:12:08 +0200
Subject: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs

KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
that the msr bitmap was changed.

vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
-> vmx_msr_bitmap_l01_changed which in the end calls this function. The
function checks for current_vmcs if it is null but the check is
insufficient because current_vmcs is not initialized. Because of this, the
code might incorrectly write to the structure pointed by current_vmcs value
left by another task. Preemption is not disabled, the current task can be
preempted and moved to another CPU while current_vmcs is accessed multiple
times from evmcs_touch_msr_bitmap() which leads to crash.

The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
solution is to use vmx->vmcs01.vmcs instead of current_vmcs.

  BUG: kernel NULL pointer dereference, address: 0000000000000338
  PGD 4e1775067 P4D 0
  Oops: 0002 [#1] PREEMPT SMP NOPTI
  ...
  RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
  ...
  Call Trace:
   vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
   vmx_vcpu_create+0xe6/0x540 [kvm_intel]
   kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
   kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
   kvm_vm_ioctl+0x53f/0x790 [kvm]
   __x64_sys_ioctl+0x8a/0xc0
   do_syscall_64+0x5c/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: ceef7d10dfb6 ("KVM: x86: VMX: hyper-v: Enlightened MSR-Bitmap support")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
Link: https://lore.kernel.org/r/20230123221208.4964-1-alexandru.matei@uipath.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index caf658726169..78d17667e7ec 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -250,16 +250,6 @@ static __always_inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
-{
-	if (unlikely(!current_evmcs))
-		return;
-
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
-}
-
 static inline void evmcs_load(u64 phys_addr)
 {
 	struct hv_vp_assist_page *vp_ap =
@@ -280,7 +270,6 @@ static __always_inline u64 evmcs_read64(unsigned long field) { return 0; }
 static __always_inline u32 evmcs_read32(unsigned long field) { return 0; }
 static __always_inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8a9911ae1240..33614ee2cd67 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3936,8 +3936,13 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
 	 * bitmap has changed.
 	 */
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		if (evmcs->hv_enlightenments_control.msr_bitmap)
+			evmcs->hv_clean_fields &=
+				~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	}
 
 	vmx->nested.force_msr_bitmap_recalc = true;
 }

