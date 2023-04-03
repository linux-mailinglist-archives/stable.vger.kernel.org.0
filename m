Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DA46D40F0
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjDCJmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjDCJmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 05:42:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225DA1116C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 02:42:05 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3339VSgc010394;
        Mon, 3 Apr 2023 09:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Iz7mbwgPlKyxjKpbFvJlivCD5T324+5JzkcFV6+8eAs=;
 b=MoY3tzjtx7PEpdXNmx4Ka2oBTOEkrO3VIWvxYdnh6kDeJwl3D8I0LJ54Z8dmPbss/ql3
 Rf+HvYj+8Fzzj7zHWoYMZwFbh1H9R+KEck5jXNFsU+8pYFxCf93c88Uv1sT5rJKkI1h4
 pslD43tJjs5oRp9UgrDZ7A+V/22cchKM/DvfZkbw6F6CG1/anasxZLC7G1A5H72GS9DH
 MZU/YHmkWC/jXkEvwBEYsFyYe5x7gggdjnPq1OAiz10jSZzc52IJgyqhAZEm6gEYvmoh
 1RnJhsWIVOmiqnkNHQO9Co6eQYsx/VVp2/xCC4yennfBuAlwka1XcB/AjU0z8ebwnwsR rA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqv8086w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 09:42:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3331Mqc5015135;
        Mon, 3 Apr 2023 09:42:00 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg1gbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 09:42:00 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3339fuS321365484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 09:41:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB49D2004B;
        Mon,  3 Apr 2023 09:41:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EDD520043;
        Mon,  3 Apr 2023 09:41:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 09:41:56 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4.y] s390/uaccess: add missing earlyclobber annotations to __clear_user()
Date:   Mon,  3 Apr 2023 11:41:55 +0200
Message-Id: <20230403094155.1325215-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <2023040337-opposing-arrange-ad10@gregkh>
References: <2023040337-opposing-arrange-ad10@gregkh>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3TstlVN59vVssxJUB7liZdiqniPyNgSy
X-Proofpoint-GUID: 3TstlVN59vVssxJUB7liZdiqniPyNgSy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_05,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=592 mlxscore=0
 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030073
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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

