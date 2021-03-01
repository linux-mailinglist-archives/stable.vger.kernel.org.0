Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847853290C7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243106AbhCAUOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234783AbhCAUFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:05:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F1665074;
        Mon,  1 Mar 2021 17:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621510;
        bh=D4N8CCUdhPlcoRdIszCejWL/nP1kIlsHKmSCT+6rI2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viBgC5m22/suJFcOZZHYuYxWtR7psZJRLtXxKrlGf3zVPSEVsF/DQZfkGvGxdJzRh
         0HsoMzNzgy9pJCt1t3gPb2O0u5N0VCM/lGDEp9PumyYaX62zTsxu+sPYQZO+Tq+zNw
         njmAHw0jtEINtdlBVcE1YJEPhcyls8Y5sBbQ9N08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 543/775] wireguard: device: do not generate ICMP for non-IP packets
Date:   Mon,  1 Mar 2021 17:11:51 +0100
Message-Id: <20210301161228.319027821@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index a3ed49cd95c31..82ce757c852ee 100644
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



