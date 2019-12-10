Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F40A61199F0
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfLJVrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbfLJVJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB44246A3;
        Tue, 10 Dec 2019 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012150;
        bh=CqC1QaSNSdiClsWs9lcedYOIFVertyaxPunXnTmuUs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/P7Geybmv8vpe9cg4Gbx0Q4OZ3bAOHGYNu+P+fYByrb+DnyTx+HFVgEc9vCDu6aE
         uZ8RewX7StJk6Vqcf1eDiNA6GNrt8CTgjPAFZ6JXmx3f1OJyC2mB0vqDau7gxHeWmu
         CxAJSJD9uUvCAQ996SX4mvwFF6d+ChmW1f+6cP90=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= 
        <lclaudio@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 113/350] perf trace: Filter own pid to avoid a feedback look in 'perf trace record -a'
Date:   Tue, 10 Dec 2019 16:03:38 -0500
Message-Id: <20191210210735.9077-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7fbfe22cf4cfe01a88704dd76ca65d108039d297 ]

When doing a system wide 'perf trace record' we need, just like in 'perf
trace' live mode, to filter out perf trace's own pid, so set up a
tracepoint filter for the raw_syscalls tracepoints right after adding
them to the argv array that is set up to then call cmd_record().

Reported-by: Andi Kleen <ak@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-uysx5w8f2y5ndoln5cq370tv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index bb5130d021554..e47a08f6fca8a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2576,21 +2576,23 @@ static int trace__record(struct trace *trace, int argc, const char **argv)
 		"-m", "1024",
 		"-c", "1",
 	};
-
+	pid_t pid = getpid();
+	char *filter = asprintf__tp_filter_pids(1, &pid);
 	const char * const sc_args[] = { "-e", };
 	unsigned int sc_args_nr = ARRAY_SIZE(sc_args);
 	const char * const majpf_args[] = { "-e", "major-faults" };
 	unsigned int majpf_args_nr = ARRAY_SIZE(majpf_args);
 	const char * const minpf_args[] = { "-e", "minor-faults" };
 	unsigned int minpf_args_nr = ARRAY_SIZE(minpf_args);
+	int err = -1;
 
-	/* +1 is for the event string below */
-	rec_argc = ARRAY_SIZE(record_args) + sc_args_nr + 1 +
+	/* +3 is for the event string below and the pid filter */
+	rec_argc = ARRAY_SIZE(record_args) + sc_args_nr + 3 +
 		majpf_args_nr + minpf_args_nr + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
-	if (rec_argv == NULL)
-		return -ENOMEM;
+	if (rec_argv == NULL || filter == NULL)
+		goto out_free;
 
 	j = 0;
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
@@ -2607,11 +2609,13 @@ static int trace__record(struct trace *trace, int argc, const char **argv)
 			rec_argv[j++] = "syscalls:sys_enter,syscalls:sys_exit";
 		else {
 			pr_err("Neither raw_syscalls nor syscalls events exist.\n");
-			free(rec_argv);
-			return -1;
+			goto out_free;
 		}
 	}
 
+	rec_argv[j++] = "--filter";
+	rec_argv[j++] = filter;
+
 	if (trace->trace_pgfaults & TRACE_PFMAJ)
 		for (i = 0; i < majpf_args_nr; i++)
 			rec_argv[j++] = majpf_args[i];
@@ -2623,7 +2627,11 @@ static int trace__record(struct trace *trace, int argc, const char **argv)
 	for (i = 0; i < (unsigned int)argc; i++)
 		rec_argv[j++] = argv[i];
 
-	return cmd_record(j, rec_argv);
+	err = cmd_record(j, rec_argv);
+out_free:
+	free(filter);
+	free(rec_argv);
+	return err;
 }
 
 static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
-- 
2.20.1

