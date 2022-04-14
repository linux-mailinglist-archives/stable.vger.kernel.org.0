Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF079500F94
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241200AbiDNNd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244753AbiDNN2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10D1A5E84;
        Thu, 14 Apr 2022 06:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C593B82910;
        Thu, 14 Apr 2022 13:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE727C385A1;
        Thu, 14 Apr 2022 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942449;
        bh=2zWZxTrsP5/RfF9yi4JqkDJsws+s/Yba/ETsECVbivU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aozHTa8kZb2iQ7CTFSVW5PW4r9o14uvZOcOvp+iscOFgYsVm9US3YK0GbPGmd3JSH
         ZhVvXOdrHY7+OHPR3DJNiW7VHXG1i1vQxiT14N1+ZiCDyaWjciI8iva9Bg4+v1Kmjt
         4pWHBgoN25v+VFjrEasq5nTqMlKWmwru8I528sr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/338] KVM: x86: Fix emulation in writing cr8
Date:   Thu, 14 Apr 2022 15:10:42 +0200
Message-Id: <20220414110842.862331088@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 56a4b9762b0c..89d07312e58c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2045,10 +2045,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
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



