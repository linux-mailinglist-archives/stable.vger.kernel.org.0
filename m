Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C307D49A3C4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368786AbiAYAAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846529AbiAXXQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB79C0617BB;
        Mon, 24 Jan 2022 13:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 027AEB811A2;
        Mon, 24 Jan 2022 21:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEF8C340E5;
        Mon, 24 Jan 2022 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059530;
        bh=l5m0JNrwApBjUgpOL2jCcyrk+wjkCLYERdR8P9Cx/Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXEjFp9vPfYuvNSqweUSV5h6LJlR8Vx35kMrME0Ep3SnDqDTcvBxC8m9f4FCnJJhO
         Jn/lLoCmDErfWipqRlN6QoILlsGMVegnSbwN4gG4y/TDnQ8P7Nir65fOsP43uCRcLu
         /Jb9l9xXNMfA0NN18dG2P5S402XFh9M5z3ioR32U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        David Gow <davidgow@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0646/1039] kunit: Dont crash if no parameters are generated
Date:   Mon, 24 Jan 2022 19:40:35 +0100
Message-Id: <20220124184147.064749898@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



