Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A8B504E4B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiDRJUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiDRJUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6361021
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B5D661180
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E34C385A7;
        Mon, 18 Apr 2022 09:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650273447;
        bh=4CdnzlJ3lsWxijIK0cYMTZQol8h39Cy09I81p4WO2h8=;
        h=Subject:To:Cc:From:Date:From;
        b=VTAMfx6GiWtjqBbM/TBUNCskHt+AV1NPRKlsORyk0izXQ3Z/DFO1xKumcuTmcHkqq
         HWzwTV7hhbbRMtFOykDqMxgmxw74X2RUIs1lsadKLTKcU9Wbv2mW/cLde2zH0a0hQ4
         csir+MwaqOi+cXyQhUjGlQRzvl+NwFzsudvAGlnY=
Subject: FAILED: patch "[PATCH] perf tools: Fix segfault accessing sample_id xyarray" failed to apply to 5.17-stable tree
To:     adrian.hunter@intel.com, acme@redhat.com, irogers@google.com,
        jolsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:17:24 +0200
Message-ID: <1650273444163227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a668cc07f990d2ed19424d5c1a529521a9d1cee1 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 13 Apr 2022 14:42:32 +0300
Subject: [PATCH] perf tools: Fix segfault accessing sample_id xyarray

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

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 1b15ba13c477..a09315538a30 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -577,7 +577,6 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 {
 	struct perf_evsel *evsel;
 	const struct perf_cpu_map *cpus = evlist->user_requested_cpus;
-	const struct perf_thread_map *threads = evlist->threads;
 
 	if (!ops || !ops->get || !ops->mmap)
 		return -EINVAL;
@@ -589,7 +588,7 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 	perf_evlist__for_each_entry(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
-		    perf_evsel__alloc_id(evsel, perf_cpu_map__nr(cpus), threads->nr) < 0)
+		    perf_evsel__alloc_id(evsel, evsel->fd->max_x, evsel->fd->max_y) < 0)
 			return -ENOMEM;
 	}
 

