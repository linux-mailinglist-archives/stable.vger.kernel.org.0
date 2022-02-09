Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F374AFC96
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbiBIS7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241615AbiBIS7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:59:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED76C03BFD7;
        Wed,  9 Feb 2022 10:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74A80B8238B;
        Wed,  9 Feb 2022 18:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F120DC340E9;
        Wed,  9 Feb 2022 18:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433061;
        bh=XsjJlOdpGpZb296y+UI/bJTYqDpon73xor3FNeJnAYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdE6g74YQ9ADFoHrVf2Yk3dlnTpE2v1V87I0QnAuHcjrocebjJZhgoiuFnTAu7JUn
         pO1ih2l7R1xmTnpigEYNS9c8La+/Vp1HBGs9K2kbng7QY1h0n+HZbA7KmV+f/r/LMk
         RGK8mmDrjkvWQEUiJkutvsulGJQ0lgzpJaa9Cv0F9d6WEgbk6/dpyPgcjBEJpzTFJp
         wu/GlQ6W02oOPa4XNiZtNuERTar7CT8zZ8/YeVSuku67eW4oIP8B23Jg1RKZKxo+6M
         gGuM5tn73iLwv6OaxBJxdF7T3eOVx2qs6ZfGw56ES/L44du3PF6yllzSW/Z+KowdQ4
         xPm9Ft3gHadgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.4 2/2] KVM: nVMX: WARN on any attempt to allocate shadow VMCS for vmcs02
Date:   Wed,  9 Feb 2022 13:57:31 -0500
Message-Id: <20220209185733.49157-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209185733.49157-1-sashal@kernel.org>
References: <20220209185733.49157-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d6e656cd266cdcc95abd372c7faef05bee271d1a ]

WARN if KVM attempts to allocate a shadow VMCS for vmcs02.  KVM emulates
VMCS shadowing but doesn't virtualize it, i.e. KVM should never allocate
a "real" shadow VMCS for L2.

The previous code WARNed but continued anyway with the allocation,
presumably in an attempt to avoid NULL pointer dereference.
However, alloc_vmcs (and hence alloc_shadow_vmcs) can fail, and
indeed the sole caller does:

	if (enable_shadow_vmcs && !alloc_shadow_vmcs(vcpu))
		goto out_shadow_vmcs;

which makes it not a useful attempt.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220125220527.2093146-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3041015b05f71..44e11f6db3efe 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4360,18 +4360,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
 	struct loaded_vmcs *loaded_vmcs = vmx->loaded_vmcs;
 
 	/*
-	 * We should allocate a shadow vmcs for vmcs01 only when L1
-	 * executes VMXON and free it when L1 executes VMXOFF.
-	 * As it is invalid to execute VMXON twice, we shouldn't reach
-	 * here when vmcs01 already have an allocated shadow vmcs.
+	 * KVM allocates a shadow VMCS only when L1 executes VMXON and frees it
+	 * when L1 executes VMXOFF or the vCPU is forced out of nested
+	 * operation.  VMXON faults if the CPU is already post-VMXON, so it
+	 * should be impossible to already have an allocated shadow VMCS.  KVM
+	 * doesn't support virtualization of VMCS shadowing, so vmcs01 should
+	 * always be the loaded VMCS.
 	 */
-	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
+	if (WARN_ON(loaded_vmcs != &vmx->vmcs01 || loaded_vmcs->shadow_vmcs))
+		return loaded_vmcs->shadow_vmcs;
+
+	loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
+	if (loaded_vmcs->shadow_vmcs)
+		vmcs_clear(loaded_vmcs->shadow_vmcs);
 
-	if (!loaded_vmcs->shadow_vmcs) {
-		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
-		if (loaded_vmcs->shadow_vmcs)
-			vmcs_clear(loaded_vmcs->shadow_vmcs);
-	}
 	return loaded_vmcs->shadow_vmcs;
 }
 
-- 
2.34.1

