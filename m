Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E523FB72
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgHHXtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgHHXhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35BA72073E;
        Sat,  8 Aug 2020 23:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929832;
        bh=EuYOFVLnvPo1+2S5w/3/GkQEHKQPzj6YFWOX9TrrUfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARKLd2XpVdLSC6lKZTBTvUmRKZmEoh53WU1HuiINjgioZA7ugKsQa7P4NMgVaMgnq
         W1zzCnUFEKUeN3Kf5aFrHJuF2VYHAdf16S8aeGyHLXRwrv2ieu+aYBiTjqv9ENyTgq
         v2Bvd32eLCOhrwG5i2M72MY2RtCLJb9XIZ/o+f9Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.8 63/72] kunit: tool: fix broken default args in unit tests
Date:   Sat,  8 Aug 2020 19:35:32 -0400
Message-Id: <20200808233542.3617339-63-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 6816fe61bda8c819c368ad2002cd27172ecb79de ]

Commit ddbd60c779b4 ("kunit: use --build_dir=.kunit as default") changed
the default build directory for KUnit tests, but failed to update
associated unit tests for kunit_tool, so update them.

Fixes: ddbd60c779b4 ("kunit: use --build_dir=.kunit as default")
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_tool_test.py | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index f9eeaea94cad1..ee942d80bdd02 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -258,14 +258,14 @@ class KUnitMainTest(unittest.TestCase):
 	def test_build_passes_args_pass(self):
 		kunit.main(['build'], self.linux_source_mock)
 		assert self.linux_source_mock.build_reconfig.call_count == 0
-		self.linux_source_mock.build_um_kernel.assert_called_once_with(False, 8, '', None)
+		self.linux_source_mock.build_um_kernel.assert_called_once_with(False, 8, '.kunit', None)
 		assert self.linux_source_mock.run_kernel.call_count == 0
 
 	def test_exec_passes_args_pass(self):
 		kunit.main(['exec'], self.linux_source_mock)
 		assert self.linux_source_mock.build_reconfig.call_count == 0
 		assert self.linux_source_mock.run_kernel.call_count == 1
-		self.linux_source_mock.run_kernel.assert_called_once_with(build_dir='', timeout=300)
+		self.linux_source_mock.run_kernel.assert_called_once_with(build_dir='.kunit', timeout=300)
 		self.print_mock.assert_any_call(StrContains('Testing complete.'))
 
 	def test_run_passes_args_pass(self):
@@ -273,7 +273,7 @@ class KUnitMainTest(unittest.TestCase):
 		assert self.linux_source_mock.build_reconfig.call_count == 1
 		assert self.linux_source_mock.run_kernel.call_count == 1
 		self.linux_source_mock.run_kernel.assert_called_once_with(
-			build_dir='', timeout=300)
+			build_dir='.kunit', timeout=300)
 		self.print_mock.assert_any_call(StrContains('Testing complete.'))
 
 	def test_exec_passes_args_fail(self):
@@ -313,7 +313,7 @@ class KUnitMainTest(unittest.TestCase):
 	def test_exec_timeout(self):
 		timeout = 3453
 		kunit.main(['exec', '--timeout', str(timeout)], self.linux_source_mock)
-		self.linux_source_mock.run_kernel.assert_called_once_with(build_dir='', timeout=timeout)
+		self.linux_source_mock.run_kernel.assert_called_once_with(build_dir='.kunit', timeout=timeout)
 		self.print_mock.assert_any_call(StrContains('Testing complete.'))
 
 	def test_run_timeout(self):
@@ -321,7 +321,7 @@ class KUnitMainTest(unittest.TestCase):
 		kunit.main(['run', '--timeout', str(timeout)], self.linux_source_mock)
 		assert self.linux_source_mock.build_reconfig.call_count == 1
 		self.linux_source_mock.run_kernel.assert_called_once_with(
-			build_dir='', timeout=timeout)
+			build_dir='.kunit', timeout=timeout)
 		self.print_mock.assert_any_call(StrContains('Testing complete.'))
 
 	def test_run_builddir(self):
-- 
2.25.1

