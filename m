Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7489B17E2F6
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 16:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgCIPBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 11:01:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbgCIPBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 11:01:15 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029EwqPo013602;
        Mon, 9 Mar 2020 11:01:14 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8n7c3eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:01:11 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 029F0JxR024513;
        Mon, 9 Mar 2020 11:00:51 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8n7c2yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:00:51 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 029F0WRH024797;
        Mon, 9 Mar 2020 15:00:35 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 2ym38635ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 15:00:35 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 029F0ZgN53346704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 15:00:35 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFA8928077;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C86EE2805A;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/4] KVM: s390: Also reset registers in sync regs for initial cpu reset
Date:   Mon,  9 Mar 2020 11:00:25 -0400
Message-Id: <20200309150026.4329-4-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200309150026.4329-1-borntraeger@de.ibm.com>
References: <20200309150026.4329-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090104
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we do the initial CPU reset we must not only clear the registers
in the internal data structures but also in kvm_run sync_regs. For
modern userspace sync_regs is the only place that it looks at.

Cc: stable@vger.kernel.org
Fixes: 7de3f1423ff943 ("KVM: s390: Add new reset vcpu API")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b1842a9feed..81f54ddedb3d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3529,7 +3529,10 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 	/* Initial reset is a superset of the normal reset */
 	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
 
-	/* this equals initial cpu reset in pop, but we don't switch to ESA */
+	/*
+	 * This equals initial cpu reset in pop, but we don't switch to ESA.
+	 * We do not even reset the internal data, but also ...
+	 */
 	vcpu->arch.sie_block->gpsw.mask = 0;
 	vcpu->arch.sie_block->gpsw.addr = 0;
 	kvm_s390_set_prefix(vcpu, 0);
@@ -3538,6 +3541,19 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
 	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
 	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
+
+	/* ... the data in sync regs */
+	memset(vcpu->run->s.regs.crs, 0, sizeof(vcpu->run->s.regs.crs));
+	vcpu->run->s.regs.ckc = 0;
+	vcpu->run->s.regs.crs[0] = CR0_INITIAL_MASK;
+	vcpu->run->s.regs.crs[14] = CR14_INITIAL_MASK;
+	vcpu->run->psw_addr = 0;
+	vcpu->run->psw_mask = 0;
+	vcpu->run->s.regs.todpr = 0;
+	vcpu->run->s.regs.cputm = 0;
+	vcpu->run->s.regs.ckc = 0;
+	vcpu->run->s.regs.pp = 0;
+	vcpu->run->s.regs.gbea = 1;
 	vcpu->run->s.regs.fpc = 0;
 	/*
 	 * Do not reset these registers in the protected case, as some of
-- 
2.25.0

