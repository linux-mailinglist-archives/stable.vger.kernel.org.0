Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD5164A058
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiLLNYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiLLNXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:23:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6411035
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B17C461042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD78C433F2;
        Mon, 12 Dec 2022 13:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851432;
        bh=suGJSlugSIlA5/xFGwXX230LcGqzmshN4VaqN6SRcQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nyq3ehcEMVNiMVwKb0zi+31AJmCbT6E6pZEJHkF7nil0d+efB7uqb84xLwxdDHyv0
         l62AntpUTpp134hxzFwuILmx+twvaGGbJY/E550Au5YLuxcs+8wbnfPomtXDYOVdR1
         +PIMkafS++SaMsBQTxbdLotHqMZ0HeMhMs0Y7sjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Donald Sharp <sharpd@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 61/67] ipv4: Fix incorrect route flushing when table ID 0 is used
Date:   Mon, 12 Dec 2022 14:17:36 +0100
Message-Id: <20221212130920.527377379@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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
 net/ipv4/fib_frontend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index d38c8ca93ba0..be31eeacb0be 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -840,6 +840,9 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	return 0;
 errout:
 	return err;
-- 
2.35.1



