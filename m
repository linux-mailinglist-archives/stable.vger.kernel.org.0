Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCE550F52D
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiDZInd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345583AbiDZIl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E01159787;
        Tue, 26 Apr 2022 01:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67D6B6185D;
        Tue, 26 Apr 2022 08:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA2BC385A0;
        Tue, 26 Apr 2022 08:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961995;
        bh=/TMUWetx3+P/4PGL0bH92LjO0vr668Ype3Zm2jhJ/4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brjzEDdeaySDRgMOpVrKt8uamF+zIv0w8PvypiuCVJ4vmRwo/f+oP5qwxMgHfnkaO
         9Gcy39CjgpJARE5kYQ2pehOUsbfzr1gzjPJSkZLR3ScPfhIx9mnPeLeoSNyM1REiNG
         LkuRlI8dvkfqaWAamOxsPg3L2GzYI7nKehVT+RbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 04/86] perf tools: Fix segfault accessing sample_id xyarray
Date:   Tue, 26 Apr 2022 10:20:32 +0200
Message-Id: <20220426081741.332847179@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit a668cc07f990d2ed19424d5c1a529521a9d1cee1 upstream.

perf_evsel::sample_id is an xyarray which can cause a segfault when
accessed beyond its size. e.g.

  # perf record -e intel_pt// -C 1 sleep 1
  Segmentation fault (core dumped)
  #

That is happening because a dummy event is opened to capture text poke
events accross all CPUs, however the mmap logic is allocating according
to the number of user_requested_cpus.

In general, perf sometimes uses the evsel cpus to open events, and
sometimes the evlist user_requested_cpus. However, it is not necessary
to determine which case is which because the opened event file
descriptors are also in an xyarray, the size of whch can be used
to correctly allocate the size of the sample_id xyarray, because there
is one ID per file descriptor.

Note, in the affected code path, perf_evsel fd array is subsequently
used to get the file descriptor for the mmap, so it makes sense for the
xyarrays to be the same size there.

Fixes: d1a177595b3a824c ("libperf: Adopt perf_evlist__mmap()/munmap() from tools/perf")
Fixes: 246eba8e9041c477 ("perf tools: Add support for PERF_RECORD_TEXT_POKE")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org # 5.5+
Link: https://lore.kernel.org/r/20220413114232.26914-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/perf/evlist.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -571,7 +571,6 @@ int perf_evlist__mmap_ops(struct perf_ev
 {
 	struct perf_evsel *evsel;
 	const struct perf_cpu_map *cpus = evlist->cpus;
-	const struct perf_thread_map *threads = evlist->threads;
 
 	if (!ops || !ops->get || !ops->mmap)
 		return -EINVAL;
@@ -583,7 +582,7 @@ int perf_evlist__mmap_ops(struct perf_ev
 	perf_evlist__for_each_entry(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
-		    perf_evsel__alloc_id(evsel, perf_cpu_map__nr(cpus), threads->nr) < 0)
+		    perf_evsel__alloc_id(evsel, evsel->fd->max_x, evsel->fd->max_y) < 0)
 			return -ENOMEM;
 	}
 


