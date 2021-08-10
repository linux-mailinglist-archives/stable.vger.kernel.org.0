Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5413E5CE8
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242554AbhHJOQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242395AbhHJOPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A5A60F94;
        Tue, 10 Aug 2021 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604932;
        bh=jC6uSCrgt69kXfrpA/d+Zpv7RChIWevKRH+aKooCZ/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXx6eHWArKZe5Jr5YlScKwnc+I9Lv35SxtAGwKc0cHz+0DHGQrZD605dRlFlTvVzb
         Cy6Eo2WuZT5ubBxbcf8e8J9ZmkLTST7ZkFdosG0O03Hvpw634dBXtJa0vTdFDAMHeY
         iPSr4ebaz5sPmoiDIkFj64Rh87VfHPzGnpR29JXlKKb9GpjJmV0rP95JoGkodAWRvW
         KjBkhFNAHhIlkqAvsFQvh924qKLzTk+bQVfvVKVnB7cYin4PNJEen2DWgMA/DsE4iV
         LjLQu0QYYAK+c28iy8stODayiTDKaw2oPhzmQkk/ekWkMH6ds1LqKkpuJQx3bz+q2f
         MojgDOaTs+x1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Like Xu <likexu@tencent.com>, Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 20/24] perf/x86: Fix out of bound MSR access
Date:   Tue, 10 Aug 2021 10:15:01 -0400
Message-Id: <20210810141505.3117318-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
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

