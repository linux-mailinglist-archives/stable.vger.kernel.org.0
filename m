Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502D84BE10F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350760AbiBUJpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:45:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351363AbiBUJn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:43:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194DB3EF36;
        Mon, 21 Feb 2022 01:18:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A85F960F1E;
        Mon, 21 Feb 2022 09:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8914DC340E9;
        Mon, 21 Feb 2022 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435086;
        bh=5qhkVxfItGQQNxvUKf+JzHc+TAsYK+cLdIQAogmQhQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQICsgqYSs6dhmIDybBLzIwMQvTj5PCFrJh0fiuMHPnPkirYI22PvGRNpymMVefow
         hbxnjfPsGjB8pUWYF7AwoS8ALuEMXdZ+E4nwTYkisxh/2NrN2jvhHbW2c08hzsyKcM
         TXsEiB+cNwDTV9OH74Pr2Bdn/G9na0A7TH3beK+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 038/227] selftests: netfilter: reduce zone stress test running time
Date:   Mon, 21 Feb 2022 09:47:37 +0100
Message-Id: <20220221084936.127082941@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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



