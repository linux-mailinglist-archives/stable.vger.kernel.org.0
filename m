Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A483A6C0FC6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjCTKyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCTKxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:53:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F6812F17
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:50:27 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KAXXFr024220
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tVKP/OOcKh9BI0Zq7OkJFhEuLzZhfwIjYB8j4HYfsiQ=;
 b=PiIZxXDaeNk2gQWeiAQmuDjz8SCG40I9MzjkbZr5TFG7O8H20JWK5h6ZhPcpRX2ftJYC
 YOZGUfpsZECRZ48iXFlshjflvHxKdGK7ac0b0AZiuMV5VJEOxhyzcEhrK54N+1RzszVm
 c4DW6+9C1frAP6fyw1bLq/f1r2+9AqqanXIN+ckWaa3ohB0hSZopOSaRCiWGq0/GG2xX
 mg/KJzLowDkaSrVUjWd2SGPRgLWpA9/abVkAqNXO8yxPJZoCFvsX79F1D75b1Ln5XOOm
 Po4uiFRnY9OKTFdpkhfehNr5q0aTKMxsVt9FORLsdpqdf+9DqDVdWPA9CrXatTs9EQl5 Vw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdprjdtp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:49:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32K4SrZV015046
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:49:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pd4jfb44r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:49:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32KAnOSx25494036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 10:49:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EF1F2004B;
        Mon, 20 Mar 2023 10:49:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F342D2004D;
        Mon, 20 Mar 2023 10:49:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Mar 2023 10:49:23 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55390)
        id B4198E038D; Mon, 20 Mar 2023 11:49:23 +0100 (CET)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     gor@linux.ibm.com
Subject: [PATCH 5.4.y] s390/ipl: add missing intersection check to ipl_report handling
Date:   Mon, 20 Mar 2023 11:49:18 +0100
Message-Id: <20230320104918.421601-1-svens@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <1679303913560@kroah.com>
References: <1679303913560@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NCb9MQrgIb8WUL-21mm90uNe_UkHhNam
X-Proofpoint-GUID: NCb9MQrgIb8WUL-21mm90uNe_UkHhNam
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_06,2023-03-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

