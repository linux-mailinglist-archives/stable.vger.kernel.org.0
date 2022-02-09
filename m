Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86594AFC49
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241355AbiBIS5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbiBIS4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:56:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60914C0401D1;
        Wed,  9 Feb 2022 10:56:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C97612CC;
        Wed,  9 Feb 2022 18:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505EFC340E7;
        Wed,  9 Feb 2022 18:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433003;
        bh=VJ/N0JazzuRmFU1tDsAyHVrOmtuD8Q3QOGqJ9jK6NJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aX9OPgo4Wtr2kJWHHpBEMImaHBvJCnjlINll1tc6wAFiXxzQYLvwbgdcU6l4S66/T
         MtgUSwzN4/u3lMGRrk2i/EZhmFifrL1l8nqo/Dvk7AzcOqCSmzHywzkTLmJiQqkIxi
         cB3ggApE+DqXv6KDbCTjEm3J4PN1MXXpj0kM2wTiLlhrKCW33KXQUiO0TKvMWITbDU
         puChYEht6z7S5KRvdJsdfukUdFFAll9I/IEKmEeoIwtMFNwOhHxikmBLpIWR7qPkMl
         rCLsorMZKgrEIA5C1HL0PwrneQYVBaqBmkueIt8CJC1aM6rmzYVWuNmJvBJunMfMXX
         iUnR1aRPPFLgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.16 4/8] KVM: nVMX: WARN on any attempt to allocate shadow VMCS for vmcs02
Date:   Wed,  9 Feb 2022 13:56:30 -0500
Message-Id: <20220209185635.48730-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209185635.48730-1-sashal@kernel.org>
References: <20220209185635.48730-1-sashal@kernel.org>
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
index c605c2c01394b..9cd68e1fcf602 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4827,18 +4827,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
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

