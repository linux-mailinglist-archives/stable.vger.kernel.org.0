Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77765EA3F3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbiIZLhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238077AbiIZLft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D44C4D25C;
        Mon, 26 Sep 2022 03:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E17260B7E;
        Mon, 26 Sep 2022 10:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C6EC433D7;
        Mon, 26 Sep 2022 10:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189007;
        bh=B6U0drhn08g0LmIo7aANssbc+0zXfg4+1s/TNYvoYp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/mWgycI3E8anMR7prUm0yYbqJfO5weC1LC69CsbFxvYEfE3jK6CNTd7O4d+UEzam
         SpEf4KxQ0HMQI36DKBdyQaXKbxF6zPpQ4UD3cwmcvWCJN8LjM3bX8JIqiaEPuaRFPP
         xBpl+Waw/iQ6TQ8clEs5c2nwupr2WeFA8toXg5Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.19 044/207] libperf evlist: Fix polling of system-wide events
Date:   Mon, 26 Sep 2022 12:10:33 +0200
Message-Id: <20220926100808.590969680@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 6cc447964555df209c590756bd804d3bb9ce1fe0 upstream.

Originally, (refer commit f90d194a867a5a1d ("perf evlist: Do not poll
events that use the system_wide flag") there wasn't much reason to poll
system-wide events because:

 1. The mmaps get "merged" via set-output anyway (the per-cpu case)
 2. perf reads all mmaps when any event is woken
 3. system-wide mmaps do not fill up as fast as the mmaps for user
    selected events

But there was 1 reason not to poll which was that it prevented correct
termination due to POLLHUP on all user selected events.  That issue is
now easily resolved by using fdarray_flag__nonfilterable.

With the advent of commit ae4f8ae16a078964 ("libperf evlist: Allow
mixing per-thread and per-cpu mmaps"), system-wide mmaps can be used
also in the per-thread case where reason 1 does not apply.

Fix the omission of system-wide events from polling by using the
fdarray_flag__nonfilterable flag.

Example:

 Before:

    $ perf record --no-bpf-event -vvv -e intel_pt// --per-thread uname 2>err.txt
    Linux
    $ grep 'sys_perf_event_open.*=\|pollfd' err.txt
    sys_perf_event_open: pid 155076  cpu -1  group_fd -1  flags 0x8 = 5
    sys_perf_event_open: pid 155076  cpu -1  group_fd -1  flags 0x8 = 6
    sys_perf_event_open: pid -1  cpu 0  group_fd -1  flags 0x8 = 7
    sys_perf_event_open: pid -1  cpu 1  group_fd -1  flags 0x8 = 9
    sys_perf_event_open: pid -1  cpu 2  group_fd -1  flags 0x8 = 10
    sys_perf_event_open: pid -1  cpu 3  group_fd -1  flags 0x8 = 11
    sys_perf_event_open: pid -1  cpu 4  group_fd -1  flags 0x8 = 12
    sys_perf_event_open: pid -1  cpu 5  group_fd -1  flags 0x8 = 13
    sys_perf_event_open: pid -1  cpu 6  group_fd -1  flags 0x8 = 14
    sys_perf_event_open: pid -1  cpu 7  group_fd -1  flags 0x8 = 15
    thread_data[0x55fb43c29e80]: pollfd[0] <- event_fd=5
    thread_data[0x55fb43c29e80]: pollfd[1] <- event_fd=6
    thread_data[0x55fb43c29e80]: pollfd[2] <- non_perf_event fd=4

 After:

    $ perf record --no-bpf-event -vvv -e intel_pt// --per-thread uname 2>err.txt
    Linux
    $ grep 'sys_perf_event_open.*=\|pollfd' err.txt
    sys_perf_event_open: pid 156316  cpu -1  group_fd -1  flags 0x8 = 5
    sys_perf_event_open: pid 156316  cpu -1  group_fd -1  flags 0x8 = 6
    sys_perf_event_open: pid -1  cpu 0  group_fd -1  flags 0x8 = 7
    sys_perf_event_open: pid -1  cpu 1  group_fd -1  flags 0x8 = 9
    sys_perf_event_open: pid -1  cpu 2  group_fd -1  flags 0x8 = 10
    sys_perf_event_open: pid -1  cpu 3  group_fd -1  flags 0x8 = 11
    sys_perf_event_open: pid -1  cpu 4  group_fd -1  flags 0x8 = 12
    sys_perf_event_open: pid -1  cpu 5  group_fd -1  flags 0x8 = 13
    sys_perf_event_open: pid -1  cpu 6  group_fd -1  flags 0x8 = 14
    sys_perf_event_open: pid -1  cpu 7  group_fd -1  flags 0x8 = 15
    thread_data[0x55cc19e58e80]: pollfd[0] <- event_fd=5
    thread_data[0x55cc19e58e80]: pollfd[1] <- event_fd=6
    thread_data[0x55cc19e58e80]: pollfd[2] <- event_fd=7
    thread_data[0x55cc19e58e80]: pollfd[3] <- event_fd=9
    thread_data[0x55cc19e58e80]: pollfd[4] <- event_fd=10
    thread_data[0x55cc19e58e80]: pollfd[5] <- event_fd=11
    thread_data[0x55cc19e58e80]: pollfd[6] <- event_fd=12
    thread_data[0x55cc19e58e80]: pollfd[7] <- event_fd=13
    thread_data[0x55cc19e58e80]: pollfd[8] <- event_fd=14
    thread_data[0x55cc19e58e80]: pollfd[9] <- event_fd=15
    thread_data[0x55cc19e58e80]: pollfd[10] <- non_perf_event fd=4

Fixes: ae4f8ae16a078964 ("libperf evlist: Allow mixing per-thread and per-cpu mmaps")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220915122612.81738-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/perf/evlist.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 6b1bafe267a4..8ec5b9f344e0 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -441,6 +441,7 @@ mmap_per_evsel(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 
 	perf_evlist__for_each_entry(evlist, evsel) {
 		bool overwrite = evsel->attr.write_backward;
+		enum fdarray_flags flgs;
 		struct perf_mmap *map;
 		int *output, fd, cpu;
 
@@ -504,8 +505,8 @@ mmap_per_evsel(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 
 		revent = !overwrite ? POLLIN : 0;
 
-		if (!evsel->system_wide &&
-		    perf_evlist__add_pollfd(evlist, fd, map, revent, fdarray_flag__default) < 0) {
+		flgs = evsel->system_wide ? fdarray_flag__nonfilterable : fdarray_flag__default;
+		if (perf_evlist__add_pollfd(evlist, fd, map, revent, flgs) < 0) {
 			perf_mmap__put(map);
 			return -1;
 		}
-- 
2.37.3



