Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBFE1EFEE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbfEOLac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfEOLab (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:30:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FED20843;
        Wed, 15 May 2019 11:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919831;
        bh=D2wjTzLY+6BhBi4u1J9Nm0dZ/GGBbMLUC2F6GZL8Gug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7seZHIDf8G8ihl+zVW6wwWmJl2IWK7Fru4e6XsHJNba1aEuYz98jCq892h2VIA42
         imFBtEjnRPcBjTOeHe4VTSfd0kLkiIVqoHRnK1T1+vOIr26G+o6xZztcBAGksvp1w3
         OYhNYieGuWM4r9Oiv0x/myoVpjcp4YYGilzMfDKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 109/137] ipv4: Fix raw socket lookup for local traffic
Date:   Wed, 15 May 2019 12:56:30 +0200
Message-Id: <20190515090701.497230082@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 19e4e768064a87b073a4b4c138b55db70e0cfb9f ]

inet_iif should be used for the raw socket lookup. inet_iif considers
rt_iif which handles the case of local traffic.

As it stands, ping to a local address with the '-I <dev>' option fails
ever since ping was changed to use SO_BINDTODEVICE instead of
cmsg + IP_PKTINFO.

IPv6 works fine.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -173,6 +173,7 @@ static int icmp_filter(const struct sock
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 {
 	int sdif = inet_sdif(skb);
+	int dif = inet_iif(skb);
 	struct sock *sk;
 	struct hlist_head *head;
 	int delivered = 0;
@@ -185,8 +186,7 @@ static int raw_v4_input(struct sk_buff *
 
 	net = dev_net(skb->dev);
 	sk = __raw_v4_lookup(net, __sk_head(head), iph->protocol,
-			     iph->saddr, iph->daddr,
-			     skb->dev->ifindex, sdif);
+			     iph->saddr, iph->daddr, dif, sdif);
 
 	while (sk) {
 		delivered = 1;


