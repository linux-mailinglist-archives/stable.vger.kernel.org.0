Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB5A533072
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiEXScT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240343AbiEXScT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:32:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2AC60FA
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:32:17 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHnIF6015392;
        Tue, 24 May 2022 18:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=3cqK8lDDtUbkak7Q8ZMkp/adPfZLV9GlHQlaYiil2+0=;
 b=F33VCFaU1Rr1hZvFCo1dV1w8FhsPAIZjTolvjzvpn3YxM6fWYJCbpzHUlLYOgGrITdJo
 L5CLgFBJ40tcE4BMCRIioKj6iibyr2VnQUu9/0AGAHbjfsvN5396bund/xfv4lrYNOpU
 vPf08D2Xb6Mxv4oSrv3o59MY3X/4+t1VP17HuSj2vGPfS94n9QPdUb+G0wI1KTXKAgfB
 hcnfPjzLQ6ZkHr3UVs7u0xzxkiEiaNH6KnzkwVp1UnE5RSS9ywUge8CBynPoFf9rXxZA
 kC7S5b3uydpXPfBZ5BolXZVvJLy/YOaZdAdc/XYcq1dHgcSOWfh7QuEEBKMVsQFZjoq2 GQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tc05p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:32:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OIGNWP012420;
        Tue, 24 May 2022 18:32:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x51au8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:32:13 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OISvbH006398;
        Tue, 24 May 2022 18:32:13 GMT
Received: from t460.home (dhcp-10-175-38-116.vpn.oracle.com [10.175.38.116])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x51ata-1;
        Tue, 24 May 2022 18:32:12 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 5.10.y] KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID
Date:   Tue, 24 May 2022 20:31:38 +0200
Message-Id: <20220524183138.12389-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.35.1.46.g38062e73e0
In-Reply-To: <165314153878227@kroah.com>
References: <165314153878227@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: qHn4t0qSV39mEXABRw3JPA855tBB3vOb
X-Proofpoint-GUID: qHn4t0qSV39mEXABRw3JPA855tBB3vOb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9f46c187e2e680ecd9de7983e4d081c3391acc76 upstream.

With shadow paging enabled, the INVPCID instruction results in a call
to kvm_mmu_invpcid_gva.  If INVPCID is executed with CR0.PG=0, the
invlpg callback is not set and the result is a NULL pointer dereference.
Fix it trivially by checking for mmu->invlpg before every call.

There are other possibilities:

- check for CR0.PG, because KVM (like all Intel processors after P5)
  flushes guest TLB on CR0.PG changes so that INVPCID/INVLPG are a
  nop with paging disabled

- check for EFER.LMA, because KVM syncs and flushes when switching
  MMU contexts outside of 64-bit mode

All of these are tricky, go for the simple solution.  This is CVE-2022-1789.

Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[fix conflict due to missing b9e5603c2a3accbadfec570ac501a54431a6bdba]
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 70ef5b542681c..bcf1bd9424f21 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5178,14 +5178,16 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	uint i;
 
 	if (pcid == kvm_get_active_pcid(vcpu)) {
-		mmu->invlpg(vcpu, gva, mmu->root_hpa);
+		if (mmu->invlpg)
+			mmu->invlpg(vcpu, gva, mmu->root_hpa);
 		tlb_flush = true;
 	}
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
 		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd)) {
-			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+			if (mmu->invlpg)
+				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 			tlb_flush = true;
 		}
 	}
-- 
2.35.1.46.g38062e73e0

