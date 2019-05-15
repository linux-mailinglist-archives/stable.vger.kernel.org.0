Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529961F21A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfEOLM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbfEOLMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E008E20843;
        Wed, 15 May 2019 11:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918775;
        bh=mekFkMR1FwcGPTsu+UoZ8+ALW4DZsQFqZaoCIhmdbC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP3YW6X/D9s8pTzPtTsGZ2bMYLW4Y0+wH/OqL4J3B3oOBFbnRPGCLzaKdOuK8Csr8
         6l5hMj6S2bUS/vxPjRDDOg2s4wFRlwxCQFer1IZnmVz1PVallrTOIpoZxlbsgAanDn
         8cBQq6LFAK51odGt7i+BX32xfH4ra18Dnwa7DtMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 262/266] ipv4: Fix raw socket lookup for local traffic
Date:   Wed, 15 May 2019 12:56:09 +0200
Message-Id: <20190515090731.880445211@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
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
@@ -167,6 +167,7 @@ static int icmp_filter(const struct sock
  */
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 {
+	int dif = inet_iif(skb);
 	struct sock *sk;
 	struct hlist_head *head;
 	int delivered = 0;
@@ -179,8 +180,7 @@ static int raw_v4_input(struct sk_buff *
 
 	net = dev_net(skb->dev);
 	sk = __raw_v4_lookup(net, __sk_head(head), iph->protocol,
-			     iph->saddr, iph->daddr,
-			     skb->dev->ifindex);
+			     iph->saddr, iph->daddr, dif);
 
 	while (sk) {
 		delivered = 1;


