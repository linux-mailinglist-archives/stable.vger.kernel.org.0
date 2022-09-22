Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0F05E6C9E
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiIVUCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 16:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIVUCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 16:02:22 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE3B2F647;
        Thu, 22 Sep 2022 13:02:20 -0700 (PDT)
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MHCnSr018532;
        Thu, 22 Sep 2022 20:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=hrmDoxXNnaoMzX0uDj4vrE4mN2zUsUoIEygEbT+8Fgg=;
 b=ggzTAojvzWg9UuHd2E3gGj0AQolEZFYj69pwstnwr6PXevDpRAlZwN7ReF8PZlgNKyvF
 R5451w6y5HL6y9H51iz+Sos6TTt7WpsRjbNczX1rSVKxh4LTo+00R7ZWPkvwI1FCKK5c
 JrXddx9GBriQmOqL3uA9kb1yeHz8iTJ9L2pK+XkMMwht4LnCxyAgV1vs45wtZSbiMuhY
 o1r7OMwPYSnh4HRoqRXLHroaWpwbZ6kTDMYFdPEuPQ0L81ZJX+BC6IK8hgW6V7t+XKfy
 Kj+8shhPat0PRxjRO5mmIZpXJFleYWEegUHvgXepsPZbkMjSmgobeM5z14XCjtk6/kZD yg== 
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3jruwbhb07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 20:01:41 +0000
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 382EE801AD4;
        Thu, 22 Sep 2022 20:01:40 +0000 (UTC)
Received: from dog.eag.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTP id E0EF9807672;
        Thu, 22 Sep 2022 20:01:37 +0000 (UTC)
From:   Mike Travis <mike.travis@hpe.com>
To:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org
Cc:     Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        stable@vger.kernel.org, Andy Shevchenko <andy@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH v2] x86/platform/uv: Dont use smp_processor_id while preemptible
Date:   Thu, 22 Sep 2022 15:00:35 -0500
Message-Id: <20220922200035.94823-1-mike.travis@hpe.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: hHU9eJaViupHQ3IJVxCe-wNB3pgRoexl
X-Proofpoint-ORIG-GUID: hHU9eJaViupHQ3IJVxCe-wNB3pgRoexl
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_14,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 clxscore=1011 phishscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220129
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To avoid a "BUG: using smp_processor_id() in preemptible" debug warning
message, disable preemption around use of the processor id.  This code
sequence merely decides which portal that this CPU uses to read the RTC.
It does this to avoid thrashing the cache but even if preempted it still
reads the same time from the single RTC clock.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: stable@vger.kernel.org
---
v2: modify patch description, add Cc:stable tag
---
 arch/x86/platform/uv/uv_time.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 54663f3e00cb..094190814a28 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -275,14 +275,17 @@ static int uv_rtc_unset_timer(int cpu, int force)
  */
 static u64 uv_read_rtc(struct clocksource *cs)
 {
-	unsigned long offset;
+	unsigned long offset, time;
+	unsigned int cpu = get_cpu();
 
 	if (uv_get_min_hub_revision_id() == 1)
 		offset = 0;
 	else
-		offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
+		offset = (uv_cpu_blade_processor_id(cpu) * L1_CACHE_BYTES) % PAGE_SIZE;
 
-	return (u64)uv_read_local_mmr(UVH_RTC | offset);
+	time = (u64)uv_read_local_mmr(UVH_RTC | offset);
+	put_cpu();
+	return time;
 }
 
 /*
-- 
2.26.2

