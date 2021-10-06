Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B2E423C3D
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbhJFLOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238289AbhJFLOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 07:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6859611C3;
        Wed,  6 Oct 2021 11:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633518760;
        bh=LCpnkQrtkpFME+dlxC2cukeR2xTz9DTyA0bWkNu3oDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtaHTQ9AEaoqB0JDxOl0SD/NfBuN7uQ5j81y1dkciQlg/q+8oFaUyy3Rqo6SjfGc/
         fUjxBqPBUTesv9l0UlVPey9S8XXVgL20jVuxCbmw2oXybrhS0nIUvs+APtM5lAcT7D
         tW97gyqIMFZj0S7IG57Bd6qs/sF/kq58xgZvHUKREXkiax0CtodMhwWkL3GQFTYGjp
         yqe3apTMEGts1oS/5hcP6t0IVkDDhHG48/7K/hqTYiZ2An5SypvwN+Uc+vCxoAHVdF
         cHVFZ+PnrS2y/d/EXHQpSnZ98KWcVxZGjMXcAukhm3KpGYkGeYjUwOn1Xr1CgQ+RsQ
         FuM5W/OpRFN1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 4/7] KVM: x86: VMX: synthesize invalid VM exit when emulating invalid guest state
Date:   Wed,  6 Oct 2021 07:12:30 -0400
Message-Id: <20211006111234.264020-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006111234.264020-1-sashal@kernel.org>
References: <20211006111234.264020-1-sashal@kernel.org>
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
index fcd8bcb7e0ea..e3af56f05a37 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6670,10 +6670,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
 
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty = false;
-- 
2.33.0

