Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503B9512021
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbiD0P6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240701AbiD0P54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:57:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A89771C5;
        Wed, 27 Apr 2022 08:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92496B82883;
        Wed, 27 Apr 2022 15:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32586C385B2;
        Wed, 27 Apr 2022 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074867;
        bh=SMMW/xa9C8D5vurAKOeqVtrr7C7izTSMHjwXwWpZJXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCh2HVLGGkhXuunUVGw1ZozflMJnfhtqPsXZFOBSbVW68j7N7TxYtgRaGFqUPsG6C
         YtQIOaej9FVpHQqzq95bGHI/v+RARkQTwyeOMDOJCNLp5CsgTGUxKYmpwa4VnReEhm
         M/i5/QbDZrk/xMYYpSqYVIIZzlCpVOAZ+O7WavTh47kcNkYr2e6aCuq5+EldJJKK4G
         K+OIv14PyTH77uEeP6ObhTyG5y98Qa1aeObv7ZvzHXzckeqRep+FlpEoK6o4mZxUBV
         XYdXcVsrSopRL/1G0ML85OAw/il61SycZYMZQipPhTP6rfaSA7EQronCx2Tl15fPXB
         P/Of2FCn1Vljw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Aili Yao <yaoaili@kingsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 7/7] KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised
Date:   Wed, 27 Apr 2022 11:54:03 -0400
Message-Id: <20220427155408.19352-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155408.19352-1-sashal@kernel.org>
References: <20220427155408.19352-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit 1714a4eb6fb0cb79f182873cd011a8ed60ac65e8 ]

As commit 0c5f81dad46 ("KVM: LAPIC: Inject timer interrupt via posted
interrupt") mentioned that the host admin should well tune the guest
setup, so that vCPUs are placed on isolated pCPUs, and with several pCPUs
surplus for *busy* housekeeping.  In this setup, it is preferrable to
disable mwait/hlt/pause vmexits to keep the vCPUs in non-root mode.

However, if only some guests isolated and others not, they would not
have any benefit from posted timer interrupts, and at the same time lose
VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
returns true and therefore forces kvm_can_use_hv_timer() to false.

By guaranteeing that posted-interrupt timer is only used if MWAIT or
HLT are done without vmexit, KVM can make a better choice and use the
VMX preemption timer and the corresponding fast paths.

Reported-by: Aili Yao <yaoaili@kingsoft.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6b6f9359d29e..970d5c740b00 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -113,7 +113,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
 }
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
-- 
2.35.1

