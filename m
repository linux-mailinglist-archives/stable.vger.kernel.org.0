Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C91F6B48D6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjCJPHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbjCJPGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:06:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45A4EE746
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:59:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3056DB822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760C3C433D2;
        Fri, 10 Mar 2023 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460270;
        bh=Q5RgjF7CcaPS+GlEpAdaLTyht1a8mfKi6WAPdqD5wa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLTkkIDR2p5fRuRCn6gKIEdjpgzx9uBTg277KsuxCvAVxFy5rPxjRsb/906h/2Mfh
         5Pe2aUvy/mRQtePc4YX9kchcIKKHmq7xYJRCIMfzR04GhwOKnvv53+HejDnCd08oLL
         FUrqWzkri37fmcg5zj25IwWj31NcApnv1Qp0Qnns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/529] powerpc/perf/hv-24x7: add missing RTAS retry status handling
Date:   Fri, 10 Mar 2023 14:36:34 +0100
Message-Id: <20230310133816.595023765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit cc4b26eab1859fa1a70711872caaf6414809973f ]

The ibm,get-system-parameter RTAS function may return -2 or 990x,
which indicate that the caller should try again. read_24x7_sys_info()
ignores this, allowing transient failures in reporting processor
module information.

Move the RTAS call into a coventional rtas_busy_delay()-based loop,
along with the parsing of results on success.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 8ba214267382 ("powerpc/hv-24x7: Add rtas call in hv-24x7 driver to get processor details")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230125-b4-powerpc-rtas-queue-v3-2-26929c8cce78@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-24x7.c | 42 ++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 6e7e820508df7..1cd2351d241e8 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -79,9 +79,8 @@ static u32 phys_coresperchip; /* Physical cores per chip */
  */
 void read_24x7_sys_info(void)
 {
-	int call_status, len, ntypes;
-
-	spin_lock(&rtas_data_buf_lock);
+	const s32 token = rtas_token("ibm,get-system-parameter");
+	int call_status;
 
 	/*
 	 * Making system parameter: chips and sockets and cores per chip
@@ -91,32 +90,27 @@ void read_24x7_sys_info(void)
 	phys_chipspersocket = 1;
 	phys_coresperchip = 1;
 
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				PROCESSOR_MODULE_INFO,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		call_status = rtas_call(token, 3, 1, NULL, PROCESSOR_MODULE_INFO,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		if (call_status == 0) {
+			int ntypes = be16_to_cpup((__be16 *)&rtas_data_buf[2]);
+			int len = be16_to_cpup((__be16 *)&rtas_data_buf[0]);
+
+			if (len >= 8 && ntypes != 0) {
+				phys_sockets = be16_to_cpup((__be16 *)&rtas_data_buf[4]);
+				phys_chipspersocket = be16_to_cpup((__be16 *)&rtas_data_buf[6]);
+				phys_coresperchip = be16_to_cpup((__be16 *)&rtas_data_buf[8]);
+			}
+		}
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		pr_err("Error calling get-system-parameter %d\n",
 		       call_status);
-	} else {
-		len = be16_to_cpup((__be16 *)&rtas_data_buf[0]);
-		if (len < 8)
-			goto out;
-
-		ntypes = be16_to_cpup((__be16 *)&rtas_data_buf[2]);
-
-		if (!ntypes)
-			goto out;
-
-		phys_sockets = be16_to_cpup((__be16 *)&rtas_data_buf[4]);
-		phys_chipspersocket = be16_to_cpup((__be16 *)&rtas_data_buf[6]);
-		phys_coresperchip = be16_to_cpup((__be16 *)&rtas_data_buf[8]);
 	}
-
-out:
-	spin_unlock(&rtas_data_buf_lock);
 }
 
 /* Domains for which more than one result element are returned for each event. */
-- 
2.39.2



