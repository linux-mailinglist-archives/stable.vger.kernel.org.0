Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D5F63DF0F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiK3Sn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiK3SnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDA26168
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E394561D76
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94F5C433C1;
        Wed, 30 Nov 2022 18:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833794;
        bh=OOD+tYPIH/bBvPYBFQJgUNo52ozICWFuGCxahjNu2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cx5F5o19dR3/kptou8w2vwvqHwFbkHbuzxEuR3ownLyOlHE5xgAYAqMVY1xzPX1u1
         OtV1wg5JzBIiw7A7u9GyEu2Sg1wPIhgfKMbD8mUj6sfe8KnrMI0iPsFFrWfp1PQa34
         Tpc89cRASH5OClboi3rJqsX4e6R8zTeKZWmKvTjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrien Thierry <athierry@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 017/289] selftests/net: give more time to udpgro bg processes to complete startup
Date:   Wed, 30 Nov 2022 19:20:02 +0100
Message-Id: <20221130180544.523825583@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Adrien Thierry <athierry@redhat.com>

[ Upstream commit cdb525ca92b196f8916102b62431aa0d9a644ff2 ]

In some conditions, background processes in udpgro don't have enough
time to set up the sockets. When foreground processes start, this
results in the test failing with "./udpgso_bench_tx: sendmsg: Connection
refused". For instance, this happens from time to time on a Qualcomm
SA8540P SoC running CentOS Stream 9.

To fix this, increase the time given to background processes to
complete the startup before foreground processes start.

Signed-off-by: Adrien Thierry <athierry@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh         | 4 ++--
 tools/testing/selftests/net/udpgro_bench.sh   | 2 +-
 tools/testing/selftests/net/udpgro_frglist.sh | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index ebbd0b282432..6a443ca3cd3a 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -50,7 +50,7 @@ run_one() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 	ret=$?
 	wait $(jobs -p)
@@ -117,7 +117,7 @@ run_one_2sock() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args} -p 12345
 	sleep 0.1
 	# first UDP GSO socket should be closed at this point
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index fad2d1a71cac..8a1109a545db 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -39,7 +39,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 }
 
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index 832c738cc3c2..7fe85ba51075 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -44,7 +44,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 }
 
-- 
2.35.1



