Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F01332AF2D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhCCAPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44813 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443549AbhCBMLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF12864F5E;
        Tue,  2 Mar 2021 11:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686229;
        bh=YDrJ6wM4CZuG0au8XgV+YfuCnN9JNUVXPSm9QYJC6U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eE3QMX3CshUK1diDRXsUhg5ppqB2yksUL6WbvwK+6jZYCdbqjaukWn7y7Iar/Syx+
         3W6R1gsenhg/oJY61cHTxLyovqYsCpZSqabPFkFM/seD0i7wDvlPdfLfKzftS1KO8S
         tSQZY9Yzi2i+LRhOanZ2SDAiuA2aBLdK/uAZlC4SH7fo/pQ2soWH8t7xayo2HHgxzP
         asPjOrRY7TRztj7lNE/h3gc2VY92nlV54yMOB6lw0TZYENaK6FDtX9I3y+4QxhCq7w
         U7Gf8LG9UCvKdFIl03hXXqZyrDvhXfC89G5x3Y10eg1fA89DlehtXl21cmwZQxSXvQ
         FpdLXrle/PD8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Latypov <dlatypov@google.com>,
        David Gow <davidgow@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 18/47] kunit: tool: fix unit test cleanup handling
Date:   Tue,  2 Mar 2021 06:56:17 -0500
Message-Id: <20210302115646.62291-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit cfd607e43da4a20753744f134e201310262b827a ]

* Stop leaking file objects.
* Use self.addCleanup() to ensure we call cleanup functions even if
setUp() fails.
* use mock.patch.stopall instead of more error-prone manual approach

Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_tool_test.py | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index 497ab51bc170..3fbe1acd531a 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -288,19 +288,17 @@ class StrContains(str):
 class KUnitMainTest(unittest.TestCase):
 	def setUp(self):
 		path = get_absolute_path('test_data/test_is_test_passed-all_passed.log')
-		file = open(path)
-		all_passed_log = file.readlines()
-		self.print_patch = mock.patch('builtins.print')
-		self.print_mock = self.print_patch.start()
+		with open(path) as file:
+			all_passed_log = file.readlines()
+
+		self.print_mock = mock.patch('builtins.print').start()
+		self.addCleanup(mock.patch.stopall)
+
 		self.linux_source_mock = mock.Mock()
 		self.linux_source_mock.build_reconfig = mock.Mock(return_value=True)
 		self.linux_source_mock.build_um_kernel = mock.Mock(return_value=True)
 		self.linux_source_mock.run_kernel = mock.Mock(return_value=all_passed_log)
 
-	def tearDown(self):
-		self.print_patch.stop()
-		pass
-
 	def test_config_passes_args_pass(self):
 		kunit.main(['config', '--build_dir=.kunit'], self.linux_source_mock)
 		assert self.linux_source_mock.build_reconfig.call_count == 1
-- 
2.30.1

