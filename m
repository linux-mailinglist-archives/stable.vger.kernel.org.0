Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756BF6D40DC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjDCJmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjDCJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 05:41:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22D2D300
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 02:41:22 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3339Z2Pp002195;
        Mon, 3 Apr 2023 09:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Iz7mbwgPlKyxjKpbFvJlivCD5T324+5JzkcFV6+8eAs=;
 b=diw2JdAM7fREdOECM+gfdoRmm+MfyQF+BGrD3ubn37VZKiMnNC7J8Ka8HiD3ayjxYQ+2
 7y7C0eQq3hobHxpQELbCNHzq4+suGU6UWLFyxF6kV5kxcH3M8ad+esz42gzkoORF1xBH
 Z6wHbo8ncqd737zetbjxmju47CPP0mJA/pCjIou+OhOdfOIXurQ/Zp5IDh9pIuPPs/RN
 ONswk0/EK3AfCuMVyYri3COHPpxzYf3ut6FxTkv3tSCch0mymlI1Cfz3nYdupjcRNY4P
 gP6ox2xVVa7Q/C4WAnZyBz7lD2crJlb+UYZX4d4yfdAlt30L0YVYX5jKNx7UN8iJPoli Cw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqva1045c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 09:41:20 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 332KMrWm024715;
        Mon, 3 Apr 2023 09:41:18 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ppc86s4y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 09:41:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3339fEfx28770986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 09:41:14 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 769D220040;
        Mon,  3 Apr 2023 09:41:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 480702004F;
        Mon,  3 Apr 2023 09:41:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 09:41:14 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10.y] s390/uaccess: add missing earlyclobber annotations to __clear_user()
Date:   Mon,  3 Apr 2023 11:41:12 +0200
Message-Id: <20230403094112.1324790-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <2023040336-reformist-kinship-d451@gregkh>
References: <2023040336-reformist-kinship-d451@gregkh>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UFgDzPBlNWPtrIOl_2xkcezCrmvLMZc-
X-Proofpoint-ORIG-GUID: UFgDzPBlNWPtrIOl_2xkcezCrmvLMZc-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_06,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxlogscore=592
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030073
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 89aba4c26fae4e459f755a18912845c348ee48f3 upstream.

Add missing earlyclobber annotation to size, to, and tmp2 operands of the
__clear_user() inline assembly since they are modified or written to before
the last usage of all input operands. This can lead to incorrect register
allocation for the inline assembly.

Fixes: 6c2a9e6df604 ("[S390] Use alternative user-copy operations for new hardware.")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/all/20230321122514.1743889-3-mark.rutland@arm.com/
Cc: stable@vger.kernel.org
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/lib/uaccess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 0267405ab7c6..fcfd78f99cb4 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -339,7 +339,7 @@ static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size
 		"4: slgr  %0,%0\n"
 		"5:\n"
 		EX_TABLE(0b,2b) EX_TABLE(3b,5b)
-		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
+		: "+&a" (size), "+&a" (to), "+a" (tmp1), "=&a" (tmp2)
 		: "a" (empty_zero_page), "d" (reg0) : "cc", "memory");
 	return size;
 }
-- 
2.37.2

