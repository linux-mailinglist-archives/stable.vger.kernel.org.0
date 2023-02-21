Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C29F69E03B
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 13:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjBUMWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 07:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbjBUMTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 07:19:46 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21E125E20
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 04:19:21 -0800 (PST)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L4nAks002765;
        Tue, 21 Feb 2023 12:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=qcppdkim1;
 bh=Gu7DWZTvjSI5Gom+khvkXdLEWWuRU6yN5Z/ds2zH4bk=;
 b=AwD4lgNIgUhwGb3rdJdLypN2aitKw8uvNOCVJ8pUq76uI2IgqeS5jJ6XhJLFgyt4wQOP
 LC3w5dN9538oHjdvcl8e20YJnPxhcR1cHqqa9SAbieSRhefJeYz3Dk7OgIZxYFqcMgjm
 wgyUW9+6G9I+d8dLPAux1Mlil2Iy0HNihf3yc1+ri2wctyVkXMs559w7I4XIqtO1e7lQ
 5PnVuJIMP+eHtBA1ucaaLKjZOAus7ThqR3+0jYRmhHq3J5KKDiB6F+DocrIf47jR2erC
 t5S1MeFUWOF8QLwfnBIzerHaPxeU2F7Qmztt2iST3S9IlgktakrsC69nJkXtPrqYLEv6 GA== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nvprgryab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 12:04:44 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
        by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 31LC4ekp002255;
        Tue, 21 Feb 2023 12:04:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3ntqrke68c-1;
        Tue, 21 Feb 2023 12:04:40 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LC4eIG002248;
        Tue, 21 Feb 2023 12:04:40 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-c-spathi-hyd.qualcomm.com [10.213.108.59])
        by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 31LC4eh5002247;
        Tue, 21 Feb 2023 12:04:40 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 212714)
        id D02BF485A; Tue, 21 Feb 2023 17:34:39 +0530 (+0530)
From:   Srinivasarao Pathipati <quic_spathi@quicinc.com>
To:     stable@vger.kernel.org, gregkh@google.com
Cc:     Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Subject: [PATCH V2] rcu-tasks: Fix build error
Date:   Tue, 21 Feb 2023 17:34:34 +0530
Message-Id: <1676981074-27435-1-git-send-email-quic_spathi@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: uTpn642AnMZkIfnT7KYKKovtRdOBZbcb
X-Proofpoint-ORIG-GUID: uTpn642AnMZkIfnT7KYKKovtRdOBZbcb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_06,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=592 lowpriorityscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210101
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

