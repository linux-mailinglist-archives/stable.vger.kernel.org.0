Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4908768D7E5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjBGNEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjBGND5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4671C39B98
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06E83CE1C9C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D31CC433EF;
        Tue,  7 Feb 2023 13:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775031;
        bh=ryRjPv5+EV4SdbMn0PqZCEH2sX01BDvZSzs4Y9hggKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDWCBv1O8iWahfCBAVkvgBdKUwNnITbeRykc9OZ6gCBZaK7J1asOYUsXcB9nu022t
         Cm6eox2uJPjD1tybZyLH+BXs/WSRlwz4ZcqQhma9cukNbVRfU5qFD0bkNnbVbHy9RV
         EWOBDfGNB+BiJmKV6vfM5mVSAVl3o1Uz19a1EAdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andrei Gherzan <andrei.gherzan@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/208] selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs
Date:   Tue,  7 Feb 2023 13:55:39 +0100
Message-Id: <20230207125638.202602740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Gherzan <andrei.gherzan@canonical.com>

[ Upstream commit dafe93b9ee21028d625dce347118b82659652eff ]

"udpgro_bench.sh" invokes udpgso_bench_rx/udpgso_bench_tx programs
subsequently and while doing so, there is a chance that the rx one is not
ready to accept socket connections. This racing bug could fail the test
with at least one of the following:

./udpgso_bench_tx: connect: Connection refused
./udpgso_bench_tx: sendmsg: Connection refused
./udpgso_bench_tx: write: Connection refused

This change addresses this by making udpgro_bench.sh wait for the rx
program to be ready before firing off the tx one - up to a 10s timeout.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230201001612.515730-3-andrei.gherzan@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench.sh | 24 +++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
index dc932fd65363..640bc43452fa 100755
--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -7,6 +7,7 @@ readonly GREEN='\033[0;92m'
 readonly YELLOW='\033[0;33m'
 readonly RED='\033[0;31m'
 readonly NC='\033[0m' # No Color
+readonly TESTPORT=8000
 
 readonly KSFT_PASS=0
 readonly KSFT_FAIL=1
@@ -56,11 +57,26 @@ trap wake_children EXIT
 
 run_one() {
 	local -r args=$@
+	local nr_socks=0
+	local i=0
+	local -r timeout=10
+
+	./udpgso_bench_rx -p "$TESTPORT" &
+	./udpgso_bench_rx -p "$TESTPORT" -t &
+
+	# Wait for the above test program to get ready to receive connections.
+	while [ "$i" -lt "$timeout" ]; do
+		nr_socks="$(ss -lnHi | grep -c "\*:${TESTPORT}")"
+		[ "$nr_socks" -eq 2 ] && break
+		i=$((i + 1))
+		sleep 1
+	done
+	if [ "$nr_socks" -ne 2 ]; then
+		echo "timed out while waiting for udpgso_bench_rx"
+		exit 1
+	fi
 
-	./udpgso_bench_rx &
-	./udpgso_bench_rx -t &
-
-	./udpgso_bench_tx ${args}
+	./udpgso_bench_tx -p "$TESTPORT" ${args}
 }
 
 run_in_netns() {
-- 
2.39.0



