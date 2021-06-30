Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974813B8AD7
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 01:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhF3XUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 19:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236446AbhF3XUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 19:20:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27BED6128E;
        Wed, 30 Jun 2021 23:18:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1lyjTK-000ZCk-6E; Wed, 30 Jun 2021 19:18:22 -0400
Message-ID: <20210630231822.036137810@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 30 Jun 2021 19:17:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [for-next][PATCH 1/5] tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing
References: <20210630231758.861158022@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

All internal use cases for tracepoint_probe_register() is set to not ever
be called with the same function and data. If it is, it is considered a
bug, as that means the accounting of handling tracepoints is corrupted.
If the function and data for a tracepoint is already registered when
tracepoint_probe_register() is called, it will call WARN_ON_ONCE() and
return with EEXISTS.

The BPF system call can end up calling tracepoint_probe_register() with
the same data, which now means that this can trigger the warning because
of a user space process. As WARN_ON_ONCE() should not be called because
user space called a system call with bad data, there needs to be a way to
register a tracepoint without triggering a warning.

Enter tracepoint_probe_register_may_exist(), which can be called, but will
not cause a WARN_ON() if the probe already exists. It will still error out
with EEXIST, which will then be sent to the user space that performed the
BPF system call.

This keeps the previous testing for issues with other users of the
tracepoint code, while letting BPF call it with duplicated data and not
warn about it.

Link: https://lore.kernel.org/lkml/20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp/
Link: https://syzkaller.appspot.com/bug?id=41f4318cf01762389f4d1c1c459da4f542fe5153

Cc: stable@vger.kernel.org
Fixes: c4f6699dfcb85 ("bpf: introduce BPF_RAW_TRACEPOINT")
Reported-by: syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot+721aa903751db87aa244@syzkaller.appspotmail.com
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/tracepoint.h | 10 ++++++++++
 kernel/trace/bpf_trace.c   |  3 ++-
 kernel/tracepoint.c        | 33 ++++++++++++++++++++++++++++++---
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 13f65420f188..ab58696d0ddd 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -41,7 +41,17 @@ extern int
 tracepoint_probe_register_prio(struct tracepoint *tp, void *probe, void *data,
 			       int prio);
 extern int
+tracepoint_probe_register_prio_may_exist(struct tracepoint *tp, void *probe, void *data,
+					 int prio);
+extern int
 tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
+static inline int
+tracepoint_probe_register_may_exist(struct tracepoint *tp, void *probe,
+				    void *data)
+{
+	return tracepoint_probe_register_prio_may_exist(tp, probe, data,
+							TRACEPOINT_DEFAULT_PRIO);
+}
 extern void
 for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
 		void *priv);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7a52bc172841..f0568b3d6bd1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1840,7 +1840,8 @@ static int __bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *
 	if (prog->aux->max_tp_access > btp->writable_size)
 		return -EINVAL;
 
-	return tracepoint_probe_register(tp, (void *)btp->bpf_func, prog);
+	return tracepoint_probe_register_may_exist(tp, (void *)btp->bpf_func,
+						   prog);
 }
 
 int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 9f478d29b926..976bf8ce8039 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -273,7 +273,8 @@ static void tracepoint_update_call(struct tracepoint *tp, struct tracepoint_func
  * Add the probe function to a tracepoint.
  */
 static int tracepoint_add_func(struct tracepoint *tp,
-			       struct tracepoint_func *func, int prio)
+			       struct tracepoint_func *func, int prio,
+			       bool warn)
 {
 	struct tracepoint_func *old, *tp_funcs;
 	int ret;
@@ -288,7 +289,7 @@ static int tracepoint_add_func(struct tracepoint *tp,
 			lockdep_is_held(&tracepoints_mutex));
 	old = func_add(&tp_funcs, func, prio);
 	if (IS_ERR(old)) {
-		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
+		WARN_ON_ONCE(warn && PTR_ERR(old) != -ENOMEM);
 		return PTR_ERR(old);
 	}
 
@@ -343,6 +344,32 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 	return 0;
 }
 
+/**
+ * tracepoint_probe_register_prio_may_exist -  Connect a probe to a tracepoint with priority
+ * @tp: tracepoint
+ * @probe: probe handler
+ * @data: tracepoint data
+ * @prio: priority of this function over other registered functions
+ *
+ * Same as tracepoint_probe_register_prio() except that it will not warn
+ * if the tracepoint is already registered.
+ */
+int tracepoint_probe_register_prio_may_exist(struct tracepoint *tp, void *probe,
+					     void *data, int prio)
+{
+	struct tracepoint_func tp_func;
+	int ret;
+
+	mutex_lock(&tracepoints_mutex);
+	tp_func.func = probe;
+	tp_func.data = data;
+	tp_func.prio = prio;
+	ret = tracepoint_add_func(tp, &tp_func, prio, false);
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_register_prio_may_exist);
+
 /**
  * tracepoint_probe_register_prio -  Connect a probe to a tracepoint with priority
  * @tp: tracepoint
@@ -366,7 +393,7 @@ int tracepoint_probe_register_prio(struct tracepoint *tp, void *probe,
 	tp_func.func = probe;
 	tp_func.data = data;
 	tp_func.prio = prio;
-	ret = tracepoint_add_func(tp, &tp_func, prio);
+	ret = tracepoint_add_func(tp, &tp_func, prio, true);
 	mutex_unlock(&tracepoints_mutex);
 	return ret;
 }
-- 
2.30.2
