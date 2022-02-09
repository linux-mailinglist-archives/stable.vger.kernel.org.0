Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F014AFA28
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiBISea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238740AbiBISe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:34:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C4CC05CB8A;
        Wed,  9 Feb 2022 10:34:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62E0B8203D;
        Wed,  9 Feb 2022 18:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BA7C340E7;
        Wed,  9 Feb 2022 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431669;
        bh=5qhkVxfItGQQNxvUKf+JzHc+TAsYK+cLdIQAogmQhQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZ7Uw3bjR4YCgbEpzqLlXVphB3LlgQwGKn4mBJhROh4uBBI0FmDvZ6ep4tVOI8D/o
         yksj+nEPUopZtnsr9Jn1xSLdUqfBV4wwGDU+nSqJQjHN+JrBBnw1Ys/myxSBL6BS2S
         5Q1hQ/z/sQ406tokEjZTrix0l6d04AlSqA7zS96z0A80lO1uyJwaK0uQGJ77i9c5wp
         Z6VJrdZX26dya1EvDXRz+Iucmd2lI+PQ47lDhsNI86mNm7ZBpQ400B/5AS3ULOHI1Q
         n9ousjkM1QKxnUAa6KCpx6hiAIVWZti+IoYC0UIdL9pyvp4NE58tQBmoXn7/4v/sd4
         WgUGd9e0wjV7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 08/42] selftests: netfilter: reduce zone stress test running time
Date:   Wed,  9 Feb 2022 13:32:40 -0500
Message-Id: <20220209183335.46545-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c858620d2ae3489409af593f005a48a8a324da3d ]

This selftests needs almost 3 minutes to complete, reduce the
insertes zones to 1000.  Test now completes in about 20 seconds.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/nft_zones_many.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_zones_many.sh b/tools/testing/selftests/netfilter/nft_zones_many.sh
index 04633119b29a0..5a8db0b48928f 100755
--- a/tools/testing/selftests/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/netfilter/nft_zones_many.sh
@@ -9,7 +9,7 @@ ns="ns-$sfx"
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-zones=20000
+zones=2000
 have_ct_tool=0
 ret=0
 
@@ -75,10 +75,10 @@ EOF
 
 	while [ $i -lt $max_zones ]; do
 		local start=$(date +%s%3N)
-		i=$((i + 10000))
+		i=$((i + 1000))
 		j=$((j + 1))
 		# nft rule in output places each packet in a different zone.
-		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
+		dd if=/dev/zero of=/dev/stdout bs=8k count=1000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
 		if [ $? -ne 0 ] ;then
 			ret=1
 			break
@@ -86,7 +86,7 @@ EOF
 
 		stop=$(date +%s%3N)
 		local duration=$((stop-start))
-		echo "PASS: added 10000 entries in $duration ms (now $i total, loop $j)"
+		echo "PASS: added 1000 entries in $duration ms (now $i total, loop $j)"
 	done
 
 	if [ $have_ct_tool -eq 1 ]; then
@@ -128,11 +128,11 @@ test_conntrack_tool() {
 			break
 		fi
 
-		if [ $((i%10000)) -eq 0 ];then
+		if [ $((i%1000)) -eq 0 ];then
 			stop=$(date +%s%3N)
 
 			local duration=$((stop-start))
-			echo "PASS: added 10000 entries in $duration ms (now $i total)"
+			echo "PASS: added 1000 entries in $duration ms (now $i total)"
 			start=$stop
 		fi
 	done
-- 
2.34.1

