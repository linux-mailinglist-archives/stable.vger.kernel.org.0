Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6711A532CFE
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbiEXPMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbiEXPML (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:12:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ED35A143
        for <stable@vger.kernel.org>; Tue, 24 May 2022 08:12:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OCx8Eg018480;
        Tue, 24 May 2022 15:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=q8y/sTn9rODfYGwKE5wQiTVQtjNK4rI9yfRuGngNWhg=;
 b=IINgsjFxtbJideLPXpE0Zol6llQmB6e2Ax/s9urWAJ0e30MhXpjgjZGdDHHTy/Oy2suG
 KbSA8GJ/4CWFhHIFsdB23sduwwkjMjJ1t+mVASZQ8pV0AJ/u0ufmy9G2D1jkSfo4yhvx
 3hb2jI/9tbxNPCacsGeFy9JCguWqD0ZY/Kem49+eb7yymTWZvysDh/m535dZ98WNNHr8
 X/pKLgPRBACdmZu3fLOGoMHXyE1a5Pa+4IeokZvqLfJ0GNc73lWVOuxDhyqrrAfyo505
 MqhJKtSr5B3LctoQmYnGL74JEMQULfr9cYxPYROL3rSsFSyISC+/z3WNjNUAIvSbCPZW MA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qps6rjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 15:12:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OFAhe3019491;
        Tue, 24 May 2022 15:12:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph2gch0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 15:12:06 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OFC5tx026796;
        Tue, 24 May 2022 15:12:06 GMT
Received: from t460.home (dhcp-10-175-38-116.vpn.oracle.com [10.175.38.116])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph2gced-1;
        Tue, 24 May 2022 15:12:05 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID
Date:   Tue, 24 May 2022 17:11:18 +0200
Message-Id: <20220524151118.4828-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.35.1.46.g38062e73e0
In-Reply-To: <165314153515625@kroah.com>
References: <165314153515625@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: GlC3bXFys3mcj754MWtQm3Da8jwNMFrh
X-Proofpoint-GUID: GlC3bXFys3mcj754MWtQm3Da8jwNMFrh
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
index e7cd16e1e0a0b..ff65584c7e5f4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5416,14 +5416,16 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
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

