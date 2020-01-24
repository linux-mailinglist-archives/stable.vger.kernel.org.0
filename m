Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55FD147B2A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgAXJlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731098AbgAXJlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:23 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4221020709;
        Fri, 24 Jan 2020 09:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858883;
        bh=w+G4NVqaJfeoUiPfweuKnyPLiAOfS3+sG9zpvCiD7y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEwgRX1hMm32KLB4WAqgpGQl1rPo+kOgvfZsZ9HMaqXKJD9tcycx7V/2NkMyjEHx3
         +cg9h1NahUufPlZV3BJTteHVI5FoWVoP41M3ONUIUvLqD1FzP8IP5CYc5I0tfvDUlP
         8h8bNstAJjCTbEkwjFZPKPqj3Ju4dlqeE2U9lEzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/102] hv_netvsc: flag software created hash value
Date:   Fri, 24 Jan 2020 10:31:14 +0100
Message-Id: <20200124092817.676330032@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Hemminger <sthemmin@microsoft.com>

[ Upstream commit df9f540ca74297a84bafacfa197e9347b20beea5 ]

When the driver needs to create a hash value because it
was not done at higher level, then the hash should be marked
as a software not hardware hash.

Fixes: f72860afa2e3 ("hv_netvsc: Exclude non-TCP port numbers from vRSS hashing")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 78e3e689a733b..0dee358864f30 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -285,9 +285,9 @@ static inline u32 netvsc_get_hash(
 		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
 			hash = jhash2((u32 *)&flow.addrs.v6addrs, 8, hashrnd);
 		else
-			hash = 0;
+			return 0;
 
-		skb_set_hash(skb, hash, PKT_HASH_TYPE_L3);
+		__skb_set_sw_hash(skb, hash, false);
 	}
 
 	return hash;
@@ -795,8 +795,7 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	    skb->protocol == htons(ETH_P_IP))
 		netvsc_comp_ipcsum(skb);
 
-	/* Do L4 checksum offload if enabled and present.
-	 */
+	/* Do L4 checksum offload if enabled and present. */
 	if (csum_info && (net->features & NETIF_F_RXCSUM)) {
 		if (csum_info->receive.tcp_checksum_succeeded ||
 		    csum_info->receive.udp_checksum_succeeded)
-- 
2.20.1



