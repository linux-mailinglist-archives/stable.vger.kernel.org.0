Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED713F6454
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhHXRDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238755AbhHXRAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E4B615E6;
        Tue, 24 Aug 2021 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824274;
        bh=2f3xjSiU61X6SPNSptqweo0kpsBIRfPcxUCX14ODoxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFSYYYIfhk1a04A/AWWKmtZg9+sampTpexRPhFp6evwDibbQYd/KZQghD8SQrHmsq
         Bsk9nF7N0bw2hYAibjchxJJ3K/z7699hvrlZ5Yz+tv6esF4Hx3mZlmYWL38EpcshGQ
         n6wH+3S8vz8ZwTKVE9aLDgzXztACXGXe3RO98BrLWkm5n8oqbxhFHxacLXC47ZqxWn
         sjJpPMwfIksbqLYwrlWXgo6US+Aro3r6a4muLVHzmGxl6WenLhzeV7/OA2mb3+Gezn
         z75IZomFXR07ywYQBLcgO1tf5SCjT4Ep6wNhercAVbnBk9oNQdB8UYEwXZzOGJ6nG+
         FX0tZ7x2F2r0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pingfan Liu <kernelfans@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 109/127] tracing: Apply trace filters on all output channels
Date:   Tue, 24 Aug 2021 12:55:49 -0400
Message-Id: <20210824165607.709387-110-sashal@kernel.org>
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

From: Pingfan Liu <kernelfans@gmail.com>

[ Upstream commit 6c34df6f350df9579ce99d887a2b5fa14cc13b32 ]

The event filters are not applied on all of the output, which results in
the flood of printk when using tp_printk. Unfolding
event_trigger_unlock_commit_regs() into trace_event_buffer_commit(), so
the filters can be applied on every output.

Link: https://lkml.kernel.org/r/20210814034538.8428-1-kernelfans@gmail.com

Cc: stable@vger.kernel.org
Fixes: 0daa2302968c1 ("tracing: Add tp_printk cmdline to have tracepoints go to printk()")
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 18 +++++++++++++++---
 kernel/trace/trace.h | 32 --------------------------------
 2 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 018067e379f2..fa617a0a9eed 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2853,14 +2853,26 @@ int tracepoint_printk_sysctl(struct ctl_table *table, int write,
 
 void trace_event_buffer_commit(struct trace_event_buffer *fbuffer)
 {
+	enum event_trigger_type tt = ETT_NONE;
+	struct trace_event_file *file = fbuffer->trace_file;
+
+	if (__event_trigger_test_discard(file, fbuffer->buffer, fbuffer->event,
+			fbuffer->entry, &tt))
+		goto discard;
+
 	if (static_key_false(&tracepoint_printk_key.key))
 		output_printk(fbuffer);
 
 	if (static_branch_unlikely(&trace_event_exports_enabled))
 		ftrace_exports(fbuffer->event, TRACE_EXPORT_EVENT);
-	event_trigger_unlock_commit_regs(fbuffer->trace_file, fbuffer->buffer,
-				    fbuffer->event, fbuffer->entry,
-				    fbuffer->trace_ctx, fbuffer->regs);
+
+	trace_buffer_unlock_commit_regs(file->tr, fbuffer->buffer,
+			fbuffer->event, fbuffer->trace_ctx, fbuffer->regs);
+
+discard:
+	if (tt)
+		event_triggers_post_call(file, tt);
+
 }
 EXPORT_SYMBOL_GPL(trace_event_buffer_commit);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cd80d046c7a5..1b60ecf85391 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1391,38 +1391,6 @@ event_trigger_unlock_commit(struct trace_event_file *file,
 		event_triggers_post_call(file, tt);
 }
 
-/**
- * event_trigger_unlock_commit_regs - handle triggers and finish event commit
- * @file: The file pointer associated with the event
- * @buffer: The ring buffer that the event is being written to
- * @event: The event meta data in the ring buffer
- * @entry: The event itself
- * @trace_ctx: The tracing context flags.
- *
- * This is a helper function to handle triggers that require data
- * from the event itself. It also tests the event against filters and
- * if the event is soft disabled and should be discarded.
- *
- * Same as event_trigger_unlock_commit() but calls
- * trace_buffer_unlock_commit_regs() instead of trace_buffer_unlock_commit().
- */
-static inline void
-event_trigger_unlock_commit_regs(struct trace_event_file *file,
-				 struct trace_buffer *buffer,
-				 struct ring_buffer_event *event,
-				 void *entry, unsigned int trace_ctx,
-				 struct pt_regs *regs)
-{
-	enum event_trigger_type tt = ETT_NONE;
-
-	if (!__event_trigger_test_discard(file, buffer, event, entry, &tt))
-		trace_buffer_unlock_commit_regs(file->tr, buffer, event,
-						trace_ctx, regs);
-
-	if (tt)
-		event_triggers_post_call(file, tt);
-}
-
 #define FILTER_PRED_INVALID	((unsigned short)-1)
 #define FILTER_PRED_IS_RIGHT	(1 << 15)
 #define FILTER_PRED_FOLD	(1 << 15)
-- 
2.30.2

