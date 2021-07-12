Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A823C52B6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347130AbhGLHs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241750AbhGLHqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98DE1611AF;
        Mon, 12 Jul 2021 07:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075743;
        bh=jl+ad3IWHu5y9beWDWIxlhAtdfOYXOdzXGlC3+FatsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QF9JNXCMg/XyIvEqhFOPDNvapLZeGQwanKTZKJ6CrZap6lmvdO1NGal/Zmum/H8n4
         2856F6nTkgZr+P8MoVRfMhLxE56TMhpOUkZZmbt2w5XCVQ4RXqx37gdIRMHrn9VWkz
         UjiAyBHSCb4K0JfeqlrkmBqNsAs+O/PpV+a0j2d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 346/800] perf: Fix task context PMU for Hetero
Date:   Mon, 12 Jul 2021 08:06:09 +0200
Message-Id: <20210712061003.817282982@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 012669c740e6e2afa8bdb95394d06676f933dd2d ]

On HETEROGENEOUS hardware (ARM big.Little, Intel Alderlake etc.) each
CPU might have a different hardware PMU. Since each such PMU is
represented by a different struct pmu, but we only have a single HW
task context.

That means that the task context needs to switch PMU type when it
switches CPUs.

Not doing this means that ctx->pmu calls (pmu_{dis,en}able(),
{start,commit,cancel}_txn() etc.) are called against the wrong PMU and
things will go wobbly.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Reported-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lkml.kernel.org/r/YMsy7BuGT8nBTspT@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fe88d6eea3c2..9ebac2a79467 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3821,9 +3821,16 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 					struct task_struct *task)
 {
 	struct perf_cpu_context *cpuctx;
-	struct pmu *pmu = ctx->pmu;
+	struct pmu *pmu;
 
 	cpuctx = __get_cpu_context(ctx);
+
+	/*
+	 * HACK: for HETEROGENEOUS the task context might have switched to a
+	 * different PMU, force (re)set the context,
+	 */
+	pmu = ctx->pmu = cpuctx->ctx.pmu;
+
 	if (cpuctx->task_ctx == ctx) {
 		if (cpuctx->sched_cb_usage)
 			__perf_pmu_sched_task(cpuctx, true);
-- 
2.30.2



