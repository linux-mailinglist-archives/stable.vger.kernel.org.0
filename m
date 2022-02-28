Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D13A4C75D3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbiB1R4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiB1Ryq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E54553733;
        Mon, 28 Feb 2022 09:43:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18BB060748;
        Mon, 28 Feb 2022 17:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029FDC340F5;
        Mon, 28 Feb 2022 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070237;
        bh=pRsXDIZaX6/B6+4vcBJG6GbnQNuzWJ76G+Fce0QPDKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Spc3msSxvShts5jnzc5y5emtTM0oX11MOys7GNoPX5ldpOAGbnhDqxCpi6Gq4qRW5
         wACfidJDnIRkQJpl7fdP8LQ+R+h5zGILThtYslK8Nx0xD7FEvw9NChZb/Gr/vgFgM0
         X9Z5LqGtYyR1O8Elnc4BC0RfZYYr3g6zD2Z5rzGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        alexander.shishkin@intel.com, Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.16 036/164] perf evlist: Fix failed to use cpu list for uncore events
Date:   Mon, 28 Feb 2022 18:23:18 +0100
Message-Id: <20220228172403.551965170@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

commit 8a3d2ee0de3828e0d01f9682d35ee53704659bd0 upstream.

The 'perf record' and 'perf stat' commands have supported the option
'-C/--cpus' to count or collect only on the list of CPUs provided.

Commit 1d3351e631fc34d7 ("perf tools: Enable on a list of CPUs for
hybrid") add it to be supported for hybrid. For hybrid support, it
checks the cpu list are available on hybrid PMU. But when we test only
uncore events(or events not in cpu_core and cpu_atom), there is a bug:

Before:

 # perf stat -C0  -e uncore_clock/clockticks/ sleep 1
   failed to use cpu list 0

In this case, for uncore event, its pmu_name is not cpu_core or
cpu_atom, so in evlist__fix_hybrid_cpus, perf_pmu__find_hybrid_pmu
should return NULL,both events_nr and unmatched_count should be 0 ,then
the cpu list check function evlist__fix_hybrid_cpus return -1 and the
error "failed to use cpu list 0" will happen. Bypass "events_nr=0" case
then the issue is fixed.

After:

 # perf stat -C0  -e uncore_clock/clockticks/ sleep 1

 Performance counter stats for 'CPU(s) 0':

       195,476,873      uncore_clock/clockticks/

       1.004518677 seconds time elapsed

When testing with at least one core event and uncore events, it has no
issue.

 # perf stat -C0  -e cpu_core/cpu-cycles/,uncore_clock/clockticks/ sleep 1

 Performance counter stats for 'CPU(s) 0':

         5,993,774      cpu_core/cpu-cycles/
       301,025,912      uncore_clock/clockticks/

       1.003964934 seconds time elapsed

Fixes: 1d3351e631fc34d7 ("perf tools: Enable on a list of CPUs for hybrid")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: alexander.shishkin@intel.com
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20220218093127.1844241-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/evlist-hybrid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/evlist-hybrid.c
+++ b/tools/perf/util/evlist-hybrid.c
@@ -153,8 +153,8 @@ int evlist__fix_hybrid_cpus(struct evlis
 		perf_cpu_map__put(matched_cpus);
 		perf_cpu_map__put(unmatched_cpus);
 	}
-
-	ret = (unmatched_count == events_nr) ? -1 : 0;
+	if (events_nr)
+		ret = (unmatched_count == events_nr) ? -1 : 0;
 out:
 	perf_cpu_map__put(cpus);
 	return ret;


