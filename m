Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD0697B6E
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 13:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjBOMGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 07:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBOMGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 07:06:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B4F38642
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 04:05:38 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31F9o4ik017952;
        Wed, 15 Feb 2023 12:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vHKPzMQmU6nsyJNTx2bOwTig9zzaWSMSuLpy4Yp+RcM=;
 b=qYT0ao6qdVatb2LEu9hHflx/7TCYdV2KCajJfXsj80KrJEPt5e6XoC9CeHhl99eDtYas
 RwGpmZkqxT7HYhRKtvyyo7tBk3T0S0xQwO6w+ic1KTOS0Oh6WhggINT3f/ZknCo6+xVa
 j5iG7sw2bVLEq+so/asFa360LHyftqv+2y7zKaku1TGLTCoJ+1BmeqkRoOjuLwMprLl4
 tmUf7zDfnHUZblcLsLxt+QbiSCScR2W0QWngla0jo7hxxXAfMD41GbJLWwyqbiTE/UVL
 ivlihl3DYlS+J0tnREG99Hb9DcoviLX+5p/sAj70tvd4WrefJHurKQaQ0UJbt+ot/9Xz zA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrw3w37vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 12:05:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FC0COM011341;
        Wed, 15 Feb 2023 12:05:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6wb2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 12:05:08 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FC520l23921308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 12:05:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8FB220043;
        Wed, 15 Feb 2023 12:05:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65F022005A;
        Wed, 15 Feb 2023 12:05:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 12:05:02 +0000 (GMT)
From:   Sumanth Korikkar <sumanthk@linux.ibm.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        debian-s390@lists.debian.org, debian-kernel@lists.debian.org
Cc:     svens@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        sumanthk@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: [PATCH 1/1] s390/signal: fix endless loop in do_signal
Date:   Wed, 15 Feb 2023 13:04:13 +0100
Message-Id: <20230215120413.949348-2-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230215120413.949348-1-sumanthk@linux.ibm.com>
References: <20230215120413.949348-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JkE-JhRCFtCznPcI80vZ80ORfa5nbqi3
X-Proofpoint-GUID: JkE-JhRCFtCznPcI80vZ80ORfa5nbqi3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=869 adultscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No upstream commit exists.

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

