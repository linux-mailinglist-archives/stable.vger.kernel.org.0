Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2641CAB28
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgEHMkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbgEHMki (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5CF22495F;
        Fri,  8 May 2020 12:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941638;
        bh=3uEuShsqQANn0H5av7DAVs0Ph+aR+CYOdRo0mjWHD2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHybevTKLsDF8e98yXEKdMTtA2JHZGd1CBNluzM4km8zKVklWzhzX3uMtopFKToq/
         i8xoskSBXHX5mVdTYcEJSIdMmP5s0uiWXrPyX8mltHUkxPZS+V9DvGnQrBrIV8hRpE
         HLi7SDIpSrn6rKeQmjdUMQIJDd08oqieDHdk2gJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 113/312] net: ipv6: tcp reset, icmp need to consider L3 domain
Date:   Fri,  8 May 2020 14:31:44 +0200
Message-Id: <20200508123132.428039604@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsa@cumulusnetworks.com>

commit 1d2f7b2d956e242179aaf4a08f3545f99c81f9a3 upstream.

Responses for packets to unused ports are getting lost with L3 domains.

IPv4 has ip_send_unicast_reply for sending TCP responses which accounts
for L3 domains; update the IPv6 counterpart tcp_v6_send_response.
For icmp the L3 master check needs to be moved up in icmp6_send
to properly respond to UDP packets to a port with no listener.

Fixes: ca254490c8df ("net: Add VRF support to IPv6 stack")
Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/icmp.c     |    5 ++---
 net/ipv6/tcp_ipv6.c |    7 ++++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -445,6 +445,8 @@ static void icmp6_send(struct sk_buff *s
 
 	if (__ipv6_addr_needs_scope_id(addr_type))
 		iif = skb->dev->ifindex;
+	else
+		iif = l3mdev_master_ifindex(skb->dev);
 
 	/*
 	 *	Must not send error if the source does not uniquely
@@ -499,9 +501,6 @@ static void icmp6_send(struct sk_buff *s
 	else if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = np->ucast_oif;
 
-	if (!fl6.flowi6_oif)
-		fl6.flowi6_oif = l3mdev_master_ifindex(skb->dev);
-
 	dst = icmpv6_route_lookup(net, skb, sk, &fl6);
 	if (IS_ERR(dst))
 		goto out;
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -815,8 +815,13 @@ static void tcp_v6_send_response(const s
 	fl6.flowi6_proto = IPPROTO_TCP;
 	if (rt6_need_strict(&fl6.daddr) && !oif)
 		fl6.flowi6_oif = tcp_v6_iif(skb);
-	else
+	else {
+		if (!oif && netif_index_is_l3_master(net, skb->skb_iif))
+			oif = skb->skb_iif;
+
 		fl6.flowi6_oif = oif;
+	}
+
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, skb->mark);
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;


