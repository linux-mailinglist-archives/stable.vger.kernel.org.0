Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50C22B6292
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbgKQN3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:29:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731611AbgKQN3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B52272078D;
        Tue, 17 Nov 2020 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619779;
        bh=dizju8lYZOrFLA9xJElZzOvX1rEz4qciiufdAKpGV8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RknM2zHKMAk6Cel+Uvvdk94DNbBvv1yjDQ/Ehz/Z/WbjdB0gi2GONZyNdNI5pXG3w
         jhX+0kq3uMHJ2kVQZMoUHUmy0zl2oEml+UKNhs+VU6oBV4ti59d5g8sLJJBTt0Qsbv
         Lan2L8alg9KK7jGDoLnABLydMLBMjw1xwwcgwzEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Herms <oliver.peter.herms@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 138/151] IPv6: Set SIT tunnel hard_header_len to zero
Date:   Tue, 17 Nov 2020 14:06:08 +0100
Message-Id: <20201117122128.144098328@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
@@ -1088,7 +1088,6 @@ static void ipip6_tunnel_bind_dev(struct
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 
-		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
 		dev->mtu = tdev->mtu - t_hlen;
 		if (dev->mtu < IPV6_MIN_MTU)
 			dev->mtu = IPV6_MIN_MTU;
@@ -1378,7 +1377,6 @@ static void ipip6_tunnel_setup(struct ne
 	dev->priv_destructor	= ipip6_dev_free;
 
 	dev->type		= ARPHRD_SIT;
-	dev->hard_header_len	= LL_MAX_HEADER + t_hlen;
 	dev->mtu		= ETH_DATA_LEN - t_hlen;
 	dev->min_mtu		= IPV6_MIN_MTU;
 	dev->max_mtu		= IP6_MAX_MTU - t_hlen;


