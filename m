Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FDE697F33
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 16:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjBOPOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 10:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjBOPON (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 10:14:13 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4987301A3
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 07:14:09 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FDhuHw005300;
        Wed, 15 Feb 2023 15:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=XxRocGEIxjcg1DHebJnvWeYvpdT9wGPFE+gzHbUCtMg=;
 b=I5jzuxoU8oRR5VxJ8Fjq99gue5ikZOYZDZLsdCzZ/y1jAfzROdl8RdgK3TwEblLksK65
 Nn/unjzcqwQ8vLmJm5yR3RxSNxhBdibg0wlMZXBNXPKYcu0v9YjKocYWwwsIqMQ2BsKB
 auRMoiuMQQh32D1ycYVr42wVq3vjipdgs3KmieryxXe7F4HMWpjg9OmzjDG8eHtArQiv
 JLEkHzOfus56yjMBUzqzuu9ne/vHEniquQnhWVbrM9Rs1IFGt8Cs3w6Y3Z5JIV7eNFIH
 cLdXvUbo7rjfgoe9rjZWx77bglyPRXJKx0IB+bdKIND8WJF0WpytlFaPnKOj3ihaezxp Yw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrxb1qhbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 15:14:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FBplVF017758;
        Wed, 15 Feb 2023 15:14:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6nguw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 15:14:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FFDv0N49086726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 15:13:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FD8920040;
        Wed, 15 Feb 2023 15:13:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E3BB20049;
        Wed, 15 Feb 2023 15:13:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 15:13:57 +0000 (GMT)
From:   Sumanth Korikkar <sumanthk@linux.ibm.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        debian-s390@lists.debian.org, debian-kernel@lists.debian.org
Cc:     svens@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        sumanthk@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: [PATCH v3] s390/signal: fix endless loop in do_signal
Date:   Wed, 15 Feb 2023 16:13:35 +0100
Message-Id: <20230215151335.1448645-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NOu8O55uEo5cjL9XPO1Nw5d1SflqWZtk
X-Proofpoint-GUID: NOu8O55uEo5cjL9XPO1Nw5d1SflqWZtk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=651 spamscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150135
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
'commit 56e62a737028 ("s390: convert to generic entry")', which
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
v2->v3:
Correct changelog.

v1->v2:
Add the changelog.

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

