Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C128069D298
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjBTSOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjBTSOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:14:23 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B94311EAC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:14:22 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31KCD2Ul026569;
        Mon, 20 Feb 2023 18:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=qcppdkim1;
 bh=0K/BuO4oy2MBZ/loFZOdLDJw1ovRx5QkgOa5SP+VKew=;
 b=e5teTtKtl5W+xAouYxhvBzx5JNTmdslsyVERXME0W2s3SebZ5bp8+6oW1qlHiN2MoFkJ
 Zv6/bq2NXmyie7FRW2Ge17dzT+tsRqd4S2S69RvVBhyxNaiQofyFxgskMi1gdefX29xe
 6xeYRabj9Zvrs973Xx4FOJ7e35mvcIuh2f8VG7OFA6FBMax+Q6BfE5195tQxKw6ejK4o
 8WVWDDgFCSwqxCmO5EQvQADvUIrOw6Hv4RoS8IRqfpd6A51T7ui22NRBVl79C84IFTg/
 IpIOQflyjsSluJqUChbjPgyGTeUENQtwurBtbTWvZk7O7XqvH85u+PIGbA2J6L7BsGsW iw== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ntq2entav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Feb 2023 18:14:20 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
        by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 31KIEG8k021265;
        Mon, 20 Feb 2023 18:14:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3ntqrkb2gr-1;
        Mon, 20 Feb 2023 18:14:16 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31KIEFPZ021259;
        Mon, 20 Feb 2023 18:14:15 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-c-spathi-hyd.qualcomm.com [10.213.108.59])
        by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 31KIEFcl021258;
        Mon, 20 Feb 2023 18:14:15 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 212714)
        id F420F485C; Mon, 20 Feb 2023 23:44:14 +0530 (+0530)
From:   Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
To:     stable@vger.kernel.org, gregkh@google.com
Cc:     Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Subject: [PATCH V1] rcu-tasks: Fix build error
Date:   Mon, 20 Feb 2023 23:43:59 +0530
Message-Id: <1676916839-32235-1-git-send-email-quic_c_spathi@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: jEKcFw0M7Iv307QN3J5akioMW4CdMsQt
X-Proofpoint-GUID: jEKcFw0M7Iv307QN3J5akioMW4CdMsQt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_15,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 impostorscore=0
 spamscore=0 mlxscore=0 mlxlogscore=559 malwarescore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302200167
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
fix below compilation error.
This is applicable to only 5.10 kernels as code got modified
in latest kernels.

 In file included from kernel/rcu/update.c:579:0:
 kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
  static void show_rcu_tasks_rude_gp_kthread(void) {}

Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
---
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

