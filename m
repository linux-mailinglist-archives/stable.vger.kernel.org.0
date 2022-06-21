Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393AE553DAA
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356156AbiFUV0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356037AbiFUVZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EA53121B;
        Tue, 21 Jun 2022 14:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F03A615A5;
        Tue, 21 Jun 2022 21:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2B8C3411C;
        Tue, 21 Jun 2022 21:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655846502;
        bh=KtkOG/ERJjQUv0N/orDTSLTsAF0g4uTxZJXILtA9Y1A=;
        h=From:To:Cc:Subject:Date:From;
        b=Rb53o1TDYMg1DmHZ1lU1Cm+ctEzyxgIT0jpHrcV8zatSEhYwT/C1m/PbTP7D9q8nT
         gaQg5v6LTZNivML+c8KLc5bWpnE2nlN5axJtLbf+1WnahRohCbb20C/LTmD6+uMcy0
         jZZ/oZIkPeoMRolJqfs8u7N+UQhQCiMgciCRVYDaX/eD+jCnUn01+kLgM8UnIjemSU
         XVyMl7i0GcVntYww7hkahxGv5swpnCg60VFZz59C8fJ1G1jyhC0+ARZYOt5PMwbJQK
         VCXbV4Li+aIn/ubdB4ogjzJ9oZYsQVlkDjmXgS964diasZJPdO+bWT66NInWqF74YZ
         Q5aIC2xtHzNaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 1/3] KVM: x86: disable preemption while updating apicv inhibition
Date:   Tue, 21 Jun 2022 17:21:37 -0400
Message-Id: <20220621212139.251808-1-sashal@kernel.org>
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
index 5204283da798..0e456c82a00b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9668,6 +9668,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		return;
 
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
+	preempt_disable();
 
 	activate = kvm_apicv_activated(vcpu->kvm);
 	if (vcpu->arch.apicv_active == activate)
@@ -9687,6 +9688,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 out:
+	preempt_enable();
 	up_read(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
-- 
2.35.1

