Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4842E541A50
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379152AbiFGVci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380040AbiFGVaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:30:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCBE152D97;
        Tue,  7 Jun 2022 12:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78EE9B82182;
        Tue,  7 Jun 2022 19:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6282C385A5;
        Tue,  7 Jun 2022 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628556;
        bh=E0zcAoJnQ0/3RynKXh6tUGd1y8IcqeLOSOpYh37x114=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuW+CIxaOl08Gin+yoRqqNxgOnTN+1smBreQH1z0/ubpadMTKzbOvufXNUhkfizhJ
         k7jmaPN6uo7/ZHLIHLMR62UcCA0hZZIZYSbimh0+Sxv+1w8H8bhK9ceCG1ZiaWAR50
         aEMeTk5MV0zKvg2rBgpPVSyNkb1g9LpyOA8t7j/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Steigerwald <Martin.Steigerwald@proact.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 332/879] sched/psi: report zeroes for CPU full at the system level
Date:   Tue,  7 Jun 2022 18:57:30 +0200
Message-Id: <20220607165012.493952445@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 890d550d7dbac7a31ecaa78732aa22be282bb6b8 ]

Martin find it confusing when look at the /proc/pressure/cpu output,
and found no hint about that CPU "full" line in psi Documentation.

% cat /proc/pressure/cpu
some avg10=0.92 avg60=0.91 avg300=0.73 total=933490489
full avg10=0.22 avg60=0.23 avg300=0.16 total=358783277

The PSI_CPU_FULL state is introduced by commit e7fcd7622823
("psi: Add PSI_CPU_FULL state"), which mainly for cgroup level,
but also counted at the system level as a side effect.

Naturally, the FULL state doesn't exist for the CPU resource at
the system level. These "full" numbers can come from CPU idle
schedule latency. For example, t1 is the time when task wakeup
on an idle CPU, t2 is the time when CPU pick and switch to it.
The delta of (t2 - t1) will be in CPU_FULL state.

Another case all processes can be stalled is when all cgroups
have been throttled at the same time, which unlikely to happen.

Anyway, CPU_FULL metric is meaningless and confusing at the
system level. So this patch will report zeroes for CPU full
at the system level, and update psi Documentation accordingly.

Fixes: e7fcd7622823 ("psi: Add PSI_CPU_FULL state")
Reported-by: Martin Steigerwald <Martin.Steigerwald@proact.de>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/r/20220408121914.82855-1-zhouchengming@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/accounting/psi.rst |  9 ++++-----
 kernel/sched/psi.c               | 15 +++++++++------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
index 860fe651d645..5e40b3f437f9 100644
--- a/Documentation/accounting/psi.rst
+++ b/Documentation/accounting/psi.rst
@@ -37,11 +37,7 @@ Pressure interface
 Pressure information for each resource is exported through the
 respective file in /proc/pressure/ -- cpu, memory, and io.
 
-The format for CPU is as such::
-
-	some avg10=0.00 avg60=0.00 avg300=0.00 total=0
-
-and for memory and IO::
+The format is as such::
 
 	some avg10=0.00 avg60=0.00 avg300=0.00 total=0
 	full avg10=0.00 avg60=0.00 avg300=0.00 total=0
@@ -58,6 +54,9 @@ situation from a state where some tasks are stalled but the CPU is
 still doing productive work. As such, time spent in this subset of the
 stall state is tracked separately and exported in the "full" averages.
 
+CPU full is undefined at the system level, but has been reported
+since 5.13, so it is set to zero for backward compatibility.
+
 The ratios (in %) are tracked as recent trends over ten, sixty, and
 three hundred second windows, which gives insight into short term events
 as well as medium and long term trends. The total absolute stall time
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a4fa3aadfcba..ed9fb557dadd 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1060,14 +1060,17 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 	mutex_unlock(&group->avgs_lock);
 
 	for (full = 0; full < 2; full++) {
-		unsigned long avg[3];
-		u64 total;
+		unsigned long avg[3] = { 0, };
+		u64 total = 0;
 		int w;
 
-		for (w = 0; w < 3; w++)
-			avg[w] = group->avg[res * 2 + full][w];
-		total = div_u64(group->total[PSI_AVGS][res * 2 + full],
-				NSEC_PER_USEC);
+		/* CPU FULL is undefined at the system level */
+		if (!(group == &psi_system && res == PSI_CPU && full)) {
+			for (w = 0; w < 3; w++)
+				avg[w] = group->avg[res * 2 + full][w];
+			total = div_u64(group->total[PSI_AVGS][res * 2 + full],
+					NSEC_PER_USEC);
+		}
 
 		seq_printf(m, "%s avg10=%lu.%02lu avg60=%lu.%02lu avg300=%lu.%02lu total=%llu\n",
 			   full ? "full" : "some",
-- 
2.35.1



