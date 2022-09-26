Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9464D5EA5E0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiIZMX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbiIZMXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:23:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EB08A1DE;
        Mon, 26 Sep 2022 04:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2552CE1117;
        Mon, 26 Sep 2022 10:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84783C433D6;
        Mon, 26 Sep 2022 10:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189323;
        bh=iQBts69Xg4uRZG7l2hp4cSGamepujS260GBRhpeKnlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Usr4bFJUtRg+rESsU6WdhYe6dsAsE0Zf1x6vltQKpY1d7aHDFN/fXaZDkpK626BLW
         i/4rYy7F+dayaIGrKe/csmWUWmSdA9xjDF7ZEnygvCJ056Xn0JLqBCxeGWJfTiPjXh
         qoCWhyZRy4qLKHpcAaV6VbtoBbNI4UXFlz7/EhOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 149/207] perf tools: Honor namespace when synthesizing build-ids
Date:   Mon, 26 Sep 2022 12:12:18 +0200
Message-Id: <20220926100813.321988454@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 999e4eaa4b3691acf85d094836260ec4b66c74fd ]

It needs to enter the namespace before reading a file.

Fixes: 4183a8d70a288627 ("perf tools: Allow synthesizing the build id for kernel/modules/tasks in PERF_RECORD_MMAP2")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20220920222822.2171056-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index 84d17bd4efae..64e273b2b1b2 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -367,13 +367,24 @@ static void perf_record_mmap2__read_build_id(struct perf_record_mmap2 *event,
 					     bool is_kernel)
 {
 	struct build_id bid;
+	struct nsinfo *nsi;
+	struct nscookie nc;
 	int rc;
 
-	if (is_kernel)
+	if (is_kernel) {
 		rc = sysfs__read_build_id("/sys/kernel/notes", &bid);
-	else
-		rc = filename__read_build_id(event->filename, &bid) > 0 ? 0 : -1;
+		goto out;
+	}
+
+	nsi = nsinfo__new(event->pid);
+	nsinfo__mountns_enter(nsi, &nc);
 
+	rc = filename__read_build_id(event->filename, &bid) > 0 ? 0 : -1;
+
+	nsinfo__mountns_exit(&nc);
+	nsinfo__put(nsi);
+
+out:
 	if (rc == 0) {
 		memcpy(event->build_id, bid.data, sizeof(bid.data));
 		event->build_id_size = (u8) bid.size;
-- 
2.35.1



