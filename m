Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B415F59512A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiHPEuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiHPEsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F178EB514C;
        Mon, 15 Aug 2022 13:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CEAFB811AC;
        Mon, 15 Aug 2022 20:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0461C433D6;
        Mon, 15 Aug 2022 20:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596220;
        bh=DemmFqknU4D3MR+kRLzsx5FOMFNFYVOCBaSJPJ3o/NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thTgyGfyD44juLaFCFW8c7VRzqzmMd39gKPQ3RhwjSg2sJagzS3l0ZWp63kAaJyFs
         Vncb1nU4bKGBGlnk8oZb2+SApIsMdn6Wd+RardplzG92ht/nxbNELYsNH+KoBfo14X
         I9xOJAguTP/22B99Y0cbzY2XXj9DAtrKRzr+2Nzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0977/1157] perf test: Fix test case 83 (perf stat CSV output linter) on s390
Date:   Mon, 15 Aug 2022 20:05:33 +0200
Message-Id: <20220815180518.812896007@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 87abe344cd280802f431998fabfd35d2d340ca90 ]

Perf test case 83: perf stat CSV output linter might fail
on s390.
The reason for this is the output of the command

 ./perf stat -x, -A -a --no-merge true

which depends on a .config file setting. When CONFIG_SCHED_TOPOLOGY
is set, the output of above perf command is

   CPU0,1.50,msec,cpu-clock,1502781,100.00,1.052,CPUs utilized

When CONFIG_SCHED_TOPOLOGY is *NOT* set the output of above perf
command is

   0.95,msec,cpu-clock,949800,100.00,1.060,CPUs utilized

Fix the test case to accept both output formats.

Output before:
 # perf test 83
 83: perf stat CSV output linter       : FAILED!
 #

Output after:
 # ./perf test 83
 83: perf stat CSV output linter       : Ok
 #

Fixes: ec906102e5b7d339 ("perf test: Fix "perf stat CSV output linter" test on s390")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20220720123419.220953-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat+csv_output.sh | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/shell/stat+csv_output.sh b/tools/perf/tests/shell/stat+csv_output.sh
index 38c26f3ef4c1..eb5196f58190 100755
--- a/tools/perf/tests/shell/stat+csv_output.sh
+++ b/tools/perf/tests/shell/stat+csv_output.sh
@@ -8,7 +8,8 @@ set -e
 
 function commachecker()
 {
-	local -i cnt=0 exp=0
+	local -i cnt=0
+	local exp=0
 
 	case "$1"
 	in "--no-args")		exp=6
@@ -17,7 +18,7 @@ function commachecker()
 	;; "--interval")	exp=7
 	;; "--per-thread")	exp=7
 	;; "--system-wide-no-aggr")	exp=7
-				[ $(uname -m) = "s390x" ] && exp=6
+				[ $(uname -m) = "s390x" ] && exp='^[6-7]$'
 	;; "--per-core")	exp=8
 	;; "--per-socket")	exp=8
 	;; "--per-node")	exp=8
@@ -34,7 +35,7 @@ function commachecker()
 		x=$(echo $line | tr -d -c ',')
 		cnt="${#x}"
 		# echo $line $cnt
-		[ "$cnt" -ne "$exp" ] && {
+		[[ ! "$cnt" =~ $exp ]] && {
 			echo "wrong number of fields. expected $exp in $line" 1>&2
 			exit 1;
 		}
-- 
2.35.1



