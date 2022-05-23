Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B973C531B4B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbiEWQrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 12:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238871AbiEWQrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 12:47:45 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC02313B3;
        Mon, 23 May 2022 09:47:41 -0700 (PDT)
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NG7i9Q020385;
        Mon, 23 May 2022 16:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=FzQNwTi13ARFCJVSGCYihZ8rVSZ+bSBFvx/V3quqw0c=;
 b=HNc6yecs4gSb53mS9wiGIWdJY8+MxfWJCveeh+dnhs6PVeiHQ7+Zc1gcd+6xDn6cUuc+
 8E3GyLIe+Uv0s6o+//w78cgZnwQ0o71zrtcqP8A9GtrX2PnZM5mzIqNGJaNiarEKhXtj
 ySFGDL2UK/ExHmt5piVKfWaZjAKJ1GzG+h5xI8RzZYr4HrU4DQ7h4zBceHDs0Ih152gY
 V5rIx1GI1UIRZKhNDL8dq8GKbfixLFjrEQ+0UbtOr8CMDp4VmMRHyNLvSrRsJrbzhMCC
 qLzTKerP+IL7xDy3h+eDvIPWYKT37t0CTuUzGGpLCxGF5VRUwf56AUucYvpvO3tJODHA cA== 
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3g884f44q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 16:47:03 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5008.houston.hpe.com (Postfix) with ESMTP id F33DC4F;
        Mon, 23 May 2022 16:47:01 +0000 (UTC)
Received: from dog.eag.rdlabs.hpecorp.net (dog.eag.rdlabs.hpecorp.net [128.162.243.181])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 5FF374C;
        Mon, 23 May 2022 16:47:00 +0000 (UTC)
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
Date:   Mon, 23 May 2022 11:45:21 -0500
Message-Id: <20220523164521.155872-1-mike.travis@hpe.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: AWsB_-ro9HKGeoA4AQdZCDpc7-9ZvM_B
X-Proofpoint-GUID: AWsB_-ro9HKGeoA4AQdZCDpc7-9ZvM_B
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_07,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205230094
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To avoid a "BUG: using smp_processor_id() in preemptible" debug
warning message, disable preemption around use of the processor id.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: stable@vger.kernel.org
---
v2: Add Cc: stable tag
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

