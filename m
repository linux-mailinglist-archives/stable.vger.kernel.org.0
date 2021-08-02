Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22BB3DD903
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhHBN4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236089AbhHBNy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBA0661108;
        Mon,  2 Aug 2021 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912391;
        bh=jmRWFUcfC8KhEV3vhVBmVTECd1YL6QmemgNy4kThsaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tN5VazOxOKpRLt0SmtPo3QX89Phsz7NVKXUhPS1snBgIP198PBofipSeC5OzNOxc+
         G9Ei0pBpqsep2Nu5wrg+0xKihBuhUuM0e3sOXr/2ugclAzOCjbJcoFMwHMsrJAGUc5
         3ny4VTLmiul071aQRrRxprWUSljFme0MuZaFBvj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Gilad Naaman <gnaaman@drivenets.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/67] net: Set true network header for ECN decapsulation
Date:   Mon,  2 Aug 2021 15:45:02 +0200
Message-Id: <20210802134340.353155847@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Naaman <gnaaman@drivenets.com>

[ Upstream commit 227adfb2b1dfbc53dfc53b9dd7a93a6298ff7c56 ]

In cases where the header straight after the tunnel header was
another ethernet header (TEB), instead of the network header,
the ECN decapsulation code would treat the ethernet header as if
it was an IP header, resulting in mishandling and possible
wrong drops or corruption of the IP header.

In this case, ECT(1) is sent, so IP_ECN_decapsulate tries to copy it to the
inner IPv4 header, and correct its checksum.

The offset of the ECT bits in an IPv4 header corresponds to the
lower 2 bits of the second octet of the destination MAC address
in the ethernet header.
The IPv4 checksum corresponds to end of the source address.

In order to reproduce:

    $ ip netns add A
    $ ip netns add B
    $ ip -n A link add _v0 type veth peer name _v1 netns B
    $ ip -n A link set _v0 up
    $ ip -n A addr add dev _v0 10.254.3.1/24
    $ ip -n A route add default dev _v0 scope global
    $ ip -n B link set _v1 up
    $ ip -n B addr add dev _v1 10.254.1.6/24
    $ ip -n B route add default dev _v1 scope global
    $ ip -n B link add gre1 type gretap local 10.254.1.6 remote 10.254.3.1 key 0x49000000
    $ ip -n B link set gre1 up

    # Now send an IPv4/GRE/Eth/IPv4 frame where the outer header has ECT(1),
    # and the inner header has no ECT bits set:

    $ cat send_pkt.py
        #!/usr/bin/env python3
        from scapy.all import *

        pkt = IP(b'E\x01\x00\xa7\x00\x00\x00\x00@/`%\n\xfe\x03\x01\n\xfe\x01\x06 \x00eXI\x00'
                 b'\x00\x00\x18\xbe\x92\xa0\xee&\x18\xb0\x92\xa0l&\x08\x00E\x00\x00}\x8b\x85'
                 b'@\x00\x01\x01\xe4\xf2\x82\x82\x82\x01\x82\x82\x82\x02\x08\x00d\x11\xa6\xeb'
                 b'3\x1e\x1e\\xf3\\xf7`\x00\x00\x00\x00ZN\x00\x00\x00\x00\x00\x00\x10\x11\x12'
                 b'\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !"#$%&\'()*+,-./01234'
                 b'56789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ')

        send(pkt)
    $ sudo ip netns exec B tcpdump -neqlllvi gre1 icmp & ; sleep 1
    $ sudo ip netns exec A python3 send_pkt.py

In the original packet, the source/destinatio MAC addresses are
dst=18:be:92:a0:ee:26 src=18:b0:92:a0:6c:26

In the received packet, they are
dst=18:bd:92:a0:ee:26 src=18:b0:92:a0:6c:27

Thanks to Lahav Schlesinger <lschlesinger@drivenets.com> and Isaac Garzon <isaac@speed.io>
for helping me pinpoint the origin.

Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")
Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 0dca00745ac3..be75b409445c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -390,7 +390,7 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		tunnel->i_seqno = ntohl(tpi->seq) + 1;
 	}
 
-	skb_reset_network_header(skb);
+	skb_set_network_header(skb, (tunnel->dev->type == ARPHRD_ETHER) ? ETH_HLEN : 0);
 
 	err = IP_ECN_decapsulate(iph, skb);
 	if (unlikely(err)) {
-- 
2.30.2



