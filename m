Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE11579B8E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239956AbiGSM3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240119AbiGSM2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:28:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A4D66AE1;
        Tue, 19 Jul 2022 05:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6497B81B37;
        Tue, 19 Jul 2022 12:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A27C36AED;
        Tue, 19 Jul 2022 12:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232639;
        bh=LJ0bZOhkY762LRAckvDUrHlvWHgbHjuwRbE7KKyNk/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnanUM2ZKH2JkIilai8qTR4WY5Pl2U8RbC2eOz024ns0QDVFEcJQxjswebJ9ywgWb
         mgeLnnRHZOwzvyDdSiqq3ZwyPFL8GThERwCz4zOoWPYP2qZZPNNZQQVMpaDSC0Ggld
         PKzn1C0KLZY9O/9xRnpXO4T+K0MOXBra9ewK92bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Edwin Brossette <edwin.brossette@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 014/167] ip: fix dflt addr selection for connected nexthop
Date:   Tue, 19 Jul 2022 13:52:26 +0200
Message-Id: <20220719114658.089156765@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 747c14307214b55dbd8250e1ab44cad8305756f1 upstream.

When a nexthop is added, without a gw address, the default scope was set
to 'host'. Thus, when a source address is selected, 127.0.0.1 may be chosen
but rejected when the route is used.

When using a route without a nexthop id, the scope can be configured in the
route, thus the problem doesn't exist.

To explain more deeply: when a user creates a nexthop, it cannot specify
the scope. To create it, the function nh_create_ipv4() calls fib_check_nh()
with scope set to 0. fib_check_nh() calls fib_check_nh_nongw() wich was
setting scope to 'host'. Then, nh_create_ipv4() calls
fib_info_update_nhc_saddr() with scope set to 'host'. The src addr is
chosen before the route is inserted.

When a 'standard' route (ie without a reference to a nexthop) is added,
fib_create_info() calls fib_info_update_nhc_saddr() with the scope set by
the user. iproute2 set the scope to 'link' by default.

Here is a way to reproduce the problem:
ip netns add foo
ip -n foo link set lo up
ip netns add bar
ip -n bar link set lo up
sleep 1

ip -n foo link add name eth0 type dummy
ip -n foo link set eth0 up
ip -n foo address add 192.168.0.1/24 dev eth0

ip -n foo link add name veth0 type veth peer name veth1 netns bar
ip -n foo link set veth0 up
ip -n bar link set veth1 up

ip -n bar address add 192.168.1.1/32 dev veth1
ip -n bar route add default dev veth1

ip -n foo nexthop add id 1 dev veth0
ip -n foo route add 192.168.1.1 nhid 1

Try to get/use the route:
> $ ip -n foo route get 192.168.1.1
> RTNETLINK answers: Invalid argument
> $ ip netns exec foo ping -c1 192.168.1.1
> ping: connect: Invalid argument

Try without nexthop group (iproute2 sets scope to 'link' by dflt):
ip -n foo route del 192.168.1.1
ip -n foo route add 192.168.1.1 dev veth0

Try to get/use the route:
> $ ip -n foo route get 192.168.1.1
> 192.168.1.1 dev veth0 src 192.168.0.1 uid 0
>     cache
> $ ip netns exec foo ping -c1 192.168.1.1
> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.039 ms
>
> --- 192.168.1.1 ping statistics ---
> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> rtt min/avg/max/mdev = 0.039/0.039/0.039/0.000 ms

CC: stable@vger.kernel.org
Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
Reported-by: Edwin Brossette <edwin.brossette@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20220713114853.29406-1-nicolas.dichtel@6wind.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1228,7 +1228,7 @@ static int fib_check_nh_nongw(struct net
 
 	nh->fib_nh_dev = in_dev->dev;
 	dev_hold(nh->fib_nh_dev);
-	nh->fib_nh_scope = RT_SCOPE_HOST;
+	nh->fib_nh_scope = RT_SCOPE_LINK;
 	if (!netif_carrier_ok(nh->fib_nh_dev))
 		nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 	err = 0;


