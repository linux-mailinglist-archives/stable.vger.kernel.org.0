Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29703CDBE3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238943AbhGSOuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344515AbhGSOsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF04260E0C;
        Mon, 19 Jul 2021 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708573;
        bh=zoLuEX6xisYtWDQ8VLdTtZvsH/rrdcn8EQ1XbW33Gzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mw3b4CH72TnDeWAZe+zemCwaQQaqPbKYuRcGEryddXtJUGSx3Fsyx606mMq034+hC
         WS/EBn5KnJYanXSnEtXpxefzhzu8Tkl3a63+Po26G6cDlp/PN1DPHb2CLZEPnD/3ij
         GkSzDNnjQuwEdFlwHmpuzG3CMnTm3OZ2EmMTOHFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 045/421] tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing
Date:   Mon, 19 Jul 2021 16:47:36 +0200
Message-Id: <20210719144947.787023146@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 9913d5745bd720c4266805c8d29952a3702e4eca upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/tracepoint.h |   10 ++++++++++
 kernel/trace/bpf_trace.c   |    3 ++-
 kernel/tracepoint.c        |   33 ++++++++++++++++++++++++++++++---
 3 files changed, 42 insertions(+), 4 deletions(-)

--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -42,7 +42,17 @@ extern int
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
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1221,7 +1221,8 @@ static int __bpf_probe_register(struct b
 	if (prog->aux->max_ctx_offset > btp->num_args * sizeof(u64))
 		return -EINVAL;
 
-	return tracepoint_probe_register(tp, (void *)btp->bpf_func, prog);
+	return tracepoint_probe_register_may_exist(tp, (void *)btp->bpf_func,
+						   prog);
 }
 
 int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -284,7 +284,8 @@ static void *func_remove(struct tracepoi
  * Add the probe function to a tracepoint.
  */
 static int tracepoint_add_func(struct tracepoint *tp,
-			       struct tracepoint_func *func, int prio)
+			       struct tracepoint_func *func, int prio,
+			       bool warn)
 {
 	struct tracepoint_func *old, *tp_funcs;
 	int ret;
@@ -299,7 +300,7 @@ static int tracepoint_add_func(struct tr
 			lockdep_is_held(&tracepoints_mutex));
 	old = func_add(&tp_funcs, func, prio);
 	if (IS_ERR(old)) {
-		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
+		WARN_ON_ONCE(warn && PTR_ERR(old) != -ENOMEM);
 		return PTR_ERR(old);
 	}
 
@@ -351,6 +352,32 @@ static int tracepoint_remove_func(struct
 }
 
 /**
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
+/**
  * tracepoint_probe_register_prio -  Connect a probe to a tracepoint with priority
  * @tp: tracepoint
  * @probe: probe handler
@@ -373,7 +400,7 @@ int tracepoint_probe_register_prio(struc
 	tp_func.func = probe;
 	tp_func.data = data;
 	tp_func.prio = prio;
-	ret = tracepoint_add_func(tp, &tp_func, prio);
+	ret = tracepoint_add_func(tp, &tp_func, prio, true);
 	mutex_unlock(&tracepoints_mutex);
 	return ret;
 }


