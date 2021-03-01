Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DC0328D0A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbhCATET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:04:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240879AbhCAS6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:58:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B0C651E5;
        Mon,  1 Mar 2021 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619161;
        bh=5s9YUJUH5HJI4x8xi7gkB8koNYjb9xPbHWD5Sko/iTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zywr4EfocgE8UU0xjfhdzWUFBtJzzws9dJt5pBblfQtD49tarwrqs9VE0Gxia8mpB
         1fzZY4S8RBCuYkSRhHvqHk4t8pEunc216A6Ki2FvMZRA94vj6Na5jDvYKuo5fPmAnr
         zuJrJK8DR9wJX+JON52Mm3LtUwlUhKDaofRbnEYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        David Gow <davidgow@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/663] kunit: tool: fix unit test cleanup handling
Date:   Mon,  1 Mar 2021 17:10:02 +0100
Message-Id: <20210301161159.371942142@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 497ab51bc1702..3fbe1acd531ae 100755
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
2.27.0



