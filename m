Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F1963859E
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 09:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiKYIz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 03:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiKYIz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 03:55:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869E31F96;
        Fri, 25 Nov 2022 00:55:23 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP8b5np014183;
        Fri, 25 Nov 2022 08:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=id6Jg8I7w0STngEpJYuiJ5AtIFfIVvrCx6SbzczTnH0=;
 b=XGD9Q5jPTSignhE8/V20hvAoG2XwX5Z5bg0C/OVGrZmluDqu4CL1ezc4ibVr2qeJrx7/
 wLAz4DACQ/87OMui/J9SY0vUTX1dCZ+SBgcTI2rGiUi+yVCem/YoHF5wkOVpymgiwfPW
 MLptgAEdouJ3Mpt5YvbZ116KO/ZhGtS2wdN2PxbInNvzgpCEtfv6z08m02lpMLlf6kM5
 7hf3FNqUrmz8zZz6rRf3zzuEWGWUvy7I6RgFWbv2TYIQ0DxjvVohstzZNv1po6DzGSXo
 6R21olm1Kzh5u/HQ7fW6/YDBqGuUz0JW1G6ygAIztbC2NMfJ4Yzp03UKRge2xmcVOu63 dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2rg42v3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 08:55:23 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AP8eBHS027950;
        Fri, 25 Nov 2022 08:55:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2rg42v2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 08:55:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AP8p1vF017564;
        Fri, 25 Nov 2022 08:55:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3kxps91aur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 08:55:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AP8tHRS54722956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 08:55:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B4F35204E;
        Fri, 25 Nov 2022 08:55:17 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E2A4552050;
        Fri, 25 Nov 2022 08:55:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 1/1] KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field
Date:   Fri, 25 Nov 2022 09:54:54 +0100
Message-Id: <20221125085454.16673-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125085454.16673-1-frankja@linux.ibm.com>
References: <20221125085454.16673-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: boZ2AoLnRbLJn4H8BdHuLgggWoDHVraO
X-Proofpoint-GUID: QkTnaEyxF0vew9G7DtUtghUBlxWPtM6E
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1011
 suspectscore=0 priorityscore=1501 mlxlogscore=813 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211250069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

We recently experienced some weird huge time jumps in nested guests when
rebooting them in certain cases. After adding some debug code to the epoch
handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
obvious that the "epdx" field (the multi-epoch extension) did not get set
to 0xff in case the "epoch" field was negative.
Seems like the code misses to copy the value from the epdx field from
the guest to the shadow control block. By doing so, the weird time
jumps are gone in our scenarios.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")
Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Cc: stable@vger.kernel.org # 4.19+
Link: https://lore.kernel.org/r/20221123090833.292938-1-thuth@redhat.com
Message-Id: <20221123090833.292938-1-thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 94138f8f0c1c..ace2541ababd 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -546,8 +546,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
 		scb_s->eca |= scb_o->eca & ECA_CEI;
 	/* Epoch Extension */
-	if (test_kvm_facility(vcpu->kvm, 139))
+	if (test_kvm_facility(vcpu->kvm, 139)) {
 		scb_s->ecd |= scb_o->ecd & ECD_MEF;
+		scb_s->epdx = scb_o->epdx;
+	}
 
 	/* etoken */
 	if (test_kvm_facility(vcpu->kvm, 156))
-- 
2.38.1

