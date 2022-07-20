Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6157ACCB
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbiGTBZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242175AbiGTBYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:24:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9613173922;
        Tue, 19 Jul 2022 18:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33BE4B81DE9;
        Wed, 20 Jul 2022 01:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EB5C385A2;
        Wed, 20 Jul 2022 01:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279856;
        bh=iGu6qKd7yT7goJF9KlsQhecw9qq/oWTc1G922YTXj4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEjanR2vr7ACfJoJZpBKeCdr7UzODAr0cVPuixg6yhRFc6AejOuCTu6kippF/HhSe
         cI2UEV+P4qWf2wun46GbiCqfo4bsexKUc4MNmnHKCF8lLB/HubqKfcZiQ94ba8Gvme
         ajqq0WeeoTFQE10R5Jx/CLbH6+AZS0R9vH43EgIYX0Brk3C3cxIs73jR4YC0lTKJ/Z
         CmJ+3rfBVQFsvt7RHRIO/43pxkDylSuu93jLgnAbIW1CAmpwR74nCEmJFX8NI3JLfc
         GBtUaCObo83wthJV9qo7DtvaCsBpeH14YTWHsBcoGeigT/1ZlCDtdYlyUwvKrTKz0o
         1teCT0ktPIxxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/16] x86/kvm/vmx: Make noinstr clean
Date:   Tue, 19 Jul 2022 21:17:17 -0400
Message-Id: <20220720011730.1025099-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011730.1025099-1-sashal@kernel.org>
References: <20220720011730.1025099-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 742ab6df974ae8384a2dd213db1a3a06cf6d8936 ]

The recent mmio_stale_data fixes broke the noinstr constraints:

  vmlinux.o: warning: objtool: vmx_vcpu_enter_exit+0x15b: call to wrmsrl.constprop.0() leaves .noinstr.text section
  vmlinux.o: warning: objtool: vmx_vcpu_enter_exit+0x1bf: call to kvm_arch_has_assigned_device() leaves .noinstr.text section

make it all happy again.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c   | 6 +++---
 arch/x86/kvm/x86.c       | 4 ++--
 include/linux/kvm_host.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bd1bf6214ee..485c2046ca8d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -358,9 +358,9 @@ static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
 	if (!vmx->disable_fb_clear)
 		return;
 
-	rdmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
+	msr = __rdmsr(MSR_IA32_MCU_OPT_CTRL);
 	msr |= FB_CLEAR_DIS;
-	wrmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
+	native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
 	/* Cache the MSR value to avoid reading it later */
 	vmx->msr_ia32_mcu_opt_ctrl = msr;
 }
@@ -371,7 +371,7 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
 		return;
 
 	vmx->msr_ia32_mcu_opt_ctrl &= ~FB_CLEAR_DIS;
-	wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
+	native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
 }
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d0b297583df8..c431a34522d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10329,9 +10329,9 @@ void kvm_arch_end_assignment(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_end_assignment);
 
-bool kvm_arch_has_assigned_device(struct kvm *kvm)
+bool noinstr kvm_arch_has_assigned_device(struct kvm *kvm)
 {
-	return atomic_read(&kvm->arch.assigned_device_count);
+	return arch_atomic_read(&kvm->arch.assigned_device_count);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19e8344c51a8..677adb384d06 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -929,7 +929,7 @@ static inline void kvm_arch_end_assignment(struct kvm *kvm)
 {
 }
 
-static inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
+static __always_inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
 {
 	return false;
 }
-- 
2.35.1

