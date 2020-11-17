Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360B92B6383
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732670AbgKQNis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732661AbgKQNiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A00D20870;
        Tue, 17 Nov 2020 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620324;
        bh=87b4bQQlqOc0fgZlqnYwOkxq/fy48FsiROERkeuxlxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhIkO+KvFutnF0rWHhyslgTjA7kwJgE8xUndChWOXTI7ip23lFFrZVh6xckyEgMk9
         UJCF4c9//C6EMMHPx4mwoV+reluy+JGSwgCIHTtL18lAuN2E2FEu0NE95+RTxepVNw
         nCmmDqHKhebWZ1xIbRJHWfoETH0E0NChqEePNokQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 180/255] perf: Simplify group_sched_in()
Date:   Tue, 17 Nov 2020 14:05:20 +0100
Message-Id: <20201117122147.688844248@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 251ff2d49347793d348babcff745289b11910e96 ]

Collate the error paths. Code duplication only leads to divergence and
extra bugs.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201029162901.972161394@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 98a603098f23e..c245ccd426b71 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2565,11 +2565,8 @@ group_sched_in(struct perf_event *group_event,
 
 	pmu->start_txn(pmu, PERF_PMU_TXN_ADD);
 
-	if (event_sched_in(group_event, cpuctx, ctx)) {
-		pmu->cancel_txn(pmu);
-		perf_mux_hrtimer_restart(cpuctx);
-		return -EAGAIN;
-	}
+	if (event_sched_in(group_event, cpuctx, ctx))
+		goto error;
 
 	/*
 	 * Schedule in siblings as one group (if any):
@@ -2598,10 +2595,9 @@ group_error:
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
+error:
 	pmu->cancel_txn(pmu);
-
 	perf_mux_hrtimer_restart(cpuctx);
-
 	return -EAGAIN;
 }
 
-- 
2.27.0



