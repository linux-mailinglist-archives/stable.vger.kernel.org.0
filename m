Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44A3837A1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244026AbhEQPqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343629AbhEQPmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34DDF6198B;
        Mon, 17 May 2021 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262551;
        bh=dZXU+yJRdUHUJdDNVw1EqzrfWGGrCG60z/TqiAep5+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRX8adm73LolA5bFvCTlX+1ZyUwrEhJX6cJBFtaaovMEVqHGr3bvCTmWcl0p4eG6K
         KWoOYNmP2IKFA1bPtEyEInHeSCU2VLj6ua3piXQ7IKKYPg9omoYqtsN1VzjAojHte7
         uuGZGrUkuU9ApYXLzC22D7r4+NwwjyuXAtRsWt7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/289] KVM: LAPIC: Accurately guarantee busy wait for timer to expire when using hv_timer
Date:   Mon, 17 May 2021 16:02:17 +0200
Message-Id: <20210517140312.258680324@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index 4ca81ae9bc8a..5759eb075d2f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1908,8 +1908,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
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



