Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BD459D9C4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241619AbiHWKCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242091AbiHWJ70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:59:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A75A220B;
        Tue, 23 Aug 2022 01:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A4F6B81C28;
        Tue, 23 Aug 2022 08:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC30BC433C1;
        Tue, 23 Aug 2022 08:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244487;
        bh=3KmEpMGR6c7BCp8aZrOzLRXP9eHflZRAsYfKvwD+VUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1TtK7tDDAoaHeKeR66DnskG/vqBmR0qszvay5as5a9dJyHbBCIBeoIS9fqHT9ZMo
         7pkw0HWiNo/kAWihOukMdO3R3woFnvxZSIxRNs3ynp0Xep4nrwmINRBnsrc6dxbLUX
         su25fdk32siJxKNlWV4HMzGzSi79XgkGMuRQf+pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 101/244] perf tests: Fix Track with sched_switch test for hybrid case
Date:   Tue, 23 Aug 2022 10:24:20 +0200
Message-Id: <20220823080102.404760852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 1da1d60774014137d776d0400fdf2f1779d8d4d5 upstream.

If cpu_core PMU event fails to parse, try also cpu_atom PMU event when
parsing cycles event.

Fixes: 43eb05d066795bdf ("perf tests: Support 'Track with sched_switch' test for hybrid")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220809080702.6921-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/switch-tracking.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/tools/perf/tests/switch-tracking.c
+++ b/tools/perf/tests/switch-tracking.c
@@ -324,6 +324,7 @@ out_free_nodes:
 int test__switch_tracking(struct test *test __maybe_unused, int subtest __maybe_unused)
 {
 	const char *sched_switch = "sched:sched_switch";
+	const char *cycles = "cycles:u";
 	struct switch_tracking switch_tracking = { .tids = NULL, };
 	struct record_opts opts = {
 		.mmap_pages	     = UINT_MAX,
@@ -372,12 +373,19 @@ int test__switch_tracking(struct test *t
 	cpu_clocks_evsel = evlist__last(evlist);
 
 	/* Second event */
-	if (perf_pmu__has_hybrid())
-		err = parse_events(evlist, "cpu_core/cycles/u", NULL);
-	else
-		err = parse_events(evlist, "cycles:u", NULL);
+	if (perf_pmu__has_hybrid()) {
+		cycles = "cpu_core/cycles/u";
+		err = parse_events(evlist, cycles, NULL);
+		if (err) {
+			cycles = "cpu_atom/cycles/u";
+			pr_debug("Trying %s\n", cycles);
+			err = parse_events(evlist, cycles, NULL);
+		}
+	} else {
+		err = parse_events(evlist, cycles, NULL);
+	}
 	if (err) {
-		pr_debug("Failed to parse event cycles:u\n");
+		pr_debug("Failed to parse event %s\n", cycles);
 		goto out_err;
 	}
 


