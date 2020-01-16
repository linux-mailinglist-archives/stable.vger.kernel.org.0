Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03AAC13F94F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgAPTYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbgAPQwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590F621582;
        Thu, 16 Jan 2020 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193573;
        bh=B652F4k9tD2WEfGYtVNwbN/7riZj1x+5P2wOqwV+xf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uy5QgMCzc1q9SVd7F6MDzOExcJQ2Rdc5uN7ymykNcMPO8pZZG87gI9ojsj2YTjLYX
         IJ/Wxq/dsu5VcSH5R/HepEhGEH6HX7iCYh6vD4oRdbUkZqRHCabGRd3jK0sMhEDFMH
         CK6gd6kqfmEQnQnMMjOajSIfTx+HHobT/hVrEMcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 116/205] selftests: gen_kselftest_tar.sh: Do not clobber kselftest/
Date:   Thu, 16 Jan 2020 11:41:31 -0500
Message-Id: <20200116164300.6705-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit ea1bf0bb18c0bd627d7b551196453ff2fff44225 ]

The default installation location for gen_kselftest_tar.sh was still
"kselftest/" which collides with the existing directory. Instead, this
moves the installation target into "kselftest_install/kselftest/" and
adjusts the tar creation accordingly. This also adjusts indentation and
logic to be consistent.

Fixes: 42d46e57ec97 ("selftests: Extract single-test shell logic from lib.mk")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/gen_kselftest_tar.sh | 21 ++++++++++-------
 tools/testing/selftests/kselftest_install.sh | 24 ++++++++++----------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/gen_kselftest_tar.sh b/tools/testing/selftests/gen_kselftest_tar.sh
index a27e2eec3586..8b2b6088540d 100755
--- a/tools/testing/selftests/gen_kselftest_tar.sh
+++ b/tools/testing/selftests/gen_kselftest_tar.sh
@@ -38,16 +38,21 @@ main()
 	esac
 	fi
 
-	install_dir=./kselftest
+	# Create working directory.
+	dest=`pwd`
+	install_work="$dest"/kselftest_install
+	install_name=kselftest
+	install_dir="$install_work"/"$install_name"
+	mkdir -p "$install_dir"
 
-# Run install using INSTALL_KSFT_PATH override to generate install
-# directory
-./kselftest_install.sh
-tar $copts kselftest${ext} $install_dir
-echo "Kselftest archive kselftest${ext} created!"
+	# Run install using INSTALL_KSFT_PATH override to generate install
+	# directory
+	./kselftest_install.sh "$install_dir"
+	(cd "$install_work"; tar $copts "$dest"/kselftest${ext} $install_name)
+	echo "Kselftest archive kselftest${ext} created!"
 
-# clean up install directory
-rm -rf kselftest
+	# clean up top-level install work directory
+	rm -rf "$install_work"
 }
 
 main "$@"
diff --git a/tools/testing/selftests/kselftest_install.sh b/tools/testing/selftests/kselftest_install.sh
index e2e1911d62d5..407af7da7037 100755
--- a/tools/testing/selftests/kselftest_install.sh
+++ b/tools/testing/selftests/kselftest_install.sh
@@ -6,30 +6,30 @@
 # Author: Shuah Khan <shuahkh@osg.samsung.com>
 # Copyright (C) 2015 Samsung Electronics Co., Ltd.
 
-install_loc=`pwd`
-
 main()
 {
-	if [ $(basename $install_loc) !=  "selftests" ]; then
+	base_dir=`pwd`
+	install_dir="$base_dir"/kselftest_install
+
+	# Make sure we're in the selftests top-level directory.
+	if [ $(basename "$base_dir") !=  "selftests" ]; then
 		echo "$0: Please run it in selftests directory ..."
 		exit 1;
 	fi
+
+	# Only allow installation into an existing location.
 	if [ "$#" -eq 0 ]; then
-		echo "$0: Installing in default location - $install_loc ..."
+		echo "$0: Installing in default location - $install_dir ..."
 	elif [ ! -d "$1" ]; then
 		echo "$0: $1 doesn't exist!!"
 		exit 1;
 	else
-		install_loc=$1
-		echo "$0: Installing in specified location - $install_loc ..."
+		install_dir="$1"
+		echo "$0: Installing in specified location - $install_dir ..."
 	fi
 
-	install_dir=$install_loc/kselftest_install
-
-# Create install directory
-	mkdir -p $install_dir
-# Build tests
-	KSFT_INSTALL_PATH=$install_dir make install
+	# Build tests
+	KSFT_INSTALL_PATH="$install_dir" make install
 }
 
 main "$@"
-- 
2.20.1

