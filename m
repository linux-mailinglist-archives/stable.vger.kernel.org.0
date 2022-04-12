Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EBC4FD7E6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353568AbiDLHd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353672AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B1127176;
        Tue, 12 Apr 2022 00:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 418AC61045;
        Tue, 12 Apr 2022 07:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB97C385A6;
        Tue, 12 Apr 2022 07:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747008;
        bh=QYtL3qHNY1I1xa0spV91JFtcnSYu9RAcJzIviIhw3Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQxQBFWxC5S6WY8OKDRG1bjyqx0iG1FaGLjTkD7KaVVdsx0FZY/jCadpIY29kTII1
         fLoWnBAHKwzrUCYabwGYPosQKAFMrEC7W+e/4l2/YCWvpvB3vhXwHFt/Ej+8utUWHt
         10DPGmCu8RXUuxQKsu+ZPIEJ0pfz5hYT0gc9AE/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Denis Nikitin <denik@chromium.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 211/285] perf session: Remap buf if there is no space for event
Date:   Tue, 12 Apr 2022 08:31:08 +0200
Message-Id: <20220412062949.748634000@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Denis Nikitin <denik@chromium.org>

[ Upstream commit bc21e74d4775f883ae1f542c1f1dc7205b15d925 ]

If a perf event doesn't fit into remaining buffer space return NULL to
remap buf and fetch the event again.

Keep the logic to error out on inadequate input from fuzzing.

This fixes perf failing on ChromeOS (with 32b userspace):

  $ perf report -v -i perf.data
  ...
  prefetch_event: head=0x1fffff8 event->header_size=0x30, mmap_size=0x2000000: fuzzed or compressed perf.data?
  Error:
  failed to process sample

Fixes: 57fc032ad643ffd0 ("perf session: Avoid infinite loop when seeing invalid header.size")
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Denis Nikitin <denik@chromium.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220330031130.2152327-1-denik@chromium.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d8857d1b6d7c..c64953dabcf5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -2082,6 +2082,7 @@ prefetch_event(char *buf, u64 head, size_t mmap_size,
 	       bool needs_swap, union perf_event *error)
 {
 	union perf_event *event;
+	u16 event_size;
 
 	/*
 	 * Ensure we have enough space remaining to read
@@ -2094,15 +2095,23 @@ prefetch_event(char *buf, u64 head, size_t mmap_size,
 	if (needs_swap)
 		perf_event_header__bswap(&event->header);
 
-	if (head + event->header.size <= mmap_size)
+	event_size = event->header.size;
+	if (head + event_size <= mmap_size)
 		return event;
 
 	/* We're not fetching the event so swap back again */
 	if (needs_swap)
 		perf_event_header__bswap(&event->header);
 
-	pr_debug("%s: head=%#" PRIx64 " event->header_size=%#x, mmap_size=%#zx:"
-		 " fuzzed or compressed perf.data?\n",__func__, head, event->header.size, mmap_size);
+	/* Check if the event fits into the next mmapped buf. */
+	if (event_size <= mmap_size - head % page_size) {
+		/* Remap buf and fetch again. */
+		return NULL;
+	}
+
+	/* Invalid input. Event size should never exceed mmap_size. */
+	pr_debug("%s: head=%#" PRIx64 " event->header.size=%#x, mmap_size=%#zx:"
+		 " fuzzed or compressed perf.data?\n", __func__, head, event_size, mmap_size);
 
 	return error;
 }
-- 
2.35.1



