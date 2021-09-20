Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4CC412633
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354809AbhITS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385439AbhITSu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D938B61373;
        Mon, 20 Sep 2021 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159285;
        bh=i0mBu9iEvvKStJ0/0Zj+capezk4Pb/noTVeQcU8lomw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9pYZ8sgUk3ZEKrzjWBWcPEhKWSI8yyK0xWPC9DhlQ7K4kyodrRasWibLLtRK3dup
         4nik3E+yFavpv4dCDoFCphuHKnWq1R8p8U2UbKyaP2UVPOFM7349RMXsB37EzCjYyX
         VdxIGGwZ9oZVTcA3CCHVfpgDV/Us3SX0eB4QtXGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@idosch.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 160/168] ip_gre: validate csum_start only on pull
Date:   Mon, 20 Sep 2021 18:44:58 +0200
Message-Id: <20210920163926.926056941@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 8a0ed250f911da31a2aef52101bc707846a800ff ]

The GRE tunnel device can pull existing outer headers in ipge_xmit.
This is a rare path, apparently unique to this device. The below
commit ensured that pulling does not move skb->data beyond csum_start.

But it has a false positive if ip_summed is not CHECKSUM_PARTIAL and
thus csum_start is irrelevant.

Refine to exclude this. At the same time simplify and strengthen the
test.

Simplify, by moving the check next to the offending pull, making it
more self documenting and removing an unnecessary branch from other
code paths.

Strengthen, by also ensuring that the transport header is correct and
therefore the inner headers will be after skb_reset_inner_headers.
The transport header is set to csum_start in skb_partial_csum_set.

Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
Reported-by: Ido Schimmel <idosch@idosch.org>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 95419b7adf5c..6480c6dfe1bf 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -473,8 +473,6 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-	if (csum && skb_checksum_start(skb) < skb->data)
-		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
@@ -632,15 +630,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
+		const int pull_len = tunnel->hlen + sizeof(struct iphdr);
+
 		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
 
+		if (pull_len > skb_transport_offset(skb))
+			goto free_skb;
+
 		/* Pull skb since ip_tunnel_xmit() needs skb->data pointing
 		 * to gre header.
 		 */
-		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
+		skb_pull(skb, pull_len);
 		skb_reset_mac_header(skb);
 	} else {
 		if (skb_cow_head(skb, dev->needed_headroom))
-- 
2.30.2



