Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350244BFA47
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 15:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiBVOGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 09:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiBVOGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 09:06:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7415315F36A;
        Tue, 22 Feb 2022 06:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 082DE6146F;
        Tue, 22 Feb 2022 14:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDD4C340E8;
        Tue, 22 Feb 2022 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645538730;
        bh=UJdBhqcefZEm1mKKDL1sjTb3cthVU/RoSGxzRcj8I6U=;
        h=From:To:Cc:Subject:Date:From;
        b=e37oz1QNc6XBwkzmAzpj9OQGCNxkWTQR5+wvcgsx2PLij3W60qqXP+HZ+USUEtptQ
         Hd70D461xthGyU9iXL+wJD86tEg+hfOJD+HiPWtsH7FGP4l2N1xleMQwr0jVHT+gBe
         80daXbpreAdk05lqqk0ToovjAoPPJkCRpg/tC+DEPQp+Ar0v0ZnsOabCTPu+c6VepT
         LRhgzySEAlchEQ36gWWPmbQ+J+UXjDqlM1VRmo8ROmSVcB52o774X1oeEduMTBL6Wg
         NfyQWxgPfy1pWbz1LEtyc/azAZjnKyUpGopb6SKyf1GywGc6kL6JxwEq+EemUFYmZO
         Q+0kCQbkrA4ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 1/2] KVM: x86: lapic: don't touch irr_pending in kvm_apic_update_apicv when inhibiting it
Date:   Tue, 22 Feb 2022 09:05:26 -0500
Message-Id: <20220222140527.211584-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 755c2bf878607dbddb1423df9abf16b82205896f ]

kvm_apic_update_apicv is called when AVIC is still active, thus IRR bits
can be set by the CPU after it is called, and don't cause the irr_pending
to be set to true.

Also logic in avic_kick_target_vcpu doesn't expect a race with this
function so to make it simple, just keep irr_pending set to true and
let the next interrupt injection to the guest clear it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220207155447.840194-9-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 91c2dc9f198df..5f935e7a09566 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2306,7 +2306,12 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		apic->irr_pending = true;
 		apic->isr_count = 1;
 	} else {
-		apic->irr_pending = (apic_search_irr(apic) != -1);
+		/*
+		 * Don't clear irr_pending, searching the IRR can race with
+		 * updates from the CPU as APICv is still active from hardware's
+		 * perspective.  The flag will be cleared as appropriate when
+		 * KVM injects the interrupt.
+		 */
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
 }
-- 
2.34.1

