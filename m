Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF03157AB67
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbiGTBKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbiGTBKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:10:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9209B481FC;
        Tue, 19 Jul 2022 18:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E8A26172D;
        Wed, 20 Jul 2022 01:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BB5C341C6;
        Wed, 20 Jul 2022 01:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279437;
        bh=iyRLA+DAXkZaeBukF5eaYWdqM/9ijPvnUbZY7Ny8mCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuaJ8rbajPkNRNY/bF7RSgTUv6C1uQ694uxLtSE6flA5HgMA4fuugVczdivyffcVI
         CMq2sqDbXF6D7UvpZxRVp6SGP/MVLEYMXfC+nK+VU1sbjvRYr+8uE0Gkq4WPeYcRhM
         s/Stb0FhssDPpZ0xnYMJ7sX/Rk44U/SXPYZoBxo5nhSRm6X2dCn5zJRCl8W8yZaRCm
         P2kj9yCE1PgqW+k/Q38YM63iz1mvGVfdMmA37597QoK6m4jZ6E3ifpyZYtDK9upvTB
         lYlPEi8WAU6x+dNir7tsEgSchc5AZENU9FOtNuEtaiRHZJBhlMpHyEoKQtzSUzjrfa
         AwCHLK8FAKiKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 03/54] x86/kvm/vmx: Make noinstr clean
Date:   Tue, 19 Jul 2022 21:09:40 -0400
Message-Id: <20220720011031.1023305-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
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
index 9646ae886b4b..da103938e62e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -383,9 +383,9 @@ static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
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
@@ -396,7 +396,7 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
 		return;
 
 	vmx->msr_ia32_mcu_opt_ctrl &= ~FB_CLEAR_DIS;
-	wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
+	native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
 }
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 558d1f2ab5b4..9caa902f0de1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12531,9 +12531,9 @@ void kvm_arch_end_assignment(struct kvm *kvm)
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
index 34eed5f85ed6..88d94cf515e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1511,7 +1511,7 @@ static inline void kvm_arch_end_assignment(struct kvm *kvm)
 {
 }
 
-static inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
+static __always_inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
 {
 	return false;
 }
-- 
2.35.1

