Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D79E6CF36A
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 21:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjC2Tn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 15:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjC2TnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 15:43:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9436A60
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 12:42:42 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TEj7OG025562
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=IZyLlXhCAMBF1wQdqn0DjLf9xN1kg0KeGUYVs6i0SqQ=;
 b=BZRVRDCM8h+DMEdV91Ndcuoivb6JT5x08/JFRHEoSBEfjPHzHxUHK5IraxvuiLIU+3P4
 ftuoBEXW84TJBhQQy0sSHXi9bVwdnTwRwFzncuGL2EFm2BdHgfDZOXID7+VOUPy9veZE
 loSjTEE+ArpEVseoGVjfursWHE0neHCCBkylQl3AuoyTD/cIksTB5Ckjw3y8wh8g9pPK
 STk7AJz4xaImxtY2kby+REu5a6SITQ5cpUkKUmU4YiqBbm7dAYAy3u6V+x/u/aRHRacp
 aF3c35AGM/XV+ky76TRReSN6KuPOGFWLU4U7kiszbIgGLX6Ir6th4pGge5nBxWMJkIjy NA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmqbyrumh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:42:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32TJG3ig036404
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:42:41 GMT
Received: from alaljime-amd-bm-e3.allregionalphxs.osdevelopmenphx.oraclevcn.com (alaljime-amd-bm-e3.allregionalphxs.osdevelopmenphx.oraclevcn.com [100.107.196.22])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3phqdg35hv-1
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:42:41 +0000
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15.y] KVM: x86: Purge "highest ISR" cache when updating APICv state
Date:   Wed, 29 Mar 2023 19:42:40 +0000
Message-Id: <20230329194240.238392-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.34.2
In-Reply-To: <167812333979118@kroah.com>
References: <167812333979118@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_12,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303290150
X-Proofpoint-GUID: lRWJLOQFA7h4a4XdQ2YDImlsyhetbp7m
X-Proofpoint-ORIG-GUID: lRWJLOQFA7h4a4XdQ2YDImlsyhetbp7m
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 97a71c444a147ae41c7d0ab5b3d855d7f762f3ed upstream.

Purge the "highest ISR" cache when updating APICv state on a vCPU.  The
cache must not be used when APICv is active as hardware may emulate EOIs
(and other operations) without exiting to KVM.

This fixes a bug where KVM will effectively block IRQs in perpetuity due
to the "highest ISR" never getting reset if APICv is activated on a vCPU
while an IRQ is in-service.  Hardware emulates the EOI and KVM never gets
a chance to update its cache.

Fixes: b26a695a1d78 ("kvm: lapic: Introduce APICv update helper function")
Cc: stable@vger.kernel.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230106011306.85230-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

[Alejandro: stable backport 5.15.y]

Trivial conflicts in kvm_apic_set_state() due to missing:

ce0a58f4756c ("KVM: x86: Move "apicv_active" into "struct kvm_lapic"")
which modifies check for APICv active.

d39850f57d21 ("KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()")
abb6d479e226 ("KVM: x86: make several APIC virtualization callbacks optional")
which replace instances of static_call() with static_call_cond() in
kvm_apic_set_state() and change the signature of the hwapic_isr_update()
callback.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
Sanity tested by booting guest on AMD Genoa host with AVIC (no x2AVIC) enabled,
and guest on Intel Skylake-SP host with posted interrupts enabled.

 arch/x86/kvm/lapic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 243aa43f7113..40fc1879a697 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2316,6 +2316,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		apic->irr_pending = (apic_search_irr(apic) != -1);
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
+	apic->highest_isr_cache = -1;
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 
@@ -2368,7 +2369,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 
@@ -2638,7 +2638,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
 		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call(kvm_x86_hwapic_irr_update)(vcpu,
-- 
2.34.2

