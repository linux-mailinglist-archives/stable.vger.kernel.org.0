Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1458DC9862
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 08:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJCGnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 02:43:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63142 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbfJCGnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 02:43:25 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x936emPY023424
        for <stable@vger.kernel.org>; Wed, 2 Oct 2019 23:43:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=6DXtwSfVTxTQsg7OTAhIZXgsLk6C+uUhHjPiAO5wwjY=;
 b=dLBEBmZ62kTmrmp57awYr6nJ79lFsBRMUGbKHuv6g7qkTYpUn2+OIx9UosJRybSBzX7b
 MTZHwBn8ltvYqJBAN5U2Jey7kn15pQmka6VP3JrJWJ2DpojP5rdE/ljWa0Tj5DJ8jEPI
 j0tsFdJ7j2xsQF0xp8e/rV404/9XOrTr2m8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vc8tb1gfr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 02 Oct 2019 23:43:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 2 Oct 2019 23:43:23 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 8EA6762E311C; Wed,  2 Oct 2019 23:43:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-kernel@vger.kernel.org>
CC:     <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>,
        <stable@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH] perf/core: fix corner case in perf_rotate_context()
Date:   Wed, 2 Oct 2019 23:43:17 -0700
Message-ID: <20191003064317.3961135-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-03_03:2019-10-01,2019-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910030064
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a rare corner case, but it does happen:

In perf_rotate_context(), when the first cpu flexible event fail to
schedule, cpu_rotate is 1, while cpu_event is NULL. Since cpu_event is
NULL, perf_rotate_context will _NOT_ call cpu_ctx_sched_out(), thus
cpuctx->ctx.is_active will have EVENT_FLEXIBLE set. Then, the next
perf_event_sched_in() will skip all cpu flexible events because of the
EVENT_FLEXIBLE bit.

In the next call of perf_rotate_context(), cpu_rotate stays 1, and
cpu_event stays NULL, so this process repeats. The end result is, flexible
events on this cpu will not be scheduled (until another event being added
to the cpuctx).

Similar issue may happen with the task_ctx. But it is usually not a
problem because the task_ctx moves around different CPU.

Fix this corner case by using cpu_rotate and task_rotate to gate calls for
(cpu_)ctx_sched_out and rotate_ctx. Also enable rotate_ctx() to handle
event == NULL case.

Fixes: 8d5bce0c37fa ("perf/core: Optimize perf_rotate_context() event scheduling")
Cc: stable@vger.kernel.org # v4.17+
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/events/core.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4655adbbae10..50021735f367 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3775,6 +3775,13 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
 	if (ctx->rotate_disable)
 		return;
 
+	/* if no event specified, try to rotate the first event */
+	if (!event)
+		event = rb_entry_safe(rb_first(&ctx->flexible_groups.tree),
+				      typeof(*event), group_node);
+	if (!event)
+		return;
+
 	perf_event_groups_delete(&ctx->flexible_groups, event);
 	perf_event_groups_insert(&ctx->flexible_groups, event);
 }
@@ -3816,14 +3823,14 @@ static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
 	 * As per the order given at ctx_resched() first 'pop' task flexible
 	 * and then, if needed CPU flexible.
 	 */
-	if (task_event || (task_ctx && cpu_event))
+	if (task_rotate || (task_ctx && cpu_rotate))
 		ctx_sched_out(task_ctx, cpuctx, EVENT_FLEXIBLE);
-	if (cpu_event)
+	if (cpu_rotate)
 		cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	if (task_event)
+	if (task_rotate)
 		rotate_ctx(task_ctx, task_event);
-	if (cpu_event)
+	if (cpu_rotate)
 		rotate_ctx(&cpuctx->ctx, cpu_event);
 
 	perf_event_sched_in(cpuctx, task_ctx, current);
-- 
2.17.1

