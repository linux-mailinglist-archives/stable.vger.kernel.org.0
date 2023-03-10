Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390936B4B3D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbjCJPg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjCJPge (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:36:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC48010E252
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C539CCE2944
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66BAC433EF;
        Fri, 10 Mar 2023 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461158;
        bh=//pQzCxhE4KZJii3zPgvNLZUMp7EQxAa0kZfU6dnOAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPhK1fv7sy6ipa4XSYjgdFLiWFA7XJtlodJonuFDCx/j5/EBXC+R51gMCl+VmpW3Z
         rj6ySlBjOcDp9oLHiOec0X+AmWaxg3z+W/b4gs/P/B86xvOPpZG7IDvQL66OiTUwHw
         2JnakwdbvvyzZj956CY3jEnWTvgRck7KDwI+V5TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lu Wei <luwei32@huawei.com>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/136] ipv6: Add lwtunnel encap size of all siblings in nexthop calculation
Date:   Fri, 10 Mar 2023 14:42:46 +0100
Message-Id: <20230310133708.407297294@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit 4cc59f386991ec9374cb4bc83dbe1c0b5a95033f ]

In function rt6_nlmsg_size(), the length of nexthop is calculated
by multipling the nexthop length of fib6_info and the number of
siblings. However if the fib6_info has no lwtunnel but the siblings
have lwtunnels, the nexthop length is less than it should be, and
it will trigger a warning in inet6_rt_notify() as follows:

WARNING: CPU: 0 PID: 6082 at net/ipv6/route.c:6180 inet6_rt_notify+0x120/0x130
......
Call Trace:
 <TASK>
 fib6_add_rt2node+0x685/0xa30
 fib6_add+0x96/0x1b0
 ip6_route_add+0x50/0xd0
 inet6_rtm_newroute+0x97/0xa0
 rtnetlink_rcv_msg+0x156/0x3d0
 netlink_rcv_skb+0x5a/0x110
 netlink_unicast+0x246/0x350
 netlink_sendmsg+0x250/0x4c0
 sock_sendmsg+0x66/0x70
 ___sys_sendmsg+0x7c/0xd0
 __sys_sendmsg+0x5d/0xb0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

This bug can be reproduced by script:

ip -6 addr add 2002::2/64 dev ens2
ip -6 route add 100::/64 via 2002::1 dev ens2 metric 100

for i in 10 20 30 40 50 60 70;
do
	ip link add link ens2 name ipv_$i type ipvlan
	ip -6 addr add 2002::$i/64 dev ipv_$i
	ifconfig ipv_$i up
done

for i in 10 20 30 40 50 60;
do
	ip -6 route append 100::/64 encap ip6 dst 2002::$i via 2002::1
dev ipv_$i metric 100
done

ip -6 route append 100::/64 via 2002::1 dev ipv_70 metric 100

This patch fixes it by adding nexthop_len of every siblings using
rt6_nh_nlmsg_size().

Fixes: beb1afac518d ("net: ipv6: Add support to dump multipath routes via RTA_MULTIPATH attribute")
Signed-off-by: Lu Wei <luwei32@huawei.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230222083629.335683-2-luwei32@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0655fd8c67e93..7b26882b9e70e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5555,16 +5555,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
 		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
 					 &nexthop_len);
 	} else {
+		struct fib6_info *sibling, *next_sibling;
 		struct fib6_nh *nh = f6i->fib6_nh;
 
 		nexthop_len = 0;
 		if (f6i->fib6_nsiblings) {
-			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
-				    + NLA_ALIGN(sizeof(struct rtnexthop))
-				    + nla_total_size(16) /* RTA_GATEWAY */
-				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
+			rt6_nh_nlmsg_size(nh, &nexthop_len);
 
-			nexthop_len *= f6i->fib6_nsiblings;
+			list_for_each_entry_safe(sibling, next_sibling,
+						 &f6i->fib6_siblings, fib6_siblings) {
+				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
+			}
 		}
 		nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
 	}
-- 
2.39.2



