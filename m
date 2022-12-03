Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208DB641642
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLCLAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLCLAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:00:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5631C927
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1A6B60B95
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEDFC433C1;
        Sat,  3 Dec 2022 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670065204;
        bh=Kthzv4FL1UQS5O4IKdvSqRjNFSZag3bmjC1+78m3ftI=;
        h=Subject:To:Cc:From:Date:From;
        b=109NAJOLjBqdQSG8+4TTSFW2Y2P4dTUIl6UXlWohR2KAN/xPqdIob4apOyxkrs0Xt
         N7Md2tQyHkcTu+7ZWHzDHWNyCGKbQpd1eLhRlIeX/kJjf9skdgFo6T/55GLA/Ylh8b
         TaLlb1Fb/8rIG9PSKXCvi0u0CZrgWhG8K3PCTOng=
Subject: FAILED: patch "[PATCH] ipv4: Fix route deletion when nexthop info is not specified" failed to apply to 6.0-stable tree
To:     idosch@nvidia.com, dsahern@kernel.org, jonas.gorski@gmail.com,
        kuba@kernel.org, razor@blackwall.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:00:01 +0100
Message-ID: <1670065201171234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d5082d386eee ("ipv4: Fix route deletion when nexthop info is not specified")
61b91eb33a69 ("ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d5082d386eee7e8ec46fa8581932c81a4961dcef Mon Sep 17 00:00:00 2001
From: Ido Schimmel <idosch@nvidia.com>
Date: Thu, 24 Nov 2022 23:09:32 +0200
Subject: [PATCH] ipv4: Fix route deletion when nexthop info is not specified

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

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f721c308248b..19a662003eef 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -888,9 +888,11 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
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
index ee5e98204d3d..a47b26ab48f2 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1228,6 +1228,17 @@ ipv4_fcnal()
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

