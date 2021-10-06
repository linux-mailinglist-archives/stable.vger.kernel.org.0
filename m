Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8164423F53
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhJFNcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238845AbhJFNcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60AF6610A8;
        Wed,  6 Oct 2021 13:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527029;
        bh=QLZ6t27qJjhlPkoFsEFqVjdFK7qxIrD4AzyNiprhj5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kD6PsbKn72GnPCHwcsflqSoEqLSwcsoX5IfkIddzOnWOTuYQ5Cy3drhn14YFOc/AG
         eMHbe8MpWiX8PzUigFhSALnUjZkiBMLNvKp4IY4QddSttVImd1/CNK0V1wTwYZ+7MU
         9s0L1Ryu85LQpiyfv1G48E9SueDl1mkWX3t/BrxllPk/WX8MVKM58t70IibCv/YLv4
         bAT+NSAKiALozqAvy+1jtJ3bNpSTpVsgbqr17vvzbEiCIULa3Zwz+XMbQcahLf9T9Y
         iKfrnOBxFAflm7628MhKkZKrumrZY48arp/T8qJu2OG+Pu/OXx7Lk4tVfDqvTQKt7F
         0zF7AZ19fn+gA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 5/9] KVM: x86: VMX: synthesize invalid VM exit when emulating invalid guest state
Date:   Wed,  6 Oct 2021 09:30:17 -0400
Message-Id: <20211006133021.271905-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006133021.271905-1-sashal@kernel.org>
References: <20211006133021.271905-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit c42dec148b3e1a88835e275b675e5155f99abd43 ]

Since no actual VM entry happened, the VM exit information is stale.
To avoid this, synthesize an invalid VM guest state VM exit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210913140954.165665-6-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 256f8cab4b8b..339116ff236f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6607,10 +6607,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
 		vmx->loaded_vmcs->entry_time = ktime_get();
 
-	/* Don't enter VMX if guest state is invalid, let the exit handler
-	   start emulation until we arrive back to a valid state */
-	if (vmx->emulation_required)
+	/*
+	 * Don't enter VMX if guest state is invalid, let the exit handler
+	 * start emulation until we arrive back to a valid state.  Synthesize a
+	 * consistency check VM-Exit due to invalid guest state and bail.
+	 */
+	if (unlikely(vmx->emulation_required)) {
+		vmx->fail = 0;
+		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
+		vmx->exit_reason.failed_vmentry = 1;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
+		vmx->exit_qualification = ENTRY_FAIL_DEFAULT;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
+		vmx->exit_intr_info = 0;
 		return EXIT_FASTPATH_NONE;
+	}
 
 	trace_kvm_entry(vcpu);
 
-- 
2.33.0

