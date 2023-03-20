Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149186C0EE4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCTKdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjCTKdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:33:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643B64205
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:32:48 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32K9KQvU026826
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tVKP/OOcKh9BI0Zq7OkJFhEuLzZhfwIjYB8j4HYfsiQ=;
 b=PnsPlKX2HZ99KsIik2PHbloCt91bGCx895MVgSKTOQRLhD6E+qUYWRhgO27AnmYmKdRU
 8tc+mrSX915ZCrE4sE8/IlCIG8luamVIXgZXQNNwldnpYZ9NrqffKrJmxbkmoOXbszZN
 vUtK3gNY595LefcDSO6nuF9OkCrZEnUsOcKjUx9PdNCv8vPCDeGBXt01gvGI3Q16f5pa
 leH2QhaJltMRQBadiB3Xw6YcnYAjp+RsbNsundx9IrvaWzPyk/2OiSmECdciLhwbqjuj
 /QcOboqgdUXquBKr+xRwQY4CJZmebd3lq1FDegNSE9qsnN3IpLYx16ytzC7rq4oKQ+N1 DA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdpvrw0tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:32:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32JHxGiv011649
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:32:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6aju9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:32:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32KAWXFb13173292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 10:32:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBA302004F;
        Mon, 20 Mar 2023 10:32:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBA3620040;
        Mon, 20 Mar 2023 10:32:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Mar 2023 10:32:32 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55390)
        id 9AC49E038D; Mon, 20 Mar 2023 11:32:32 +0100 (CET)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     gor@linux.ibm.com
Subject: [PATCH 5.10.y] s390/ipl: add missing intersection check to ipl_report handling
Date:   Mon, 20 Mar 2023 11:32:02 +0100
Message-Id: <20230320103202.34739-1-svens@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <16793039081369@kroah.com>
References: <16793039081369@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U9acIwj0IXKbUhcJWOEVKTTUHNHzMGS-
X-Proofpoint-GUID: U9acIwj0IXKbUhcJWOEVKTTUHNHzMGS-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_06,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 clxscore=1011 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The code which handles the ipl report is searching for a free location
in memory where it could copy the component and certificate entries to.
It checks for intersection between the sections required for the kernel
and the component/certificate data area, but fails to check whether
the data structures linking these data areas together intersect.

This might cause the iplreport copy code to overwrite the iplreport
itself. Fix this by adding two addtional intersection checks.

Cc: <stable@vger.kernel.org>
Fixes: 9641b8cc733f ("s390/ipl: read IPL report at early boot")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
(cherry picked from commit a52e5cdbe8016d4e3e6322fd93d71afddb9a5af9)
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
---
 arch/s390/boot/ipl_report.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/s390/boot/ipl_report.c b/arch/s390/boot/ipl_report.c
index 0b4965573656..88bacf4999c4 100644
--- a/arch/s390/boot/ipl_report.c
+++ b/arch/s390/boot/ipl_report.c
@@ -57,11 +57,19 @@ static unsigned long find_bootdata_space(struct ipl_rb_components *comps,
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && INITRD_START && INITRD_SIZE &&
 	    intersects(INITRD_START, INITRD_SIZE, safe_addr, size))
 		safe_addr = INITRD_START + INITRD_SIZE;
+	if (intersects(safe_addr, size, (unsigned long)comps, comps->len)) {
+		safe_addr = (unsigned long)comps + comps->len;
+		goto repeat;
+	}
 	for_each_rb_entry(comp, comps)
 		if (intersects(safe_addr, size, comp->addr, comp->len)) {
 			safe_addr = comp->addr + comp->len;
 			goto repeat;
 		}
+	if (intersects(safe_addr, size, (unsigned long)certs, certs->len)) {
+		safe_addr = (unsigned long)certs + certs->len;
+		goto repeat;
+	}
 	for_each_rb_entry(cert, certs)
 		if (intersects(safe_addr, size, cert->addr, cert->len)) {
 			safe_addr = cert->addr + cert->len;
-- 
2.37.2

