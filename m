Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BC22E4015
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502779AbgL1Orw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:47:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439209AbgL1OXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A944207B2;
        Mon, 28 Dec 2020 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165369;
        bh=Tj44dTdXaFk23UtGG7HF/SNLeLwIp4umRsHOGWmOdzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4hAWyY2QoOzB4QcLo0AqaiLsLmf0GtB4q53LkbM68s2J0A4Wnrx6YZ68ZVWCobT8
         E2OASFvLxsG/nEP/tKy5xTZAW4J3XgD432A+ot7VeHjcdQXJZIGZtDCLQvhobHGxcn
         DODz6YsCstjA6IUZ4qwxt/cMguUBoeCBE8slctG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Truong <alexandre.truong@arm.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        He Zhe <zhe.he@windriver.com>, Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/717] perf probe: Fix memory leak when synthesizing SDT probes
Date:   Mon, 28 Dec 2020 13:48:23 +0100
Message-Id: <20201228125045.154010502@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5149303fdfe5c67ddb51c911e23262f781cd75eb ]

The argv_split() function must be paired with argv_free(), else we must
keep a reference to the argv array received or do the freeing ourselves,
in synthesize_sdt_probe_command() we were simply leaking that argv[]
array.

Fixes: 3b1f8311f6963cd1 ("perf probe: Add sdt probes arguments into the uprobe cmd string")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Truong <alexandre.truong@arm.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: He Zhe <zhe.he@windriver.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201224135139.GF477817@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-file.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 064b63a6a3f31..bbecb449ea944 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -791,7 +791,7 @@ static char *synthesize_sdt_probe_command(struct sdt_note *note,
 					const char *sdtgrp)
 {
 	struct strbuf buf;
-	char *ret = NULL, **args;
+	char *ret = NULL;
 	int i, args_count, err;
 	unsigned long long ref_ctr_offset;
 
@@ -813,12 +813,19 @@ static char *synthesize_sdt_probe_command(struct sdt_note *note,
 		goto out;
 
 	if (note->args) {
-		args = argv_split(note->args, &args_count);
+		char **args = argv_split(note->args, &args_count);
+
+		if (args == NULL)
+			goto error;
 
 		for (i = 0; i < args_count; ++i) {
-			if (synthesize_sdt_probe_arg(&buf, i, args[i]) < 0)
+			if (synthesize_sdt_probe_arg(&buf, i, args[i]) < 0) {
+				argv_free(args);
 				goto error;
+			}
 		}
+
+		argv_free(args);
 	}
 
 out:
-- 
2.27.0



