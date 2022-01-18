Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6B14915E7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbiARCcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344078AbiARC2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:28:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB12C0612AC;
        Mon, 17 Jan 2022 18:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79027B81255;
        Tue, 18 Jan 2022 02:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A87BC36AE3;
        Tue, 18 Jan 2022 02:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472760;
        bh=l5m0JNrwApBjUgpOL2jCcyrk+wjkCLYERdR8P9Cx/Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsqCz5Xgxy/cYo0kmAq7wcKtn/VSxyLlCWSF2Ib1QRP+EKmZ4bS0znbUh+h1urEXj
         TB8rrS0dnKtHcBQWSDMu7ZA921+fg8gcuvBpZjNfTLBhjefYr1XIF9gDGWvM0nj3lh
         pNEglrCuP8aDfXNLEmnULcDkfSSdzBxE+0OYT+U0Kl1vmotMitF3gtgEErfwdSdRQ6
         PqF7qlfu6E9LsJj/kJaywV76xYquHXRAJUO0HpZwbQZJTbi6dF7IYZTjV0NoMx7w5u
         ZqEU+fB65SaBq0W23/VMcC/pZV5NxKsdXWLFweOSdG0PeUq3M/RnY/L/+B7R+te7yQ
         AxD//H85jYpEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.16 128/217] kunit: Don't crash if no parameters are generated
Date:   Mon, 17 Jan 2022 21:18:11 -0500
Message-Id: <20220118021940.1942199-128-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 37dbb4c7c7442dbfc9b651e4ddd4afe30b26afc9 ]

It's possible that a parameterised test could end up with zero
parameters. At the moment, the test function will nevertheless be called
with NULL as the parameter. Instead, don't try to run the test code, and
just mark the test as SKIPped.

Reported-by: Daniel Latypov <dlatypov@google.com>
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/test.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 3bd741e50a2d3..f96498ede2cc5 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -504,16 +504,18 @@ int kunit_run_tests(struct kunit_suite *suite)
 		struct kunit_result_stats param_stats = { 0 };
 		test_case->status = KUNIT_SKIPPED;
 
-		if (test_case->generate_params) {
+		if (!test_case->generate_params) {
+			/* Non-parameterised test. */
+			kunit_run_case_catch_errors(suite, test_case, &test);
+			kunit_update_stats(&param_stats, test.status);
+		} else {
 			/* Get initial param. */
 			param_desc[0] = '\0';
 			test.param_value = test_case->generate_params(NULL, param_desc);
-		}
 
-		do {
-			kunit_run_case_catch_errors(suite, test_case, &test);
+			while (test.param_value) {
+				kunit_run_case_catch_errors(suite, test_case, &test);
 
-			if (test_case->generate_params) {
 				if (param_desc[0] == '\0') {
 					snprintf(param_desc, sizeof(param_desc),
 						 "param-%d", test.param_index);
@@ -530,11 +532,11 @@ int kunit_run_tests(struct kunit_suite *suite)
 				param_desc[0] = '\0';
 				test.param_value = test_case->generate_params(test.param_value, param_desc);
 				test.param_index++;
-			}
 
-			kunit_update_stats(&param_stats, test.status);
+				kunit_update_stats(&param_stats, test.status);
+			}
+		}
 
-		} while (test.param_value);
 
 		kunit_print_test_stats(&test, param_stats);
 
-- 
2.34.1

