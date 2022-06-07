Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE14E5411CC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354432AbiFGTmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357732AbiFGTmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38431B6FE7;
        Tue,  7 Jun 2022 11:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F18C60C1C;
        Tue,  7 Jun 2022 18:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B91C385A2;
        Tue,  7 Jun 2022 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625763;
        bh=DrlCtqRdmd/H4FDcqecWOdiAET1SvEdTVJUq2ANWkK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7n753ac52ftv+ZTubg0kuXmrHHCnC8xykXaliiomV8jzmIBql4WVTcSeifzgCJwy
         3lo7Q9fz4fqnd008T3VKDv52rfIafMXOBIKxp0Q/peJZ4tkm0SAS6zjsHC2z9dxFOA
         SLhwh/faVJF4BRK7XmceNO/xX2slu/CdkIY/d7hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        Zeal Robot <zealci@zte.com.cn>, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 136/772] kunit: bail out of test filtering logic quicker if OOM
Date:   Tue,  7 Jun 2022 18:55:28 +0200
Message-Id: <20220607164953.051201324@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit a02353f491622e49c7ddedc6a6dc4f1d6ed2150a ]

When filtering what tests to run (suites and/or cases) via
kunit.filter_glob (e.g. kunit.py run <glob>), we allocate copies of
suites.

These allocations can fail, and we largely don't handle that.
Note: realistically, this probably doesn't matter much.
We're not allocating much memory and this happens early in boot, so if
we can't do that, then there's likely far bigger problems.

This patch makes us immediately bail out from the top-level function
(kunit_filter_suites) with -ENOMEM if any of the underlying kmalloc()
calls return NULL.

Implementation note: we used to return NULL pointers from some functions
to indicate either that all suites/tests were filtered out or there was
an error allocating the new array.

We'll log a short error in this case and not run any tests or print a
TAP header. From a kunit.py user's perspective, they'll get a message
about missing/invalid TAP output and have to dig into the test.log to
see it. Since hitting this error seems so unlikely, it's probably fine
to not invent a way to plumb this error message more visibly.

See also: https://lore.kernel.org/linux-kselftest/20220329103919.2376818-1-lv.ruyi@zte.com.cn/

Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor.c      | 27 ++++++++++++++++++++++-----
 lib/kunit/executor_test.c |  4 +++-
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index 22640c9ee819..2f73a6a35a7e 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -71,9 +71,13 @@ kunit_filter_tests(struct kunit_suite *const suite, const char *test_glob)
 
 	/* Use memcpy to workaround copy->name being const. */
 	copy = kmalloc(sizeof(*copy), GFP_KERNEL);
+	if (!copy)
+		return ERR_PTR(-ENOMEM);
 	memcpy(copy, suite, sizeof(*copy));
 
 	filtered = kcalloc(n + 1, sizeof(*filtered), GFP_KERNEL);
+	if (!filtered)
+		return ERR_PTR(-ENOMEM);
 
 	n = 0;
 	kunit_suite_for_each_test_case(suite, test_case) {
@@ -106,14 +110,16 @@ kunit_filter_subsuite(struct kunit_suite * const * const subsuite,
 
 	filtered = kmalloc_array(n + 1, sizeof(*filtered), GFP_KERNEL);
 	if (!filtered)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	n = 0;
 	for (i = 0; subsuite[i] != NULL; ++i) {
 		if (!glob_match(filter->suite_glob, subsuite[i]->name))
 			continue;
 		filtered_suite = kunit_filter_tests(subsuite[i], filter->test_glob);
-		if (filtered_suite)
+		if (IS_ERR(filtered_suite))
+			return ERR_CAST(filtered_suite);
+		else if (filtered_suite)
 			filtered[n++] = filtered_suite;
 	}
 	filtered[n] = NULL;
@@ -146,7 +152,8 @@ static void kunit_free_suite_set(struct suite_set suite_set)
 }
 
 static struct suite_set kunit_filter_suites(const struct suite_set *suite_set,
-					    const char *filter_glob)
+					    const char *filter_glob,
+					    int *err)
 {
 	int i;
 	struct kunit_suite * const **copy, * const *filtered_subsuite;
@@ -166,6 +173,10 @@ static struct suite_set kunit_filter_suites(const struct suite_set *suite_set,
 
 	for (i = 0; i < max; ++i) {
 		filtered_subsuite = kunit_filter_subsuite(suite_set->start[i], &filter);
+		if (IS_ERR(filtered_subsuite)) {
+			*err = PTR_ERR(filtered_subsuite);
+			return filtered;
+		}
 		if (filtered_subsuite)
 			*copy++ = filtered_subsuite;
 	}
@@ -236,9 +247,15 @@ int kunit_run_all_tests(void)
 		.start = __kunit_suites_start,
 		.end = __kunit_suites_end,
 	};
+	int err;
 
-	if (filter_glob_param)
-		suite_set = kunit_filter_suites(&suite_set, filter_glob_param);
+	if (filter_glob_param) {
+		suite_set = kunit_filter_suites(&suite_set, filter_glob_param, &err);
+		if (err) {
+			pr_err("kunit executor: error filtering suites: %d\n", err);
+			return err;
+		}
+	}
 
 	if (!action_param)
 		kunit_exec_run_tests(&suite_set);
diff --git a/lib/kunit/executor_test.c b/lib/kunit/executor_test.c
index 4ed57fd94e42..eac6ff480273 100644
--- a/lib/kunit/executor_test.c
+++ b/lib/kunit/executor_test.c
@@ -137,14 +137,16 @@ static void filter_suites_test(struct kunit *test)
 		.end = suites + 2,
 	};
 	struct suite_set filtered = {.start = NULL, .end = NULL};
+	int err = 0;
 
 	/* Emulate two files, each having one suite */
 	subsuites[0][0] = alloc_fake_suite(test, "suite0", dummy_test_cases);
 	subsuites[1][0] = alloc_fake_suite(test, "suite1", dummy_test_cases);
 
 	/* Filter out suite1 */
-	filtered = kunit_filter_suites(&suite_set, "suite0");
+	filtered = kunit_filter_suites(&suite_set, "suite0", &err);
 	kfree_subsuites_at_end(test, &filtered); /* let us use ASSERTs without leaking */
+	KUNIT_EXPECT_EQ(test, err, 0);
 	KUNIT_ASSERT_EQ(test, filtered.end - filtered.start, (ptrdiff_t)1);
 
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filtered.start);
-- 
2.35.1



