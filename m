Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10D59DF47
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfH0Hwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729611AbfH0Hww (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:52:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC4021881;
        Tue, 27 Aug 2019 07:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892371;
        bh=9/5dpNPUo2nUy+0Uk5+4xtKNFRNAwE8t6rqidz1AH48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvEoGq4+TXN7wVW9eyauk54c2g7tvTDpvQUXuOOSc/ZzfHRUVwV0sP3nP9xlTZ61M
         KJzIs0TwZvIAHugpa1Otwo03aCIudHgHP8R1VYxItvxa+YvRZGEgoeO0VDMEI7Tr2O
         p5lp8FcNEVCYZj2blHFel3K4Ye4x82S/qX6B5Gbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/62] perf ftrace: Fix failure to set cpumask when only one cpu is present
Date:   Tue, 27 Aug 2019 09:50:37 +0200
Message-Id: <20190827072702.573643896@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



