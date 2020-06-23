Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B752064C6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389863AbgFWV1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389229AbgFWUQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36012145D;
        Tue, 23 Jun 2020 20:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943419;
        bh=iremO8qJ45paftYAO3M1qTShaKNRP4EwjN7wWH9FyL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tld/yRDocRi67pnPWJ4WoBIkWt3fIK75DIo2kIuo+2YzSEa63pLRefVPa0BSDF41t
         gXVLUQ6qE1fievZJ/FOp3pJOJ8gIydgAe6sdWPT0IZWxWPK4ta1i8/ertwjBRwvjMY
         EGWaS0ENp58uBUxKtzk1nM2Xt7Y+ik4eS5L3OgqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        bpf@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 385/477] perf probe: Fix user attribute access in kprobes
Date:   Tue, 23 Jun 2020 21:56:22 +0200
Message-Id: <20200623195425.725155460@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit 9256c3031eb9beafa3957c61093104c3c75a6148 ]

Issue:

  # perf probe -a 'do_sched_setscheduler pid policy param->sched_priority@user'

did not work before.

Fix:

Make:

  # perf probe -a 'do_sched_setscheduler pid policy param->sched_priority@user'

output equivalent to ftrace:

  # echo 'p:probe/do_sched_setscheduler _text+517384 pid=%r2:s32 policy=%r3:s32 sched_priority=+u0(%r4):s32' > /sys/kernel/debug/tracing/kprobe_events

Other:

1. Right now, __match_glob() does not handle [u]<offset>. For now, use
  *u]<offset>.

2. @user attribute was introduced in commit 1e032f7cfa14 ("perf-probe:
   Add user memory access attribute support")

Test:
1. perf probe -a 'do_sched_setscheduler  pid policy
   param->sched_priority@user'

2 ./perf script
   sched 305669 [000] 1614458.838675: perf_bpf_probe:func: (2904e508)
   pid=261614 policy=2 sched_priority=1

3. cat /sys/kernel/debug/tracing/trace
   <...>-309956 [006] .... 1616098.093957: 0: prio: 1

Committer testing:

Before:

  # perf probe -a 'do_sched_setscheduler pid policy param->sched_priority@user'
  param(type:sched_param) has no member sched_priority@user.
    Error: Failed to add events.
  # pahole sched_param
  struct sched_param {
  	int                        sched_priority;       /*     0     4 */

  	/* size: 4, cachelines: 1, members: 1 */
  	/* last cacheline: 4 bytes */
  };
  #

After:

  # perf probe -a 'do_sched_setscheduler pid policy param->sched_priority@user'
  Added new event:
    probe:do_sched_setscheduler (on do_sched_setscheduler with pid policy sched_priority=param->sched_priority)

  You can now use it in all perf tools, such as:

  	perf record -e probe:do_sched_setscheduler -aR sleep 1

  # cat /sys/kernel/debug/tracing/kprobe_events
  p:probe/do_sched_setscheduler _text+1113792 pid=%di:s32 policy=%si:s32 sched_priority=+u0(%dx):s32
  #

Fixes: 1e032f7cfa14 ("perf-probe: Add user memory access attribute support")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: bpf@vger.kernel.org
LPU-Reference: 20200609081019.60234-2-sumanthk@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-event.c | 7 +++++--
 tools/perf/util/probe-file.c  | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a08f373d33056..df713a5d1e26a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1575,7 +1575,7 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 	}
 
 	tmp = strchr(str, '@');
-	if (tmp && tmp != str && strcmp(tmp + 1, "user")) { /* user attr */
+	if (tmp && tmp != str && !strcmp(tmp + 1, "user")) { /* user attr */
 		if (!user_access_is_supported()) {
 			semantic_error("ftrace does not support user access\n");
 			return -EINVAL;
@@ -1995,7 +1995,10 @@ static int __synthesize_probe_trace_arg_ref(struct probe_trace_arg_ref *ref,
 		if (depth < 0)
 			return depth;
 	}
-	err = strbuf_addf(buf, "%+ld(", ref->offset);
+	if (ref->user_access)
+		err = strbuf_addf(buf, "%s%ld(", "+u", ref->offset);
+	else
+		err = strbuf_addf(buf, "%+ld(", ref->offset);
 	return (err < 0) ? err : depth;
 }
 
diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 8c852948513e3..064b63a6a3f31 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -1044,7 +1044,7 @@ static struct {
 	DEFINE_TYPE(FTRACE_README_PROBE_TYPE_X, "*type: * x8/16/32/64,*"),
 	DEFINE_TYPE(FTRACE_README_KRETPROBE_OFFSET, "*place (kretprobe): *"),
 	DEFINE_TYPE(FTRACE_README_UPROBE_REF_CTR, "*ref_ctr_offset*"),
-	DEFINE_TYPE(FTRACE_README_USER_ACCESS, "*[u]<offset>*"),
+	DEFINE_TYPE(FTRACE_README_USER_ACCESS, "*u]<offset>*"),
 	DEFINE_TYPE(FTRACE_README_MULTIPROBE_EVENT, "*Create/append/*"),
 	DEFINE_TYPE(FTRACE_README_IMMEDIATE_VALUE, "*\\imm-value,*"),
 };
-- 
2.25.1



