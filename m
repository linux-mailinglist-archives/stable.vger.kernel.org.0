Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B9364A1DA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiLLNq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiLLNqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5265813F9B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:45:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00001B80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAB9C433EF;
        Mon, 12 Dec 2022 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852742;
        bh=JDnNYfW8/r/s/ReGuphi1cHUhyil0OBobZw2gU4FTCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjvF6wk9pgqj1/u3R5DjGP/Xa8tMZKKkFajlA2x3WNiBjZ6wm/P9LDJMtaHApP4mV
         mLF8UxmYYJqNd48ith+zlEKUjPnsmNnOcBI9uJ5Co0wYl8kBqZHW61PNPq4lm0yEa5
         hlcgxzZbRFm9TVvZS65OBwfZgVU2u1Z5KmKUo52Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Donald Sharp <sharpd@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 143/157] ipv4: Fix incorrect route flushing when table ID 0 is used
Date:   Mon, 12 Dec 2022 14:18:11 +0100
Message-Id: <20221212130940.886342383@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit c0d999348e01df03e0a7f550351f3907fabbf611 ]

Cited commit added the table ID to the FIB info structure, but did not
properly initialize it when table ID 0 is used. This can lead to a route
in the default VRF with a preferred source address not being flushed
when the address is deleted.

Consider the following example:

 # ip address add dev dummy1 192.0.2.1/28
 # ip address add dev dummy1 192.0.2.17/28
 # ip route add 198.51.100.0/24 via 192.0.2.2 src 192.0.2.17 metric 100
 # ip route add table 0 198.51.100.0/24 via 192.0.2.2 src 192.0.2.17 metric 200
 # ip route show 198.51.100.0/24
 198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 100
 198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 200

Both routes are installed in the default VRF, but they are using two
different FIB info structures. One with a metric of 100 and table ID of
254 (main) and one with a metric of 200 and table ID of 0. Therefore,
when the preferred source address is deleted from the default VRF,
the second route is not flushed:

 # ip address del dev dummy1 192.0.2.17/28
 # ip route show 198.51.100.0/24
 198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 200

Fix by storing a table ID of 254 instead of 0 in the route configuration
structure.

Add a test case that fails before the fix:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Table ID 0
     TEST: Route removed in default VRF when source address deleted      [FAIL]

 Tests passed:   8
 Tests failed:   1

And passes after:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Table ID 0
     TEST: Route removed in default VRF when source address deleted      [ OK ]

 Tests passed:   9
 Tests failed:   0

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Reported-by: Donald Sharp <sharpd@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c                  |  3 +++
 tools/testing/selftests/net/fib_tests.sh | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 943edf4ad4db..3528e8befa58 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -841,6 +841,9 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	return 0;
 errout:
 	return err;
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 11c89148b19f..5637b5dadabd 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1712,11 +1712,13 @@ ipv4_del_addr_test()
 	$IP addr add dev dummy1 172.16.104.1/24
 	$IP addr add dev dummy1 172.16.104.11/24
 	$IP addr add dev dummy1 172.16.104.12/24
+	$IP addr add dev dummy1 172.16.104.13/24
 	$IP addr add dev dummy2 172.16.104.1/24
 	$IP addr add dev dummy2 172.16.104.11/24
 	$IP addr add dev dummy2 172.16.104.12/24
 	$IP route add 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
 	$IP route add 172.16.106.0/24 dev lo src 172.16.104.12
+	$IP route add table 0 172.16.107.0/24 via 172.16.104.2 src 172.16.104.13
 	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
 	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
 	set +e
@@ -1762,6 +1764,14 @@ ipv4_del_addr_test()
 	$IP ro ls vrf red | grep -q 172.16.106.0/24
 	log_test $? 0 "Route in VRF is not removed by address delete"
 
+	# removing address from device in default vrf should remove route from
+	# the default vrf even when route was inserted with a table ID of 0.
+	echo "    Table ID 0"
+
+	$IP addr del dev dummy1 172.16.104.13/24
+	$IP ro ls | grep -q 172.16.107.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
-- 
2.35.1



