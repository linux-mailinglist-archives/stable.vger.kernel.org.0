Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777994048BA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 12:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhIIKyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 06:54:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234473AbhIIKyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 06:54:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 189AXltD134381
        for <stable@vger.kernel.org>; Thu, 9 Sep 2021 06:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=v+C0UKv0L4yjE/EjUzeD9nkeHDPPDnJabBOUpr0b4UU=;
 b=kp2a1QTE7UQuS3P1Q2jOOw3l/MEeA1SrSTKFrjaE+8wGryMnfQqLtizN40oashD3Mq5p
 0FdptcfSGT9VN2vCnlbnGbVGTT3b2i1Vdgn7M3K9/aUhCrtaAPz4pJu0VVjGG7ehz3XK
 uq07fotFeUlD/NmMvy1zunvI8sutyVsEU4ATAao++II2fVrLf8lftO8TcvVjc5uHSyR8
 qMa0bAbEQ/usv5KtTqZSq7uAQNKJ2vurVxyE8rz+IvskKwDkYFiEzEfw2wdPxuDzXc7w
 +kcZ/hnVV4Lg3j+5ZbHSS0gAWKUUm8qTcmQVCrZTUPV2MV1Vo9RYKpsSPaGX7M8qiStR AA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axp75ns8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 06:53:28 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 189AfWPM014203
        for <stable@vger.kernel.org>; Thu, 9 Sep 2021 10:53:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3axcnpkp6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 10:53:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 189ArM6O54067660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Sep 2021 10:53:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B01A11CC0E;
        Thu,  9 Sep 2021 10:53:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D760C11CC0A;
        Thu,  9 Sep 2021 10:53:21 +0000 (GMT)
Received: from oc8242746057.ibm.com.com (unknown [9.171.34.55])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Sep 2021 10:53:21 +0000 (GMT)
From:   Alexander Egorenkov <egorenar@linux.ibm.com>
To:     hca@linux.ibm.com, borntraeger@de.ibm.com
Cc:     oberpar@linux.ibm.com,
        linux390-list@tuxmaker.boeblingen.de.ibm.com,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] s390/sclp: fix Secure-IPL facility detection
Date:   Thu,  9 Sep 2021 12:53:18 +0200
Message-Id: <20210909105318.187592-1-egorenar@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rR62lFkpg0nlB8UDdsJUoQNYrx7d-NUo
X-Proofpoint-ORIG-GUID: rR62lFkpg0nlB8UDdsJUoQNYrx7d-NUo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_03:2021-09-09,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=779 mlxscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prevent out-of-range access if the returned SCLP SCCB response is smaller
in size than the address of the Secure-IPL flag.

Fixes: c9896acc7851 ("s390/ipl: Provide has_secure sysfs attribute")
Cc: stable@vger.kernel.org # 5.2+
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
---
 drivers/s390/char/sclp_early.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index 2f3515fa242a..f3d5c7f4c13d 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -45,13 +45,14 @@ static void __init sclp_early_facilities_detect(void)
 	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
 	sclp.has_hvs = !!(sccb->fac119 & 0x80);
 	sclp.has_kss = !!(sccb->fac98 & 0x01);
-	sclp.has_sipl = !!(sccb->cbl & 0x4000);
 	if (sccb->fac85 & 0x02)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
 	if (sccb->fac91 & 0x40)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_TLB_GUEST;
 	if (sccb->cpuoff > 134)
 		sclp.has_diag318 = !!(sccb->byte_134 & 0x80);
+	if (sccb->cpuoff > 137)
+		sclp.has_sipl = !!(sccb->cbl & 0x4000);
 	sclp.rnmax = sccb->rnmax ? sccb->rnmax : sccb->rnmax2;
 	sclp.rzm = sccb->rnsize ? sccb->rnsize : sccb->rnsize2;
 	sclp.rzm <<= 20;
-- 
2.31.1

