Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8818866C528
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjAPQCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjAPQBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A72A2333A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C173EB81061
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F260DC433EF;
        Mon, 16 Jan 2023 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884903;
        bh=kudM798/kcei4T9wKUjSprpmfWS0PRt+yng+0kWIehA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9cDcpBEttgOvVrc43PcL3yJlgYh9BCfnV90BPeQi5xt9yJeo+u4PFdEocGCYb/Q3
         4ROK1U/YByyhLvCwLFQuyDs+nUagrlrkzcgniqDWO5YpEnA1Vn21w48cgCgfVXNrZq
         49EEP34rNuHs5jZX4ZAbMqKYmvlT/tRXpDPdjK8w=
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
Subject: [PATCH 6.1 166/183] perf kmem: Support legacy tracepoints
Date:   Mon, 16 Jan 2023 16:51:29 +0100
Message-Id: <20230116154810.314865374@linuxfoundation.org>
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

[ Upstream commit b3719108ae60169eda5c941ca5e1be1faa371c57 ]

Commit 11e9734bcb6a7361 ("mm/slab_common: unify NUMA and UMA version of
tracepoints") removed tracepoints 'kmalloc_node' and
'kmem_cache_alloc_node', we need to consider the tool should be backward
compatible.

If it detect the tracepoint "kmem:kmalloc_node", this patch enables the
legacy tracepoints, otherwise, it will ignore them.

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
Link: https://lore.kernel.org/r/20230108062400.250690-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-kmem.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index ebfab2ca1702..63c759edb8bc 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1823,6 +1823,19 @@ static int parse_line_opt(const struct option *opt __maybe_unused,
 	return 0;
 }
 
+static bool slab_legacy_tp_is_exposed(void)
+{
+	/*
+	 * The tracepoints "kmem:kmalloc_node" and
+	 * "kmem:kmem_cache_alloc_node" have been removed on the latest
+	 * kernel, if the tracepoint "kmem:kmalloc_node" is existed it
+	 * means the tool is running on an old kernel, we need to
+	 * rollback to support these legacy tracepoints.
+	 */
+	return IS_ERR(trace_event__tp_format("kmem", "kmalloc_node")) ?
+		false : true;
+}
+
 static int __cmd_record(int argc, const char **argv)
 {
 	const char * const record_args[] = {
@@ -1830,22 +1843,28 @@ static int __cmd_record(int argc, const char **argv)
 	};
 	const char * const slab_events[] = {
 	"-e", "kmem:kmalloc",
-	"-e", "kmem:kmalloc_node",
 	"-e", "kmem:kfree",
 	"-e", "kmem:kmem_cache_alloc",
-	"-e", "kmem:kmem_cache_alloc_node",
 	"-e", "kmem:kmem_cache_free",
 	};
+	const char * const slab_legacy_events[] = {
+	"-e", "kmem:kmalloc_node",
+	"-e", "kmem:kmem_cache_alloc_node",
+	};
 	const char * const page_events[] = {
 	"-e", "kmem:mm_page_alloc",
 	"-e", "kmem:mm_page_free",
 	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
+	unsigned int slab_legacy_tp_exposed = slab_legacy_tp_is_exposed();
 
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
-	if (kmem_slab)
+	if (kmem_slab) {
 		rec_argc += ARRAY_SIZE(slab_events);
+		if (slab_legacy_tp_exposed)
+			rec_argc += ARRAY_SIZE(slab_legacy_events);
+	}
 	if (kmem_page)
 		rec_argc += ARRAY_SIZE(page_events) + 1; /* for -g */
 
@@ -1860,6 +1879,10 @@ static int __cmd_record(int argc, const char **argv)
 	if (kmem_slab) {
 		for (j = 0; j < ARRAY_SIZE(slab_events); j++, i++)
 			rec_argv[i] = strdup(slab_events[j]);
+		if (slab_legacy_tp_exposed) {
+			for (j = 0; j < ARRAY_SIZE(slab_legacy_events); j++, i++)
+				rec_argv[i] = strdup(slab_legacy_events[j]);
+		}
 	}
 	if (kmem_page) {
 		rec_argv[i++] = strdup("-g");
-- 
2.35.1



