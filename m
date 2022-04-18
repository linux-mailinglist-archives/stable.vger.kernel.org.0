Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43BC5055CE
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbiDRN05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbiDRNZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78023D1E7;
        Mon, 18 Apr 2022 05:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B109E612AB;
        Mon, 18 Apr 2022 12:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A274AC385A1;
        Mon, 18 Apr 2022 12:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286372;
        bh=YgaaXn8L+J0QNN2LrURmoLOQzivUOwU+l9C8Qdd+nFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pxWAcft1FAGbvZm5Lmf0JlE8tzOAvg6yswWYRFxchcNh7oHozIA+V+ph+tpF+hUi
         mnlio93LaSawASDsYss5J8eHGdqrSgLHs21nYbEbf0ZW/F7wKvkWKPKAXyCuOH6VYA
         At8/60JBjUGmG/KRO9qsCnv+3L1ScuynFl1aU4lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 113/284] KVM: x86: Fix emulation in writing cr8
Date:   Mon, 18 Apr 2022 14:11:34 +0200
Message-Id: <20220418121214.202313915@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d4fdf0e52144..99b3fa3a29bf 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1929,10 +1929,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
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



