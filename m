Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6966537D78
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbiE3NiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237646AbiE3Ngy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AC060DB6;
        Mon, 30 May 2022 06:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D4660EE0;
        Mon, 30 May 2022 13:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E1CC385B8;
        Mon, 30 May 2022 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917433;
        bh=xRzVVb9dp3AfJuQgs6IuBJGSwSqg0aexqaH6UBZReSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EChGrhftWYhvDU+MG1c6B62esrZ9vMbXnCY5xCQ8mllztiCTksMoj8ypMVUEaDKHK
         HCFHCF0vREkIH6LlOLoMC329tJn94EyxOH2hSqNey8RM/uQvAuXpwa8Ksw4EeuxgLf
         iD1Je94SEP7G6LWSPu3dSP71dwxzLJuf16UeWcRW34IuVHX3CF3cjXD+XthSd3vkae
         GpX1aHiZ6X+5PODhahq80UWXhE6O9IiiUjXQ1rZLSDoTs0XoiZRTfxI/7GkspJsAtA
         3yJnq2KDtN3FQCuMBft6J4IQ7+JBYSOD/uJOcJZyGQk18o9cWHTKC1+ne1EiIiudN0
         Uc4T0JA3aiQxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Latypov <dlatypov@google.com>,
        David Gow <davidgow@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.18 133/159] kunit: tool: make parser stop overwriting status of suites w/ no_tests
Date:   Mon, 30 May 2022 09:23:58 -0400
Message-Id: <20220530132425.1929512-133-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit dbf0b0d53a2b5afa6ef7372dcedf52302669fc2c ]

Consider this invocation
$ ./tools/testing/kunit/kunit.py parse <<EOF
  TAP version 14
  1..2
  ok 1 - suite
    # Subtest: no_tests_suite
    # catastrophic error!
  not ok 1 - no_tests_suite
EOF

It will have a 0 exit code even though there's a "not ok".

Consider this one:
$ ./tools/testing/kunit/kunit.py parse <<EOF
  TAP version 14
  1..2
  ok 1 - suite
  not ok 1 - no_tests_suite
EOF

It will a non-zero exit code.

Why?
We have this line in the kunit_parser.py
> parent_test = parse_test_header(lines, test)
where we have special handling when we see "# Subtest" and we ignore the
explicit reported "not ok 1" status!

Also, NO_TESTS at a suite-level only results in a non-zero status code
where then there's only one suite atm.

This change is the minimal one to make sure we don't overwrite it.

Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_parser.py                        | 7 +++++--
 .../test_data/test_is_test_passed-no_tests_no_plan.log     | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index 05ff334761dd..2f93ed1d7f99 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -789,8 +789,11 @@ def parse_test(lines: LineStream, expected_num: int, log: List[str]) -> Test:
 
 	# Check for there being no tests
 	if parent_test and len(subtests) == 0:
-		test.status = TestStatus.NO_TESTS
-		test.add_error('0 tests run!')
+		# Don't override a bad status if this test had one reported.
+		# Assumption: no subtests means CRASHED is from Test.__init__()
+		if test.status in (TestStatus.TEST_CRASHED, TestStatus.SUCCESS):
+			test.status = TestStatus.NO_TESTS
+			test.add_error('0 tests run!')
 
 	# Add statuses to TestCounts attribute in Test object
 	bubble_up_test_results(test)
diff --git a/tools/testing/kunit/test_data/test_is_test_passed-no_tests_no_plan.log b/tools/testing/kunit/test_data/test_is_test_passed-no_tests_no_plan.log
index dd873c981108..4f81876ee6f1 100644
--- a/tools/testing/kunit/test_data/test_is_test_passed-no_tests_no_plan.log
+++ b/tools/testing/kunit/test_data/test_is_test_passed-no_tests_no_plan.log
@@ -3,5 +3,5 @@ TAP version 14
   # Subtest: suite
   1..1
     # Subtest: case
-  ok 1 - case # SKIP
+  ok 1 - case
 ok 1 - suite
-- 
2.35.1

