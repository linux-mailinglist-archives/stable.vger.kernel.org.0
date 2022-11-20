Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B5B631624
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 21:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiKTUHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 15:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKTUHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 15:07:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135391AF27;
        Sun, 20 Nov 2022 12:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B99A60D30;
        Sun, 20 Nov 2022 20:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99B3C43147;
        Sun, 20 Nov 2022 20:07:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1owqbG-00Di7E-2n;
        Sun, 20 Nov 2022 15:07:34 -0500
Message-ID: <20221120200734.707886372@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 20 Nov 2022 15:07:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: [for-linus][PATCH 08/13] ftrace: Fix null pointer dereference in ftrace_add_mod()
References: <20221120200700.725968899@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

The @ftrace_mod is allocated by kzalloc(), so both the members {prev,next}
of @ftrace_mode->list are NULL, it's not a valid state to call list_del().
If kstrdup() for @ftrace_mod->{func|module} fails, it goes to @out_free
tag and calls free_ftrace_mod() to destroy @ftrace_mod, then list_del()
will write prev->next and next->prev, where null pointer dereference
happens.

BUG: kernel NULL pointer dereference, address: 0000000000000008
Oops: 0002 [#1] PREEMPT SMP NOPTI
Call Trace:
 <TASK>
 ftrace_mod_callback+0x20d/0x220
 ? do_filp_open+0xd9/0x140
 ftrace_process_regex.isra.51+0xbf/0x130
 ftrace_regex_write.isra.52.part.53+0x6e/0x90
 vfs_write+0xee/0x3a0
 ? __audit_filter_op+0xb1/0x100
 ? auditd_test_task+0x38/0x50
 ksys_write+0xa5/0xe0
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
Kernel panic - not syncing: Fatal exception

So call INIT_LIST_HEAD() to initialize the list member to fix this issue.

Link: https://lkml.kernel.org/r/20221116015207.30858-1-xiujianfeng@huawei.com

Cc: stable@vger.kernel.org
Fixes: 673feb9d76ab ("ftrace: Add :mod: caching infrastructure to trace_array")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 56a168121bfc..33236241f236 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1289,6 +1289,7 @@ static int ftrace_add_mod(struct trace_array *tr,
 	if (!ftrace_mod)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ftrace_mod->list);
 	ftrace_mod->func = kstrdup(func, GFP_KERNEL);
 	ftrace_mod->module = kstrdup(module, GFP_KERNEL);
 	ftrace_mod->enable = enable;
-- 
2.35.1


