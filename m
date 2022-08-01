Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACBC586969
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiHAMC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiHAMBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:01:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9E452DE3;
        Mon,  1 Aug 2022 04:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E066DB81170;
        Mon,  1 Aug 2022 11:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52168C433C1;
        Mon,  1 Aug 2022 11:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354819;
        bh=WuhQ8glCoCgZcuHqBbEAvdh4TYzU60trc0vQAcMLLBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bf63rCi2RjREB1JRX4kXW/oX8PoYCNWTgcAZbRmwvwJMZVP94hZspIyqT01yJBNbT
         cg33THGbKk1SsnkBRzH8S2PoD0SaNJONgOA/64lUfI4Nkjvnzt8VjOGhTFSrsughuR
         AxPam/QZ7kiSytRBMwOk50flq37pEVcEdjbu/cd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 31/69] ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr
Date:   Mon,  1 Aug 2022 13:46:55 +0200
Message-Id: <20220801114135.774760661@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 85f0173df35e5462d89947135a6a5599c6c3ef6f upstream.

Change net device's MTU to smaller than IPV6_MIN_MTU or unregister
device while matching route. That may trigger null-ptr-deref bug
for ip6_ptr probability as following.

=========================================================
BUG: KASAN: null-ptr-deref in find_match.part.0+0x70/0x134
Read of size 4 at addr 0000000000000308 by task ping6/263

CPU: 2 PID: 263 Comm: ping6 Not tainted 5.19.0-rc7+ #14
Call trace:
 dump_backtrace+0x1a8/0x230
 show_stack+0x20/0x70
 dump_stack_lvl+0x68/0x84
 print_report+0xc4/0x120
 kasan_report+0x84/0x120
 __asan_load4+0x94/0xd0
 find_match.part.0+0x70/0x134
 __find_rr_leaf+0x408/0x470
 fib6_table_lookup+0x264/0x540
 ip6_pol_route+0xf4/0x260
 ip6_pol_route_output+0x58/0x70
 fib6_rule_lookup+0x1a8/0x330
 ip6_route_output_flags_noref+0xd8/0x1a0
 ip6_route_output_flags+0x58/0x160
 ip6_dst_lookup_tail+0x5b4/0x85c
 ip6_dst_lookup_flow+0x98/0x120
 rawv6_sendmsg+0x49c/0xc70
 inet_sendmsg+0x68/0x94

Reproducer as following:
Firstly, prepare conditions:
$ip netns add ns1
$ip netns add ns2
$ip link add veth1 type veth peer name veth2
$ip link set veth1 netns ns1
$ip link set veth2 netns ns2
$ip netns exec ns1 ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1
$ip netns exec ns2 ip -6 addr add 2001:0db8:0:f101::2/64 dev veth2
$ip netns exec ns1 ifconfig veth1 up
$ip netns exec ns2 ifconfig veth2 up
$ip netns exec ns1 ip -6 route add 2000::/64 dev veth1 metric 1
$ip netns exec ns2 ip -6 route add 2001::/64 dev veth2 metric 1

Secondly, execute the following two commands in two ssh windows
respectively:
$ip netns exec ns1 sh
$while true; do ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1; ip -6 route add 2000::/64 dev veth1 metric 1; ping6 2000::2; done

$ip netns exec ns1 sh
$while true; do ip link set veth1 mtu 1000; ip link set veth1 mtu 1500; sleep 5; done

It is because ip6_ptr has been assigned to NULL in addrconf_ifdown() firstly,
then ip6_ignore_linkdown() accesses ip6_ptr directly without NULL check.

	cpu0			cpu1
fib6_table_lookup
__find_rr_leaf
			addrconf_notify [ NETDEV_CHANGEMTU ]
			addrconf_ifdown
			RCU_INIT_POINTER(dev->ip6_ptr, NULL)
find_match
ip6_ignore_linkdown

So we can add NULL check for ip6_ptr before using in ip6_ignore_linkdown() to
fix the null-ptr-deref bug.

Fixes: dcd1f572954f ("net/ipv6: Remove fib6_idev")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220728013307.656257-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/addrconf.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -403,6 +403,9 @@ static inline bool ip6_ignore_linkdown(c
 {
 	const struct inet6_dev *idev = __in6_dev_get(dev);
 
+	if (unlikely(!idev))
+		return true;
+
 	return !!idev->cnf.ignore_routes_with_linkdown;
 }
 


