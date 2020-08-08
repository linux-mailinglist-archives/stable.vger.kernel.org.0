Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB76923FB61
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHHXhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgHHXhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 741002075D;
        Sat,  8 Aug 2020 23:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929833;
        bh=S52HMP+iGIQTiPXzc+/0cRLoLrDrJlI50TCAzbDwHIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIcsOjGIxKYTZ1V8CQfasOxObj1NYQvuZVMksI4MVw6pytudwEuLPBJH68PlhhA/a
         sZQxjUW/mVpE9jok2hMFt9dZ+nFHWbzCs7gSmcG/vvY2Px3PG0Wbrfo3ocsP35cbZH
         BvWFXpuPR4ULpZ/uP809bvKLCo4iFpArOTMFTKxM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.8 64/72] kunit: tool: fix improper treatment of file location
Date:   Sat,  8 Aug 2020 19:35:33 -0400
Message-Id: <20200808233542.3617339-64-sashal@kernel.org>
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

[ Upstream commit d43c7fb05765152d4d4a39a8ef957c4ea14d8847 ]

Commit 01397e822af4 ("kunit: Fix TabError, remove defconfig code and
handle when there is no kunitconfig") and commit 45ba7a893ad8 ("kunit:
kunit_tool: Separate out config/build/exec/parse") introduced two
closely related issues which built off of each other: they excessively
created the build directory when not present and modified a constant
(constants in Python only exist by convention).

Together these issues broken a number of unit tests for KUnit tool, so
fix them.

Fixed up commit log to fic checkpatch commit description style error.
Shuah Khan <skhan@linuxfoundation.org>

Fixes: 01397e822af4 ("kunit: Fix TabError, remove defconfig code and handle when there is no kunitconfig")
Fixes: 45ba7a893ad8 ("kunit: kunit_tool: Separate out config/build/exec/parse")
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit.py           | 24 ------------------------
 tools/testing/kunit/kunit_tool_test.py |  4 ++--
 2 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index f9b769f3437dd..425ef40067e7e 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -240,12 +240,6 @@ def main(argv, linux=None):
 	if cli_args.subcommand == 'run':
 		if not os.path.exists(cli_args.build_dir):
 			os.mkdir(cli_args.build_dir)
-		kunit_kernel.kunitconfig_path = os.path.join(
-			cli_args.build_dir,
-			kunit_kernel.kunitconfig_path)
-
-		if not os.path.exists(kunit_kernel.kunitconfig_path):
-			create_default_kunitconfig()
 
 		if not linux:
 			linux = kunit_kernel.LinuxSourceTree()
@@ -263,12 +257,6 @@ def main(argv, linux=None):
 		if cli_args.build_dir:
 			if not os.path.exists(cli_args.build_dir):
 				os.mkdir(cli_args.build_dir)
-			kunit_kernel.kunitconfig_path = os.path.join(
-				cli_args.build_dir,
-				kunit_kernel.kunitconfig_path)
-
-		if not os.path.exists(kunit_kernel.kunitconfig_path):
-			create_default_kunitconfig()
 
 		if not linux:
 			linux = kunit_kernel.LinuxSourceTree()
@@ -285,12 +273,6 @@ def main(argv, linux=None):
 		if cli_args.build_dir:
 			if not os.path.exists(cli_args.build_dir):
 				os.mkdir(cli_args.build_dir)
-			kunit_kernel.kunitconfig_path = os.path.join(
-				cli_args.build_dir,
-				kunit_kernel.kunitconfig_path)
-
-		if not os.path.exists(kunit_kernel.kunitconfig_path):
-			create_default_kunitconfig()
 
 		if not linux:
 			linux = kunit_kernel.LinuxSourceTree()
@@ -309,12 +291,6 @@ def main(argv, linux=None):
 		if cli_args.build_dir:
 			if not os.path.exists(cli_args.build_dir):
 				os.mkdir(cli_args.build_dir)
-			kunit_kernel.kunitconfig_path = os.path.join(
-				cli_args.build_dir,
-				kunit_kernel.kunitconfig_path)
-
-		if not os.path.exists(kunit_kernel.kunitconfig_path):
-			create_default_kunitconfig()
 
 		if not linux:
 			linux = kunit_kernel.LinuxSourceTree()
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index ee942d80bdd02..287c74d821c33 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -251,7 +251,7 @@ class KUnitMainTest(unittest.TestCase):
 		pass
 
 	def test_config_passes_args_pass(self):
-		kunit.main(['config'], self.linux_source_mock)
+		kunit.main(['config', '--build_dir=.kunit'], self.linux_source_mock)
 		assert self.linux_source_mock.build_reconfig.call_count == 1
 		assert self.linux_source_mock.run_kernel.call_count == 0
 
@@ -326,7 +326,7 @@ class KUnitMainTest(unittest.TestCase):
 
 	def test_run_builddir(self):
 		build_dir = '.kunit'
-		kunit.main(['run', '--build_dir', build_dir], self.linux_source_mock)
+		kunit.main(['run', '--build_dir=.kunit'], self.linux_source_mock)
 		assert self.linux_source_mock.build_reconfig.call_count == 1
 		self.linux_source_mock.run_kernel.assert_called_once_with(
 			build_dir=build_dir, timeout=300)
-- 
2.25.1

