Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCF64F379D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiDELSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349151AbiDEJtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C54322A;
        Tue,  5 Apr 2022 02:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E908CE1C90;
        Tue,  5 Apr 2022 09:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297CEC385A2;
        Tue,  5 Apr 2022 09:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151695;
        bh=oSV8lJ2c42++rCF3a6nUKOYIl7Se0T+6CgrsoKG5vIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6cBqLP2wrgRH4qlWtOeRCvyQ1CKMl6wsHmZ0hRzZPMMiMHFnbfB/xLOOVRFdMV7o
         GouCTssC6Fkb8ZbEfcJ8wMRNqReeSs+X9k09kYwv8/EBOt57Eo/bmeZok887pr+bRV
         v+Vb7Xr9AWTQRkhJzEaV7/YQlgfD7cTdAQ9T8J9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 509/913] KVM: x86: Fix emulation in writing cr8
Date:   Tue,  5 Apr 2022 09:26:11 +0200
Message-Id: <20220405070355.112628678@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

[ Upstream commit f66af9f222f08d5b11ea41c1bd6c07a0f12daa07 ]

In emulation of writing to cr8, one of the lowest four bits in TPR[3:0]
is kept.

According to Intel SDM 10.8.6.1(baremetal scenario):
"APIC.TPR[bits 7:4] = CR8[bits 3:0], APIC.TPR[bits 3:0] = 0";

and SDM 28.3(use TPR shadow):
"MOV to CR8. The instruction stores bits 3:0 of its source operand into
bits 7:4 of VTPR; the remainder of VTPR (bits 3:0 and bits 31:8) are
cleared.";

and AMD's APM 16.6.4:
"Task Priority Sub-class (TPS)-Bits 3 : 0. The TPS field indicates the
current sub-priority to be used when arbitrating lowest-priority messages.
This field is written with zero when TPR is written using the architectural
CR8 register.";

so in KVM emulated scenario, clear TPR[3:0] to make a consistent behavior
as in other scenarios.

This doesn't impact evaluation and delivery of pending virtual interrupts
because processor does not use the processor-priority sub-class to
determine which interrupts to delivery and which to inhibit.

Sub-class is used by hardware to arbitrate lowest priority interrupts,
but KVM just does a round-robin style delivery.

Fixes: b93463aa59d6 ("KVM: Accelerated apic support")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220210094506.20181-1-zhenzhong.duan@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 91c2dc9f198d..d790337613aa 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2242,10 +2242,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-
-	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
-		     | (kvm_lapic_get_reg(apic, APIC_TASKPRI) & 4));
+	apic_set_tpr(vcpu->arch.apic, (cr8 & 0x0f) << 4);
 }
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
-- 
2.34.1



