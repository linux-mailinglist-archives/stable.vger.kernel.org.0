Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824B6423F41
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbhJFNcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238868AbhJFNcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:32:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA38E61075;
        Wed,  6 Oct 2021 13:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527030;
        bh=3X4bHHU6qsEzNqkqSdvTI2O/IYbV9+9XJ5AhO6SVdXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVo8I5ePPvfu6D+bIV5wGjwhLxLfl0YgjwKl5gdobUXPpHbVjtm0LxGHaeo5qyqxv
         tgjNuoI7EWpbG8IZOuDn2XMZXS+k3ph8KW6pDfGTSTCAGhPOYRnPhimR1EO2VnN4IE
         PAjMie+aP6n2NwAyi0TZr79kqmBOhp8mqxPJhX2/xyTMPLDjjGGQLrRJg0hM5rPRA/
         AJOqYS0VMNjPIoX/aAO5dAwDag/Pr1m/6IKlRAYnVi5/cR6s+bU9YcXXkApcOuSEY7
         VyfjelGRb4GX8BCvyF6PrrPLoS1X1k0bIDxZyGfF5EqaJKFn0R75YTLHkSo5s/KRZx
         7BfH+Y42tiSYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 6/9] KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry
Date:   Wed,  6 Oct 2021 09:30:18 -0400
Message-Id: <20211006133021.271905-6-sashal@kernel.org>
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

[ Upstream commit c8607e4a086fae05efe5bffb47c5199c65e7216e ]

It is possible that when non root mode is entered via special entry
(!from_vmentry), that is from SMM or from loading the nested state,
the L2 state could be invalid in regard to non unrestricted guest mode,
but later it can become valid.

(for example when RSM emulation restores segment registers from SMRAM)

Thus delay the check to VM entry, where we will check this and fail.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210913140954.165665-7-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 7 ++++++-
 arch/x86/kvm/vmx/vmx.c    | 5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ac1803dac435..2e8a46f9f552 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2576,8 +2576,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * Guest state is invalid and unrestricted guest is disabled,
 	 * which means L1 attempted VMEntry to L2 with invalid state.
 	 * Fail the VMEntry.
+	 *
+	 * However when force loading the guest state (SMM exit or
+	 * loading nested state after migration, it is possible to
+	 * have invalid guest state now, which will be later fixed by
+	 * restoring L2 register state
 	 */
-	if (CC(!vmx_guest_state_valid(vcpu))) {
+	if (CC(from_vmentry && !vmx_guest_state_valid(vcpu))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 339116ff236f..974029917713 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6613,7 +6613,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * consistency check VM-Exit due to invalid guest state and bail.
 	 */
 	if (unlikely(vmx->emulation_required)) {
-		vmx->fail = 0;
+
+		/* We don't emulate invalid state of a nested guest */
+		vmx->fail = is_guest_mode(vcpu);
+
 		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
 		vmx->exit_reason.failed_vmentry = 1;
 		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
-- 
2.33.0

