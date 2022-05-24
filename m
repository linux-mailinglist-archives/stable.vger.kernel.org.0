Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28004532FBC
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 19:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiEXRmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 13:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiEXRmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 13:42:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30905AA58
        for <stable@vger.kernel.org>; Tue, 24 May 2022 10:42:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHU6Ds025530;
        Tue, 24 May 2022 17:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=q8y/sTn9rODfYGwKE5wQiTVQtjNK4rI9yfRuGngNWhg=;
 b=iZ1zQpsW59a6u0vMwUV9y05Ob3CL0Wd6Jd3SbISaeytkYL+Cxxt3A4dHtoGj73K16qbw
 LBvB4TyQJrJFTn6zgc0PR8Q/OksQ+NL20oNjVFG8+Dbg1j5e7ywmQsV5dZme78HB/X9w
 jjwm7b0/DC7U3eb8Q92X+4ovVyDPd/VLRL0ttNG8oSPTZlKfJNwhV2w/rUtTqFkYCE1w
 iWxaspgtyy/kc/RsIDkmenrYn9QFF++/+ZXl1Vx64NjLvwEXySCY2RUzuy2Tuh0sOt17
 cP0izqid+hwtwGOLl09n1R7BkNzW1RRMFcn9XAcoGyG0MnUSWFhpt5JaHYt886ZpBPYj Xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tbr115-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 17:42:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHgMFA025471;
        Tue, 24 May 2022 17:42:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wyr3q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 17:42:26 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OHgQMB025717;
        Tue, 24 May 2022 17:42:26 GMT
Received: from t460.home (dhcp-10-175-38-116.vpn.oracle.com [10.175.38.116])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wyr3nf-1;
        Tue, 24 May 2022 17:42:25 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 5.15] KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID
Date:   Tue, 24 May 2022 19:40:41 +0200
Message-Id: <20220524174041.10479-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.35.1.46.g38062e73e0
In-Reply-To: <165314153685166@kroah.com>
References: <165314153685166@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 2o_sOq1CeGKg3uv8qQXAa_kAwTdn_utU
X-Proofpoint-ORIG-GUID: 2o_sOq1CeGKg3uv8qQXAa_kAwTdn_utU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

