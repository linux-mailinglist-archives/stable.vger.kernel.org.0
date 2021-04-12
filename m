Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B549535C087
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbhDLJOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240719AbhDLJKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4DA961372;
        Mon, 12 Apr 2021 09:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218396;
        bh=f0vDZguZh0FbWYHFEG301WAvVp6cUsAy93qNBVXQ4bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q36gmouvzHGZP0Pe86Nj28/Gft6H1ObA35cb1k/Sq2xIWO8Vgdp6XYJcbpuL7c3Wo
         OkKN+dTFnppQLil8FmqaGD0c+VG8Mtp2DGr63gY1Lvyg6UV4Fqy1KwSisqNv2uZteU
         +8qViorXrmvYnCuTTmdxGovCsk3dTUtzYOccDI6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jin Yao <yao.jin@intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 183/210] perf report: Fix wrong LBR block sorting
Date:   Mon, 12 Apr 2021 10:41:28 +0200
Message-Id: <20210412084022.102512435@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit f2013278ae40b89cc27916366c407ce5261815ef ]

When '--total-cycles' is specified, it supports sorting for all blocks
by 'Sampled Cycles%'. This is useful to concentrate on the globally
hottest blocks.

'Sampled Cycles%' - block sampled cycles aggregation / total sampled cycles

But in current code, it doesn't use the cycles aggregation. Part of
'cycles' counting is possibly dropped for some overlap jumps. But for
identifying the hot block, we always need the full cycles.

  # perf record -b ./triad_loop
  # perf report --total-cycles --stdio

Before:

  #
  # Sampled Cycles%  Sampled Cycles  Avg Cycles%  Avg Cycles                                          [Program Block Range]      Shared Object
  # ...............  ..............  ...........  ..........  .............................................................  .................
  #
              0.81%             793        4.32%         793                           [setup-vdso.h:34 -> setup-vdso.h:40]         ld-2.27.so
              0.49%             480        0.87%         160                    [native_write_msr+0 -> native_write_msr+16]  [kernel.kallsyms]
              0.48%             476        0.52%          95                      [native_read_msr+0 -> native_read_msr+29]  [kernel.kallsyms]
              0.31%             303        1.65%         303                              [nmi_restore+0 -> nmi_restore+37]  [kernel.kallsyms]
              0.26%             255        1.39%         255      [nohz_balance_exit_idle+75 -> nohz_balance_exit_idle+162]  [kernel.kallsyms]
              0.24%             234        1.28%         234                       [end_repeat_nmi+67 -> end_repeat_nmi+83]  [kernel.kallsyms]
              0.23%             227        1.24%         227            [__irqentry_text_end+96 -> __irqentry_text_end+126]  [kernel.kallsyms]
              0.20%             194        1.06%         194             [native_set_debugreg+52 -> native_set_debugreg+56]  [kernel.kallsyms]
              0.11%             106        0.14%          26                [native_sched_clock+0 -> native_sched_clock+98]  [kernel.kallsyms]
              0.10%              97        0.53%          97            [trigger_load_balance+0 -> trigger_load_balance+67]  [kernel.kallsyms]
              0.09%              85        0.46%          85             [get-dynamic-info.h:102 -> get-dynamic-info.h:111]         ld-2.27.so
  ...
              0.00%           92.7K        0.02%           4                           [triad_loop.c:64 -> triad_loop.c:65]         triad_loop

The hottest block '[triad_loop.c:64 -> triad_loop.c:65]' is not at
the top of output.

After:

  # Sampled Cycles%  Sampled Cycles  Avg Cycles%  Avg Cycles                                           [Program Block Range]      Shared Object
  # ...............  ..............  ...........  ..........  ..............................................................  .................
  #
             94.35%           92.7K        0.02%           4                            [triad_loop.c:64 -> triad_loop.c:65]         triad_loop
              0.81%             793        4.32%         793                            [setup-vdso.h:34 -> setup-vdso.h:40]         ld-2.27.so
              0.49%             480        0.87%         160                     [native_write_msr+0 -> native_write_msr+16]  [kernel.kallsyms]
              0.48%             476        0.52%          95                       [native_read_msr+0 -> native_read_msr+29]  [kernel.kallsyms]
              0.31%             303        1.65%         303                               [nmi_restore+0 -> nmi_restore+37]  [kernel.kallsyms]
              0.26%             255        1.39%         255       [nohz_balance_exit_idle+75 -> nohz_balance_exit_idle+162]  [kernel.kallsyms]
              0.24%             234        1.28%         234                        [end_repeat_nmi+67 -> end_repeat_nmi+83]  [kernel.kallsyms]
              0.23%             227        1.24%         227             [__irqentry_text_end+96 -> __irqentry_text_end+126]  [kernel.kallsyms]
              0.20%             194        1.06%         194              [native_set_debugreg+52 -> native_set_debugreg+56]  [kernel.kallsyms]
              0.11%             106        0.14%          26                 [native_sched_clock+0 -> native_sched_clock+98]  [kernel.kallsyms]
              0.10%              97        0.53%          97             [trigger_load_balance+0 -> trigger_load_balance+67]  [kernel.kallsyms]
              0.09%              85        0.46%          85              [get-dynamic-info.h:102 -> get-dynamic-info.h:111]         ld-2.27.so
              0.08%              82        0.06%          11  [intel_pmu_drain_pebs_nhm+580 -> intel_pmu_drain_pebs_nhm+627]  [kernel.kallsyms]
              0.08%              77        0.42%          77                  [lru_add_drain_cpu+0 -> lru_add_drain_cpu+133]  [kernel.kallsyms]
              0.08%              74        0.10%          18                [handle_pmi_common+271 -> handle_pmi_common+310]  [kernel.kallsyms]
              0.08%              74        0.40%          74              [get-dynamic-info.h:131 -> get-dynamic-info.h:157]         ld-2.27.so
              0.07%              69        0.09%          17  [intel_pmu_drain_pebs_nhm+432 -> intel_pmu_drain_pebs_nhm+468]  [kernel.kallsyms]

Now the hottest block is reported at the top of output.

Fixes: b65a7d372b1a55db ("perf hist: Support block formats with compare/sort/display")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210407024452.29988-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/block-info.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/block-info.c b/tools/perf/util/block-info.c
index 423ec69bda6c..5ecd4f401f32 100644
--- a/tools/perf/util/block-info.c
+++ b/tools/perf/util/block-info.c
@@ -201,7 +201,7 @@ static int block_total_cycles_pct_entry(struct perf_hpp_fmt *fmt,
 	double ratio = 0.0;
 
 	if (block_fmt->total_cycles)
-		ratio = (double)bi->cycles / (double)block_fmt->total_cycles;
+		ratio = (double)bi->cycles_aggr / (double)block_fmt->total_cycles;
 
 	return color_pct(hpp, block_fmt->width, 100.0 * ratio);
 }
@@ -216,9 +216,9 @@ static int64_t block_total_cycles_pct_sort(struct perf_hpp_fmt *fmt,
 	double l, r;
 
 	if (block_fmt->total_cycles) {
-		l = ((double)bi_l->cycles /
+		l = ((double)bi_l->cycles_aggr /
 			(double)block_fmt->total_cycles) * 100000.0;
-		r = ((double)bi_r->cycles /
+		r = ((double)bi_r->cycles_aggr /
 			(double)block_fmt->total_cycles) * 100000.0;
 		return (int64_t)l - (int64_t)r;
 	}
-- 
2.30.2



