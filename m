Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F409D6CF33A
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 21:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjC2ThE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 15:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC2ThB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 15:37:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A20469C
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 12:37:00 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TETvPF017439
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=dzhJchIZqa9AHioEr/885TurzS7xFDZG0xquhMf6+80=;
 b=FMwaiQoyuobi0dmltU3izMnOTXcGePKgwL1qTYQirkCmybv9YJjv1VnZTvlQ2y/7HmYu
 vBh6xaEdUZmWCJL5fcDxlR65aVsfT5J7+3XBN4kgJiMaS43gMfko15fikb+BtJA7/XK/
 tUccEbj71JYqfYQLZrKclzXJsSLip0nQTEXK3MpWKTpluzu762FXLS6IONdC1O8VecoO
 R7xoWB/vqDGTrfzuJE6aSNJov7SedsD966BeGbAyM1yJonf9GytdxKHBrwVpj6UPKdr3
 yfI9CSEAIz5yzA1E15W5H6cp8iyhoFeOcy+NQ16rAqbZu5pi+yDTzl48dp45qWMrwGk/ lA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq538v5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:36:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32TIx3Y6030096
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:36:58 GMT
Received: from alaljime-amd-bm-e3.allregionalphxs.osdevelopmenphx.oraclevcn.com (alaljime-amd-bm-e3.allregionalphxs.osdevelopmenphx.oraclevcn.com [100.107.196.22])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3phqdetbu1-1
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:36:58 +0000
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15.y] KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
Date:   Wed, 29 Mar 2023 19:36:57 +0000
Message-Id: <20230329193657.238077-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.34.2
In-Reply-To: <167812345411383@kroah.com>
References: <167812345411383@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_12,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303290149
X-Proofpoint-GUID: bisJ1f1GDKH3YGCyewzj8fL6Kow6yGK9
X-Proofpoint-ORIG-GUID: bisJ1f1GDKH3YGCyewzj8fL6Kow6yGK9
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

commit ab52be1b310bcb39e6745d34a8f0e8475d67381a upstream.

Reject attempts to set bits 63:32 for 32-bit x2APIC registers, i.e. all
x2APIC registers except ICR.  Per Intel's SDM:

  Non-zero writes (by WRMSR instruction) to reserved bits to these
  registers will raise a general protection fault exception

Opportunistically fix a typo in a nearby comment.

Reported-by: Marc Orr <marcorr@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20230107011025.565472-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

[Alejandro: stable backport 5.15.y]

Mainline commit:
5429478d038f ("KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes")
introduces helper kvm_lapic_msr_write(). Apply the changes to the call sites of
the helper in kvm_x2apic_msr_write() and kvm_hv_vapic_msr_write() instead.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
Sanity tested by booting Linux guest on Intel Skylake-SP host (enable_apicv=Y).

 arch/x86/kvm/lapic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8c9e41ff2a24..243aa43f7113 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2802,6 +2802,10 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
 		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	else if (data >> 32)
+		/* Bits 63:32 are reserved in all other registers. */
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
@@ -2836,6 +2840,10 @@ int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
 		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	else if (data >> 32)
+		/* Bits 63:32 are reserved in all other registers. */
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
-- 
2.34.2

