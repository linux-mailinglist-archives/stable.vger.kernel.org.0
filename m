Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F4B5F2A46
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiJCHeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiJCHdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:33:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12A4F02B;
        Mon,  3 Oct 2022 00:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A455660FBD;
        Mon,  3 Oct 2022 07:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD5CC433D6;
        Mon,  3 Oct 2022 07:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781610;
        bh=1gUeMXGvlG3wk/DWkcHRFN1RbJh6rlH/eFsmuofcZWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svPP+d70+5cwGuClT8k95yzWdKh1SxwlE6RiRaCv6ZWF99mNcI+1Y6RiQvVCbTbf+
         B3/jKeTiKTG8ssoA///3ZBsIXTSFd/V4lV69fZdNGwV0Q4TtbcP41szBYC/Gsx2I8i
         IMCB08zFkKQi1ykpZKeX80ZAz2tKPv++VZc6vwf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 82/83] perf pmu: Fix alias events list
Date:   Mon,  3 Oct 2022 09:11:47 +0200
Message-Id: <20221003070724.059824448@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: John Garry <john.garry@huawei.com>

commit e0257a01d6689c273a019756ed5e13911cc1bfed upstream.

Commit 0e0ae8742207c3b4 ("perf list: Display hybrid PMU events with cpu
type") changes the event list for uncore PMUs or arm64 heterogeneous CPU
systems, such that duplicate aliases are incorrectly listed per PMU
(which they should not be), like:

  # perf list
  ...
  unc_cbo_cache_lookup.any_es
  [Unit: uncore_cbox L3 Lookup any request that access cache and found
  line in E or S-state]
  unc_cbo_cache_lookup.any_es
  [Unit: uncore_cbox L3 Lookup any request that access cache and found
  line in E or S-state]
  unc_cbo_cache_lookup.any_i
  [Unit: uncore_cbox L3 Lookup any request that access cache and found
  line in I-state]
  unc_cbo_cache_lookup.any_i
  [Unit: uncore_cbox L3 Lookup any request that access cache and found
  line in I-state]
  ...

Notice how the events are listed twice.

The named commit changed how we remove duplicate events, in that events
for different PMUs are not treated as duplicates. I suppose this is to
handle how "Each hybrid pmu event has been assigned with a pmu name".

Fix PMU alias listing by restoring behaviour to remove duplicates for
non-hybrid PMUs.

Fixes: 0e0ae8742207c3b4 ("perf list: Display hybrid PMU events with cpu type")
Signed-off-by: John Garry <john.garry@huawei.com>
Tested-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/1640103090-140490-1-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/pmu.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1659,6 +1659,21 @@ bool is_pmu_core(const char *name)
 	return !strcmp(name, "cpu") || is_arm_pmu_core(name);
 }
 
+static bool pmu_alias_is_duplicate(struct sevent *alias_a,
+				   struct sevent *alias_b)
+{
+	/* Different names -> never duplicates */
+	if (strcmp(alias_a->name, alias_b->name))
+		return false;
+
+	/* Don't remove duplicates for hybrid PMUs */
+	if (perf_pmu__is_hybrid(alias_a->pmu) &&
+	    perf_pmu__is_hybrid(alias_b->pmu))
+		return false;
+
+	return true;
+}
+
 void print_pmu_events(const char *event_glob, bool name_only, bool quiet_flag,
 			bool long_desc, bool details_flag, bool deprecated,
 			const char *pmu_name)
@@ -1744,12 +1759,8 @@ void print_pmu_events(const char *event_
 	qsort(aliases, len, sizeof(struct sevent), cmp_sevent);
 	for (j = 0; j < len; j++) {
 		/* Skip duplicates */
-		if (j > 0 && !strcmp(aliases[j].name, aliases[j - 1].name)) {
-			if (!aliases[j].pmu || !aliases[j - 1].pmu ||
-			    !strcmp(aliases[j].pmu, aliases[j - 1].pmu)) {
-				continue;
-			}
-		}
+		if (j > 0 && pmu_alias_is_duplicate(&aliases[j], &aliases[j - 1]))
+			continue;
 
 		if (name_only) {
 			printf("%s ", aliases[j].name);


