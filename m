Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283F46AEF71
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjCGSXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbjCGSXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFA439CC1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07589B819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E2EC433EF;
        Tue,  7 Mar 2023 18:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213082;
        bh=dxFSj10K1gAdGhzhQE+cReJR7o4SDTExojXack2sgcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wk3R3wijWJ0QgjOtcQM1k3qMjrGUFazDtRYDOsK+QC2A9U8j20r6N3VZFfZ5/m2bz
         /5hxSZWM0yv3e0HvUasLI7dOAWKi3iF9N6Z7hCxmIR7cejX8V5LVjNNb0D230oK95T
         sdW6nhB7SNEPNCxwTOAeIk3ynsHkptTYEFVNjD+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Disha Goel <disgoel@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>, Kajol Jain <kjain@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nageswara R Sastry <rnsastry@linux.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>, linuxppc-dev@lists.ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 392/885] perf test bpf: Skip test if kernel-debuginfo is not present
Date:   Tue,  7 Mar 2023 17:55:26 +0100
Message-Id: <20230307170019.411130641@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 34266f904abd45731bdade2e92d0536c092ee9bc ]

Perf BPF filter test fails in environment where "kernel-debuginfo"
is not installed.

Test failure logs:

  <<>>
  42: BPF filter                            :
  42.1: Basic BPF filtering                 : Ok
  42.2: BPF pinning                         : Ok
  42.3: BPF prologue generation             : FAILED!
  <<>>

Enabling verbose option provided debug logs, which says debuginfo
needs to be installed. Snippet of verbose logs:

  <<>>
  42.3: BPF prologue generation                                       :
  --- start ---
  test child forked, pid 28218
  <<>>
  Rebuild with CONFIG_DEBUG_INFO=y, or install an appropriate debuginfo
  package.
  bpf_probe: failed to convert perf probe events
  Failed to add events selected by BPF
  test child finished with -1
  ---- end ----
  BPF filter subtest 3: FAILED!
  <<>>

Here the subtest "BPF prologue generation" failed and logs shows
debuginfo is needed. After installing kernel-debuginfo package, testcase
passes.

The "BPF prologue generation" subtest failed because, the do_test()
returns TEST_FAIL without checking the error type returned by
parse_events_load_bpf_obj().

parse_events_load_bpf_obj() can also return error of type -ENODATA
incase kernel-debuginfo package is not installed. Fix this by adding
check for -ENODATA error.

Test result after the patch changes:

Test failure logs:

  <<>>
  42: BPF filter                 :
  42.1: Basic BPF filtering      : Ok
  42.2: BPF pinning              : Ok
  42.3: BPF prologue generation  : Skip (clang/debuginfo isn't installed or environment missing BPF support)
  <<>>

Fixes: ba1fae431e74bb42 ("perf test: Add 'perf test BPF'")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Disha Goel <disgoel@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nageswara R Sastry <rnsastry@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lore.kernel.org/linux-perf-users/Y7bIk77mdE4j8Jyi@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bpf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index 17c023823713d..6a4235a9cf57e 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -126,6 +126,10 @@ static int do_test(struct bpf_object *obj, int (*func)(void),
 
 	err = parse_events_load_bpf_obj(&parse_state, &parse_state.list, obj, NULL);
 	parse_events_error__exit(&parse_error);
+	if (err == -ENODATA) {
+		pr_debug("Failed to add events selected by BPF, debuginfo package not installed\n");
+		return TEST_SKIP;
+	}
 	if (err || list_empty(&parse_state.list)) {
 		pr_debug("Failed to add events selected by BPF\n");
 		return TEST_FAIL;
@@ -368,7 +372,7 @@ static struct test_case bpf_tests[] = {
 			"clang isn't installed or environment missing BPF support"),
 #ifdef HAVE_BPF_PROLOGUE
 	TEST_CASE_REASON("BPF prologue generation", bpf_prologue_test,
-			"clang isn't installed or environment missing BPF support"),
+			"clang/debuginfo isn't installed or environment missing BPF support"),
 #else
 	TEST_CASE_REASON("BPF prologue generation", bpf_prologue_test, "not compiled in"),
 #endif
-- 
2.39.2



