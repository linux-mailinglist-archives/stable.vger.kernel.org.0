Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD891591232
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 16:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiHLObB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 10:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiHLObA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 10:31:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893611B7A2
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 07:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED5F7CE2568
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BEBC433C1;
        Fri, 12 Aug 2022 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660314655;
        bh=IAyO8vktE/amkXH35qPNQ4QIOdqfM+D/X98C+XCcBHY=;
        h=Subject:To:Cc:From:Date:From;
        b=1mn2t2QPOZcU/SPJN4zikggDKQkWAJNZC0S9npTDo/gkH0WjY2kWLhZDpha1HMxWQ
         JIzTV2CRdfqEIH+5+RMoGgK3OPx0SGBt4te8PyManEbNFruw8cqwfvxPu73lpBk9H8
         E9u0Bcxvb2hxhJdZlt9tacvnAAy+0XR1kWvPlLXs=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as a valid SPTE bit for NPT" failed to apply to 5.15-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Aug 2022 16:30:44 +0200
Message-ID: <1660314644138207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c6ab524cfae0799e55c82b2c1d61f1af0156f8d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Sat, 23 Jul 2022 01:30:29 +0000
Subject: [PATCH] KVM: x86/mmu: Treat NX as a valid SPTE bit for NPT

Treat the NX bit as valid when using NPT, as KVM will set the NX bit when
the NX huge page mitigation is enabled (mindblowing) and trigger the WARN
that fires on reserved SPTE bits being set.

KVM has required NX support for SVM since commit b26a71a1a5b9 ("KVM: SVM:
Refuse to load kvm_amd if NX support is not available") for exactly this
reason, but apparently it never occurred to anyone to actually test NPT
with the mitigation enabled.

  ------------[ cut here ]------------
  spte = 0x800000018a600ee7, level = 2, rsvd bits = 0x800f0000001fe000
  WARNING: CPU: 152 PID: 15966 at arch/x86/kvm/mmu/spte.c:215 make_spte+0x327/0x340 [kvm]
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 10.48.0 01/27/2022
  RIP: 0010:make_spte+0x327/0x340 [kvm]
  Call Trace:
   <TASK>
   tdp_mmu_map_handle_target_level+0xc3/0x230 [kvm]
   kvm_tdp_mmu_map+0x343/0x3b0 [kvm]
   direct_page_fault+0x1ae/0x2a0 [kvm]
   kvm_tdp_page_fault+0x7d/0x90 [kvm]
   kvm_mmu_page_fault+0xfb/0x2e0 [kvm]
   npf_interception+0x55/0x90 [kvm_amd]
   svm_invoke_exit_handler+0x31/0xf0 [kvm_amd]
   svm_handle_exit+0xf6/0x1d0 [kvm_amd]
   vcpu_enter_guest+0xb6d/0xee0 [kvm]
   ? kvm_pmu_trigger_event+0x6d/0x230 [kvm]
   vcpu_run+0x65/0x2c0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x355/0x610 [kvm]
   kvm_vcpu_ioctl+0x551/0x610 [kvm]
   __se_sys_ioctl+0x77/0xc0
   __x64_sys_ioctl+0x1d/0x20
   do_syscall_64+0x44/0xa0
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
   </TASK>
  ---[ end trace 0000000000000000 ]---

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220723013029.1753623-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e477333a263..3e1317325e1f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4735,7 +4735,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->root_role.level, false,
+					context->root_role.level, true,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else

