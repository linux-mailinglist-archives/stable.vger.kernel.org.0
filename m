Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661588DA20
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbfHNRPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731213AbfHNRPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:15:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4D922173B;
        Wed, 14 Aug 2019 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802918;
        bh=fGHYA2jkSjAb5qy2817gBuqAcPDx6rCnCyhCJyo463A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbv1XCZNXlQ0PNNjb1yVvqjOiN7Zv+9OJ2OOx8tZdKCmEkOLQwKBAr94S0YM/lS2/
         /BLLvBoXnIRm8JpNtyCphO0OH73gOUkG8DAXFxwXowx1Q9oSmUQ3Dvf9UgQRg3z/xU
         epMeEsW+eOeafNW9yjhpGoB5bqQpMLOq3vVk2BPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Frank Li <Frank.li@nxp.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 50/69] perf/core: Fix creating kernel counters for PMUs that override event->cpu
Date:   Wed, 14 Aug 2019 19:01:48 +0200
Message-Id: <20190814165748.941530786@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4ce54af8b33d3e21ca935fc1b89b58cbba956051 ]

Some hardware PMU drivers will override perf_event.cpu inside their
event_init callback. This causes a lockdep splat when initialized through
the kernel API:

 WARNING: CPU: 0 PID: 250 at kernel/events/core.c:2917 ctx_sched_out+0x78/0x208
 pc : ctx_sched_out+0x78/0x208
 Call trace:
  ctx_sched_out+0x78/0x208
  __perf_install_in_context+0x160/0x248
  remote_function+0x58/0x68
  generic_exec_single+0x100/0x180
  smp_call_function_single+0x174/0x1b8
  perf_install_in_context+0x178/0x188
  perf_event_create_kernel_counter+0x118/0x160

Fix this by calling perf_install_in_context with event->cpu, just like
perf_event_open

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Frank Li <Frank.li@nxp.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/r/c4ebe0503623066896d7046def4d6b1e06e0eb2e.1563972056.git.leonard.crestez@nxp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3d4eb6f840eba..ea4f3f7a0c6f3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10474,7 +10474,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_unlock;
 	}
 
-	perf_install_in_context(ctx, event, cpu);
+	perf_install_in_context(ctx, event, event->cpu);
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
-- 
2.20.1



