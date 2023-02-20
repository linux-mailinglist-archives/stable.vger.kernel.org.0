Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B6269CC97
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjBTNmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBTNmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:42:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A871D901
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEC1BB80D49
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF44C433D2;
        Mon, 20 Feb 2023 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900500;
        bh=+xN2G4FFyrc3YwaxbCfRwqzIgM0o3/OssfSvDnWlT68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naaFe49h4tpJXL+X8w4KlVrmWTNCR9tKU/wLlxKYfZZHVkufyV3gu4hn6ASKaEDvX
         mB20MFtLcedV8oltKQOOCuyWAcTdrry1x/4xctvkJLr0mcesti0qdbjbAhbn+Lok6w
         ufOM+Ek00G/bFenqpTOoAoPprG4A8CWCcc3jsAmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/89] nVMX x86: Check VMX-preemption timer controls on vmentry of L2 guests
Date:   Mon, 20 Feb 2023 14:35:20 +0100
Message-Id: <20230220133553.904515238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

[ Upstream commit 14aa61d0a9eb3ddad06c3a0033f88b5fa7f05613 ]

According to section "Checks on VMX Controls" in Intel SDM vol 3C, the
following check needs to be enforced on vmentry of L2 guests:

    If the "activate VMX-preemption timer" VM-execution control is 0, the
    the "save VMX-preemption timer value" VM-exit control must also be 0.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: a44b331614e6 ("KVM: x86/vmx: Do not skip segment attributes if unusable bit is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9bb696d7300c..f8ad29968e85 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2062,6 +2062,12 @@ static inline bool nested_cpu_has_shadow_vmcs(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_SHADOW_VMCS);
 }
 
+static inline bool nested_cpu_has_save_preemption_timer(struct vmcs12 *vmcs12)
+{
+	return vmcs12->vm_exit_controls &
+	    VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
+}
+
 static inline bool is_nmi(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
@@ -12609,6 +12615,10 @@ static int check_vmentry_prereqs(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	if (nested_vmx_check_msr_switch_controls(vcpu, vmcs12))
 		return VMXERR_ENTRY_INVALID_CONTROL_FIELD;
 
+	if (!nested_cpu_has_preemption_timer(vmcs12) &&
+	    nested_cpu_has_save_preemption_timer(vmcs12))
+		return VMXERR_ENTRY_INVALID_CONTROL_FIELD;
+
 	if (nested_vmx_check_pml_controls(vcpu, vmcs12))
 		return VMXERR_ENTRY_INVALID_CONTROL_FIELD;
 
-- 
2.39.0



