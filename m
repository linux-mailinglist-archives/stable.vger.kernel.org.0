Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A55304A7F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbhAZFFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731317AbhAYSyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B576A20758;
        Mon, 25 Jan 2021 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600838;
        bh=sVbDhgfyIsvJGMXVq/+9yP+CleiLoZ+m83dKE+LA8FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CI0mDaTd1zialWMgi5FqNlJ3Bidshc9aUouh6eau0T9ewdFOgm+aBTwAw8guxPOoW
         9z7z9G3KqTUFU4XkOJibCPW297ixboz3Gwd4a12TV/tbFjOa6q+rchG9s0Q1g9HjOe
         VclmFHz4JctSAibED/F/nNBFojDn7OhqCNVP5eKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 171/199] udp: mask TOS bits in udp_v4_early_demux()
Date:   Mon, 25 Jan 2021 19:39:53 +0100
Message-Id: <20210125183223.415612093@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit 8d2b51b008c25240914984208b2ced57d1dd25a5 upstream.

udp_v4_early_demux() is the only function that calls
ip_mc_validate_source() with a TOS that hasn't been masked with
IPTOS_RT_MASK.

This results in different behaviours for incoming multicast UDPv4
packets, depending on if ip_mc_validate_source() is called from the
early-demux path (udp_v4_early_demux) or from the regular input path
(ip_route_input_noref).

ECN would normally not be used with UDP multicast packets, so the
practical consequences should be limited on that side. However,
IPTOS_RT_MASK is used to also masks the TOS' high order bits, to align
with the non-early-demux path behaviour.

Reproducer:

  Setup two netns, connected with veth:
  $ ip netns add ns0
  $ ip netns add ns1
  $ ip -netns ns0 link set dev lo up
  $ ip -netns ns1 link set dev lo up
  $ ip link add name veth01 netns ns0 type veth peer name veth10 netns ns1
  $ ip -netns ns0 link set dev veth01 up
  $ ip -netns ns1 link set dev veth10 up
  $ ip -netns ns0 address add 192.0.2.10 peer 192.0.2.11/32 dev veth01
  $ ip -netns ns1 address add 192.0.2.11 peer 192.0.2.10/32 dev veth10

  In ns0, add route to multicast address 224.0.2.0/24 using source
  address 198.51.100.10:
  $ ip -netns ns0 address add 198.51.100.10/32 dev lo
  $ ip -netns ns0 route add 224.0.2.0/24 dev veth01 src 198.51.100.10

  In ns1, define route to 198.51.100.10, only for packets with TOS 4:
  $ ip -netns ns1 route add 198.51.100.10/32 tos 4 dev veth10

  Also activate rp_filter in ns1, so that incoming packets not matching
  the above route get dropped:
  $ ip netns exec ns1 sysctl -wq net.ipv4.conf.veth10.rp_filter=1

  Now try to receive packets on 224.0.2.11:
  $ ip netns exec ns1 socat UDP-RECVFROM:1111,ip-add-membership=224.0.2.11:veth10,ignoreeof -

  In ns0, send packet to 224.0.2.11 with TOS 4 and ECT(0) (that is,
  tos 6 for socat):
  $ echo test0 | ip netns exec ns0 socat - UDP-DATAGRAM:224.0.2.11:1111,bind=:1111,tos=6

  The "test0" message is properly received by socat in ns1, because
  early-demux has no cached dst to use, so source address validation
  is done by ip_route_input_mc(), which receives a TOS that has the
  ECN bits masked.

  Now send another packet to 224.0.2.11, still with TOS 4 and ECT(0):
  $ echo test1 | ip netns exec ns0 socat - UDP-DATAGRAM:224.0.2.11:1111,bind=:1111,tos=6

  The "test1" message isn't received by socat in ns1, because, now,
  early-demux has a cached dst to use and calls ip_mc_validate_source()
  immediately, without masking the ECN bits.

Fixes: bc044e8db796 ("udp: perform source validation for mcast early demux")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/udp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2553,7 +2553,8 @@ int udp_v4_early_demux(struct sk_buff *s
 		 */
 		if (!inet_sk(sk)->inet_daddr && in_dev)
 			return ip_mc_validate_source(skb, iph->daddr,
-						     iph->saddr, iph->tos,
+						     iph->saddr,
+						     iph->tos & IPTOS_RT_MASK,
 						     skb->dev, in_dev, &itag);
 	}
 	return 0;


