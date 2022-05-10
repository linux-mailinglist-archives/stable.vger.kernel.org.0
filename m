Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E499521805
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbiEJNcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243919AbiEJNcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B51D54;
        Tue, 10 May 2022 06:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75BBFB81D7A;
        Tue, 10 May 2022 13:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDEEC385C2;
        Tue, 10 May 2022 13:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189023;
        bh=qS9yeF5Z4kqyQaN+jkF6ZO2qnwVTEewgiRMJ/qCZUY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsuvJgX+iw44plVfiOEzFKvkjDcRTjxBPRhLoav92kG21ydBkCBmJJGWxys/BmvNb
         KTy7Hw/dhGdqvLEmYNNEuzlFcRWrTEZpH1U2BKHBmsQWym8DLD7Ax6MEjTyLulT/JK
         aozR6Cs+KgUR6RRcIHlmoNnNXkGrO1dY+u7J8OI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aili Yao <yaoaili@kingsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/52] KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised
Date:   Tue, 10 May 2022 15:08:07 +0200
Message-Id: <20220510130730.967514649@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index afe3b8e61514..3696b4de9d99 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -118,7 +118,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 
 bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
 }
 EXPORT_SYMBOL_GPL(kvm_can_post_timer_interrupt);
 
-- 
2.35.1



