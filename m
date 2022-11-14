Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3F362805E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiKNNFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237790AbiKNNFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9722A41B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8000BB80EA6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A65C433D7;
        Mon, 14 Nov 2022 13:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431117;
        bh=7VUnwqb40tBpZsu2YD87m6YhQY70tujM3NicsDbG7/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkThHXYoK+1tQrYxl/25lPfs3TzUDQ38qL2KmYmBR+yPFq6IZeE5DxmLF5kbLArLY
         0qK7NBWsK1PneQEFnazhDBY3CzbriBH/U1OXUgSScqiqEmR/c6TNrRztTFo1H7qcFh
         oX0iubBmR7vxy3/EjXfcv2/US72uUOMnA8H59zS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Clark <james.clark@arm.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Anshuman.Khandual@arm.com, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Kajol Jain <kjain@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 077/190] perf test: Fix skipping branch stack sampling test
Date:   Mon, 14 Nov 2022 13:45:01 +0100
Message-Id: <20221114124502.044973276@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

[ Upstream commit 20ebc4a649b82e6ad892684c76ea1e8dd786d336 ]

Commit f4a2aade6809c657 ("perf tests powerpc: Fix branch stack sampling
test to include sanity check for branch filter") added a skip if certain
branch options aren't available.

But the change added both -b (--branch-any) and --branch-filter options
at the same time, which will always result in a failure on any platform
because the arguments can't be used together.

Fix this by removing -b (--branch-any) and leaving --branch-filter which
already specifies 'any'. Also add warning messages to the test and perf
tool.

Output on x86 before this fix:

   $ sudo ./perf test branch
   108: Check branch stack sampling         : Skip

After:

   $ sudo ./perf test branch
   108: Check branch stack sampling         : Ok

Fixes: f4a2aade6809c657 ("perf tests powerpc: Fix branch stack sampling test to include sanity check for branch filter")
Signed-off-by: James Clark <james.clark@arm.com>
Tested-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Anshuman.Khandual@arm.com
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221028121913.745307-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_brstack.sh | 5 ++++-
 tools/perf/util/parse-branch-options.c | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/shell/test_brstack.sh b/tools/perf/tests/shell/test_brstack.sh
index ec801cffae6b..d7ff5c4b4da4 100755
--- a/tools/perf/tests/shell/test_brstack.sh
+++ b/tools/perf/tests/shell/test_brstack.sh
@@ -13,7 +13,10 @@ fi
 
 # skip the test if the hardware doesn't support branch stack sampling
 # and if the architecture doesn't support filter types: any,save_type,u
-perf record -b -o- -B --branch-filter any,save_type,u true > /dev/null 2>&1 || exit 2
+if ! perf record -o- --no-buildid --branch-filter any,save_type,u -- true > /dev/null 2>&1 ; then
+	echo "skip: system doesn't support filter types: any,save_type,u"
+	exit 2
+fi
 
 TMPDIR=$(mktemp -d /tmp/__perf_test.program.XXXXX)
 
diff --git a/tools/perf/util/parse-branch-options.c b/tools/perf/util/parse-branch-options.c
index bb4aa88c50a8..35264b5684d0 100644
--- a/tools/perf/util/parse-branch-options.c
+++ b/tools/perf/util/parse-branch-options.c
@@ -101,8 +101,10 @@ parse_branch_stack(const struct option *opt, const char *str, int unset)
 	/*
 	 * cannot set it twice, -b + --branch-filter for instance
 	 */
-	if (*mode)
+	if (*mode) {
+		pr_err("Error: Can't use --branch-any (-b) with --branch-filter (-j).\n");
 		return -1;
+	}
 
 	return parse_branch_str(str, mode);
 }
-- 
2.35.1



