Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA49E49A4A0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357511AbiAYAJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:09:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444318AbiAXVG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC29061451;
        Mon, 24 Jan 2022 21:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AB5C340E5;
        Mon, 24 Jan 2022 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058417;
        bh=aJ5YBxeO/4QRHT8rngDaLNVmp8PG20YzWHTts758vWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rslqiSlF3EKnu4qdJkIu3l5J51yFtfNPjEtbrzwV9Hhl3zifJ5GN8vjYpIUxrIveO
         ENH6GYsThmlkg9LOA3Snc9YMeDw8vC8i0hpThdyHpBS1lEo6qBDwQ/EKT8ao7EYOrn
         wWj2J2w/XqsdEl8suObpbhZxkXI7POqny9QVrYew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        David Gow <davidgow@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0282/1039] kunit: tool: fix --json output for skipped tests
Date:   Mon, 24 Jan 2022 19:34:31 +0100
Message-Id: <20220124184134.768342225@linuxfoundation.org>
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

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit 9a6bb30a8830bb868b09629f0b9ad5d2b5fbb2f9 ]

Currently, KUnit will report SKIPPED tests as having failed if one uses
--json.

Add the missing if statement to set the appropriate status ("SKIP").
See https://api.kernelci.org/schema-test-case.html:
  "status": {
      "type": "string",
      "description": "The status of the execution of this test case",
      "enum": ["PASS", "FAIL", "SKIP", "ERROR"],
      "default": "PASS"
  },
with this, we now can properly produce all four of the statuses.

Fixes: 5acaf6031f53 ("kunit: tool: Support skipped tests in kunit_tool")
Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_json.py      | 2 ++
 tools/testing/kunit/kunit_tool_test.py | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/kunit/kunit_json.py b/tools/testing/kunit/kunit_json.py
index 746bec72b9ac2..b6e66c5d64d14 100644
--- a/tools/testing/kunit/kunit_json.py
+++ b/tools/testing/kunit/kunit_json.py
@@ -30,6 +30,8 @@ def _get_group_json(test: Test, def_config: str,
 			test_case = {"name": subtest.name, "status": "FAIL"}
 			if subtest.status == TestStatus.SUCCESS:
 				test_case["status"] = "PASS"
+			elif subtest.status == TestStatus.SKIPPED:
+				test_case["status"] = "SKIP"
 			elif subtest.status == TestStatus.TEST_CRASHED:
 				test_case["status"] = "ERROR"
 			test_cases.append(test_case)
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index 9c41267314573..34cb0a12ba180 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -383,6 +383,12 @@ class KUnitJsonTest(unittest.TestCase):
 			{'name': 'example_simple_test', 'status': 'ERROR'},
 			result["sub_groups"][1]["test_cases"][0])
 
+	def test_skipped_test_json(self):
+		result = self._json_for('test_skip_tests.log')
+		self.assertEqual(
+			{'name': 'example_skip_test', 'status': 'SKIP'},
+			result["sub_groups"][1]["test_cases"][1])
+
 	def test_no_tests_json(self):
 		result = self._json_for('test_is_test_passed-no_tests_run_with_header.log')
 		self.assertEqual(0, len(result['sub_groups']))
-- 
2.34.1



