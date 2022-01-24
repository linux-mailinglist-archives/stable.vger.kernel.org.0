Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C41499C82
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579536AbiAXWFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577048AbiAXV5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:57:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407C6C02C307;
        Mon, 24 Jan 2022 12:38:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB910B811FB;
        Mon, 24 Jan 2022 20:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D935BC340E5;
        Mon, 24 Jan 2022 20:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056727;
        bh=uSOMnpLBoWbmn1u3zPszgvPwiLRvJiLR/eIsGJPtN6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlnZ9FEFV8Z/vlL5DcAMmrV91gnMG2/FH1b8mLNbpap387C2v+lxDVR2ytt8xSx8r
         DSco0Tv/RHCnJJoTw5AhxhJ/r8Od0AbdGJfcPT0gYKX9WsaJjW0T2SDnzmQ/5ydIbF
         WtZPMkC8yCBC5R3qiIWfz6U1JR4zFwj8zAoOuH5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        David Gow <davidgow@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 547/846] kunit: Dont crash if no parameters are generated
Date:   Mon, 24 Jan 2022 19:41:04 +0100
Message-Id: <20220124184119.893371050@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index f246b847024e3..9aef816e573c1 100644
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



