Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00C7383135
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbhEQOfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236839AbhEQOcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 059FB6190A;
        Mon, 17 May 2021 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260959;
        bh=0i23hUk+mLVJQ5yE6IVfIrU+/y8lkTiab14ntsBSRcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eylsnsjwsIsx5JrI4Ox9f3dCkhysKEOX71DZmptCKoM1XAi0zgX7MXfw9sSuqQAVm
         nlmw3A+1q7pWBogJYCqidoJr7Y25dAFgOeOA5IxgKCKiC7p1r1d16XT4oEgKbslxK7
         qcqgq7RyRO83rEfQMy83YjoUkXoht/o8VJF1SIIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 275/363] KVM: LAPIC: Accurately guarantee busy wait for timer to expire when using hv_timer
Date:   Mon, 17 May 2021 16:02:21 +0200
Message-Id: <20210517140311.915606478@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit d981dd15498b188636ec5a7d8ad485e650f63d8d ]

Commit ee66e453db13d (KVM: lapic: Busy wait for timer to expire when
using hv_timer) tries to set ktime->expired_tscdeadline by checking
ktime->hv_timer_in_use since lapic timer oneshot/periodic modes which
are emulated by vmx preemption timer also get advanced, they leverage
the same vmx preemption timer logic with tsc-deadline mode. However,
ktime->hv_timer_in_use is cleared before apic_timer_expired() handling,
let's delay this clearing in preemption-disabled region.

Fixes: ee66e453db13d ("KVM: lapic: Busy wait for timer to expire when using hv_timer")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1619608082-4187-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 49a839d0567a..fa023f3feb25 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1913,8 +1913,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	if (!apic->lapic_timer.hv_timer_in_use)
 		goto out;
 	WARN_ON(rcuwait_active(&vcpu->wait));
-	cancel_hv_timer(apic);
 	apic_timer_expired(apic, false);
+	cancel_hv_timer(apic);
 
 	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
-- 
2.30.2



