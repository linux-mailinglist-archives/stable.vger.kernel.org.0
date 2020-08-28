Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11225255E48
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 17:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgH1P5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 11:57:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725814AbgH1P5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 11:57:36 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07SFWLnU196384
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 11:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=xwaYSLoxmns2el18FYWD+ToqOB1XEL3eZs5vUHh0AQY=;
 b=QpNvfhaXRX4ksqrl05//H1U7wVs1JlsVU+unAZ+d5uF98x8Bc3PJzcg8zBJvpL9oxsjz
 quUZl3cX2Ae8v/kh69D9uckkk+fD6EgCYH0qQcXuqebuHU+MZIhnaZIev3q8eO8QRqAA
 C2gpGhh5oJEGM2OkUvS7+YjsZh0TNSaK8Is/lAIX0mEhIaWYHNgdnOIWRe6bjX5j5UdE
 IVkrL7YKqOCmhPth8lVCgmwbwh7cj/9Scs0EDKp3e32BRq6AAaka1AOhfo3OYLAQyyT7
 Yu9PR4LTBx/Fd7A1kyFvcG94qbnP0kgt5wfzS483eiB5QSovKO9j6dlBtQBfGirPb7Vm QQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3374c9h8kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 11:57:35 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07SFvRUD023249
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 15:57:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 335j271q7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 15:57:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07SFvViq52822514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 15:57:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E830DA4053;
        Fri, 28 Aug 2020 15:57:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3C8CA4040;
        Fri, 28 Aug 2020 15:57:30 +0000 (GMT)
Received: from oc3871087118.ibm.com (unknown [9.145.38.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Aug 2020 15:57:30 +0000 (GMT)
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     hca@linux.ibm.com
Subject: [PATCH] s390/numa: set node distance to LOCAL_DISTANCE
Date:   Fri, 28 Aug 2020 17:57:29 +0200
Message-Id: <1598630249-11057-1-git-send-email-agordeev@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_09:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=772 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 suspectscore=1 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280116
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 535e4fc623fab2e09a0653fc3a3e17f382ad0251 upstream.

The original upstream commit applies only to 5.7 and 5.8
stable trees. This is backport to 4.4, 4.9, 4.14, 4.19
and 5.4 trees.

The node distance is hardcoded to 0, which causes a trouble
for some user-level applications. In particular, "libnuma"
expects the distance of a node to itself as LOCAL_DISTANCE.
This update removes the offending node distance override.

Cc: Heiko Carstens <hca@linux.ibm.com>
Fixes: 3a368f742da1 ("s390/numa: add core infrastructure")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/numa/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/numa/numa.c b/arch/s390/numa/numa.c
index d2910fa..8f95db6 100644
--- a/arch/s390/numa/numa.c
+++ b/arch/s390/numa/numa.c
@@ -51,7 +51,7 @@ void numa_update_cpu_topology(void)
 
 int __node_distance(int a, int b)
 {
-	return mode->distance ? mode->distance(a, b) : 0;
+	return mode->distance ? mode->distance(a, b) : LOCAL_DISTANCE;
 }
 EXPORT_SYMBOL(__node_distance);
 
-- 
1.8.3.1

