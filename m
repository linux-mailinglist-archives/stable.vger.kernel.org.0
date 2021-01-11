Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16232F130E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbhAKNCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbhAKNCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:02:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1DD322510;
        Mon, 11 Jan 2021 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370110;
        bh=TUk7xG34DBHryzSeOrinhyiqyX9ct/+ZxntIdU1HJEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgfcIQ1BqByKlt4AiecHGCj9JZ98UOP9eV2/Dd097AJpEXAB6v7zTlCscMG4saFRx
         p2jo0h35DD9BtHOTzF5f/ikVWLEgSpjCgUgfxtFash6cvoNbncx/TlCPr0pObjfqIF
         DDlzkGq6MfNGUnVvaPntwFDYGyfbRfSHonpertC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 07/38] ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()
Date:   Mon, 11 Jan 2021 14:00:39 +0100
Message-Id: <20210111130032.818969699@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 21fdca22eb7df2a1e194b8adb812ce370748b733 ]

RT_TOS() only clears one of the ECN bits. Therefore, when
fib_compute_spec_dst() resorts to a fib lookup, it can return
different results depending on the value of the second ECN bit.

For example, ECT(0) and ECT(1) packets could be treated differently.

  $ ip netns add ns0
  $ ip netns add ns1
  $ ip link add name veth01 netns ns0 type veth peer name veth10 netns ns1
  $ ip -netns ns0 link set dev lo up
  $ ip -netns ns1 link set dev lo up
  $ ip -netns ns0 link set dev veth01 up
  $ ip -netns ns1 link set dev veth10 up

  $ ip -netns ns0 address add 192.0.2.10/24 dev veth01
  $ ip -netns ns1 address add 192.0.2.11/24 dev veth10

  $ ip -netns ns1 address add 192.0.2.21/32 dev lo
  $ ip -netns ns1 route add 192.0.2.10/32 tos 4 dev veth10 src 192.0.2.21
  $ ip netns exec ns1 sysctl -wq net.ipv4.icmp_echo_ignore_broadcasts=0

With TOS 4 and ECT(1), ns1 replies using source address 192.0.2.21
(ping uses -Q to set all TOS and ECN bits):

  $ ip netns exec ns0 ping -c 1 -b -Q 5 192.0.2.255
  [...]
  64 bytes from 192.0.2.21: icmp_seq=1 ttl=64 time=0.544 ms

But with TOS 4 and ECT(0), ns1 replies using source address 192.0.2.11
because the "tos 4" route isn't matched:

  $ ip netns exec ns0 ping -c 1 -b -Q 6 192.0.2.255
  [...]
  64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.597 ms

After this patch the ECN bits don't affect the result anymore:

  $ ip netns exec ns0 ping -c 1 -b -Q 6 192.0.2.255
  [...]
  64 bytes from 192.0.2.21: icmp_seq=1 ttl=64 time=0.591 ms

Fixes: 35ebf65e851c ("ipv4: Create and use fib_compute_spec_dst() helper.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_frontend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -299,7 +299,7 @@ __be32 fib_compute_spec_dst(struct sk_bu
 			.flowi4_iif = LOOPBACK_IFINDEX,
 			.flowi4_oif = l3mdev_master_ifindex_rcu(dev),
 			.daddr = ip_hdr(skb)->saddr,
-			.flowi4_tos = RT_TOS(ip_hdr(skb)->tos),
+			.flowi4_tos = ip_hdr(skb)->tos & IPTOS_RT_MASK,
 			.flowi4_scope = scope,
 			.flowi4_mark = vmark ? skb->mark : 0,
 		};


