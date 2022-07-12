Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA154572779
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 22:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiGLUkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 16:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiGLUkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 16:40:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C812CC790;
        Tue, 12 Jul 2022 13:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15EFDB81BE7;
        Tue, 12 Jul 2022 20:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61ECC341C8;
        Tue, 12 Jul 2022 20:39:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1oBMfj-0049O7-PU;
        Tue, 12 Jul 2022 16:39:55 -0400
Message-ID: <20220712203955.624861483@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 12 Jul 2022 16:39:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [for-linus][PATCH 1/6] tracing/histograms: Fix memory leak problem
References: <20220712203924.060569640@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

This reverts commit 46bbe5c671e06f070428b9be142cc4ee5cedebac.

As commit 46bbe5c671e0 ("tracing: fix double free") said, the
"double free" problem reported by clang static analyzer is:
  > In parse_var_defs() if there is a problem allocating
  > var_defs.expr, the earlier var_defs.name is freed.
  > This free is duplicated by free_var_defs() which frees
  > the rest of the list.

However, if there is a problem allocating N-th var_defs.expr:
  + in parse_var_defs(), the freed 'earlier var_defs.name' is
    actually the N-th var_defs.name;
  + then in free_var_defs(), the names from 0th to (N-1)-th are freed;

                        IF ALLOCATING PROBLEM HAPPENED HERE!!! -+
                                                                 \
                                                                  |
          0th           1th                 (N-1)-th      N-th    V
          +-------------+-------------+-----+-------------+-----------
var_defs: | name | expr | name | expr | ... | name | expr | name | ///
          +-------------+-------------+-----+-------------+-----------

These two frees don't act on same name, so there was no "double free"
problem before. Conversely, after that commit, we get a "memory leak"
problem because the above "N-th var_defs.name" is not freed.

If enable CONFIG_DEBUG_KMEMLEAK and inject a fault at where the N-th
var_defs.expr allocated, then execute on shell like:
  $ echo 'hist:key=call_site:val=$v1,$v2:v1=bytes_req,v2=bytes_alloc' > \
/sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

Then kmemleak reports:
  unreferenced object 0xffff8fb100ef3518 (size 8):
    comm "bash", pid 196, jiffies 4295681690 (age 28.538s)
    hex dump (first 8 bytes):
      76 31 00 00 b1 8f ff ff                          v1......
    backtrace:
      [<0000000038fe4895>] kstrdup+0x2d/0x60
      [<00000000c99c049a>] event_hist_trigger_parse+0x206f/0x20e0
      [<00000000ae70d2cc>] trigger_process_regex+0xc0/0x110
      [<0000000066737a4c>] event_trigger_write+0x75/0xd0
      [<000000007341e40c>] vfs_write+0xbb/0x2a0
      [<0000000087fde4c2>] ksys_write+0x59/0xd0
      [<00000000581e9cdf>] do_syscall_64+0x3a/0x80
      [<00000000cf3b065c>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Link: https://lkml.kernel.org/r/20220711014731.69520-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Fixes: 46bbe5c671e0 ("tracing: fix double free")
Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 48e82e141d54..e87a46794079 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4430,6 +4430,8 @@ static int parse_var_defs(struct hist_trigger_data *hist_data)
 
 			s = kstrdup(field_str, GFP_KERNEL);
 			if (!s) {
+				kfree(hist_data->attrs->var_defs.name[n_vars]);
+				hist_data->attrs->var_defs.name[n_vars] = NULL;
 				ret = -ENOMEM;
 				goto free;
 			}
-- 
2.35.1
