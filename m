Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8A4F2E18
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbiDEI1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbiDEIUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87530E8E;
        Tue,  5 Apr 2022 01:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40F4EB81B90;
        Tue,  5 Apr 2022 08:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC83C385A1;
        Tue,  5 Apr 2022 08:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146505;
        bh=PIt3LItMcm9I/B27+MH1ot3tWgjOcbN9tmyl/YHXUp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3OY9A+Sr8Macqm8tsJ3ndrcv2ytaYQ7ad2g6D86T0dIjagIvFjYMu3T97COsYUjb
         r3NT7lV5g/y3dQD7OuV0RvNqKvDoDtkXC+A2Hf8q+brHJTlXcnI9DJysKGDtHRUy/Y
         pKA4PuFwGZ7fFyL9+OabV/pcuoxtIq7xEiTHOXgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Alexandre Truong <alexandre.truong@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0787/1126] perf test arm64: Test unwinding using fame-pointer (fp) mode
Date:   Tue,  5 Apr 2022 09:25:34 +0200
Message-Id: <20220405070430.674767402@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: German Gomez <german.gomez@arm.com>

[ Upstream commit cd6382d82752737e43ef3617bb9e72913d2b1d47 ]

Add a shell script to check that the call-graphs generated using frame
pointers (--call-graph fp) are complete and not missing leaf functions:

  | $ perf test 88 -v
  |  88: Check Arm64 callgraphs are complete in fp mode                  :
  | --- start ---
  | test child forked, pid 8734
  |  + Compiling test program (/tmp/test_program.Cz3yL)...
  |  + Recording (PID=8749)...
  |  + Stopping perf-record...
  | test_program.Cz
  |                  728 leaf
  |                  753 parent
  |                  76c main
  | test child finished with 0
  | ---- end ----
  | Check Arm SPE callgraphs are complete in fp mode: Ok

It's supposed to work with both unwinders:

  | $ make                # for libunwind (default)
  | $ make NO_LIBUNWIND=1 # for libdw

Tester notes:

Ran it on N1SDP and it passes, and it fails if b9f6fbb3b2c29736 ("perf
arm64: Inject missing frames when using 'perf record --call-graph=fp'")
isn't applied.

Fixes: b9f6fbb3b2c29736 ("perf arm64: Inject missing frames when using 'perf record --call-graph=fp'")
Suggested-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: James Clark <james.clark@arm.com>
Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: German Gomez <german.gomez@arm.com>
Cc: Alexandre Truong <alexandre.truong@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220316172015.98000-1-german.gomez@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/tests/shell/test_arm_callgraph_fp.sh | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100755 tools/perf/tests/shell/test_arm_callgraph_fp.sh

diff --git a/tools/perf/tests/shell/test_arm_callgraph_fp.sh b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
new file mode 100755
index 000000000000..6ffbb27afaba
--- /dev/null
+++ b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
@@ -0,0 +1,68 @@
+#!/bin/sh
+# Check Arm64 callgraphs are complete in fp mode
+# SPDX-License-Identifier: GPL-2.0
+
+lscpu | grep -q "aarch64" || exit 2
+
+if ! [ -x "$(command -v cc)" ]; then
+	echo "failed: no compiler, install gcc"
+	exit 2
+fi
+
+PERF_DATA=$(mktemp /tmp/__perf_test.perf.data.XXXXX)
+TEST_PROGRAM_SOURCE=$(mktemp /tmp/test_program.XXXXX.c)
+TEST_PROGRAM=$(mktemp /tmp/test_program.XXXXX)
+
+cleanup_files()
+{
+	rm -f $PERF_DATA
+	rm -f $TEST_PROGRAM_SOURCE
+	rm -f $TEST_PROGRAM
+}
+
+trap cleanup_files exit term int
+
+cat << EOF > $TEST_PROGRAM_SOURCE
+int a = 0;
+void leaf(void) {
+  for (;;)
+    a += a;
+}
+void parent(void) {
+  leaf();
+}
+int main(void) {
+  parent();
+  return 0;
+}
+EOF
+
+echo " + Compiling test program ($TEST_PROGRAM)..."
+
+CFLAGS="-g -O0 -fno-inline -fno-omit-frame-pointer"
+cc $CFLAGS $TEST_PROGRAM_SOURCE -o $TEST_PROGRAM || exit 1
+
+# Add a 1 second delay to skip samples that are not in the leaf() function
+perf record -o $PERF_DATA --call-graph fp -e cycles//u -D 1000 -- $TEST_PROGRAM 2> /dev/null &
+PID=$!
+
+echo " + Recording (PID=$PID)..."
+sleep 2
+echo " + Stopping perf-record..."
+
+kill $PID
+wait $PID
+
+# expected perf-script output:
+#
+# program
+# 	728 leaf
+# 	753 parent
+# 	76c main
+# ...
+
+perf script -i $PERF_DATA -F comm,ip,sym | head -n4
+perf script -i $PERF_DATA -F comm,ip,sym | head -n4 | \
+	awk '{ if ($2 != "") sym[i++] = $2 } END { if (sym[0] != "leaf" ||
+						       sym[1] != "parent" ||
+						       sym[2] != "main") exit 1 }'
-- 
2.34.1



