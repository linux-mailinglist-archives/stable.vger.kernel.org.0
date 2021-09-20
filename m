Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA95412382
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378114AbhITSZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347699AbhITSW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92DC9632BD;
        Mon, 20 Sep 2021 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158678;
        bh=jimwPGKDJIs+U4A1ZXtA5K/rN5J/j8KvjjUvd1/x4Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPG4470gCgcBOb3q3uzSHX4aUHyr3I3CijRb327oyH7vzgIoFItTLw2bQaKkk/Mv7
         yAmmtniOkhxCQFXx75ehxKJPCdHnK6LkywqzEL4f7/bl8Qkb4E7GEod4hKyk+3KG4Z
         Q/uQpWGXAKa1g7HGMXtkUJEpCJAuxnEKDSdzMb1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@idosch.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 259/260] ip_gre: validate csum_start only on pull
Date:   Mon, 20 Sep 2021 18:44:37 +0200
Message-Id: <20210920163939.908174353@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index fd8298b8b1c5..c4989e5903e4 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -446,8 +446,6 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-	if (csum && skb_checksum_start(skb) < skb->data)
-		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
@@ -605,15 +603,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
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



