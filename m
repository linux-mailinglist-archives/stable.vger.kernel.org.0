Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA13A3D435B
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 01:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhGWWiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:38:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231954AbhGWWiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 18:38:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NN2lbm026571;
        Fri, 23 Jul 2021 19:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8sfxVjObelAC18t2Mcrt5gz09PThZDf56hljvbnXAjM=;
 b=aCHUFS074T+vPxlYlzIy4ATjxL28SJOxK8T2g+rJtUycE7J2IC6wetG0c5PBE/ss+HIx
 Zq00KV/TpjlGOEilk4+bjaSaDip30qFZJF7Ikow7IuqtLepF8E0goz/9C8DD+ZW3t6xN
 rJZoCP9zFU1jXzBr48wWzLGyLOn0gz754TAkZQqQIvTSE9Od2oDqhO9WfRJHUHejy6jN
 3y4BrL+shpH6oFlclwiWREVXuszuCIDkhApEwoNvWlunCwXzoFXSCuGRJ//yeounNkDG
 Eq59p9+vUjaatbII+/0yOsI9O8cXNSxDMSS6Vjn2/SoaUPk3ew0nkkRzH3Yf3g4YC8EE ng== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a06hns5pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 19:18:11 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NNHFHa008905;
        Fri, 23 Jul 2021 23:18:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 39vng72vw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 23:18:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NNI5Gi29491600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 23:18:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C9C94C08B;
        Fri, 23 Jul 2021 23:18:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C42D14C07A;
        Fri, 23 Jul 2021 23:18:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 23:18:04 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Will Deacon <will@kernel.org>,
        Claire Chang <tientzu@chromium.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 1/1] s390/pv: fix the forcing of the swiotlb
Date:   Sat, 24 Jul 2021 01:17:46 +0200
Message-Id: <20210723231746.3964989-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m1jpGHpOV5hVjMebEskb7OtI42Sl7OlE
X-Proofpoint-ORIG-GUID: m1jpGHpOV5hVjMebEskb7OtI42Sl7OlE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_13:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 adultscore=0 suspectscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107230137
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for
swiotlb data bouncing") if code sets swiotlb_force it needs to do so
before the swiotlb is initialised. Otherwise
io_tlb_default_mem->force_bounce will not get set to true, and devices
that use (the default) swiotlb will not bounce despite switolb_force
having the value of SWIOTLB_FORCE.

Let us restore swiotlb functionality for PV by fulfilling this new
requirement.

This change addresses what turned out to be a fragility in
commit 64e1f0c531d1 ("s390/mm: force swiotlb for protected
virtualization"), which ain't exactly broken in its original context,
but could give us some more headache if people backport the broken
change and forget this fix.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for swiotlb data bouncing")
Fixes: 64e1f0c531d1 ("s390/mm: force swiotlb for protected virtualization")
Cc: stable@vger.kernel.org #5.3+

---

I'm aware that this fix does not really satisfy the formal requirements
for the stable process. But to avoid problems with backports we would
like this fix applied to 5.3+ stable kernels.
---
 arch/s390/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index d85bd7f5d8dc..1c8f8ccebfb7 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -186,9 +186,9 @@ static void pv_init(void)
 		return;
 
 	/* make sure bounce buffers are shared */
+	swiotlb_force = SWIOTLB_FORCE;
 	swiotlb_init(1);
 	swiotlb_update_mem_attributes();
-	swiotlb_force = SWIOTLB_FORCE;
 }
 
 void __init mem_init(void)

base-commit: 90d856e71443a2fcacca8e7539bac44d9cb3f7ab
-- 
2.25.1

