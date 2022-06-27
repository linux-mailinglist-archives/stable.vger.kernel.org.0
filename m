Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D00B55D3D4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiF0Llx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiF0LkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23C6BF69;
        Mon, 27 Jun 2022 04:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E7B060CA5;
        Mon, 27 Jun 2022 11:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676F7C3411D;
        Mon, 27 Jun 2022 11:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329730;
        bh=hukwWuigzV21quC7Sf4EGCOyizLdoQuLY9l8pf4YG5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zw62WMlLUT6eTt2fQgG7WIL/IEsY768l7kq5s/Q/80l4isZuS5HgiH7yppAYm+6L3
         2ky7vI1+1cfQEEpxG9FGX/5uRLRhf+92v1ydIsWA/XOsmvEugdkoFERZ6wgJy0YSkE
         sg/iYb7e9fcSkjV+BiH1YBvchlgMl2wsjyRfICeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/135] s390/cpumf: Handle events cycles and instructions identical
Date:   Mon, 27 Jun 2022 13:21:26 +0200
Message-Id: <20220627111940.452928409@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit be857b7f77d130dbbd47c91fc35198b040f35865 ]

Events CPU_CYCLES and INSTRUCTIONS can be submitted with two different
perf_event attribute::type values:
 - PERF_TYPE_HARDWARE: when invoked via perf tool predefined events name
   cycles or cpu-cycles or instructions.
 - pmu->type: when invoked via perf tool event name cpu_cf/CPU_CYLCES/ or
   cpu_cf/INSTRUCTIONS/. This invocation also selects the PMU to which
   the event belongs.
Handle both type of invocations identical for events CPU_CYLCES and
INSTRUCTIONS. They address the same hardware.
The result is different when event modifier exclude_kernel is also set.
Invocation with event modifier for user space event counting fails.

Output before:

 # perf stat -e cpum_cf/cpu_cycles/u -- true

 Performance counter stats for 'true':

   <not supported>      cpum_cf/cpu_cycles/u

       0.000761033 seconds time elapsed

       0.000076000 seconds user
       0.000725000 seconds sys

 #

Output after:
 # perf stat -e cpum_cf/cpu_cycles/u -- true

 Performance counter stats for 'true':

           349,613      cpum_cf/cpu_cycles/u

       0.000844143 seconds time elapsed

       0.000079000 seconds user
       0.000800000 seconds sys
 #

Fixes: 6a82e23f45fe ("s390/cpumf: Adjust registration of s390 PMU device drivers")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
[agordeev@linux.ibm.com corrected commit ID of Fixes commit]
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index cceb8ec707e4..d2a2a18b5580 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -516,6 +516,26 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 	return err;
 }
 
+/* Events CPU_CYLCES and INSTRUCTIONS can be submitted with two different
+ * attribute::type values:
+ * - PERF_TYPE_HARDWARE:
+ * - pmu->type:
+ * Handle both type of invocations identical. They address the same hardware.
+ * The result is different when event modifiers exclude_kernel and/or
+ * exclude_user are also set.
+ */
+static int cpumf_pmu_event_type(struct perf_event *event)
+{
+	u64 ev = event->attr.config;
+
+	if (cpumf_generic_events_basic[PERF_COUNT_HW_CPU_CYCLES] == ev ||
+	    cpumf_generic_events_basic[PERF_COUNT_HW_INSTRUCTIONS] == ev ||
+	    cpumf_generic_events_user[PERF_COUNT_HW_CPU_CYCLES] == ev ||
+	    cpumf_generic_events_user[PERF_COUNT_HW_INSTRUCTIONS] == ev)
+		return PERF_TYPE_HARDWARE;
+	return PERF_TYPE_RAW;
+}
+
 static int cpumf_pmu_event_init(struct perf_event *event)
 {
 	unsigned int type = event->attr.type;
@@ -525,7 +545,7 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
 		/* Registered as unknown PMU */
-		err = __hw_perf_event_init(event, PERF_TYPE_RAW);
+		err = __hw_perf_event_init(event, cpumf_pmu_event_type(event));
 	else
 		return -ENOENT;
 
-- 
2.35.1



