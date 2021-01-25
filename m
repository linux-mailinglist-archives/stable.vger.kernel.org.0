Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E9A303303
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbhAZEoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:44:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727678AbhAYSmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D6220758;
        Mon, 25 Jan 2021 18:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600132;
        bh=COVkIUrBU1g4MgiSVX59ZRoHTENOzHOaCYoVyIS9IDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIgTgsLTK0MlSLc6GyTECaIY3dK4bJ3Nv84dpjdbY405Li1N4dbI52MYn8CLJmQEv
         o/9Sk1P2SMXJJ9xQiD9Nq8gxCO04DtHCSWUlOjcbNkGNumybJST9syXnC3HmENymQQ
         0iGZQxPLMSOraRvQ6AQGJ5enOM968D64tAr5KXWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 44/58] netfilter: rpfilter: mask ecn bits before fib lookup
Date:   Mon, 25 Jan 2021 19:39:45 +0100
Message-Id: <20210125183158.609415967@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit 2e5a6266fbb11ae93c468dfecab169aca9c27b43 upstream.

RT_TOS() only masks one of the two ECN bits. Therefore rpfilter_mt()
treats Not-ECT or ECT(1) packets in a different way than those with
ECT(0) or CE.

Reproducer:

  Create two netns, connected with a veth:
  $ ip netns add ns0
  $ ip netns add ns1
  $ ip link add name veth01 netns ns0 type veth peer name veth10 netns ns1
  $ ip -netns ns0 link set dev veth01 up
  $ ip -netns ns1 link set dev veth10 up
  $ ip -netns ns0 address add 192.0.2.10/32 dev veth01
  $ ip -netns ns1 address add 192.0.2.11/32 dev veth10

  Add a route to ns1 in ns0:
  $ ip -netns ns0 route add 192.0.2.11/32 dev veth01

  In ns1, only packets with TOS 4 can be routed to ns0:
  $ ip -netns ns1 route add 192.0.2.10/32 tos 4 dev veth10

  Ping from ns0 to ns1 works regardless of the ECN bits, as long as TOS
  is 4:
  $ ip netns exec ns0 ping -Q 4 192.0.2.11   # TOS 4, Not-ECT
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 5 192.0.2.11   # TOS 4, ECT(1)
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 6 192.0.2.11   # TOS 4, ECT(0)
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 7 192.0.2.11   # TOS 4, CE
    ... 0% packet loss ...

  Now use iptable's rpfilter module in ns1:
  $ ip netns exec ns1 iptables-legacy -t raw -A PREROUTING -m rpfilter --invert -j DROP

  Not-ECT and ECT(1) packets still pass:
  $ ip netns exec ns0 ping -Q 4 192.0.2.11   # TOS 4, Not-ECT
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 5 192.0.2.11   # TOS 4, ECT(1)
    ... 0% packet loss ...

  But ECT(0) and ECN packets are dropped:
  $ ip netns exec ns0 ping -Q 6 192.0.2.11   # TOS 4, ECT(0)
    ... 100% packet loss ...
  $ ip netns exec ns0 ping -Q 7 192.0.2.11   # TOS 4, CE
    ... 100% packet loss ...

After this patch, rpfilter doesn't drop ECT(0) and CE packets anymore.

Fixes: 8f97339d3feb ("netfilter: add ipv4 reverse path filter match")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/ipt_rpfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -94,7 +94,7 @@ static bool rpfilter_mt(const struct sk_
 	flow.daddr = iph->saddr;
 	flow.saddr = rpfilter_get_saddr(iph->daddr);
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
-	flow.flowi4_tos = RT_TOS(iph->tos);
+	flow.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
 	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
 


