Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519933F63A0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhHXQ5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234343AbhHXQ5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26127613AB;
        Tue, 24 Aug 2021 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824189;
        bh=jC6uSCrgt69kXfrpA/d+Zpv7RChIWevKRH+aKooCZ/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpRpy/b4mQ15Kcmo73gWIGIvxe5m6zfz4+Cwkr/2T3J/AZg4iIhaq+iuFKI/+O/TQ
         jwuY1o60QNFDkWqvRPVLEzNXNyiauRAfsZPuRD9UzPtuqFQ0mZEtd8TmXsfILyw78m
         HP7qT7tDdDfl3T6DqtIuBiK3wwZ0Gqy9Gn+N54xdj8BFQeD+ZEkk5LeG7FQgwaQmvA
         gv7vmFxhWE5DG+Y5lUdTlluITV493f+Jx+3x19oToP2jp/nLBWfwHn8RlgaO1b7Qsc
         UMAJ76pVGuleEQP86Ac+F9RB7Fno4bbz3zoJlM0RXnr1ZK1yqtJ2zrB6luQ1uGvSgY
         P1XinFNV4jhpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Like Xu <likexu@tencent.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 021/127] perf/x86: Fix out of bound MSR access
Date:   Tue, 24 Aug 2021 12:54:21 -0400
Message-Id: <20210824165607.709387-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit f4b4b45652578357031fbbef7f7a1b04f6fa2dc3 ]

On Wed, Jul 28, 2021 at 12:49:43PM -0400, Vince Weaver wrote:
> [32694.087403] unchecked MSR access error: WRMSR to 0x318 (tried to write 0x0000000000000000) at rIP: 0xffffffff8106f854 (native_write_msr+0x4/0x20)
> [32694.101374] Call Trace:
> [32694.103974]  perf_clear_dirty_counters+0x86/0x100

The problem being that it doesn't filter out all fake counters, in
specific the above (erroneously) tries to use FIXED_BTS. Limit the
fixed counters indexes to the hardware supplied number.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Like Xu <likexu@tencent.com>
Link: https://lkml.kernel.org/r/YQJxka3dxgdIdebG@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 1eb45139fcc6..3092fbf9dbe4 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2489,13 +2489,15 @@ void perf_clear_dirty_counters(void)
 		return;
 
 	for_each_set_bit(i, cpuc->dirty, X86_PMC_IDX_MAX) {
-		/* Metrics and fake events don't have corresponding HW counters. */
-		if (is_metric_idx(i) || (i == INTEL_PMC_IDX_FIXED_VLBR))
-			continue;
-		else if (i >= INTEL_PMC_IDX_FIXED)
+		if (i >= INTEL_PMC_IDX_FIXED) {
+			/* Metrics and fake events don't have corresponding HW counters. */
+			if ((i - INTEL_PMC_IDX_FIXED) >= hybrid(cpuc->pmu, num_counters_fixed))
+				continue;
+
 			wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + (i - INTEL_PMC_IDX_FIXED), 0);
-		else
+		} else {
 			wrmsrl(x86_pmu_event_addr(i), 0);
+		}
 	}
 
 	bitmap_zero(cpuc->dirty, X86_PMC_IDX_MAX);
-- 
2.30.2

