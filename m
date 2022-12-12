Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CD764A083
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiLLN0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiLLNZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:25:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9700D13D2E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53138B80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6195FC433D2;
        Mon, 12 Dec 2022 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851546;
        bh=1q6LV/XCGJkICRHPhOXZv9+sukcew2TPlUBl0//TvHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtYKn2c8REVrvIboiyyaYwFu4mn/z3qeEkC9jFKkY/nXqL/8Tw6yoK07rn/Jq4r5S
         JnqPS35YgbOEKjCb6LPDT3eOCu6k0Ef8HcNRRJQ3pCicUgBZiWL7QCL9BaTCqkVBMc
         mvYJkh+2qo2YCJ/xrjBlBaQ8mlFWb3Ud9cQD3uXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/123] selftests/net: Find nettest in current directory
Date:   Mon, 12 Dec 2022 14:16:26 +0100
Message-Id: <20221212130927.737612718@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Daniel Díaz <daniel.diaz@linaro.org>

[ Upstream commit bd5e1e42826f18147afb0ba07e6a815f52cf8bcb ]

The `nettest` binary, built from `selftests/net/nettest.c`,
was expected to be found in the path during test execution of
`fcnal-test.sh` and `pmtu.sh`, leading to tests getting
skipped when the binary is not installed in the system, as can
be seen in these logs found in the wild [1]:

  # TEST: vti4: PMTU exceptions                                         [SKIP]
  [  350.600250] IPv6: ADDRCONF(NETDEV_CHANGE): veth_b: link becomes ready
  [  350.607421] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
  # 'nettest' command not found; skipping tests
  #   xfrm6udp not supported
  # TEST: vti6: PMTU exceptions (ESP-in-UDP)                            [SKIP]
  [  351.605102] IPv6: ADDRCONF(NETDEV_CHANGE): veth_b: link becomes ready
  [  351.612243] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
  # 'nettest' command not found; skipping tests
  #   xfrm4udp not supported

The `unicast_extensions.sh` tests also rely on `nettest`, but
it runs fine there because it looks for the binary in the
current working directory [2]:

The same mechanism that works for the Unicast extensions tests
is here copied over to the PMTU and functional tests.

[1] https://lkft.validation.linaro.org/scheduler/job/5839508#L6221
[2] https://lkft.validation.linaro.org/scheduler/job/5839508#L7958

Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 11 +++++++----
 tools/testing/selftests/net/pmtu.sh       | 10 ++++++----
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 91f54112167f..364c82b797c1 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4072,10 +4072,13 @@ elif [ "$TESTS" = "ipv6" ]; then
 	TESTS="$TESTS_IPV6"
 fi
 
-which nettest >/dev/null
-if [ $? -ne 0 ]; then
-	echo "'nettest' command not found; skipping tests"
-	exit $ksft_skip
+# nettest can be run from PATH or from same directory as this selftest
+if ! which nettest >/dev/null; then
+	PATH=$PWD:$PATH
+	if ! which nettest >/dev/null; then
+		echo "'nettest' command not found; skipping tests"
+		exit $ksft_skip
+	fi
 fi
 
 declare -i nfail=0
diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 694732e4b344..da6ab300207c 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -671,10 +671,12 @@ setup_xfrm() {
 }
 
 setup_nettest_xfrm() {
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		echo "'nettest' command not found; skipping tests"
-	        return 1
+	if ! which nettest >/dev/null; then
+		PATH=$PWD:$PATH
+		if ! which nettest >/dev/null; then
+			echo "'nettest' command not found; skipping tests"
+			return 1
+		fi
 	fi
 
 	[ ${1} -eq 6 ] && proto="-6" || proto=""
-- 
2.35.1



