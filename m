Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DF4529001
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbiEPUKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351021AbiEPUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB413473AC;
        Mon, 16 May 2022 12:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47FA760FE4;
        Mon, 16 May 2022 19:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA90C385AA;
        Mon, 16 May 2022 19:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730994;
        bh=k+MToLoaUMchIx7iY04ATQlWvuE0nwEcPwpeCEw1FW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xroSUupMv5NOU86NXEA8jgaqZTm74/Chz81VisBpOWGFIxYkyPSF81OgmrAP4Aqf
         VtmN5Faf1zJXEapvHgD0lhRxrUvlx9QhYNTu3edbLEj1/OzHQQ7Ev6PaemXLUDLqmS
         +dArWoOXjCT5/vMjm7W/hvljTbwT1hwFRYoS0EtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 070/114] perf tests: Fix coresight `perf test` failure.
Date:   Mon, 16 May 2022 21:36:44 +0200
Message-Id: <20220516193627.501172278@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit 45fa7c38696bae632310c2876ba81fdfa25cc9c2 ]

Currently the `perf test` always fails the coresight test like:

  89: Check Arm CoreSight trace data recording and synthesized samples: FAILED!

That is because the test_arm_coresight.sh is attempting to SIGINT the
parent but is using $$ rather than $PPID and it sigint's itself when
run under the perf test framework.

Since this is done in a trap clause it ends up returning a non zero
return.

Since $PPID is a bash ism and not all distros are linking /bin/sh to
bash, the alternative parent pid lookups are uglier than just dropping
the kill, and its not strictly needed, lets pick the simple solution and
drop the sigint.

Fixes: 133fe2e617e48ca0 ("perf tests: Improve temp file cleanup in test_arm_coresight.sh")
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Jeremy Linton <jeremy.linton@arm.com>
Link: https://lore.kernel.org/r/20220428151947.290146-1-jeremy.linton@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_arm_coresight.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/tests/shell/test_arm_coresight.sh b/tools/perf/tests/shell/test_arm_coresight.sh
index 6de53b7ef5ff..e4cb4f1806ff 100755
--- a/tools/perf/tests/shell/test_arm_coresight.sh
+++ b/tools/perf/tests/shell/test_arm_coresight.sh
@@ -29,7 +29,6 @@ cleanup_files()
 	rm -f ${file}
 	rm -f "${perfdata}.old"
 	trap - exit term int
-	kill -2 $$
 	exit $glb_err
 }
 
-- 
2.35.1



