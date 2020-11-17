Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543032B60A9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgKQNLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729632AbgKQNLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:11:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7B924199;
        Tue, 17 Nov 2020 13:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618691;
        bh=Bp4rcyCde0pKjllPFoIuPXalKtfRoGOYBLS0j1NhJPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pY8qW0QP7XkhEm0PIJJ3xNxd4igSOejBIuF0Q/jzLWyEPPTflBkP13b2LE/AGZ9Uc
         7ZORQrOKx7HMVVHQxjonTpUUFuMW8utJja+waiuBb6lrTYzkCPuJpxXUVdkou7Ntlj
         txBf5dg8j2SNUBA7v0lslMgn4FxUZ0e70bGO19j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Herms <oliver.peter.herms@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 53/78] IPv6: Set SIT tunnel hard_header_len to zero
Date:   Tue, 17 Nov 2020 14:05:19 +0100
Message-Id: <20201117122111.710207490@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Herms <oliver.peter.herms@gmail.com>

[ Upstream commit 8ef9ba4d666614497a057d09b0a6eafc1e34eadf ]

Due to the legacy usage of hard_header_len for SIT tunnels while
already using infrastructure from net/ipv4/ip_tunnel.c the
calculation of the path MTU in tnl_update_pmtu is incorrect.
This leads to unnecessary creation of MTU exceptions for any
flow going over a SIT tunnel.

As SIT tunnels do not have a header themsevles other than their
transport (L3, L2) headers we're leaving hard_header_len set to zero
as tnl_update_pmtu is already taking care of the transport headers
sizes.

This will also help avoiding unnecessary IPv6 GC runs and spinlock
contention seen when using SIT tunnels and for more than
net.ipv6.route.gc_thresh flows.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20201103104133.GA1573211@tws
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1072,7 +1072,6 @@ static void ipip6_tunnel_bind_dev(struct
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 
-		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
 		dev->mtu = tdev->mtu - t_hlen;
 		if (dev->mtu < IPV6_MIN_MTU)
 			dev->mtu = IPV6_MIN_MTU;
@@ -1372,7 +1371,6 @@ static void ipip6_tunnel_setup(struct ne
 	dev->destructor		= ipip6_dev_free;
 
 	dev->type		= ARPHRD_SIT;
-	dev->hard_header_len	= LL_MAX_HEADER + t_hlen;
 	dev->mtu		= ETH_DATA_LEN - t_hlen;
 	dev->flags		= IFF_NOARP;
 	netif_keep_dst(dev);


