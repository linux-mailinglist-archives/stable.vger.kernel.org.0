Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A7558287D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 16:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiG0OWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 10:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiG0OWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 10:22:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9B819C2C
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 07:22:10 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26REDLIZ005454
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 14:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GTA1IkkB/z/JAvfdXKvgu5JA1PGCFIiDnCpqA394hz4=;
 b=UAi19kyEeD8dgXen63xcYfQocCghWpNC+ZSgQg8rlf0+WJWuV5Ocr2VHD7zsJmhgVVHh
 pOpC6ILghct4DVo6vx61v33Ka3Q+v8SObupDbFqpnAPjMzl+SWX2QMgyNLk//eP9KoEy
 HAbk47DF7pHy4RkObZyrsrasF52QfKRanqgW4pn+vkZtthbgKxocgwzycQmJqWb0n4yV
 K4F4k7R9IwvrWEPD51UpMqVPnqxxcCwFuDzp1uCfiQO8vMO7EdWyQKxN6m9UqEaBQDlR
 2JPOXXiyWW1ZXOysMWlJCY/KyCi6cuQjoSqOZ85hp+44xY3TJocyaRoM6f4oCENJl7mf vQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hk6xagf73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 14:22:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26RE7QtK031612
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 14:22:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hg97td56s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 14:22:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26REM4v616712016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 14:22:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1C24A405F;
        Wed, 27 Jul 2022 14:22:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5A74A405C;
        Wed, 27 Jul 2022 14:22:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jul 2022 14:22:03 +0000 (GMT)
From:   Sumanth Korikkar <sumanthk@linux.ibm.com>
To:     gor@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH] s390/unwind: Fix fgraph return address recovery
Date:   Wed, 27 Jul 2022 16:21:43 +0200
Message-Id: <20220727142143.746445-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TUaCdk9iZNvXoWSrIfrFg86lnpyeyLS_
X-Proofpoint-ORIG-GUID: TUaCdk9iZNvXoWSrIfrFg86lnpyeyLS_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_05,2022-07-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 clxscore=1011 adultscore=0 lowpriorityscore=0
 mlxlogscore=414 suspectscore=0 mlxscore=0 impostorscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When HAVE_FUNCTION_GRAPH_RET_ADDR_PTR is defined, the return
address to the fgraph caller is recovered by tagging it along with the
stack pointer of ftrace stack. This makes the stack unwinding more
reliable.

When the fgraph return address is modified to return_to_handler,
ftrace_graph_ret_addr tries to restore it to the original
value using tagged stack pointer.

Fix this by passing tagged sp to ftrace_graph_ret_addr.

Fixes: d81675b60d09 ("s390/unwind: recover kretprobe modified return address in stacktrace")
Cc: <stable@vger.kernel.org> # 5.18
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 arch/s390/include/asm/unwind.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/unwind.h b/arch/s390/include/asm/unwind.h
index 0bf06f1682d8..02462e7100c1 100644
--- a/arch/s390/include/asm/unwind.h
+++ b/arch/s390/include/asm/unwind.h
@@ -47,7 +47,7 @@ struct unwind_state {
 static inline unsigned long unwind_recover_ret_addr(struct unwind_state *state,
 						    unsigned long ip)
 {
-	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx, ip, NULL);
+	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx, ip, (void *)state->sp);
 	if (is_kretprobe_trampoline(ip))
 		ip = kretprobe_find_ret_addr(state->task, (void *)state->sp, &state->kr_cur);
 	return ip;
-- 
2.36.1

