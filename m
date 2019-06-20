Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21F24D6EE
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfFTSOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbfFTSOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 311F5205F4;
        Thu, 20 Jun 2019 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054440;
        bh=6ijn6mL8RusQO+kHen1qojezEJ0W/LWwviffWpE/j+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpdddb6v7Bb5RDdM58VoDodQ7CXddoLvDU8Yu01BbHMGvAALXELZsEbMwK98BngvL
         d3GaxAkOYLIcc6wyQNSZcsIof8q9RfSmcW0Frvs9tXNhBgaNMGB8P/Tb3Zpq31sSrK
         78ypo2zZZ+730Qu1tIPoEczffMZwDHYdXxlNFZfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 30/98] net: correct udp zerocopy refcnt also when zerocopy only on append
Date:   Thu, 20 Jun 2019 19:56:57 +0200
Message-Id: <20190620174350.484033329@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 522924b583082f51b8a2406624a2f27c22119b20 ]

The below patch fixes an incorrect zerocopy refcnt increment when
appending with MSG_MORE to an existing zerocopy udp skb.

  send(.., MSG_ZEROCOPY | MSG_MORE);	// refcnt 1
  send(.., MSG_ZEROCOPY | MSG_MORE);	// refcnt still 1 (bar frags)

But it missed that zerocopy need not be passed at the first send. The
right test whether the uarg is newly allocated and thus has extra
refcnt 1 is not !skb, but !skb_zcopy.

  send(.., MSG_MORE);			// <no uarg>
  send(.., MSG_ZEROCOPY);		// refcnt 1

Fixes: 100f6d8e09905 ("net: correct zerocopy refcnt with udp MSG_MORE")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c  |    2 +-
 net/ipv6/ip6_output.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -923,7 +923,7 @@ static int __ip_append_data(struct sock
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
+		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1344,7 +1344,7 @@ emsgsize:
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
+		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;


