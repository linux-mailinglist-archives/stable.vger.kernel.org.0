Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E153C55AA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhGLILd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353844AbhGLIDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8423461D12;
        Mon, 12 Jul 2021 07:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076687;
        bh=/MvL68KaBzS2y7b5Z+JRjEKHXKNe8pDqfSazwZLNINs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8bbfWLHL/cf//KvPpCGsfCvprX+Ll331f4wWFpemRxCeKY+U6Nmo3sY7DjOefPxv
         kZCE30IbG+A2KQQPYDuP94dNonvT66hwmfEK5T4Hb72FKOgZzEO/d860nYzMjJraay
         k46uShwV0Y2nZwDshtHWyjr+gMfSYRu2bydKcEI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Marco Elver <elver@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 707/800] kunit: Fix result propagation for parameterised tests
Date:   Mon, 12 Jul 2021 08:12:10 +0200
Message-Id: <20210712061041.971503225@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 384426bd101cb3cd580b18de19d4891ec5ca5bf9 ]

When one parameter of a parameterised test failed, its failure would be
propagated to the overall test, but not to the suite result (unless it
was the last parameter).

This is because test_case->success was being reset to the test->success
result after each parameter was used, so a failing test's result would
be overwritten by a non-failing result. The overall test result was
handled in a third variable, test_result, but this was discarded after
the status line was printed.

Instead, just propagate the result after each parameter run.

Signed-off-by: David Gow <davidgow@google.com>
Fixes: fadb08e7c750 ("kunit: Support for Parameterized Testing")
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 2f6cc0123232..17973a4a44c2 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -376,7 +376,7 @@ static void kunit_run_case_catch_errors(struct kunit_suite *suite,
 	context.test_case = test_case;
 	kunit_try_catch_run(try_catch, &context);
 
-	test_case->success = test->success;
+	test_case->success &= test->success;
 }
 
 int kunit_run_tests(struct kunit_suite *suite)
@@ -388,7 +388,7 @@ int kunit_run_tests(struct kunit_suite *suite)
 
 	kunit_suite_for_each_test_case(suite, test_case) {
 		struct kunit test = { .param_value = NULL, .param_index = 0 };
-		bool test_success = true;
+		test_case->success = true;
 
 		if (test_case->generate_params) {
 			/* Get initial param. */
@@ -398,7 +398,6 @@ int kunit_run_tests(struct kunit_suite *suite)
 
 		do {
 			kunit_run_case_catch_errors(suite, test_case, &test);
-			test_success &= test_case->success;
 
 			if (test_case->generate_params) {
 				if (param_desc[0] == '\0') {
@@ -420,7 +419,7 @@ int kunit_run_tests(struct kunit_suite *suite)
 			}
 		} while (test.param_value);
 
-		kunit_print_ok_not_ok(&test, true, test_success,
+		kunit_print_ok_not_ok(&test, true, test_case->success,
 				      kunit_test_case_num(suite, test_case),
 				      test_case->name);
 	}
-- 
2.30.2



