Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B645531980
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242082AbiEWRkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbiEWRiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3342A93465;
        Mon, 23 May 2022 10:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E420760B35;
        Mon, 23 May 2022 17:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD88C385A9;
        Mon, 23 May 2022 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327134;
        bh=hpOjpmyQvfaALi4mtyz1e6kIE+O99SXN5GXatvJOfqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7/mj6uBhViSHW8MHpakrHrW3qWOSSlB6jIYAeJIHi3kq3TgIsHT1ya+23VHvTKiq
         eyzZU+ypL4DXJcNV1D+EF1+pqCSfw76PfX5lJoIKkcysJvTPMdA8MuBifDRM6iCUfb
         2/eKJstLpAZ9hxZDB948sjb53E201F5mwt+jil5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kajol Jain <kjain@linux.ibm.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Disha Goel <disgoel@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nageswara R Sastry <rnsastry@linux.ibm.com>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 132/158] perf test bpf: Skip test if clang is not present
Date:   Mon, 23 May 2022 19:04:49 +0200
Message-Id: <20220523165852.300414915@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 8994e97be3eb3c3a7b59d6223018ffab8c272e2d ]

Perf BPF filter test fails in environment where "clang" is not
installed.

Test failure logs:

<<>>
 42: BPF filter                    :
 42.1: Basic BPF filtering         : Skip
 42.2: BPF pinning                 : FAILED!
 42.3: BPF prologue generation     : FAILED!
<<>>

Enabling verbose option provided debug logs which says clang/llvm needs
to be installed. Snippet of verbose logs:

<<>>
 42.2: BPF pinning                  :
 --- start ---
test child forked, pid 61423
ERROR:	unable to find clang.
Hint:	Try to install latest clang/llvm to support BPF.
        Check your $PATH

<<logs_here>>

Failed to compile test case: 'Basic BPF llvm compile'
Unable to get BPF object, fix kbuild first
test child finished with -1
 ---- end ----
BPF filter subtest 2: FAILED!
<<>>

Here subtests, "BPF pinning" and "BPF prologue generation" failed and
logs shows clang/llvm is needed. After installing clang, testcase
passes.

Reason on why subtest failure happens though logs has proper debug
information:

Main function __test__bpf calls test_llvm__fetch_bpf_obj by
passing 4th argument as true ( 4th arguments maps to parameter
"force" in test_llvm__fetch_bpf_obj ). But this will cause
test_llvm__fetch_bpf_obj to skip the check for clang/llvm.

Snippet of code part which checks for clang based on
parameter "force" in test_llvm__fetch_bpf_obj:

<<>>
if (!force && (!llvm_param.user_set_param &&
<<>>

Since force is set to "false", test won't get skipped and fails to
compile test case. The BPF code compilation needs clang, So pass the
fourth argument as "false" and also skip the test if reason for return
is "TEST_SKIP"

After the patch:

<<>>
 42: BPF filter                    :
 42.1: Basic BPF filtering         : Skip
 42.2: BPF pinning                 : Skip
 42.3: BPF prologue generation     : Skip
<<>>

Fixes: ba1fae431e74bb42 ("perf test: Add 'perf test BPF'")
Reviewed-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nageswara R Sastry <rnsastry@linux.ibm.com>
Cc: Wang Nan <wangnan0@huawei.com>
Link: https://lore.kernel.org/r/20220511115438.84032-1-atrajeev@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bpf.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index 573490530194..592ab02d5ba3 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -222,11 +222,11 @@ static int __test__bpf(int idx)
 
 	ret = test_llvm__fetch_bpf_obj(&obj_buf, &obj_buf_sz,
 				       bpf_testcase_table[idx].prog_id,
-				       true, NULL);
+				       false, NULL);
 	if (ret != TEST_OK || !obj_buf || !obj_buf_sz) {
 		pr_debug("Unable to get BPF object, %s\n",
 			 bpf_testcase_table[idx].msg_compile_fail);
-		if (idx == 0)
+		if ((idx == 0) || (ret == TEST_SKIP))
 			return TEST_SKIP;
 		else
 			return TEST_FAIL;
@@ -370,9 +370,11 @@ static int test__bpf_prologue_test(struct test_suite *test __maybe_unused,
 static struct test_case bpf_tests[] = {
 #ifdef HAVE_LIBBPF_SUPPORT
 	TEST_CASE("Basic BPF filtering", basic_bpf_test),
-	TEST_CASE("BPF pinning", bpf_pinning),
+	TEST_CASE_REASON("BPF pinning", bpf_pinning,
+			"clang isn't installed or environment missing BPF support"),
 #ifdef HAVE_BPF_PROLOGUE
-	TEST_CASE("BPF prologue generation", bpf_prologue_test),
+	TEST_CASE_REASON("BPF prologue generation", bpf_prologue_test,
+			"clang isn't installed or environment missing BPF support"),
 #else
 	TEST_CASE_REASON("BPF prologue generation", bpf_prologue_test, "not compiled in"),
 #endif
-- 
2.35.1



