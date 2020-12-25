Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FEB2E29E0
	for <lists+stable@lfdr.de>; Fri, 25 Dec 2020 06:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgLYF2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Dec 2020 00:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgLYF2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Dec 2020 00:28:47 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8F2C061575
        for <stable@vger.kernel.org>; Thu, 24 Dec 2020 21:28:07 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 11so2150527pfu.4
        for <stable@vger.kernel.org>; Thu, 24 Dec 2020 21:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fggFNHkIm4LYrEAhkgghWWYvuA1sVNNnoLCFYuyGlq0=;
        b=kEN7zSRi+7riSkXhcZrU8TJWQ4DnunTjyGXKsR69nYEFYNq64ohC72qdjFnHuXBBhC
         y9REVFiXQvPsL4WT62tXjdG5TZbFfQ5JFtRrN078rt8NzJ/v/z73Z70RYBj60V5fM6IR
         2Ipq89qwjypEeyT92GO2qgvF0tobYN3uu4bGeyQHOWXpT4kN3mg0AA2/Edmt//bL8JaM
         jJ4P7b5tmFsz2GCc/ImFJyv+ts+nQm7jPrAyk/TQ11nLu4TyaFMycOL1Nrnu3Yw/YErp
         0B7b6IRQRtKIWwN9Ql17vWPXVnEjn2HFGEnStKxReFEmDIHCXFMnfFJ0AQiLRNm11VbM
         fODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fggFNHkIm4LYrEAhkgghWWYvuA1sVNNnoLCFYuyGlq0=;
        b=bq3f0enbVd44SmhMN5YFYGtVigbiWi/l4ePDOVXFYY6ZjXzp+i0CPYRuOOeG8Gjfbg
         15W0V+gnSECy8fkT6z2aJb1QsUctziupJ1+Z2D3VZh2BivERmaY4CsD0pj+9UNKwpPPt
         CtwRnFBJbnUHHGtKgAx8Ckw7uIPWXYT0y1zxhjIxXazIhSbIwHJBHlxqk+zarZYIZB+g
         o6hiWGg56rfoc7gGaa7YY5lcvUhENGFQom63DL35QKZ9bVTKG2AKiOvnhh49gdmzNTQi
         6LyNnKRPNN5gUBcV0W5UqGL6fpZUJrovyPl614ZEFveR9HzVpi87qAPqaGf72envVikz
         MC8A==
X-Gm-Message-State: AOAM533DsmEOXiczGkr3kb0b4jRR4extdKCfVKGDwgtCrJrlHDjj3Snb
        pgRXsYJA+JXamh8hcbtZ6igNiw==
X-Google-Smtp-Source: ABdhPJxH3HZ5HXhbr/CHl5MUe98jSpKJsDIbtdnv3P2YMkrXMNZCm+tx78RxEj+4EoNtjQ8SOVcwyA==
X-Received: by 2002:aa7:9ab7:0:b029:19d:ac89:39aa with SMTP id x23-20020aa79ab70000b029019dac8939aamr30486597pfi.10.1608874086935;
        Thu, 24 Dec 2020 21:28:06 -0800 (PST)
Received: from localhost ([45.137.216.7])
        by smtp.gmail.com with ESMTPSA id g85sm28526152pfb.4.2020.12.24.21.28.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Dec 2020 21:28:06 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexandre Truong <alexandre.truong@arm.com>,
        Ian Rogers <irogers@google.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        He Zhe <zhe.he@windriver.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Leo Yan <leo.yan@linaro.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/3] perf probe: Fix memory leak in synthesize_sdt_probe_command()
Date:   Fri, 25 Dec 2020 13:27:49 +0800
Message-Id: <20201225052751.24513-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201225052751.24513-1-leo.yan@linaro.org>
References: <20201225052751.24513-1-leo.yan@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In synthesize_sdt_probe_command(), it gets argument array from
argv_split() but forgets to free it.  This patch calls argv_free() to
free the argument array to avoid memory leak.

Fixes: 3b1f8311f696 ("perf probe: Add sdt probes arguments into the uprobe cmd string")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Cc: stable@vger.kernel.org
---
 tools/perf/util/probe-file.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 064b63a6a3f3..bbecb449ea94 100644
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
2.17.1

