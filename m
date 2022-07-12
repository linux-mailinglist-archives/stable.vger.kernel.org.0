Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E34572547
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbiGLTMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbiGLTMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BD8E680D;
        Tue, 12 Jul 2022 11:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06ABE61274;
        Tue, 12 Jul 2022 18:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF12C3411C;
        Tue, 12 Jul 2022 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651990;
        bh=Blu1wDuwQwj1vl2Ovptffjjz0/kzFxLq7KwHo/jSTCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Isg4KN78xrGIwbjoeH/Nqi7OSN2EgB/+u20yPVlhHebmSl2uyzhnTJpfi9PnMEGvz
         MvguOJlP2exU1MXPQzaOBP17vBOCvgqKCoeNOz5fDF33IckBX7hrbWrBXCGF8V+cBW
         bIqvG5eoMe5tA+YnqhHjmKIzIkSsWpCLNYWGhnVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 06/61] x86/kvm/vmx: Make noinstr clean
Date:   Tue, 12 Jul 2022 20:39:03 +0200
Message-Id: <20220712183237.195528665@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 742ab6df974ae8384a2dd213db1a3a06cf6d8936 upstream.

The recent mmio_stale_data fixes broke the noinstr constraints:

  vmlinux.o: warning: objtool: vmx_vcpu_enter_exit+0x15b: call to wrmsrl.constprop.0() leaves .noinstr.text section
  vmlinux.o: warning: objtool: vmx_vcpu_enter_exit+0x1bf: call to kvm_arch_has_assigned_device() leaves .noinstr.text section

make it all happy again.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c   |    6 +++---
 arch/x86/kvm/x86.c       |    4 ++--
 include/linux/kvm_host.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -383,9 +383,9 @@ static __always_inline void vmx_disable_
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
@@ -396,7 +396,7 @@ static __always_inline void vmx_enable_f
 		return;
 
 	vmx->msr_ia32_mcu_opt_ctrl &= ~FB_CLEAR_DIS;
-	wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
+	native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
 }
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12531,9 +12531,9 @@ void kvm_arch_end_assignment(struct kvm
 }
 EXPORT_SYMBOL_GPL(kvm_arch_end_assignment);
 
-bool kvm_arch_has_assigned_device(struct kvm *kvm)
+bool noinstr kvm_arch_has_assigned_device(struct kvm *kvm)
 {
-	return atomic_read(&kvm->arch.assigned_device_count);
+	return arch_atomic_read(&kvm->arch.assigned_device_count);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1511,7 +1511,7 @@ static inline void kvm_arch_end_assignme
 {
 }
 
-static inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
+static __always_inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
 {
 	return false;
 }


