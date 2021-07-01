Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CBC3B956E
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 19:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhGAR0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 13:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhGAR0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 13:26:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E566C061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 10:24:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t11-20020a056902124bb029055a821867baso3125178ybu.14
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 10:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=38K6QON43H6pH2g0pIEjP7BxAKWPFxAgioG2jiQJXbo=;
        b=aAoFWVvB2eQX8hemEnJKLwfAYIV6KQBm9A34wD1JuIPSUnV7DCsibpNnPdcd8s8N0i
         xb3YvOZM/K7gNU0iG6MBhVg81Ttw2ZWaBzBcVnlpSQFw4bXFqfLHUl+VSCk+SzxKsLnl
         u/4QEluBiQC/pREQBRfFUV3sd6e9KnKSeXSwMdRbfLylvJPchmzdErc8pMPmm4m/J1Yz
         SWUPAhQSY82+bsX6yjwHvwGoqjVwspENQELDYqjXPxC4oMwFmnPoXLniHSbXeZYxdbBr
         qktBdLVUV7vHaVejeLAYqf/O4rxJpxqqLB3z1vWl5bOCrc08UGhz/L17sjWutmFNfqUW
         3YpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=38K6QON43H6pH2g0pIEjP7BxAKWPFxAgioG2jiQJXbo=;
        b=coANe0JGMGj8QLdRAy2JuBN6r9ljRSoFIq+7cH1qUQ27E/AiYc0JDtOk8A6NskeToW
         x0leEYYNcjQ4a0VK2m1z9EHjDx4uazyz+v7YwxeWawV+UhTLY9vhMq/dfECu/MdtBgPr
         0PnDW6bdPHMExVPuq4HQyrl0DNukYB52Rvjn7vIW0B94LDTd8G7Wuo0QkeaYPAiYkl9v
         pPfW0zwGxSVU55LQ8sXR71WpInRozvZ6EYyNXO1gU3hLcd4Pn/cH8IGfgid/wj0LqWqX
         PyMGgYsWKXkyWso7IGj50MTg+QPOgJ341MHsA0Hk/QBqlKGmYvQdjC+XRJoE9+WIiY2h
         dbwg==
X-Gm-Message-State: AOAM531cpEx0os0xaVwNJlXCRJmTPr2Rc1g40p6OJCTYkYtQIGq/iINS
        Azwqyr0PgXcGObBC1P1R3fxwrWwI21+58neT
X-Google-Smtp-Source: ABdhPJwsiZdKBSmIxnQj9cHmceY++/Ee801Kq5zF2bYouqu9kW1FVUm0/Eb2H/CgKDHLBiWuX8aiUqqWZQwyL6U2
X-Received: from paulburton.mtv.corp.google.com ([2620:15c:280:201:558a:406a:d453:dbe5])
 (user=paulburton job=sendgmr) by 2002:a25:c58d:: with SMTP id
 v135mr1024007ybe.383.1625160257767; Thu, 01 Jul 2021 10:24:17 -0700 (PDT)
Date:   Thu,  1 Jul 2021 10:24:07 -0700
In-Reply-To: <20210701172407.889626-1-paulburton@google.com>
Message-Id: <20210701172407.889626-2-paulburton@google.com>
Mime-Version: 1.0
References: <20210701095525.400839d3@oasis.local.home> <20210701172407.889626-1-paulburton@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 2/2] tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT
From:   Paul Burton <paulburton@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paul Burton <paulburton@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently tgid_map is sized at PID_MAX_DEFAULT entries, which means that
on systems where pid_max is configured higher than PID_MAX_DEFAULT the
ftrace record-tgid option doesn't work so well. Any tasks with PIDs
higher than PID_MAX_DEFAULT are simply not recorded in tgid_map, and
don't show up in the saved_tgids file.

In particular since systemd v243 & above configure pid_max to its
highest possible 1<<22 value by default on 64 bit systems this renders
the record-tgids option of little use.

Increase the size of tgid_map to the configured pid_max instead,
allowing it to cover the full range of PIDs up to the maximum value of
PID_MAX_LIMIT if the system is configured that way.

On 64 bit systems with pid_max == PID_MAX_LIMIT this will increase the
size of tgid_map from 256KiB to 16MiB. Whilst this 64x increase in
memory overhead sounds significant 64 bit systems are presumably best
placed to accommodate it, and since tgid_map is only allocated when the
record-tgid option is actually used presumably the user would rather it
spends sufficient memory to actually record the tgids they expect.

The size of tgid_map could also increase for CONFIG_BASE_SMALL=y
configurations, but these seem unlikely to be systems upon which people
are both configuring a large pid_max and running ftrace with record-tgid
anyway.

Of note is that we only allocate tgid_map once, the first time that the
record-tgid option is enabled. Therefore its size is only set once, to
the value of pid_max at the time the record-tgid option is first
enabled. If a user increases pid_max after that point, the saved_tgids
file will not contain entries for any tasks with pids beyond the earlier
value of pid_max.

Signed-off-by: Paul Burton <paulburton@google.com>
Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: <stable@vger.kernel.org>
---
Changes in v2:
- Use the configured value of pid_max at the time record-tgid is enabled
  rather than unconditionally using PID_MAX_LIMIT, to avoid added memory
  overhead for systems that don't configure such a high pid_max.
---
 kernel/trace/trace.c | 60 ++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7a37c9e36b88..3c4b3b207c06 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2184,8 +2184,13 @@ void tracing_reset_all_online_cpus(void)
 	}
 }
 
+// The tgid_map array maps from pid to tgid; i.e. the value stored at index i
+// is the tgid last observed corresponding to pid=i.
 static int *tgid_map;
 
+// The maximum valid index into tgid_map.
+static size_t tgid_map_max;
+
 #define SAVED_CMDLINES_DEFAULT 128
 #define NO_CMDLINE_MAP UINT_MAX
 static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
@@ -2458,24 +2463,39 @@ void trace_find_cmdline(int pid, char comm[])
 	preempt_enable();
 }
 
+static int *trace_find_tgid_ptr(int pid)
+{
+	// Pairs with the smp_store_release in set_tracer_flag() to ensure that
+	// if we observe a non-NULL tgid_map then we also observe the correct
+	// tgid_map_max.
+	int *map = smp_load_acquire(&tgid_map);
+
+	if (unlikely(!map || pid > tgid_map_max))
+		return NULL;
+
+	return &map[pid];
+}
+
 int trace_find_tgid(int pid)
 {
-	if (unlikely(!tgid_map || !pid || pid > PID_MAX_DEFAULT))
-		return 0;
+	int *ptr = trace_find_tgid_ptr(pid);
 
-	return tgid_map[pid];
+	return ptr ? *ptr : 0;
 }
 
 static int trace_save_tgid(struct task_struct *tsk)
 {
+	int *ptr;
+
 	/* treat recording of idle task as a success */
 	if (!tsk->pid)
 		return 1;
 
-	if (unlikely(!tgid_map || tsk->pid > PID_MAX_DEFAULT))
+	ptr = trace_find_tgid_ptr(tsk->pid);
+	if (!ptr)
 		return 0;
 
-	tgid_map[tsk->pid] = tsk->tgid;
+	*ptr = tsk->tgid;
 	return 1;
 }
 
@@ -5171,6 +5191,8 @@ int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
 
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 {
+	int *map;
+
 	if ((mask == TRACE_ITER_RECORD_TGID) ||
 	    (mask == TRACE_ITER_RECORD_CMD))
 		lockdep_assert_held(&event_mutex);
@@ -5193,10 +5215,17 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 		trace_event_enable_cmd_record(enabled);
 
 	if (mask == TRACE_ITER_RECORD_TGID) {
-		if (!tgid_map)
-			tgid_map = kvcalloc(PID_MAX_DEFAULT + 1,
-					   sizeof(*tgid_map),
-					   GFP_KERNEL);
+		if (!tgid_map) {
+			tgid_map_max = pid_max;
+			map = kvcalloc(tgid_map_max + 1, sizeof(*tgid_map),
+				       GFP_KERNEL);
+
+			// Pairs with smp_load_acquire() in
+			// trace_find_tgid_ptr() to ensure that if it observes
+			// the tgid_map we just allocated then it also observes
+			// the corresponding tgid_map_max value.
+			smp_store_release(&tgid_map, map);
+		}
 		if (!tgid_map) {
 			tr->trace_flags &= ~TRACE_ITER_RECORD_TGID;
 			return -ENOMEM;
@@ -5610,21 +5639,14 @@ static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	int pid = ++(*pos);
 
-	if (pid > PID_MAX_DEFAULT)
-		return NULL;
-
-	// We already know that tgid_map is non-NULL here because the v
-	// argument is by definition a non-NULL pointer into tgid_map returned
-	// by saved_tgids_start() or an earlier call to saved_tgids_next().
-	return &tgid_map[pid];
+	return trace_find_tgid_ptr(pid);
 }
 
 static void *saved_tgids_start(struct seq_file *m, loff_t *pos)
 {
-	if (!tgid_map || *pos > PID_MAX_DEFAULT)
-		return NULL;
+	int pid = *pos;
 
-	return &tgid_map[*pos];
+	return trace_find_tgid_ptr(pid);
 }
 
 static void saved_tgids_stop(struct seq_file *m, void *v)
-- 
2.32.0.93.g670b81a890-goog

