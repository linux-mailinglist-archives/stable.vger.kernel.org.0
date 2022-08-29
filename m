Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906A35A452D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 10:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiH2Idi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 04:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiH2IdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 04:33:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13322578A8
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 01:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEF18B80D28
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3215C433D6;
        Mon, 29 Aug 2022 08:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661761982;
        bh=k+bFwLsJ2m9Lp8/N55aN7V4S9Uk1WbhVaVcHYVXUy6s=;
        h=Subject:To:Cc:From:Date:From;
        b=S1gUPD11B3mTpNpgSXarMBPgzwQs+2G1NpR5XTnTvhnsrezKWs9ka3HK3q8MJbmYL
         fJ0uDiTV5j/YZGUJN1o+4D3B0Gr/6l6eMRHrkmFGsvwXhO4epT0Gkzs547a17MK0tt
         QFnUe+OcPd2kfZFGyfBQYGAqJaeT3rQXiQ3BF+mE=
Subject: FAILED: patch "[PATCH] perf stat: Clear evsel->reset_group for each stat run" failed to apply to 5.10-stable tree
To:     irogers@google.com, acme@redhat.com, ak@linux.intel.com,
        alexander.shishkin@linux.intel.com, eranian@google.com,
        jolsa@kernel.org, kan.liang@linux.intel.com, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, peterz@infradead.org,
        zhengjun.xing@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 10:32:59 +0200
Message-ID: <1661761979188199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bf515f024e4c0ca46a1b08c4f31860c01781d8a5 Mon Sep 17 00:00:00 2001
From: Ian Rogers <irogers@google.com>
Date: Mon, 22 Aug 2022 14:33:51 -0700
Subject: [PATCH] perf stat: Clear evsel->reset_group for each stat run

If a weak group is broken then the reset_group flag remains set for
the next run. Having reset_group set means the counter isn't created
and ultimately a segfault.

A simple reproduction of this is:

  # perf stat -r2 -e '{cycles,cycles,cycles,cycles,cycles,cycles,cycles,cycles,cycles,cycles}:W

which will be added as a test in the next patch.

Fixes: 4804e0111662d7d8 ("perf stat: Use affinity for opening events")
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20220822213352.75721-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7fb81a44672d..54cd29d07ca8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -826,6 +826,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	}
 
 	evlist__for_each_entry(evsel_list, counter) {
+		counter->reset_group = false;
 		if (bpf_counter__load(counter, &target))
 			return -1;
 		if (!evsel__is_bpf(counter))

