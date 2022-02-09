Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997B94AFC44
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiBIS5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiBIS4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:56:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FACCC0401D3;
        Wed,  9 Feb 2022 10:56:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0014612CC;
        Wed,  9 Feb 2022 18:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E09C340E9;
        Wed,  9 Feb 2022 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433005;
        bh=x2jfxv6PFGtgRCW1G1/ZajYjEIi5Ja02neps3iJgefE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcOgCpKls6ng4plXqF+Abtvlbw79Etz0WW1ZZqUMi6Drqr+XrlRyK7GVA92FgD62q
         tQsMz9VWs72jYlxC/TzRxc5usiiA09AhFUL1mS7WIMeGHMYJuWjqcdvaOQwp8VCJPB
         wiEHG8JG7qdk3IKvbWBIcbnQkb1grbeugmCPZr7bV9RV1pQvptWL0uRm+Pj17VlpHD
         jl9E5+uCaJABAnqehH5wRjoZBGm0+JVNJKwZWmxDbjtkTujotIf1l8tSQE8eDCxkEv
         EAjzpd4r8FY8l11GC3bWb8b5nq67O9cBcW1jR5i3w6lcyLNcXaYu/aCTD3oPebU42k
         qxU3MfvHLLyHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.16 5/8] KVM: SVM: Don't kill SEV guest if SMAP erratum triggers in usermode
Date:   Wed,  9 Feb 2022 13:56:31 -0500
Message-Id: <20220209185635.48730-5-sashal@kernel.org>
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

[ Upstream commit cdf85e0c5dc766fc7fc779466280e454a6d04f87 ]

Inject a #GP instead of synthesizing triple fault to try to avoid killing
the guest if emulation of an SEV guest fails due to encountering the SMAP
erratum.  The injected #GP may still be fatal to the guest, e.g. if the
userspace process is providing critical functionality, but KVM should
make every attempt to keep the guest alive.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-10-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3efada37272c0..d6a4acaa65742 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4530,7 +4530,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+		/*
+		 * If the fault occurred in userspace, arbitrarily inject #GP
+		 * to avoid killing the guest and to hopefully avoid confusing
+		 * the guest kernel too much, e.g. injecting #PF would not be
+		 * coherent with respect to the guest's page tables.  Request
+		 * triple fault if the fault occurred in the kernel as there's
+		 * no fault that KVM can inject without confusing the guest.
+		 * In practice, the triple fault is moot as no sane SEV kernel
+		 * will execute from user memory while also running with SMAP=1.
+		 */
+		if (is_user)
+			kvm_inject_gp(vcpu, 0);
+		else
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
 	return false;
-- 
2.34.1

