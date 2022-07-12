Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D4457245F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbiGLTAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbiGLS7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:59:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B19DF32C8;
        Tue, 12 Jul 2022 11:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C246B81BBC;
        Tue, 12 Jul 2022 18:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C42C36AED;
        Tue, 12 Jul 2022 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651684;
        bh=858XkGJsEaEPn0Cxq0Vp/TdCC0NNhi1/foQN/ehOyak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQAnOsA+UwYmh500MP/soFjms8ujhHhPT1zRRc1ZtvP9zPGZNkDb20GaPa8f+WIS0
         53xCBdpYdXBENmj2EDHR/k/CWGCs9CURuoJm25u2DHvmlHU4WCOc5vZPi3HPVVxXcG
         NbUKZoCYcK+GiJb/i39XBBtwUOTZedFkUKD8UXNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 24/78] x86/kvm/vmx: Make noinstr clean
Date:   Tue, 12 Jul 2022 20:38:54 +0200
Message-Id: <20220712183239.791662425@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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
@@ -380,9 +380,9 @@ static __always_inline void vmx_disable_
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
@@ -393,7 +393,7 @@ static __always_inline void vmx_enable_f
 		return;
 
 	vmx->msr_ia32_mcu_opt_ctrl &= ~FB_CLEAR_DIS;
-	wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
+	native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
 }
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12177,9 +12177,9 @@ void kvm_arch_end_assignment(struct kvm
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
@@ -1233,7 +1233,7 @@ static inline void kvm_arch_end_assignme
 {
 }
 
-static inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
+static __always_inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
 {
 	return false;
 }


