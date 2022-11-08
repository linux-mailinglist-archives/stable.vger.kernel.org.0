Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FAD62159B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiKHONc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiKHONa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE26E1084
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AD4BB81B00
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBC5C433D6;
        Tue,  8 Nov 2022 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916804;
        bh=zKd5CQ+rj3cb8Pp8BDmfjSZ/q2x5enYFnhml3Cn2K0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbJ1FcnftB/cvXeZMhR8j6b2RQUdN/ieu6cY9oXzdkhuY+pg27RI++cqhSEjCsTy9
         070EU2aRpVx17fc/Lu971Y8baVGRyLtB+8f5E+ZDTxuUd8FfGLQkb0I0Rf+73ltjg8
         McWsUAGXBpb2D0kimooJ/7klrtACec1a0wVIZKtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>,
        Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 6.0 138/197] ftrace: Fix use-after-free for dynamic ftrace_ops
Date:   Tue,  8 Nov 2022 14:39:36 +0100
Message-Id: <20221108133401.216907063@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

commit 0e792b89e6800cd9cb4757a76a96f7ef3e8b6294 upstream.

KASAN reported a use-after-free with ftrace ops [1]. It was found from
vmcore that perf had registered two ops with the same content
successively, both dynamic. After unregistering the second ops, a
use-after-free occurred.

In ftrace_shutdown(), when the second ops is unregistered, the
FTRACE_UPDATE_CALLS command is not set because there is another enabled
ops with the same content.  Also, both ops are dynamic and the ftrace
callback function is ftrace_ops_list_func, so the
FTRACE_UPDATE_TRACE_FUNC command will not be set. Eventually the value
of 'command' will be 0 and ftrace_shutdown() will skip the rcu
synchronization.

However, ftrace may be activated. When the ops is released, another CPU
may be accessing the ops.  Add the missing synchronization to fix this
problem.

[1]
BUG: KASAN: use-after-free in __ftrace_ops_list_func kernel/trace/ftrace.c:7020 [inline]
BUG: KASAN: use-after-free in ftrace_ops_list_func+0x2b0/0x31c kernel/trace/ftrace.c:7049
Read of size 8 at addr ffff56551965bbc8 by task syz-executor.2/14468

CPU: 1 PID: 14468 Comm: syz-executor.2 Not tainted 5.10.0 #7
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0x0/0x40c arch/arm64/kernel/stacktrace.c:132
 show_stack+0x30/0x40 arch/arm64/kernel/stacktrace.c:196
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1b4/0x248 lib/dump_stack.c:118
 print_address_description.constprop.0+0x28/0x48c mm/kasan/report.c:387
 __kasan_report mm/kasan/report.c:547 [inline]
 kasan_report+0x118/0x210 mm/kasan/report.c:564
 check_memory_region_inline mm/kasan/generic.c:187 [inline]
 __asan_load8+0x98/0xc0 mm/kasan/generic.c:253
 __ftrace_ops_list_func kernel/trace/ftrace.c:7020 [inline]
 ftrace_ops_list_func+0x2b0/0x31c kernel/trace/ftrace.c:7049
 ftrace_graph_call+0x0/0x4
 __might_sleep+0x8/0x100 include/linux/perf_event.h:1170
 __might_fault mm/memory.c:5183 [inline]
 __might_fault+0x58/0x70 mm/memory.c:5171
 do_strncpy_from_user lib/strncpy_from_user.c:41 [inline]
 strncpy_from_user+0x1f4/0x4b0 lib/strncpy_from_user.c:139
 getname_flags+0xb0/0x31c fs/namei.c:149
 getname+0x2c/0x40 fs/namei.c:209
 [...]

Allocated by task 14445:
 kasan_save_stack+0x24/0x50 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:479 [inline]
 __kasan_kmalloc.constprop.0+0x110/0x13c mm/kasan/common.c:449
 kasan_kmalloc+0xc/0x14 mm/kasan/common.c:493
 kmem_cache_alloc_trace+0x440/0x924 mm/slub.c:2950
 kmalloc include/linux/slab.h:563 [inline]
 kzalloc include/linux/slab.h:675 [inline]
 perf_event_alloc.part.0+0xb4/0x1350 kernel/events/core.c:11230
 perf_event_alloc kernel/events/core.c:11733 [inline]
 __do_sys_perf_event_open kernel/events/core.c:11831 [inline]
 __se_sys_perf_event_open+0x550/0x15f4 kernel/events/core.c:11723
 __arm64_sys_perf_event_open+0x6c/0x80 kernel/events/core.c:11723
 [...]

Freed by task 14445:
 kasan_save_stack+0x24/0x50 mm/kasan/common.c:48
 kasan_set_track+0x24/0x34 mm/kasan/common.c:56
 kasan_set_free_info+0x20/0x40 mm/kasan/generic.c:358
 __kasan_slab_free.part.0+0x11c/0x1b0 mm/kasan/common.c:437
 __kasan_slab_free mm/kasan/common.c:445 [inline]
 kasan_slab_free+0x2c/0x40 mm/kasan/common.c:446
 slab_free_hook mm/slub.c:1569 [inline]
 slab_free_freelist_hook mm/slub.c:1608 [inline]
 slab_free mm/slub.c:3179 [inline]
 kfree+0x12c/0xc10 mm/slub.c:4176
 perf_event_alloc.part.0+0xa0c/0x1350 kernel/events/core.c:11434
 perf_event_alloc kernel/events/core.c:11733 [inline]
 __do_sys_perf_event_open kernel/events/core.c:11831 [inline]
 __se_sys_perf_event_open+0x550/0x15f4 kernel/events/core.c:11723
 [...]

Link: https://lore.kernel.org/linux-trace-kernel/20221103031010.166498-1-lihuafei1@huawei.com

Fixes: edb096e00724f ("ftrace: Fix memleak when unregistering dynamic ops when tracing disabled")
Cc: stable@vger.kernel.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3031,18 +3031,8 @@ int ftrace_shutdown(struct ftrace_ops *o
 		command |= FTRACE_UPDATE_TRACE_FUNC;
 	}
 
-	if (!command || !ftrace_enabled) {
-		/*
-		 * If these are dynamic or per_cpu ops, they still
-		 * need their data freed. Since, function tracing is
-		 * not currently active, we can just free them
-		 * without synchronizing all CPUs.
-		 */
-		if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
-			goto free_ops;
-
-		return 0;
-	}
+	if (!command || !ftrace_enabled)
+		goto out;
 
 	/*
 	 * If the ops uses a trampoline, then it needs to be
@@ -3079,6 +3069,7 @@ int ftrace_shutdown(struct ftrace_ops *o
 	removed_ops = NULL;
 	ops->flags &= ~FTRACE_OPS_FL_REMOVING;
 
+out:
 	/*
 	 * Dynamic ops may be freed, we must make sure that all
 	 * callers are done before leaving this function.
@@ -3106,7 +3097,6 @@ int ftrace_shutdown(struct ftrace_ops *o
 		if (IS_ENABLED(CONFIG_PREEMPTION))
 			synchronize_rcu_tasks();
 
- free_ops:
 		ftrace_trampoline_free(ops);
 	}
 


