Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F92F631628
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 21:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKTUHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 15:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiKTUHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 15:07:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC571CB1E;
        Sun, 20 Nov 2022 12:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 166B6B80B7F;
        Sun, 20 Nov 2022 20:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDEDC43146;
        Sun, 20 Nov 2022 20:07:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1owqbF-00Di4l-2j;
        Sun, 20 Nov 2022 15:07:33 -0500
Message-ID: <20221120200733.670542882@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 20 Nov 2022 15:07:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>
Subject: [for-linus][PATCH 03/13] tracing: Fix memory leak in tracing_read_pipe()
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

From: Wang Yufen <wangyufen@huawei.com>

kmemleak reports this issue:

unreferenced object 0xffff888105a18900 (size 128):
  comm "test_progs", pid 18933, jiffies 4336275356 (age 22801.766s)
  hex dump (first 32 bytes):
    25 73 00 90 81 88 ff ff 26 05 00 00 42 01 58 04  %s......&...B.X.
    03 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000560143a1>] __kmalloc_node_track_caller+0x4a/0x140
    [<000000006af00822>] krealloc+0x8d/0xf0
    [<00000000c309be6a>] trace_iter_expand_format+0x99/0x150
    [<000000005a53bdb6>] trace_check_vprintf+0x1e0/0x11d0
    [<0000000065629d9d>] trace_event_printf+0xb6/0xf0
    [<000000009a690dc7>] trace_raw_output_bpf_trace_printk+0x89/0xc0
    [<00000000d22db172>] print_trace_line+0x73c/0x1480
    [<00000000cdba76ba>] tracing_read_pipe+0x45c/0x9f0
    [<0000000015b58459>] vfs_read+0x17b/0x7c0
    [<000000004aeee8ed>] ksys_read+0xed/0x1c0
    [<0000000063d3d898>] do_syscall_64+0x3b/0x90
    [<00000000a06dda7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

iter->fmt alloced in
  tracing_read_pipe() -> .. ->trace_iter_expand_format(), but not
freed, to fix, add free in tracing_release_pipe()

Link: https://lkml.kernel.org/r/1667819090-4643-1-git-send-email-wangyufen@huawei.com

Cc: stable@vger.kernel.org
Fixes: efbbdaa22bb7 ("tracing: Show real address for trace event arguments")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c6c7a0af3ed2..5bd202d6d79a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6657,6 +6657,7 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(iter->started);
+	kfree(iter->fmt);
 	mutex_destroy(&iter->mutex);
 	kfree(iter);
 
-- 
2.35.1


