Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9BE43A4D2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhJYUk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhJYUk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 16:40:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4228D60EBC;
        Mon, 25 Oct 2021 20:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635194312;
        bh=a+kLtMZ1KLfEMf7pEtcJGUbQCSl0yQ0/lTx2gsK3NuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olByOznqMdyV0hQIZWfaYuPK0fUMxpUwa6YQ70fplDvxPt/cbHHJ6OP9880yt7GXP
         Uc/KAiEngNbOILY7gsBXw+ov+L0pTjlWu5XzrAK8eP2dmz3222LrYW42HCfRyJyHf+
         XkSBY4qkMlpwp9ybjCoiw/5I9ItNI5su79tf2xMuRssjxUPc8uzaP5FnWmiBOzXioe
         cUTHr4rznTrdz/lRg9VZIuAt9aDBuw7ywBQGD8LLuLxTaZ0qV36KXXVJYSlY107mhB
         3avn+KfVic++pPrSULKetYjgjvSRlwmaqt/01G7lbyxWAJ33EbkZzeTJpu0EAek7lB
         NylIkSdoFtc1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 2/5] KVM: x86: WARN if APIC HW/SW disable static keys are non-zero on unload
Date:   Mon, 25 Oct 2021 16:38:24 -0400
Message-Id: <20211025203828.1404503-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025203828.1404503-1-sashal@kernel.org>
References: <20211025203828.1404503-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 9139a7a64581c80d157027ae20e86f2f24d4292c ]

WARN if the static keys used to track if any vCPU has disabled its APIC
are left elevated at module exit.  Unlike the underflow case, nothing in
the static key infrastructure will complain if a key is left elevated,
and because an elevated key only affects performance, nothing in KVM will
fail if either key is improperly incremented.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211013003554.47705-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ba5a27879f1d..18cb699b0a14 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2942,5 +2942,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 void kvm_lapic_exit(void)
 {
 	static_key_deferred_flush(&apic_hw_disabled);
+	WARN_ON(static_branch_unlikely(&apic_hw_disabled.key));
 	static_key_deferred_flush(&apic_sw_disabled);
+	WARN_ON(static_branch_unlikely(&apic_sw_disabled.key));
 }
-- 
2.33.0

