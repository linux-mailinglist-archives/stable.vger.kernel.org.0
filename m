Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDF78C6DB
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfHNCTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfHNCTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:19:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000F4208C2;
        Wed, 14 Aug 2019 02:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749178;
        bh=D/em/S7NvFcOLs6ba7+vpegJOY8fq1VppQOFA6TU0xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/NOduyvmJxE6NYNDmTxOMjMT5dFK3keyco4+EH6qMCPSUaqgqcj34lmjLBu9LxQA
         EfsFix3wjUSwJMxGaJtOzMRZr36VSY+Y1pbocMlU1JVLOHW3J4JmtRBuWNht7u5OZG
         8T3Pl8w9zbi3gEmP3B+8KbvfMWBBHYCVgArtvvBk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     He Zhe <zhe.he@windriver.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 41/44] perf ftrace: Fix failure to set cpumask when only one cpu is present
Date:   Tue, 13 Aug 2019 22:18:30 -0400
Message-Id: <20190814021834.16662-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit cf30ae726c011e0372fd4c2d588466c8b50a8907 ]

The buffer containing the string used to set cpumask is overwritten at
the end of the string later in cpu_map__snprint_mask due to not enough
memory space, when there is only one cpu.

And thus causes the following failure:

  $ perf ftrace ls
  failed to reset ftrace
  $

This patch fixes the calculation of the cpumask string size.

Signed-off-by: He Zhe <zhe.he@windriver.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Fixes: dc23103278c5 ("perf ftrace: Add support for -a and -C option")
Link: http://lkml.kernel.org/r/1564734592-15624-1-git-send-email-zhe.he@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 25a42acabee18..13a33fb71a6da 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -162,7 +162,7 @@ static int set_tracing_cpumask(struct cpu_map *cpumap)
 	int last_cpu;
 
 	last_cpu = cpu_map__cpu(cpumap, cpumap->nr - 1);
-	mask_size = (last_cpu + 3) / 4 + 1;
+	mask_size = last_cpu / 4 + 2; /* one more byte for EOS */
 	mask_size += last_cpu / 32; /* ',' is needed for every 32th cpus */
 
 	cpumask = malloc(mask_size);
-- 
2.20.1

