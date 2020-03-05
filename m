Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB2717ACF8
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgCERXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgCERNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2447524673;
        Thu,  5 Mar 2020 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428419;
        bh=n60fiqQit++r2dt9ETpVJeF3WsCOgv/ioz+JBtX7UoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Obac0x9XnhbsWmK441GJNYpIwlVfeGc9YMnDbrBZ8jHuC/SChZMZumBowgC5dmcr8
         FvCET4SQrBORozo7k0oFS3aSyw0QygY+gwcwMPdmDKQib8PDJrkPWa8kHpJnGssJ2r
         /Az2/5Y3aWdp/DieWtsJrriqkzBNB8Y4H7I1MhiM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heidi Fahim <heidifahim@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.5 21/67] kunit: run kunit_tool from any directory
Date:   Thu,  5 Mar 2020 12:12:22 -0500
Message-Id: <20200305171309.29118-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heidi Fahim <heidifahim@google.com>

[ Upstream commit be886ba90cce2fb2f5a4dbcda8f3be3fd1b2f484 ]

Implemented small fix so that the script changes work directories to the
root of the linux kernel source tree from which kunit.py is run. This
enables the user to run kunit from any working directory. Originally
considered using os.path.join but this is more error prone as we would
have to find all file path usages and modify them accordingly. Using
os.chdir ensures that the entire script is run within /linux.

Signed-off-by: Heidi Fahim <heidifahim@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit.py | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index e59eb9e7f9236..180ad1e1b04f9 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -24,6 +24,8 @@ KunitResult = namedtuple('KunitResult', ['status','result'])
 
 KunitRequest = namedtuple('KunitRequest', ['raw_output','timeout', 'jobs', 'build_dir', 'defconfig'])
 
+KernelDirectoryPath = sys.argv[0].split('tools/testing/kunit/')[0]
+
 class KunitStatus(Enum):
 	SUCCESS = auto()
 	CONFIG_FAILURE = auto()
@@ -35,6 +37,13 @@ def create_default_kunitconfig():
 		shutil.copyfile('arch/um/configs/kunit_defconfig',
 				kunit_kernel.kunitconfig_path)
 
+def get_kernel_root_path():
+	parts = sys.argv[0] if not __file__ else __file__
+	parts = os.path.realpath(parts).split('tools/testing/kunit')
+	if len(parts) != 2:
+		sys.exit(1)
+	return parts[0]
+
 def run_tests(linux: kunit_kernel.LinuxSourceTree,
 	      request: KunitRequest) -> KunitResult:
 	config_start = time.time()
@@ -114,6 +123,9 @@ def main(argv, linux=None):
 	cli_args = parser.parse_args(argv)
 
 	if cli_args.subcommand == 'run':
+		if get_kernel_root_path():
+			os.chdir(get_kernel_root_path())
+
 		if cli_args.build_dir:
 			if not os.path.exists(cli_args.build_dir):
 				os.mkdir(cli_args.build_dir)
-- 
2.20.1

