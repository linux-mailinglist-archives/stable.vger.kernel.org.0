Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD74EED43
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbfKDWE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389747AbfKDWE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:58 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9552A218BA;
        Mon,  4 Nov 2019 22:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905097;
        bh=+WX7nYZPnUOZdA4Nj3pS3DRAfu9FBRsMfLNZ9gGK/k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYg3BlYkGKfGUG5bzVEd4bz3Zv2URgrwZ70iuf96LzvVhkAYnXif5M3Dq47hDMgnz
         wNf41in+GelP/oTeeBIVePszO8vCmAF825piEfCC2PwsobA3ioI77mb3Rc7qdFHoDP
         Dy1IloBB/2Jmo1L9CAz7v0y5PsHghenjnnoI/GmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 027/163] selftests/kselftest/runner.sh: Add 45 second timeout per test
Date:   Mon,  4 Nov 2019 22:43:37 +0100
Message-Id: <20191104212142.299841825@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 852c8cbf34d3b3130a05c38064dd98614f97d3a8 ]

Commit a745f7af3cbd ("selftests/harness: Add 30 second timeout per
test") solves the problem of kselftest_harness.h-using binary tests
possibly hanging forever. However, scripts and other binaries can still
hang forever. This adds a global timeout to each test script run.

To make this configurable (e.g. as needed in the "rtc" test case),
include a new per-test-directory "settings" file (similar to "config")
that can contain kselftest-specific settings. The first recognized field
is "timeout".

Additionally, this splits the reporting for timeouts into a specific
"TIMEOUT" not-ok (and adds exit code reporting in the remaining case).

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/runner.sh | 36 +++++++++++++++++++--
 tools/testing/selftests/rtc/settings        |  1 +
 2 files changed, 34 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/rtc/settings

diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index 00c9020bdda8b..84de7bc74f2cf 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -3,9 +3,14 @@
 #
 # Runs a set of tests in a given subdirectory.
 export skip_rc=4
+export timeout_rc=124
 export logfile=/dev/stdout
 export per_test_logging=
 
+# Defaults for "settings" file fields:
+# "timeout" how many seconds to let each test run before failing.
+export kselftest_default_timeout=45
+
 # There isn't a shell-agnostic way to find the path of a sourced file,
 # so we must rely on BASE_DIR being set to find other tools.
 if [ -z "$BASE_DIR" ]; then
@@ -24,6 +29,16 @@ tap_prefix()
 	fi
 }
 
+tap_timeout()
+{
+	# Make sure tests will time out if utility is available.
+	if [ -x /usr/bin/timeout ] ; then
+		/usr/bin/timeout "$kselftest_timeout" "$1"
+	else
+		"$1"
+	fi
+}
+
 run_one()
 {
 	DIR="$1"
@@ -32,6 +47,18 @@ run_one()
 
 	BASENAME_TEST=$(basename $TEST)
 
+	# Reset any "settings"-file variables.
+	export kselftest_timeout="$kselftest_default_timeout"
+	# Load per-test-directory kselftest "settings" file.
+	settings="$BASE_DIR/$DIR/settings"
+	if [ -r "$settings" ] ; then
+		while read line ; do
+			field=$(echo "$line" | cut -d= -f1)
+			value=$(echo "$line" | cut -d= -f2-)
+			eval "kselftest_$field"="$value"
+		done < "$settings"
+	fi
+
 	TEST_HDR_MSG="selftests: $DIR: $BASENAME_TEST"
 	echo "# $TEST_HDR_MSG"
 	if [ ! -x "$TEST" ]; then
@@ -44,14 +71,17 @@ run_one()
 		echo "not ok $test_num $TEST_HDR_MSG"
 	else
 		cd `dirname $TEST` > /dev/null
-		(((((./$BASENAME_TEST 2>&1; echo $? >&3) |
+		((((( tap_timeout ./$BASENAME_TEST 2>&1; echo $? >&3) |
 			tap_prefix >&4) 3>&1) |
 			(read xs; exit $xs)) 4>>"$logfile" &&
 		echo "ok $test_num $TEST_HDR_MSG") ||
-		(if [ $? -eq $skip_rc ]; then	\
+		(rc=$?;	\
+		if [ $rc -eq $skip_rc ]; then	\
 			echo "not ok $test_num $TEST_HDR_MSG # SKIP"
+		elif [ $rc -eq $timeout_rc ]; then \
+			echo "not ok $test_num $TEST_HDR_MSG # TIMEOUT"
 		else
-			echo "not ok $test_num $TEST_HDR_MSG"
+			echo "not ok $test_num $TEST_HDR_MSG # exit=$rc"
 		fi)
 		cd - >/dev/null
 	fi
diff --git a/tools/testing/selftests/rtc/settings b/tools/testing/selftests/rtc/settings
new file mode 100644
index 0000000000000..ba4d85f74cd6b
--- /dev/null
+++ b/tools/testing/selftests/rtc/settings
@@ -0,0 +1 @@
+timeout=90
-- 
2.20.1



