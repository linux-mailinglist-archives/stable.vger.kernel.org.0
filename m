Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1D697E22
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 15:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjBOON4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 09:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBOONz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 09:13:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD95535270
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 06:13:54 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FDhiJ8017736;
        Wed, 15 Feb 2023 14:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QAbFrsgORo89cmWrwGOq5/b4ZY3NtE6VIqG1GKGUtc4=;
 b=PWslYkOS6p10G5CLlO/nFNB7Utn3M8jwmnYq2whXPYlfPNPe48/q57TytlEC4473mfaB
 HDvjcOPc0roebbMk8Mk37S5U1Iv0D8VKAL0aC4TPqydThbrZGocqRjVN2qJ59piVMJBL
 M5dsQ+8MZx9DYTlYTEN2ADRpstVbC0YrVbbLklZYE48olcvOt3yu2txy5H21MW4gdV4N
 RP1gScxstSWEoVa+s1N6Zt+KYU6o9lrCnjkO/14hfBL/XczcAikdj2ynceETH1m/mGni
 INz7HQQ+kUUA8tWIBBRbkxi/LotH+Q+EC0rckYo6h1zf0So6kG7OWQQTwa8cWhIpTL53 dw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns0hgh0a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 14:13:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31ELk53s031205;
        Wed, 15 Feb 2023 14:13:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3np2n6c0st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 14:13:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FEDghp26411672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 14:13:42 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55E222004D;
        Wed, 15 Feb 2023 14:13:42 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ED252004B;
        Wed, 15 Feb 2023 14:13:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 14:13:42 +0000 (GMT)
From:   Sumanth Korikkar <sumanthk@linux.ibm.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        debian-s390@lists.debian.org, debian-kernel@lists.debian.org
Cc:     svens@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        sumanthk@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: [PATCH v2 1/1] s390/signal: fix endless loop in do_signal
Date:   Wed, 15 Feb 2023 15:13:24 +0100
Message-Id: <20230215141324.1239245-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0_CC2CR8Dv1SS2S0_rbCs6PPV9K5LhSb
X-Proofpoint-ORIG-GUID: 0_CC2CR8Dv1SS2S0_rbCs6PPV9K5LhSb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=598 mlxscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150126
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No upstream commit exists: the problem addressed here is that 
'commit 75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")' 
was backported to 5.10. This commit is broken, but nobody noticed
upstream, since shortly after s390 converted to generic entry with
'commit 75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")', which
implicitly fixed the problem outlined below.

Thread flag is set to TIF_NOTIFY_SIGNAL for io_uring work.  The io work
user or syscall calls do_signal when either one of the TIF_SIGPENDING or
TIF_NOTIFY_SIGNAL flag is set.  However, do_signal does consider only
TIF_SIGPENDING signal and ignores TIF_NOTIFY_SIGNAL condition.  This
means get_signal is never invoked  for TIF_NOTIFY_SIGNAL and hence the
flag is not cleared, which results in an endless do_signal loop.

Reference: 'commit 788d0824269b ("io_uring: import 5.15-stable io_uring")'
Fixes: 75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")
Cc: stable@vger.kernel.org  # 5.10.162
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 arch/s390/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index b27b6c1f058d..9e900a8977bd 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -472,7 +472,7 @@ void do_signal(struct pt_regs *regs)
 	current->thread.system_call =
 		test_pt_regs_flag(regs, PIF_SYSCALL) ? regs->int_code : 0;
 
-	if (test_thread_flag(TIF_SIGPENDING) && get_signal(&ksig)) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
 		if (current->thread.system_call) {
 			regs->int_code = current->thread.system_call;
-- 
2.37.2

