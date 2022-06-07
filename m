Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD8541564
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357678AbiFGUfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377354AbiFGUdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1251E3B33;
        Tue,  7 Jun 2022 11:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E905612F2;
        Tue,  7 Jun 2022 18:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AB8C385A2;
        Tue,  7 Jun 2022 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626898;
        bh=s3REUmejm2B+k1Evp0AVpqDRsmJH2BJYafLe0kD8m6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5/KZuPFs3BIbkyob5UXva/bnpMcwZ8VTp31arPKvg8IxWOjzLRrfzuZv9Z/EO3Le
         tomnFtAY9kaHgikWaSMbzfjxkLI46EwjlDYFcrygDM78ogiWkp8RH5oTIxtO0qB6L+
         I35ovPhjVg2x2+ncI/B6cUMPR/NfFoU43d7XJrs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 543/772] perf stat: Always keep perf metrics topdown events in a group
Date:   Tue,  7 Jun 2022 19:02:15 +0200
Message-Id: <20220607165004.964889851@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit e8f4f794d7047dd36f090f44f12cd645fba204d2 ]

If any member in a group has a different cpu mask than the other
members, the current perf stat disables group. when the perf metrics
topdown events are part of the group, the below <not supported> error
will be triggered.

  $ perf stat -e "{slots,topdown-retiring,uncore_imc_free_running_0/dclk/}" -a sleep 1
  WARNING: grouped events cpus do not match, disabling group:
    anon group { slots, topdown-retiring, uncore_imc_free_running_0/dclk/ }

   Performance counter stats for 'system wide':

         141,465,174      slots
     <not supported>      topdown-retiring
       1,605,330,334      uncore_imc_free_running_0/dclk/

The perf metrics topdown events must always be grouped with a slots
event as leader.

Factor out evsel__remove_from_group() to only remove the regular events
from the group.

Remove evsel__must_be_in_group(), since no one use it anymore.

With the patch, the topdown events aren't broken from the group for the
splitting.

  $ perf stat -e "{slots,topdown-retiring,uncore_imc_free_running_0/dclk/}" -a sleep 1
  WARNING: grouped events cpus do not match, disabling group:
    anon group { slots, topdown-retiring, uncore_imc_free_running_0/dclk/ }

   Performance counter stats for 'system wide':

         346,110,588      slots
         124,608,256      topdown-retiring
       1,606,869,976      uncore_imc_free_running_0/dclk/

         1.003877592 seconds time elapsed

Fixes: a9a1790247bdcf3b ("perf stat: Ensure group is defined on top of the same cpu mask")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20220518143900.1493980-3-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c |  7 ++-----
 tools/perf/util/evlist.c  |  6 +-----
 tools/perf/util/evsel.c   | 13 +++++++++++--
 tools/perf/util/evsel.h   |  2 +-
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 60baa3dadc4b..416a6a4fbcc7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -271,11 +271,8 @@ static void evlist__check_cpu_maps(struct evlist *evlist)
 			pr_warning("     %s: %s\n", evsel->name, buf);
 		}
 
-		for_each_group_evsel(pos, leader) {
-			evsel__set_leader(pos, pos);
-			pos->core.nr_members = 0;
-		}
-		evsel->core.leader->nr_members = 0;
+		for_each_group_evsel(pos, leader)
+			evsel__remove_from_group(pos, leader);
 	}
 }
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3ff0de0b6710..ec745209c8b4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1795,11 +1795,7 @@ struct evsel *evlist__reset_weak_group(struct evlist *evsel_list, struct evsel *
 			 * them. Some events, like Intel topdown, require being
 			 * in a group and so keep these in the group.
 			 */
-			if (!evsel__must_be_in_group(c2) && c2 != leader) {
-				evsel__set_leader(c2, c2);
-				c2->core.nr_members = 0;
-				leader->core.nr_members--;
-			}
+			evsel__remove_from_group(c2, leader);
 
 			/*
 			 * Set this for all former members of the group
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6fb3cf924dd2..63284e98c419 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3054,7 +3054,16 @@ bool __weak arch_evsel__must_be_in_group(const struct evsel *evsel __maybe_unuse
 	return false;
 }
 
-bool evsel__must_be_in_group(const struct evsel *evsel)
+/*
+ * Remove an event from a given group (leader).
+ * Some events, e.g., perf metrics Topdown events,
+ * must always be grouped. Ignore the events.
+ */
+void evsel__remove_from_group(struct evsel *evsel, struct evsel *leader)
 {
-	return arch_evsel__must_be_in_group(evsel);
+	if (!arch_evsel__must_be_in_group(evsel) && evsel != leader) {
+		evsel__set_leader(evsel, evsel);
+		evsel->core.nr_members = 0;
+		leader->core.nr_members--;
+	}
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a36172ed4cf6..47f65f8e7c74 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -483,7 +483,7 @@ bool evsel__has_leader(struct evsel *evsel, struct evsel *leader);
 bool evsel__is_leader(struct evsel *evsel);
 void evsel__set_leader(struct evsel *evsel, struct evsel *leader);
 int evsel__source_count(const struct evsel *evsel);
-bool evsel__must_be_in_group(const struct evsel *evsel);
+void evsel__remove_from_group(struct evsel *evsel, struct evsel *leader);
 
 bool arch_evsel__must_be_in_group(const struct evsel *evsel);
 
-- 
2.35.1



