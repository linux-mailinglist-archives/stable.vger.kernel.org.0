Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C3A23FABA
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgHHXjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728464AbgHHXjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:39:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE85320829;
        Sat,  8 Aug 2020 23:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929944;
        bh=/yMoRiL9K4k2IOgMxROgkfrtKFe7hZ5Taf1cht6du7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEfqRVmCkJKHNl9bYJY/Vqr6ynsgY/EQtyhkC7aego5CIfQz5pCpx4KBU4eBv1Dbz
         qoHrUmsuXEO53pY28RPFF2SdaQZOL0OnwHL0xx/emBlwQiAXcsH8BWGK08W5LlHlY8
         gHPGyVUm7PBOmvMUzjUJRjFpkfEEfxAM0m7GhEAY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qais Yousef <qais.yousef@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 15/40] sched/uclamp: Fix initialization of struct uclamp_rq
Date:   Sat,  8 Aug 2020 19:38:19 -0400
Message-Id: <20200808233844.3618823-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233844.3618823-1-sashal@kernel.org>
References: <20200808233844.3618823-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit d81ae8aac85ca2e307d273f6dc7863a721bf054e ]

struct uclamp_rq was zeroed out entirely in assumption that in the first
call to uclamp_rq_inc() they'd be initialized correctly in accordance to
default settings.

But when next patch introduces a static key to skip
uclamp_rq_{inc,dec}() until userspace opts in to use uclamp, schedutil
will fail to perform any frequency changes because the
rq->uclamp[UCLAMP_MAX].value is zeroed at init and stays as such. Which
means all rqs are capped to 0 by default.

Fix it by making sure we do proper initialization at init without
relying on uclamp_rq_inc() doing it later.

Fixes: 69842cba9ace ("sched/uclamp: Add CPU's clamp buckets refcounting")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://lkml.kernel.org/r/20200630112123.12076-2-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 38ae3cf9d173e..b34b5c6e25248 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1238,6 +1238,20 @@ static void uclamp_fork(struct task_struct *p)
 	}
 }
 
+static void __init init_uclamp_rq(struct rq *rq)
+{
+	enum uclamp_id clamp_id;
+	struct uclamp_rq *uc_rq = rq->uclamp;
+
+	for_each_clamp_id(clamp_id) {
+		uc_rq[clamp_id] = (struct uclamp_rq) {
+			.value = uclamp_none(clamp_id)
+		};
+	}
+
+	rq->uclamp_flags = 0;
+}
+
 static void __init init_uclamp(void)
 {
 	struct uclamp_se uc_max = {};
@@ -1246,11 +1260,8 @@ static void __init init_uclamp(void)
 
 	mutex_init(&uclamp_mutex);
 
-	for_each_possible_cpu(cpu) {
-		memset(&cpu_rq(cpu)->uclamp, 0,
-				sizeof(struct uclamp_rq)*UCLAMP_CNT);
-		cpu_rq(cpu)->uclamp_flags = 0;
-	}
+	for_each_possible_cpu(cpu)
+		init_uclamp_rq(cpu_rq(cpu));
 
 	for_each_clamp_id(clamp_id) {
 		uclamp_se_set(&init_task.uclamp_req[clamp_id],
-- 
2.25.1

