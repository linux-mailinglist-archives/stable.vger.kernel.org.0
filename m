Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CF96BADE4
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjCOKkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 06:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjCOKkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 06:40:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A8956526
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 03:40:43 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32F7jcHK016154;
        Wed, 15 Mar 2023 10:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=Zf0KBamLAf13JBXhDS2L1Sdm48moNY3TXcqRFJTzG+I=;
 b=F2RoIU7MHsyq9JRSL4Z9y297N4mIySMHY75JGR4hfd8lTVOry+OSQ2r31Cd1n5Zhe9BP
 VjoHzRAJBtvTTiXUlquswJBipv0AUr409DBX1ABNuQq/n0H+YnxSoVruYzghF0uRQnTZ
 5oKx9p6QXvz8VBmGNkDY1IPntaikVCd8Arl3wD3hN9PsynaxZTYr3p4LbwL2NP3JlVZT
 FAlRi+aAKdyRI4eRPi/xk4gKVqAcGEueEJB51+8O++bBlEwnJ6sAF1XmN4aWtkhgI7W+
 2OD4x/tyPk19VXbIflHNdokdbS+BkDebFbVX43jeeoFXhGVZv10EZfEKtxXssu7wPrd8 ig== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2cyh09u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 10:40:17 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32F9PX9f012185;
        Wed, 15 Mar 2023 10:40:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pb32t4jy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 10:40:16 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FAeG0r034440;
        Wed, 15 Mar 2023 10:40:16 GMT
Received: from ca-dev110.us.oracle.com (ca-dev110.us.oracle.com [10.129.136.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pb32t4jx8-1;
        Wed, 15 Mar 2023 10:40:16 +0000
From:   Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
To:     tglx@linutronix.de
Cc:     rhythm.m.mahajan@oracle.com, mingo@redhat.com, hpa@zytor.com,
        bp@suse.de, gregkh@linuxfoundation.org,
        pawan.kumar.gupta@linux.intel.com, cascardo@canonical.com,
        surajjs@amazon.com, daniel.sneddon@linux.intel.com,
        peterz@infradead.org, stable@vger.kernel.org
Subject: [PATCH 4.14 v2] x86/cpu: Fix LFENCE serialization check in init_amd()
Date:   Wed, 15 Mar 2023 03:40:15 -0700
Message-Id: <20230315104015.3607718-1-rhythm.m.mahajan@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_04,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150091
X-Proofpoint-GUID: ckIABhYzd_rcIijhWFlDi0WtYalH-j1h
X-Proofpoint-ORIG-GUID: ckIABhYzd_rcIijhWFlDi0WtYalH-j1h
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
which was backported from the upstream commit: 2632daebafd0 renamed the
MSR_F10H_DECFG_LFENCE_SERIALIZE macro to MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
The fix for 4.14 and 4.9 changed MSR_F10H_DECFG_LFENCE_SERIALIZE to
MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in the init_amd() function, but
should have used MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
This causes a discrepency in the LFENCE serialization check in the
init_amd() function.

This causes a ~16% sysbench memory regression, when running:
    sysbench --test=memory run

Fixes: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
Signed-off-by: Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
---
v1->v2
Corrected the formatting of the commit message.

---
The test result before the commit 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")

    $ sysbench --test=memory run
    sysbench 1.0.17 (using system LuaJIT 2.0.4)

    Running the test with following options:
    Number of threads: 1
    Initializing random number generator from current time

    Running memory speed test with the following options:
      block size: 1KiB
      total size: 102400MiB
      operation: write
      scope: global

    Initializing worker threads...

    Threads started!

    Total operations: 27466829 (2746182.07 per second)

    26823.08 MiB transferred (2681.82 MiB/sec)

    General statistics:
        total time:                          10.0001s
        total number of events:              27466829

    Latency (ms):
             min:                                    0.00
             avg:                                    0.00
             max:                                    0.20
             95th percentile:                        0.00
             sum:                                 4041.60

    Threads fairness:
        events (avg/stddev):           27466829.0000/0.00
        execution time (avg/stddev):   4.0416/0.00

The test result after the commit 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")

    $ sysbench --test=memory run
    sysbench 1.0.17 (using system LuaJIT 2.0.4)

    Running the test with following options:
    Number of threads: 1
    Initializing random number generator from current time

    Running memory speed test with the following options:
      block size: 1KiB
      total size: 102400MiB
      operation: write
      scope: global

    Initializing worker threads...

    Threads started!

    Total operations: 33758407 (3375232.84 per second)

    32967.19 MiB transferred (3296.13 MiB/sec)

    General statistics:
        total time:                          10.0001s
        total number of events:              33758407

    Latency (ms):
             min:                                    0.00
             avg:                                    0.00
             max:                                    0.06
             95th percentile:                        0.00
             sum:                                 4115.95

    Threads fairness:
        events (avg/stddev):           33758407.0000/0.00
        execution time (avg/stddev):   4.1160/0.00
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ee5d0f943ec8..4122afeaaaff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -941,7 +941,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * serializing.
 		 */
 		ret = rdmsrl_safe(MSR_AMD64_DE_CFG, &val);
-		if (!ret && (val & MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)) {
+		if (!ret && (val & MSR_AMD64_DE_CFG_LFENCE_SERIALIZE)) {
 			/* A serializing LFENCE stops RDTSC speculation */
 			set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 		} else {
-- 
2.39.2

