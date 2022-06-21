Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453A7553DC0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356326AbiFUV0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356056AbiFUVZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA013055D;
        Tue, 21 Jun 2022 14:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1DF8612E9;
        Tue, 21 Jun 2022 21:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7FDC3411C;
        Tue, 21 Jun 2022 21:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655846495;
        bh=fq+yHa6pssyqn9w5NdgWQCplgcXLfqXZDZuY6MEMMA0=;
        h=From:To:Cc:Subject:Date:From;
        b=Zg13X1PgSL5ZatLKsEb1FdCaRvtfKq5ln7sulvo5u4sQNFpCCTVEv28SWenzqyKyy
         hWVNczNQmmEjKG3GuqegQrB8oNm1Q+VO69TiMGpet4Cm5//mHP9DS6qciV5Kc3hK2i
         FPYZCO7qH75RscPhwUh0Aa/2LatpR559CMMJ08GI261nAqI/ORGS1Pygj4GXRVhqPP
         sVwUnrutA5w7S0Iqcf8f3/VBt1/YxPjqL4206uDhCcUImXpPmMJRMfYODGiumJvW5h
         E6ZujmF41bTSMw/rSCmv4ogdG0Duatjdk+6lfJAhNi4xCdEm/9MMHDYxiVHUqxoh30
         ZH0PO2jlTTEUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.18 1/3] KVM: x86: disable preemption while updating apicv inhibition
Date:   Tue, 21 Jun 2022 17:21:30 -0400
Message-Id: <20220621212132.251759-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 66c768d30e64e1280520f34dbef83419f55f3459 ]

Currently nothing prevents preemption in kvm_vcpu_update_apicv.

On SVM, If the preemption happens after we update the
vcpu->arch.apicv_active, the preemption itself will
'update' the inhibition since the AVIC will be first disabled
on vCPU unload and then enabled, when the current task
is loaded again.

Then we will try to update it again, which will lead to a warning
in __avic_vcpu_load, that the AVIC is already enabled.

Fix this by disabling preemption in this code.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220606180829.102503-6-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 558d1f2ab5b4..5523bd4b3702 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9765,6 +9765,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		return;
 
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
+	preempt_disable();
 
 	activate = kvm_apicv_activated(vcpu->kvm);
 	if (vcpu->arch.apicv_active == activate)
@@ -9784,6 +9785,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 out:
+	preempt_enable();
 	up_read(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
-- 
2.35.1

