Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF24066C529
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjAPQCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjAPQBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0ED23C50
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D20561047
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9F2C433EF;
        Mon, 16 Jan 2023 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884906;
        bh=7ngtpNpRdyuMIe9jf8cRtnaBAiVtorvis9hHf1pqhiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/dYQD4jrsa/OldTO84qW1CBBFZeuPn4cdppxwVXixScK8BjkZPaSyRKEIimFDKBA
         B+arq/2I1wK27rRoHFaX8cTXHM9aujaCRPAnlPxdrBkxwYFDqXouI/Fs5fDmRtrYQ5
         deyXqBbIAP9bcRQhIRU1A0F2Hff+3f2xGfZNccFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ravi Bangoria <ravi.bangoria@amd.com>,
        James Clark <james.clark@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/183] perf kmem: Support field "node" in evsel__process_alloc_event() coping with recent tracepoint restructuring
Date:   Mon, 16 Jan 2023 16:51:30 +0100
Message-Id: <20230116154810.345729215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit dce088ab0d51ae3b14fb2bd608e9c649aadfe5dc ]

Commit 11e9734bcb6a7361 ("mm/slab_common: unify NUMA and UMA version of
tracepoints") adds the field "node" into the tracepoints 'kmalloc' and
'kmem_cache_alloc', so this patch modifies the event process function to
support the field "node".

If field "node" is detected by checking function evsel__field(), it
stats the cross allocation.

When the "node" value is NUMA_NO_NODE (-1), it means the memory can be
allocated from any memory node, in this case, we don't account it as a
cross allocation.

Fixes: 11e9734bcb6a7361 ("mm/slab_common: unify NUMA and UMA version of tracepoints")
Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/r/20230108062400.250690-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-kmem.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 63c759edb8bc..40dd52acc48a 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -26,6 +26,7 @@
 #include "util/string2.h"
 
 #include <linux/kernel.h>
+#include <linux/numa.h>
 #include <linux/rbtree.h>
 #include <linux/string.h>
 #include <linux/zalloc.h>
@@ -184,22 +185,33 @@ static int evsel__process_alloc_event(struct evsel *evsel, struct perf_sample *s
 	total_allocated += bytes_alloc;
 
 	nr_allocs++;
-	return 0;
-}
 
-static int evsel__process_alloc_node_event(struct evsel *evsel, struct perf_sample *sample)
-{
-	int ret = evsel__process_alloc_event(evsel, sample);
+	/*
+	 * Commit 11e9734bcb6a ("mm/slab_common: unify NUMA and UMA
+	 * version of tracepoints") adds the field "node" into the
+	 * tracepoints 'kmalloc' and 'kmem_cache_alloc'.
+	 *
+	 * The legacy tracepoints 'kmalloc_node' and 'kmem_cache_alloc_node'
+	 * also contain the field "node".
+	 *
+	 * If the tracepoint contains the field "node" the tool stats the
+	 * cross allocation.
+	 */
+	if (evsel__field(evsel, "node")) {
+		int node1, node2;
 
-	if (!ret) {
-		int node1 = cpu__get_node((struct perf_cpu){.cpu = sample->cpu}),
-		    node2 = evsel__intval(evsel, sample, "node");
+		node1 = cpu__get_node((struct perf_cpu){.cpu = sample->cpu});
+		node2 = evsel__intval(evsel, sample, "node");
 
-		if (node1 != node2)
+		/*
+		 * If the field "node" is NUMA_NO_NODE (-1), we don't take it
+		 * as a cross allocation.
+		 */
+		if ((node2 != NUMA_NO_NODE) && (node1 != node2))
 			nr_cross_allocs++;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int ptr_cmp(void *, void *);
@@ -1368,8 +1380,8 @@ static int __cmd_kmem(struct perf_session *session)
 		/* slab allocator */
 		{ "kmem:kmalloc",		evsel__process_alloc_event, },
 		{ "kmem:kmem_cache_alloc",	evsel__process_alloc_event, },
-		{ "kmem:kmalloc_node",		evsel__process_alloc_node_event, },
-		{ "kmem:kmem_cache_alloc_node", evsel__process_alloc_node_event, },
+		{ "kmem:kmalloc_node",		evsel__process_alloc_event, },
+		{ "kmem:kmem_cache_alloc_node", evsel__process_alloc_event, },
 		{ "kmem:kfree",			evsel__process_free_event, },
 		{ "kmem:kmem_cache_free",	evsel__process_free_event, },
 		/* page allocator */
-- 
2.35.1



