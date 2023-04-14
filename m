Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF8C6E1A87
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 04:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDNCsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 22:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDNCsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 22:48:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C0040E7
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 19:48:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33DKxD6o006509;
        Fri, 14 Apr 2023 02:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=q+/WCzkQR7NWqUUKC1Ckq5z60vFKHaO9tqWYBdpJySw=;
 b=mNkLFt3LIN0b8t6P8SBLLcuceqmoWrWLWI2Pww4i1XOYtuOPTrjJQlx3ex+D1o6Pi6yv
 VUIQYwZXQ5arEr97J+0j/qM3ybfeDfp9gWs/LeMV17UIiwVDpyeRTg0Fmp34KEQFdOhh
 DnRaI9KMsVlptJiUyVqgzEhBuakAxamJfVpcY6c3+si70mBleHo79XvE6RFeEpcctit0
 TkyflFJUVEFGu7SfhvAvF8Wzp8wd8p1qF3qDzc7yADsTg6j0rMaU/XwdanGibBtu9aMY
 ElP56lDCUDlXNQXAFUYMj9+6xNVSw+WXKdF/13ymNqym7YprPhbA02MbsOf9HXBgsh52 sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hcd0kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 02:48:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33E2a1xl012564;
        Fri, 14 Apr 2023 02:48:37 GMT
Received: from localhost.localdomain (dhcp-10-191-135-81.vpn.oracle.com [10.191.135.81])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3puwebnt6f-1;
        Fri, 14 Apr 2023 02:48:37 +0000
From:   Imran Khan <imran.f.khan@oracle.com>
To:     stable@vger.kernel.org
Cc:     paulmck@kernel.org
Subject: [PATCH STABLE 5.15.y] Reduce IPI overload when multiple CPUs cat /proc/cpuinfo.
Date:   Fri, 14 Apr 2023 12:48:30 +1000
Message-Id: <20230414024830.653235-1-imran.f.khan@oracle.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_18,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140024
X-Proofpoint-GUID: wcGM6fUMPjmm_wuo6eKS9N-cDE820m1j
X-Proofpoint-ORIG-GUID: wcGM6fUMPjmm_wuo6eKS9N-cDE820m1j
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On large systems with few hundred CPUs, when applications on
each or most of these CPUs read proc/cpuinfo we get an IPI
storm and situation gets worse if one of the CPUs can't respond
to these IPIs timely.

commit f4deaf90212c ('x86/cpu: Avoid cpuinfo-induced IPI pileups')
addresses this but in the following call chain:

show_cpuinfo
    |
    |-- aperfmperf_get_khz
                |
                |-- aperfmperf_snapshot_cpu

aperfmperf_snapshot_cpu gets invoked with wait=true and this means
we endup doing a smp_call_function_single to destination CPU, even
if its ->scfpending is set.

Avoid this by making sure that even with wait=true, IPI is send only
if ->scfpending is not set.

Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
---

I am trying this approach (assuming that its okay) to avoid backporting
multiple upstream patches to fix this single issue. Kindly let me know if
its okay or would it be better to backport the relevant upstream patches
instead.

 arch/x86/kernel/cpu/aperfmperf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 22911deacb6e4..39fc390cc56af 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -69,6 +69,7 @@ static void aperfmperf_snapshot_khz(void *dummy)
 
 static bool aperfmperf_snapshot_cpu(int cpu, ktime_t now, bool wait)
 {
+	int this_cpu;
 	s64 time_delta = ktime_ms_delta(now, per_cpu(samples.time, cpu));
 	struct aperfmperf_sample *s = per_cpu_ptr(&samples, cpu);
 
@@ -76,8 +77,14 @@ static bool aperfmperf_snapshot_cpu(int cpu, ktime_t now, bool wait)
 	if (time_delta < APERFMPERF_CACHE_THRESHOLD_MS)
 		return true;
 
-	if (!atomic_xchg(&s->scfpending, 1) || wait)
+	if (!atomic_xchg(&s->scfpending, 1))
 		smp_call_function_single(cpu, aperfmperf_snapshot_khz, NULL, wait);
+	else if (wait) {
+		this_cpu = get_cpu();
+		while (atomic_read(&s->scfpending))
+			cpu_relax();
+		put_cpu();
+	}
 
 	/* Return false if the previous iteration was too long ago. */
 	return time_delta <= APERFMPERF_STALE_THRESHOLD_MS;
-- 
2.34.1

