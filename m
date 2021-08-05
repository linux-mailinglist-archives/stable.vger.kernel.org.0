Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2795C3E17D3
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242011AbhHEPYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:24:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59084 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242111AbhHEPYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:24:22 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175F5Y3j008904;
        Thu, 5 Aug 2021 11:23:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0GX9Gy92NioS8ROteRDHc23LAjtxoFW5Spf0GoAraME=;
 b=Zd6kosr749DqeIi26gidnbkgCGIPPjzJwyPs1ijMJz6W2lPAXS6Tfc8+vN6QFumUDlTq
 rKwm33Pi339RXEF59StpQq3GKAimn20k7yGCK9NZetue+f1MzZrb/UubxvsKH+U1Scvo
 pEKRBTUbaCHo5CfXeFghwROYaFS1ZlZFez8KVb5cwGhzmBf+hBC1R4hX0eu0iEgnGDwM
 zHXi9KcWYzZclfinfC0W7L/YDfd0gvmsXkKL02o1MDpBav4aIOn2UI2GsSQzyYfyBWFJ
 08yZq1uzWip9OoJyoSbr9bfPHzxL1zQQ4w8eINV6w9Tu2mCGYxfQj3lBosi6pohItmtQ oA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a846beprv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 11:23:14 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 175FEAwI029064;
        Thu, 5 Aug 2021 15:23:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3a4wsj28e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 15:23:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 175FNAml50790670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 15:23:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AC3B4C052;
        Thu,  5 Aug 2021 15:23:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C09224C066;
        Thu,  5 Aug 2021 15:23:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.150.16])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Aug 2021 15:23:09 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] powerpc/pseries: Fix update of LPAR security flavor after LPM
Date:   Thu,  5 Aug 2021 17:23:08 +0200
Message-Id: <20210805152308.33988-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Uthitbwvlqbjp2dE_DIA7AA5jeqzhNgf
X-Proofpoint-GUID: Uthitbwvlqbjp2dE_DIA7AA5jeqzhNgf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_05:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=798
 malwarescore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108050092
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After LPM, when migrating from a system with security mitigation enabled to
a system with mitigation disabled, the security flavor exposed in /proc is
not correctly set back to 0.

Do not assume the value of the security flavor is set to 0 when entering
init_cpu_char_feature_flags(), so when called after a LPM, the value is set
correctly even if the mitigation are not turned off.

Fixes: 6ce56e1ac380 ("powerpc/pseries: export LPAR security flavor in
lparcfg")

Cc: stable@vger.kernel.org # 5.13.x
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/setup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 6b0886668465..0dfaa6ab44cc 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -539,9 +539,10 @@ static void init_cpu_char_feature_flags(struct h_cpu_char_result *result)
 	 * H_CPU_BEHAV_FAVOUR_SECURITY_H could be set only if
 	 * H_CPU_BEHAV_FAVOUR_SECURITY is.
 	 */
-	if (!(result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY))
+	if (!(result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY)) {
 		security_ftr_clear(SEC_FTR_FAVOUR_SECURITY);
-	else if (result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY_H)
+		pseries_security_flavor = 0;
+	} else if (result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY_H)
 		pseries_security_flavor = 1;
 	else
 		pseries_security_flavor = 2;
-- 
2.32.0

