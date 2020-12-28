Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7202E4327
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406310AbgL1Pdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407374AbgL1Nxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675B22072C;
        Mon, 28 Dec 2020 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163594;
        bh=b9g8ysgoLDr1ZfY0IDETC9mH3H9RUvJFUYrxjrObQVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOo1cjKW4l9cYkSLsdCXrDyWOP9a97A/pCa02t8iAbB62/DJKHcEagApC9CW+au1B
         HvFNE3MtWNA68gXThJAJ8jXekeIqzNsca0Trec/n0O/ca729kgHKTCSzUiU9xOdH4W
         FUSHtnPCwivWjAa8MQjCUA4JpZIway+ETVBts9GM=
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
Subject: [PATCH 5.4 310/453] perf probe: Fix memory leak when synthesizing SDT probes
Date:   Mon, 28 Dec 2020 13:49:06 +0100
Message-Id: <20201228124952.130935643@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index bf50f464234fe..f778f8e7e65a3 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -777,7 +777,7 @@ static char *synthesize_sdt_probe_command(struct sdt_note *note,
 					const char *sdtgrp)
 {
 	struct strbuf buf;
-	char *ret = NULL, **args;
+	char *ret = NULL;
 	int i, args_count, err;
 	unsigned long long ref_ctr_offset;
 
@@ -799,12 +799,19 @@ static char *synthesize_sdt_probe_command(struct sdt_note *note,
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



