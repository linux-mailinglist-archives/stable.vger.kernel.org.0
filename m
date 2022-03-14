Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87FE4D845D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbiCNMYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243940AbiCNMVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F3D13D05;
        Mon, 14 Mar 2022 05:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D74F608C4;
        Mon, 14 Mar 2022 12:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406E1C340E9;
        Mon, 14 Mar 2022 12:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260337;
        bh=YCeyHF403XWmfv0m5fpr7Hxca6frcdIOMmZB/BHBqK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aF1H9cm0KBCvW1Zi5Tdj4P5ypzhL8Bu9QRBn6WsBI3ghvCsHLPa0STKH9Obi9BUrv
         dJSIaJ6c3bKymzkOt11lH3NMBg7PzfYDmbmzGJKwlQf78XBseAT76j4y7uNt71lgJ7
         HkdoHJV8NB3LrehTN9bZSShHLko2q6RKip9rvjt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.16 119/121] perf parse: Fix event parser error for hybrid systems
Date:   Mon, 14 Mar 2022 12:55:02 +0100
Message-Id: <20220314112747.433395731@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

commit 91c9923a473a694eb1c5c01ab778a77114969707 upstream.

This bug happened on hybrid systems when both cpu_core and cpu_atom
have the same event name such as "UOPS_RETIRED.MS" while their event
terms are different, then during perf stat, the event for cpu_atom
will parse fail and then no output for cpu_atom.

UOPS_RETIRED.MS -> cpu_core/period=0x1e8483,umask=0x4,event=0xc2,frontend=0x8/
UOPS_RETIRED.MS -> cpu_atom/period=0x1e8483,umask=0x1,event=0xc2/

It is because event terms in the "head" of parse_events_multi_pmu_add
will be changed to event terms for cpu_core after parsing UOPS_RETIRED.MS
for cpu_core, then when parsing the same event for cpu_atom, it still
uses the event terms for cpu_core, but event terms for cpu_atom are
different with cpu_core, the event parses for cpu_atom will fail. This
patch fixes it, the event terms should be parsed from the original
event.

This patch can work for the hybrid systems that have the same event
in more than 2 PMUs. It also can work in non-hybrid systems.

Before:

  # perf stat -v  -e  UOPS_RETIRED.MS  -a sleep 1

  Using CPUID GenuineIntel-6-97-1
  UOPS_RETIRED.MS -> cpu_core/period=0x1e8483,umask=0x4,event=0xc2,frontend=0x8/
  Control descriptor is not initialized
  UOPS_RETIRED.MS: 2737845 16068518485 16068518485

 Performance counter stats for 'system wide':

         2,737,845      cpu_core/UOPS_RETIRED.MS/

       1.002553850 seconds time elapsed

After:

  # perf stat -v  -e  UOPS_RETIRED.MS  -a sleep 1

  Using CPUID GenuineIntel-6-97-1
  UOPS_RETIRED.MS -> cpu_core/period=0x1e8483,umask=0x4,event=0xc2,frontend=0x8/
  UOPS_RETIRED.MS -> cpu_atom/period=0x1e8483,umask=0x1,event=0xc2/
  Control descriptor is not initialized
  UOPS_RETIRED.MS: 1977555 16076950711 16076950711
  UOPS_RETIRED.MS: 568684 8038694234 8038694234

 Performance counter stats for 'system wide':

         1,977,555      cpu_core/UOPS_RETIRED.MS/
           568,684      cpu_atom/UOPS_RETIRED.MS/

       1.004758259 seconds time elapsed

Fixes: fb0811535e92c6c1 ("perf parse-events: Allow config on kernel PMU events")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220307151627.30049-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/parse-events.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1648,6 +1648,7 @@ int parse_events_multi_pmu_add(struct pa
 {
 	struct parse_events_term *term;
 	struct list_head *list = NULL;
+	struct list_head *orig_head = NULL;
 	struct perf_pmu *pmu = NULL;
 	int ok = 0;
 	char *config;
@@ -1674,7 +1675,6 @@ int parse_events_multi_pmu_add(struct pa
 	}
 	list_add_tail(&term->list, head);
 
-
 	/* Add it for all PMUs that support the alias */
 	list = malloc(sizeof(struct list_head));
 	if (!list)
@@ -1687,13 +1687,15 @@ int parse_events_multi_pmu_add(struct pa
 
 		list_for_each_entry(alias, &pmu->aliases, list) {
 			if (!strcasecmp(alias->name, str)) {
+				parse_events_copy_term_list(head, &orig_head);
 				if (!parse_events_add_pmu(parse_state, list,
-							  pmu->name, head,
+							  pmu->name, orig_head,
 							  true, true)) {
 					pr_debug("%s -> %s/%s/\n", str,
 						 pmu->name, alias->str);
 					ok++;
 				}
+				parse_events_terms__delete(orig_head);
 			}
 		}
 	}


