Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE28C6433FC
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiLETlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiLETk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D694B70
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEBBCB811E3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378ECC433C1;
        Mon,  5 Dec 2022 19:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269105;
        bh=3gapXH4BAxW1FQUr9sWxQsiDN2ZuD4x1NMH+cHmxRso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MITjHSpT2mVrpxzEXKNGlXOOu9kKEdD/UcGvHKC0m6h710QG42MXznArZ2wFdBQmM
         CrCoruQeQetSc20tJ1bI9SQISe23YRtgqvq2YXZmxg+rdnfze3yu2YPFb2EfKVef1j
         9we/fl1FPCQkOUetfKshPe0Py1YeoqgWGENU09mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonas Gorski <jonas.gorski@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/120] ipv4: Fix route deletion when nexthop info is not specified
Date:   Mon,  5 Dec 2022 20:10:50 +0100
Message-Id: <20221205190809.840158312@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit d5082d386eee7e8ec46fa8581932c81a4961dcef ]

When the kernel receives a route deletion request from user space it
tries to delete a route that matches the route attributes specified in
the request.

If only prefix information is specified in the request, the kernel
should delete the first matching FIB alias regardless of its associated
FIB info. However, an error is currently returned when the FIB info is
backed by a nexthop object:

 # ip nexthop add id 1 via 192.0.2.2 dev dummy10
 # ip route add 198.51.100.0/24 nhid 1
 # ip route del 198.51.100.0/24
 RTNETLINK answers: No such process

Fix by matching on such a FIB info when legacy nexthop attributes are
not specified in the request. An earlier check already covers the case
where a nexthop ID is specified in the request.

Add tests that cover these flows. Before the fix:

 # ./fib_nexthops.sh -t ipv4_fcnal
 ...
 TEST: Delete route when not specifying nexthop attributes           [FAIL]

 Tests passed:  11
 Tests failed:   1

After the fix:

 # ./fib_nexthops.sh -t ipv4_fcnal
 ...
 TEST: Delete route when not specifying nexthop attributes           [ OK ]

 Tests passed:  12
 Tests failed:   0

No regressions in other tests:

 # ./fib_nexthops.sh
 ...
 Tests passed: 228
 Tests failed:   0

 # ./fib_tests.sh
 ...
 Tests passed: 186
 Tests failed:   0

Cc: stable@vger.kernel.org
Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
Fixes: 61b91eb33a69 ("ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20221124210932.2470010-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c                    |  8 +++++---
 tools/testing/selftests/net/fib_nexthops.sh | 11 +++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index c35afa20f6d0..af64ae689b13 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -886,9 +886,11 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
-	/* cannot match on nexthop object attributes */
-	if (fi->nh)
-		return 1;
+	if (fi->nh) {
+		if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
+			return 1;
+		return 0;
+	}
 
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 4280c9b6ee2d..0c066ba579d4 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1164,6 +1164,17 @@ ipv4_fcnal()
 	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
 	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
 	log_test $? 2 "Delete multipath route with only nh id based entry"
+
+	run_cmd "$IP nexthop add id 22 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.102.0/24 nhid 22"
+	run_cmd "$IP ro del 172.16.102.0/24 dev veth1"
+	log_test $? 2 "Delete route when specifying only nexthop device"
+
+	run_cmd "$IP ro del 172.16.102.0/24 via 172.16.1.6"
+	log_test $? 2 "Delete route when specifying only gateway"
+
+	run_cmd "$IP ro del 172.16.102.0/24"
+	log_test $? 0 "Delete route when not specifying nexthop attributes"
 }
 
 ipv4_grp_fcnal()
-- 
2.35.1



