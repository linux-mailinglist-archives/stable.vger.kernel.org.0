Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D69240945
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgHJPax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgHJPan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C63A20774;
        Mon, 10 Aug 2020 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073442;
        bh=wsSGHvZX2jKD9riWH4tXyy4sw108LeNGRYC5pfnkURE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g27Lh8/x9qGrodbOkcPXXN6Be+GE45ryKv+ZeyNgCbmQpY8dHS9nFJDAOLl6H/WGO
         2r5DZcIFai/WjMzlgC4PyQWPqm6juGPHAm0FG7V/h7gl8UUoytO5mO37J8uObRrSth
         XOTnM5LqckHSPV7eN3gZziss+ChndmKrK9S21B0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 41/48] Revert "vxlan: fix tos value before xmit"
Date:   Mon, 10 Aug 2020 17:22:03 +0200
Message-Id: <20200810151806.237304741@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a0dced17ad9dc08b1b25e0065b54c97a318e6e8b ]

This reverts commit 71130f29979c7c7956b040673e6b9d5643003176.

In commit 71130f29979c ("vxlan: fix tos value before xmit") we want to
make sure the tos value are filtered by RT_TOS() based on RFC1349.

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |   PRECEDENCE    |          TOS          | MBZ |
    +-----+-----+-----+-----+-----+-----+-----+-----+

But RFC1349 has been obsoleted by RFC2474. The new DSCP field defined like

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |          DS FIELD, DSCP           | ECN FIELD |
    +-----+-----+-----+-----+-----+-----+-----+-----+

So with

IPTOS_TOS_MASK          0x1E
RT_TOS(tos)		((tos)&IPTOS_TOS_MASK)

the first 3 bits DSCP info will get lost.

To take all the DSCP info in xmit, we should revert the patch and just push
all tos bits to ip_tunnel_ecn_encap(), which will handling ECN field later.

Fixes: 71130f29979c ("vxlan: fix tos value before xmit")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2223,7 +2223,7 @@ static void vxlan_xmit_one(struct sk_buf
 		ndst = &rt->dst;
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2260,7 +2260,7 @@ static void vxlan_xmit_one(struct sk_buf
 
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),


