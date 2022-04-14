Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967C05012C5
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348920AbiDNONl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347632AbiDNN7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E09C4579B;
        Thu, 14 Apr 2022 06:50:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51F15B82894;
        Thu, 14 Apr 2022 13:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6013C385A5;
        Thu, 14 Apr 2022 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944238;
        bh=UJ/ZCZObDlL/CWvNdNYfrmTLONFMY8IQg6iCnaVFk5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMCwmEwhIFcDCpeuKZ8PLtNctoTGuGqfY5SxhuSyqXwCtgX6B5sNwbliaRubK6AI4
         Gof47wBYEnG9QMq/4CVzQl4duPXp0/hWF7s/1wUGl3LmstInyJ+BwB8Pa0D+KI6RqP
         wOgWsJ3J4waGAclRudjN9kyoPmILjIVmnTPDLeBE=
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
Subject: [PATCH 5.4 444/475] perf session: Remap buf if there is no space for event
Date:   Thu, 14 Apr 2022 15:13:49 +0200
Message-Id: <20220414110907.483969398@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 8ff2c98e9032..01e15b445cb5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1960,6 +1960,7 @@ prefetch_event(char *buf, u64 head, size_t mmap_size,
 	       bool needs_swap, union perf_event *error)
 {
 	union perf_event *event;
+	u16 event_size;
 
 	/*
 	 * Ensure we have enough space remaining to read
@@ -1972,15 +1973,23 @@ prefetch_event(char *buf, u64 head, size_t mmap_size,
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



