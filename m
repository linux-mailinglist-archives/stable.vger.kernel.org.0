Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE744A8DBD
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354117AbiBCUcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35676 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354190AbiBCUaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6287A61A6D;
        Thu,  3 Feb 2022 20:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC054C36AE3;
        Thu,  3 Feb 2022 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920216;
        bh=MwkTiZJoksLSxaggOf2WpxBsuCuWyZjip0DdOvCxCRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfiFK+IQXTymMDxTqyywmp0cJ0T238B6Ii7Uw82A/DOvVgQ0i3CwWs4tyAVtaPA2S
         NtB4y8wMzS+QLSDLfpZbAQxDVCaVH3tsF5cwT+L+WyzS0mcJj5uYa2aBAuG9YM2J4u
         vl4FWcdE6L0Jvp7/8kg7W21f3eDAD2Nz4KNzvEdGhtPF3SzMAi7XN8f+zcqkVg+OuU
         vyTSD/5KlChRuvBvbJ70MMR/w5keu1jUaeXeQxTGapPABO92LixsXz7tfN2IgrbOHj
         y6r6dP9BlGAxMY996gu7Hh/Ek6jMIwdj4R7CSscq+sZacUPjJvwKXumfZ+3hrk4PQM
         +oAZVByEFL68w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        xuhaifeng <xuhaifeng@oppo.com>, Sasha Levin <sashal@kernel.org>,
        mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.16 18/52] sched: Avoid double preemption in __cond_resched_*lock*()
Date:   Thu,  3 Feb 2022 15:29:12 -0500
Message-Id: <20220203202947.2304-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7e406d1ff39b8ee574036418a5043c86723170cf ]

For PREEMPT/DYNAMIC_PREEMPT the *_unlock() will already trigger a
preemption, no point in then calling preempt_schedule_common()
*again*.

Use _cond_resched() instead, since this is a NOP for the preemptible
configs while it provide a preemption point for the others.

Reported-by: xuhaifeng <xuhaifeng@oppo.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YcGnvDEYBwOiV0cR@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 77563109c0ea0..d24823b3c3f9f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8176,9 +8176,7 @@ int __cond_resched_lock(spinlock_t *lock)
 
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		spin_lock(lock);
@@ -8196,9 +8194,7 @@ int __cond_resched_rwlock_read(rwlock_t *lock)
 
 	if (rwlock_needbreak(lock) || resched) {
 		read_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		read_lock(lock);
@@ -8216,9 +8212,7 @@ int __cond_resched_rwlock_write(rwlock_t *lock)
 
 	if (rwlock_needbreak(lock) || resched) {
 		write_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		write_lock(lock);
-- 
2.34.1

