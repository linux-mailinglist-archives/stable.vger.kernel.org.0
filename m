Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B5F69E01B
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 13:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjBUMTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 07:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjBUMTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 07:19:10 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1332685E
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 04:18:54 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L9kloi002342;
        Tue, 21 Feb 2023 12:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=qcppdkim1;
 bh=xI6uSMx7I53S2Lu2zMegkOdmxA34BlD0b/sadna6lwU=;
 b=C5NAAjW1ye8fJgo+che3iepMuBPQ7J3qDu/v204UNEht/Q+GMJ/UTHwVY3piqdrwtuvx
 85fGYWVsD8m6xmCusNAY8Z1qtKDJMm7jAdadCbs+/Sd0bqu8Ar16P2u2oh0anxmBfFZB
 huhDcwyTdCvZgeIJWmAJ4aXnrpfgJ/JAkneIbpZSo/J7j49DE7L722e+lWR5jYaQWpyV
 uivlP3pvm0TJjEgQ+ADRi7JkpGXMC59mbBMAt7GIGLKlH3GzN+kPthHmx2IqZMjhGOR6
 pqkeMU1/WEmOd1KkOINYYtZaiub29MuTjO4eYqzcHuV9zDAMHUCjJsL8p6/xmV/7Qmal dg== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nvtmm0dve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 12:03:31 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
        by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 31LC3QB4032493;
        Tue, 21 Feb 2023 12:03:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3ntqrke659-1;
        Tue, 21 Feb 2023 12:03:26 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LC3Q7o032488;
        Tue, 21 Feb 2023 12:03:26 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-c-spathi-hyd.qualcomm.com [10.213.108.59])
        by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 31LC3Qr0032487;
        Tue, 21 Feb 2023 12:03:26 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 212714)
        id BFAAA485A; Tue, 21 Feb 2023 17:33:25 +0530 (+0530)
From:   Srinivasarao Pathipati <quic_spathi@quicinc.com>
To:     stable@vger.kernel.org, gregkh@google.com
Cc:     Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Subject: [PATCH V1] rcu-tasks: Fix build error
Date:   Tue, 21 Feb 2023 17:33:22 +0530
Message-Id: <1676981002-27312-1-git-send-email-quic_spathi@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: cL8NIng-r92sapg55L8VXfE2gyEVeNCm
X-Proofpoint-ORIG-GUID: cL8NIng-r92sapg55L8VXfE2gyEVeNCm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_06,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 clxscore=1011 mlxlogscore=604 mlxscore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210101
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>

Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
fix below compilation error.
This is applicable to only 5.10 kernels as code got modified
in latest kernels.

 In file included from kernel/rcu/update.c:579:0:
 kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
  static void show_rcu_tasks_rude_gp_kthread(void) {}

Fixes: 8344496e8b49 ("rcu-tasks: Conditionally compile show_rcu_tasks_gp_kthreads()")
Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
---
v1->v2:
- Added Fixes tag
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 8b51e6a..53ddb4e 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -707,7 +707,7 @@ static void show_rcu_tasks_rude_gp_kthread(void)
 #endif /* #ifndef CONFIG_TINY_RCU */
 
 #else /* #ifdef CONFIG_TASKS_RUDE_RCU */
-static void show_rcu_tasks_rude_gp_kthread(void) {}
+static inline void show_rcu_tasks_rude_gp_kthread(void) {}
 #endif /* #else #ifdef CONFIG_TASKS_RUDE_RCU */
 
 ////////////////////////////////////////////////////////////////////////
-- 
2.7.4

