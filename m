Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADDE606E2A
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 05:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJUDKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 23:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJUDK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 23:10:26 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8851FACF4C;
        Thu, 20 Oct 2022 20:10:21 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L31J72008126;
        Fri, 21 Oct 2022 03:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=DsTItPlUtBGJbVGMl/Jdnss/A3xtazN0EmWPLV0xHSk=;
 b=WL8/QEuSWF/6Yw/gVnj7VLBTq/HZZ/+QDdGjjP6EgcpFGdLUmnoI/eKITgTvkoEy86O+
 RGYAa74XnrafHBTmxW7OFzY4Zi+bU4UoESdlhJpsiGo2mXwVofF/Tbjfsh8LhuVS+bY5
 5xwqiAHEUoB6ZhOe77Xj/ma+G8Ly5PmJ4a1cbAtp1xaeHDusfA+R1cRXz1IMaOHeB+XA
 H34sCiGhWFLFCqTa0sGwTgIyraxbhMVk0YbZtVGLP7hJXO1aJVCtUiVfhoQCUd1IOvWM
 29IFeAYm2BmkRkTnqi/Zr0A7SxANepnmQvAxR5TNaRcVqlCvj5JlxAlX+zFZziRJWnyX bQ== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kawde3fu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 03:10:15 +0000
Received: from pps.filterd (NASANPPMTA04.qualcomm.com [127.0.0.1])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 29L38WhU016313;
        Fri, 21 Oct 2022 03:10:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA04.qualcomm.com (PPS) with ESMTPS id 3kbk40028n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 03:10:15 +0000
Received: from NASANPPMTA04.qualcomm.com (NASANPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L374de015218;
        Fri, 21 Oct 2022 03:10:15 GMT
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA04.qualcomm.com (PPS) with ESMTPS id 29L3AEtG018837
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 03:10:15 +0000
Received: from aiquny2-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 20 Oct 2022 20:10:11 -0700
From:   Maria Yu <quic_aiquny@quicinc.com>
To:     <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC:     Maria Yu <quic_aiquny@quicinc.com>, <mike.kravetz@oracle.com>,
        <opendmb@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH] mm/page_isolation: fix clang deadcode warning
Date:   Fri, 21 Oct 2022 11:09:53 +0800
Message-ID: <20221021030953.34925-1-quic_aiquny@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: HqqFb_mtPIrkgfSpJYEGURS8f9LH0LXi
X-Proofpoint-ORIG-GUID: HqqFb_mtPIrkgfSpJYEGURS8f9LH0LXi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_13,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=660 malwarescore=0 clxscore=1011 phishscore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210017
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When !CONFIG_VM_BUG_ON, there is warning of
clang-analyzer-deadcode.DeadStores:
Value stored to 'mt' during its initialization
is never read.

Signed-off-by: Maria Yu <quic_aiquny@quicinc.com>
---
 mm/page_isolation.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 04141a9bea70..51d5c8025f77 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -330,9 +330,7 @@ static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
 				      zone->zone_start_pfn);
 
 	if (skip_isolation) {
-		int mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
-
-		VM_BUG_ON(!is_migrate_isolate(mt));
+		VM_BUG_ON(!is_migrate_isolate(get_pageblock_migratetype(pfn_to_page(isolate_pageblock))));
 	} else {
 		ret = set_migratetype_isolate(pfn_to_page(isolate_pageblock), migratetype,
 				flags, isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
-- 
2.17.1

