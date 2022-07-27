Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2DC583033
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiG0RfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242540AbiG0ReV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:34:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC9552FE3;
        Wed, 27 Jul 2022 09:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5FAA7CE2315;
        Wed, 27 Jul 2022 16:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B16CC433D6;
        Wed, 27 Jul 2022 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940529;
        bh=IOh/2jB7rdGTmLQnOWdk4AKkBIus8bWns1MLLS8jkNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jqERB1oTSmbwKoBJ62ZYnwXfcVIN2ukCNM+vBX0SmAvt043WO88YhnJvdyjybuZ7
         VJpxkdczXSD0lcYSL0PaixhLY8LNMYsRFEErQKqU2mzuhit43oyuq/5DoWn5FE2LqO
         SAaIA2BNpBYW/a41qfBuUuhAKu9WSP/8yNZQkOuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 055/158] perf tests: Stop Convert perf time to TSC test opening events twice
Date:   Wed, 27 Jul 2022 18:11:59 +0200
Message-Id: <20220727161023.717047753@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

[ Upstream commit 498c7a54f169b2699104d3060604d840424f15d2 ]

Do not call evlist__open() twice.

Fixes: 5bb017d4b97a0f13 ("perf test: Fix error message for test case 71 on s390, where it is not supported")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/20220713123459.24145-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/perf-time-to-tsc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 4ad0dfbc8b21..8d6d60173693 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -123,11 +123,14 @@ static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused, int su
 		evsel->core.attr.enable_on_exec = 0;
 	}
 
-	if (evlist__open(evlist) == -ENOENT) {
-		err = TEST_SKIP;
+	ret = evlist__open(evlist);
+	if (ret < 0) {
+		if (ret == -ENOENT)
+			err = TEST_SKIP;
+		else
+			pr_debug("evlist__open() failed\n");
 		goto out_err;
 	}
-	CHECK__(evlist__open(evlist));
 
 	CHECK__(evlist__mmap(evlist, UINT_MAX));
 
-- 
2.35.1



