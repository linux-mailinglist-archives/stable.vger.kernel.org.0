Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242026B10C4
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 19:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCHSM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 13:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCHSMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 13:12:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0166CE96E
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 10:12:38 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Hqh9b007038;
        Wed, 8 Mar 2023 18:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Bn9r1zYCdkflc7la4XP2PhYaSeUxrKL58egivIQPHkA=;
 b=aiMrIWGJxvXTcffQiTsBpfL1LAAFOib6mDO5Pgvet5S3HeLq06zXSr0BwtY+gSbr2Z3L
 vrb3bOzwCuwkuYAc80orNzktnpewM3vEm6kFLmMLxMJ5gRiz2eBZpUi38nBwahBK035+
 L3LA3j4aozQkHNF0s3W9idB3WAFP1V6f4vdQgqzNlllDZs0amUw81PTnJRNumNn9wPo8
 rg4M+J2TT4wGUBM8lUkKEquotLYKIVaXofG9Lauv12g7CX0X/Pmu5UXmKAopqiP4q2VY
 Xquiews9ZXbiWI61+DmwvE29SxQkN/Cx2/6feQQPYRxwAAlEbjuFqgzsHXMT49WoZS06 tA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6s9aap3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 18:12:37 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 328HqTh4003004;
        Wed, 8 Mar 2023 18:12:35 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p6g0jgvcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 18:12:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328ICWL733817318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 18:12:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0994220043;
        Wed,  8 Mar 2023 18:12:32 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F8CC20040;
        Wed,  8 Mar 2023 18:12:31 +0000 (GMT)
Received: from localhost (unknown [9.171.38.19])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  8 Mar 2023 18:12:31 +0000 (GMT)
Date:   Wed, 8 Mar 2023 19:12:30 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH stable 4.14 4.19 2/2] s390/setup: init jump labels before
 command line parsing
Message-ID: <patch-2.thread-194e16.git-194e16c6cfe3.your-ad-here.call-01678297576-ext-9970@work.hours>
References: <cover.thread-194e16.your-ad-here.call-01678297576-ext-9970@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.thread-194e16.your-ad-here.call-01678297576-ext-9970@work.hours>
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fNQgihLY3wduzsHNhxH-T7diTiowzrUx
X-Proofpoint-GUID: fNQgihLY3wduzsHNhxH-T7diTiowzrUx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_12,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=888
 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080154
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 95e61b1b5d6394b53d147c0fcbe2ae70fbe09446 upstream.

Command line parameters might set static keys. This is true for s390 at
least since commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1
and init_on_free=1 boot options"). To avoid the following WARN:

static_key_enable_cpuslocked(): static key 'init_on_alloc+0x0/0x40' used
before call to jump_label_init()

call jump_label_init() just before parse_early_param().
jump_label_init() is safe to call multiple times (x86 does that), doesn't
do any memory allocations and hence should be safe to call that early.

Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Cc: <stable@vger.kernel.org> # 5.3: d6df52e9996d: s390/maccess: add no DAT mode to kernel_write
Cc: <stable@vger.kernel.org> # 5.3
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index bfd6c01a68f0..f54f5bfd83ad 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -909,6 +909,7 @@ void __init setup_arch(char **cmdline_p)
 	if (IS_ENABLED(CONFIG_EXPOLINE_AUTO))
 		nospec_auto_detect();
 
+	jump_label_init();
 	parse_early_param();
 #ifdef CONFIG_CRASH_DUMP
 	/* Deactivate elfcorehdr= kernel parameter */
-- 
2.38.1
