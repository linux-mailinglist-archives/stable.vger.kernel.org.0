Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50C6B10C2
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 19:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCHSMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 13:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCHSMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 13:12:52 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2062CEFAE
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 10:12:35 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328HqfvN021271;
        Wed, 8 Mar 2023 18:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=CHL35NMHTtHGe0NqG4Uys298HhUPg+wRb6chQzivYZw=;
 b=dhRrM6k6HYJFlyePgE5qIT+sJXlsxsGRk9I0/yIDG5w6K/2IMIkkY/mRHTSUKoupvQMU
 NXAwPdcjK7oZnP1VlZhCHDs9Y3VlzSJv5TzA9ipOH6PItHQry02z1xXwmqRq8eqE+alY
 j/NAjM+ho5oBg7JqNVXZiiZJAeYTxUVqF/JTtseCMWDMeZ3W+wWmH6OyiQPBTV/RrSdT
 34OiqkH/EjMXPeS50Q6e/g8dsbqkKByC8WvNaNJvo72vdVXr9SNDRypoCv7A4nOfzYSa
 KYX3wLYd32RR+ErUCxhrEsroC6plyLNz2dwW2BZ1b+51m3/gdQ7ZRGXiGrLj2C9l3d6e 7w== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6suk9prf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 18:12:34 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 328134ti015019;
        Wed, 8 Mar 2023 18:12:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3p6gbw8uw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 18:12:32 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328ICTbU51642694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 18:12:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44ED320040;
        Wed,  8 Mar 2023 18:12:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA5D52004B;
        Wed,  8 Mar 2023 18:12:28 +0000 (GMT)
Received: from localhost (unknown [9.171.38.19])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  8 Mar 2023 18:12:28 +0000 (GMT)
Date:   Wed, 8 Mar 2023 19:12:27 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH stable 4.14 4.19 1/2] s390/maccess: add no DAT mode to
 kernel_write
Message-ID: <patch-1.thread-194e16.git-29698e760f88.your-ad-here.call-01678297576-ext-9970@work.hours>
References: <cover.thread-194e16.your-ad-here.call-01678297576-ext-9970@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.thread-194e16.your-ad-here.call-01678297576-ext-9970@work.hours>
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CsL54IQr6I5Bvod5L2_h3MbL7x6UypcA
X-Proofpoint-ORIG-GUID: CsL54IQr6I5Bvod5L2_h3MbL7x6UypcA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_11,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxlogscore=645
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d6df52e9996dcc2062c3d9c9123288468bb95b52 upstream.

The backport has been slightly adjusted to avoid a dependency
on the s390/jump_label rework. Specifically, commit a646ef398e72
("s390/jump_label: replace stop_machine with smp_call_function") depends
on HAVE_ARCH_JUMP_LABEL_RELATIVE, which has not been backported to
versions 4.19 and earlier.

To be able to patch kernel code before paging is initialized do plain
memcpy if DAT is off. This is required to enable early jump label
initialization.

Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/mm/maccess.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 7be06475809b..a40739ea3805 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -58,13 +58,19 @@ static notrace long s390_kernel_write_odd(void *dst, const void *src, size_t siz
  */
 void notrace s390_kernel_write(void *dst, const void *src, size_t size)
 {
+	unsigned long flags;
 	long copied;
 
-	while (size) {
-		copied = s390_kernel_write_odd(dst, src, size);
-		dst += copied;
-		src += copied;
-		size -= copied;
+	flags = arch_local_save_flags();
+	if (!(flags & PSW_MASK_DAT)) {
+		memcpy(dst, src, size);
+	} else {
+		while (size) {
+			copied = s390_kernel_write_odd(dst, src, size);
+			dst += copied;
+			src += copied;
+			size -= copied;
+		}
 	}
 }
 
-- 
2.38.1

