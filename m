Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91494536603
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 18:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiE0QcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 12:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349163AbiE0QcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 12:32:10 -0400
X-Greylist: delayed 466 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 May 2022 09:32:08 PDT
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB68B7E5
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:32:08 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L8qrN1bZvzMqWbp;
        Fri, 27 May 2022 18:24:20 +0200 (CEST)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4L8qrM6RHTzlhMbr;
        Fri, 27 May 2022 18:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1653668660;
        bh=hXEP0YV2tisSrUNLHisVWLIXyHgN/uN/8A9Zrhkd+Qo=;
        h=From:To:Cc:Subject:Date:From;
        b=JGyyRu51rIh96WccpOaxrreJkOdxxHA2C8UA6k1Jl+ZtYxoVcIG1Pu2CSiNyhi0+Q
         oFCGhWcc4IHI7q+muj7hUOtTo/06pPc6QG5Updu+mRPTVjIS+X3sD51MVw+4DZYd9o
         thYPSzk6yLgmjInePR3S8H+VHg3/QEv/LIKqri9E=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Shuah Khan <shuah@kernel.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        SeongJae Park <sjpark@amazon.de>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1] selftests/kselftest: Make failed tests exit with 1
Date:   Fri, 27 May 2022 18:24:17 +0200
Message-Id: <20220527162417.2646998-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To check that tests are passing we must parse the kselftest runner
output.  It is much more convenient to check the return value of the
runner instead: 0 is OK, and 1 implies one or more errors.

This has an impact on the kselftest's gen_tar bundle and the run_tests
make target.

Backporting this change would be useful to consistently test older
kernels as well.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: stable@vger.kernel.org # 303f8e2d0200: selftests/kselftest/runner/run_one(): allow running non-executable files
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20220527162417.2646998-1-mic@digikod.net
---
 tools/testing/selftests/kselftest/runner.sh | 36 +++++++++++++--------
 tools/testing/selftests/run_kselftest.sh    |  4 ++-
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index 294619ade49f..f6488a53a78c 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -46,6 +46,8 @@ run_one()
 	DIR="$1"
 	TEST="$2"
 	NUM="$3"
+	local rc=1
+	local ret=1
 
 	BASENAME_TEST=$(basename $TEST)
 
@@ -107,29 +109,36 @@ run_one()
 				cmd="$interpreter ./$BASENAME_TEST"
 			else
 				echo "not ok $test_num $TEST_HDR_MSG"
-				return
+				return 1
 			fi
 		fi
 		cd `dirname $TEST` > /dev/null
-		((((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
+		if (((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
 			tap_prefix >&4) 3>&1) |
-			(read xs; exit $xs)) 4>>"$logfile" &&
-		echo "ok $test_num $TEST_HDR_MSG") ||
-		(rc=$?;	\
-		if [ $rc -eq $skip_rc ]; then	\
-			echo "ok $test_num $TEST_HDR_MSG # SKIP"
-		elif [ $rc -eq $timeout_rc ]; then \
-			echo "#"
-			echo "not ok $test_num $TEST_HDR_MSG # TIMEOUT $kselftest_timeout seconds"
+			(read xs; exit $xs)) 4>>"$logfile"; then
+			echo "ok $test_num $TEST_HDR_MSG"
+			ret=0
 		else
-			echo "not ok $test_num $TEST_HDR_MSG # exit=$rc"
-		fi)
+			rc=$?
+			if [ $rc -eq $skip_rc ]; then
+				echo "ok $test_num $TEST_HDR_MSG # SKIP"
+				ret=0
+			elif [ $rc -eq $timeout_rc ]; then
+				echo "#"
+				echo "not ok $test_num $TEST_HDR_MSG # TIMEOUT $kselftest_timeout seconds"
+			else
+				echo "not ok $test_num $TEST_HDR_MSG # exit=$rc"
+			fi
+		fi
 		cd - >/dev/null
 	fi
+	return $ret
 }
 
 run_many()
 {
+	local ret=0
+
 	echo "TAP version 13"
 	DIR="${PWD#${BASE_DIR}/}"
 	test_num=0
@@ -142,6 +151,7 @@ run_many()
 			logfile="/tmp/$BASENAME_TEST"
 			cat /dev/null > "$logfile"
 		fi
-		run_one "$DIR" "$TEST" "$test_num"
+		run_one "$DIR" "$TEST" "$test_num" || ret=1
 	done
+	return $ret
 }
diff --git a/tools/testing/selftests/run_kselftest.sh b/tools/testing/selftests/run_kselftest.sh
index 97165a83df63..6164314f837e 100755
--- a/tools/testing/selftests/run_kselftest.sh
+++ b/tools/testing/selftests/run_kselftest.sh
@@ -85,9 +85,11 @@ if [ -n "$TESTS" ]; then
 	available="$(echo "$valid" | sed -e 's/ /\n/g')"
 fi
 
+ret=0
 collections=$(echo "$available" | cut -d: -f1 | uniq)
 for collection in $collections ; do
 	[ -w /dev/kmsg ] && echo "kselftest: Running tests in $collection" >> /dev/kmsg
 	tests=$(echo "$available" | grep "^$collection:" | cut -d: -f2)
-	($dryrun cd "$collection" && $dryrun run_many $tests)
+	($dryrun cd "$collection" && $dryrun run_many $tests) || ret=1
 done
+exit $ret

base-commit: 7e284070abe53d448517b80493863595af4ab5f0
-- 
2.36.0

