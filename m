Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9FC55C318
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbiF0Luk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238583AbiF0Lsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDEECE22;
        Mon, 27 Jun 2022 04:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A748CE1718;
        Mon, 27 Jun 2022 11:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308BCC3411D;
        Mon, 27 Jun 2022 11:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330147;
        bh=tKyq7EC7aUpb+IS66504kZPS8gq36q1oY/yLx6iNub0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsOlTDxyFuo9swKS47h3XLLVqfaSVEdCHYTB7mkpYkYH9z7fHPjpacNqNe8GTwvBU
         ZDUR2hUsVoYE9hWTgtEvX/CorthMszB5ZaRI7BjUjGlPsuz8XFCzzWj5n1jgTYNTvL
         dc9FToS5AWYEIwH0FArdHbNJRSG+MzoUr8YRYbEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 101/181] s390/cpumf: Handle events cycles and instructions identical
Date:   Mon, 27 Jun 2022 13:21:14 +0200
Message-Id: <20220627111947.626764892@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
index 483ab5e10164..f7dd3c849e68 100644
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



