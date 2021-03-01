Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690B9328DE2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbhCATTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241249AbhCATPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:15:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76EAA6506A;
        Mon,  1 Mar 2021 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619439;
        bh=rUGtxYsV0xaAxa5VF/jXvKRKx7OfzZR/KK2xzGjZlwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qArYeMwVNdfCQyPKpVZitlmuRC810/1oSiH0O3NskVYIMFar+0r73Udc7cO3yUDNI
         CFVZULEV5pGAunYYR0gxZlX+y8vHIOyAVGf0yYNB2gMus2x60qOsSgfhU/OQ3G5MO7
         j6blb5uF2tYRvzOiULPCMwApZIcXkzDM4BZecDyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 453/663] wireguard: device: do not generate ICMP for non-IP packets
Date:   Mon,  1 Mar 2021 17:11:41 +0100
Message-Id: <20210301161204.304229512@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 99fff5264e7ab06f45b0ad60243475be0a8d0559 ]

If skb->protocol doesn't match the actual skb->data header, it's
probably not a good idea to pass it off to icmp{,v6}_ndo_send, which is
expecting to reply to a valid IP packet. So this commit has that early
mismatch case jump to a later error label.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index c9f65e96ccb04..c1fd3e04dd3ba 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -138,7 +138,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 		else if (skb->protocol == htons(ETH_P_IPV6))
 			net_dbg_ratelimited("%s: No peer has allowed IPs matching %pI6\n",
 					    dev->name, &ipv6_hdr(skb)->daddr);
-		goto err;
+		goto err_icmp;
 	}
 
 	family = READ_ONCE(peer->endpoint.addr.sa_family);
@@ -201,12 +201,13 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 
 err_peer:
 	wg_peer_put(peer);
-err:
-	++dev->stats.tx_errors;
+err_icmp:
 	if (skb->protocol == htons(ETH_P_IP))
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
 	else if (skb->protocol == htons(ETH_P_IPV6))
 		icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
+err:
+	++dev->stats.tx_errors;
 	kfree_skb(skb);
 	return ret;
 }
-- 
2.27.0



