Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6507F947
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394596AbfHBN0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394592AbfHBN0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:26:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D54921851;
        Fri,  2 Aug 2019 13:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752390;
        bh=zB+Z+g3Ay1NKJokH8//VVXoCdVDmA4Yj9TH+lfLHBQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TroKNuFTwGzcK377UsYpw43BPaCZapNTRhhSnZxqwmRshud1ishHl16Q2ZTLEesvH
         crtaTkPZINBPGKTDBDTyegZpy+K9vOfbc5qpExioRaFiVQkDVZhCKzKpWHrA+S5cwf
         wuYOqZt1SbNM6JyGZUd5khKpe8g+G9/yDa3yNeqU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Frank Li <Frank.li@nxp.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 22/22] perf/core: Fix creating kernel counters for PMUs that override event->cpu
Date:   Fri,  2 Aug 2019 09:25:46 -0400
Message-Id: <20190802132547.14517-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132547.14517-1-sashal@kernel.org>
References: <20190802132547.14517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

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
index 93d7333c64d89..5bbf7537a6121 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10130,7 +10130,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_unlock;
 	}
 
-	perf_install_in_context(ctx, event, cpu);
+	perf_install_in_context(ctx, event, event->cpu);
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
-- 
2.20.1

