Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E966F6213A3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbiKHNwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbiKHNwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D639B65E53
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:52:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B274CE1B94
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8A8C4314D;
        Tue,  8 Nov 2022 13:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915528;
        bh=ih1GE+NmEpGemzdtjmcrmgylxR5xmLeRPzcbfGQX+Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/DhjFuCHAFbMXvODrok9vs63gE4fvSBa3fF3mKFTaOUgCad+wQbPrjVztBIHPDTg
         EFB2Jpv1ljQ9ObySziSRmq2Q5R7PG1Z4biv5f68zZM3P58+BvKZM3Cw58o/2WQNb9X
         akutpm9fLuEeVyZqCPhisIcqQ4t8rF/iM4gD0/5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/118] KVM: nVMX: Dont propagate vmcs12s PERF_GLOBAL_CTRL settings to vmcs02
Date:   Tue,  8 Nov 2022 14:38:02 +0100
Message-Id: <20221108133340.902563651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit def9d705c05eab3fdedeb10ad67907513b12038e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2395387945a8..498fed0dda98 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2345,9 +2345,14 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
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
-- 
2.35.1



