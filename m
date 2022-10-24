Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F337260B851
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiJXTo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiJXTmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:42:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFE180F77;
        Mon, 24 Oct 2022 11:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E903B818E3;
        Mon, 24 Oct 2022 12:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39ACC433C1;
        Mon, 24 Oct 2022 12:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615112;
        bh=V0NzY5TYGk7oTMHRlHDPYr843DQtFpcoSee/FPoXG2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o08cNVQKRI0jQ5v9FSiNAfIzgr15IbbrtuEXBq94WiBX6sQh8EYe+4ljf6a1hLz3J
         c7FL45cZBfjrl9FVX41JTmEUkdP7V4KSPvnAeeEyUPc3sP8ge1PPY7z9J3VsacR/Wt
         sEyVnhVFaHr+lB5uSh9xwvc8cNDOoCvXzd77yRg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 125/530] KVM: nVMX: Dont propagate vmcs12s PERF_GLOBAL_CTRL settings to vmcs02
Date:   Mon, 24 Oct 2022 13:27:49 +0200
Message-Id: <20221024113050.716544161@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit def9d705c05eab3fdedeb10ad67907513b12038e upstream.

Don't propagate vmcs12's VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL to vmcs02.
KVM doesn't disallow L1 from using VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
even when KVM itself doesn't use the control, e.g. due to the various
CPU errata that where the MSR can be corrupted on VM-Exit.

Preserve KVM's (vmcs01) setting to hopefully avoid having to toggle the
bit in vmcs02 at a later point.  E.g. if KVM is loading PERF_GLOBAL_CTRL
when running L1, then odds are good KVM will also load the MSR when
running L2.

Fixes: 8bf00a529967 ("KVM: VMX: add support for switching of PERF_GLOBAL_CTRL")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20220830133737.1539624-18-vkuznets@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2313,9 +2313,14 @@ static void prepare_vmcs02_early(struct
 	 * are emulated by vmx_set_efer() in prepare_vmcs02(), but speculate
 	 * on the related bits (if supported by the CPU) in the hope that
 	 * we can avoid VMWrites during vmx_set_efer().
+	 *
+	 * Similarly, take vmcs01's PERF_GLOBAL_CTRL in the hope that if KVM is
+	 * loading PERF_GLOBAL_CTRL via the VMCS for L1, then KVM will want to
+	 * do the same for L2.
 	 */
 	exec_control = __vm_entry_controls_get(vmcs01);
-	exec_control |= vmcs12->vm_entry_controls;
+	exec_control |= (vmcs12->vm_entry_controls &
+			 ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
 	exec_control &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_LOAD_IA32_EFER);
 	if (cpu_has_load_ia32_efer()) {
 		if (guest_efer & EFER_LMA)


