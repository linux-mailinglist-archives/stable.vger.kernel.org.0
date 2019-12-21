Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E461F128BB0
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 22:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfLUVLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 16:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfLUVLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 16:11:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19453206B7;
        Sat, 21 Dec 2019 21:11:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1iim29-000o1O-5n; Sat, 21 Dec 2019 16:11:33 -0500
Message-Id: <20191221211133.038093697@goodmis.org>
User-Agent: quilt/0.65
Date:   Sat, 21 Dec 2019 16:11:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Subject: [for-linus][PATCH 1/5] tracing: Avoid memory leak in process_system_preds()
References: <20191221211106.338673631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

When failing in the allocation of filter_item, process_system_preds()
goes to fail_mem, where the allocated filter is freed.

However, this leads to memory leak of filter->filter_string and
filter->prog, which is allocated before and in process_preds().
This bug has been detected by kmemleak as well.

Fix this by changing kfree to __free_fiter.

unreferenced object 0xffff8880658007c0 (size 32):
  comm "bash", pid 579, jiffies 4295096372 (age 17.752s)
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 20 20 3e 20 31 30  common_pid  > 10
    00 00 00 00 00 00 00 00 65 73 00 00 00 00 00 00  ........es......
  backtrace:
    [<0000000067441602>] kstrdup+0x2d/0x60
    [<00000000141cf7b7>] apply_subsystem_event_filter+0x378/0x932
    [<000000009ca32334>] subsystem_filter_write+0x5a/0x90
    [<0000000072da2bee>] vfs_write+0xe1/0x240
    [<000000004f14f473>] ksys_write+0xb4/0x150
    [<00000000a968b4a0>] do_syscall_64+0x6d/0x1e0
    [<000000001a189f40>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff888060c22d00 (size 64):
  comm "bash", pid 579, jiffies 4295096372 (age 17.752s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 e8 d7 41 80 88 ff ff  ...........A....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000b8c1b109>] process_preds+0x243/0x1820
    [<000000003972c7f0>] apply_subsystem_event_filter+0x3be/0x932
    [<000000009ca32334>] subsystem_filter_write+0x5a/0x90
    [<0000000072da2bee>] vfs_write+0xe1/0x240
    [<000000004f14f473>] ksys_write+0xb4/0x150
    [<00000000a968b4a0>] do_syscall_64+0x6d/0x1e0
    [<000000001a189f40>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff888041d7e800 (size 512):
  comm "bash", pid 579, jiffies 4295096372 (age 17.752s)
  hex dump (first 32 bytes):
    70 bc 85 97 ff ff ff ff 0a 00 00 00 00 00 00 00  p...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000001e04af34>] process_preds+0x71a/0x1820
    [<000000003972c7f0>] apply_subsystem_event_filter+0x3be/0x932
    [<000000009ca32334>] subsystem_filter_write+0x5a/0x90
    [<0000000072da2bee>] vfs_write+0xe1/0x240
    [<000000004f14f473>] ksys_write+0xb4/0x150
    [<00000000a968b4a0>] do_syscall_64+0x6d/0x1e0
    [<000000001a189f40>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: http://lkml.kernel.org/r/20191211091258.11310-1-keitasuzuki.park@sslab.ics.keio.ac.jp

Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 404a3add43c9c ("tracing: Only add filter list when needed")
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c9a74f82b14a..bf44f6bbd0c3 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1662,7 +1662,7 @@ static int process_system_preds(struct trace_subsystem_dir *dir,
 	parse_error(pe, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 	return -EINVAL;
  fail_mem:
-	kfree(filter);
+	__free_filter(filter);
 	/* If any call succeeded, we still need to sync */
 	if (!fail)
 		tracepoint_synchronize_unregister();
-- 
2.24.0


