Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BBB1891FD
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCQX15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:57 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53462 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcbmGSw7WB1b41TJZabUwjeq0nf5LD8jfGcXChn7OxA=;
        b=QmcOobwdg/hurfPfQYVRAzZZBC+fMKybKF333VfH1t3i02il/W15wffIP5xT4DG7vkATZD
        gC+MVKBPyR6IpOGtUtv8A/VWpCU4zofmizqq5J2zutNIRXkiO8wmEXk4NicjL8PWVpg7b1
        2ydO66Fw04YCBlEgdACSbeAyjVCs8cw=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 14/48] batman-adv: Fix ICMP RR ethernet access after skb_linearize
Date:   Wed, 18 Mar 2020 00:27:00 +0100
Message-Id: <20200317232734.6127-15-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3b55e4422087f9f7b241031d758a0c65584e4297 upstream.

The skb_linearize may reallocate the skb. This makes the calculated pointer
for ethhdr invalid. But it the pointer is used later to fill in the RR
field of the batadv_icmp_packet_rr packet.

Instead re-evaluate eth_hdr after the skb_linearize+skb_cow to fix the
pointer and avoid the invalid read.

Fixes: da6b8c20a5b8 ("batman-adv: generalize batman-adv icmp packet handling")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/batman-adv/routing.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index de24ab1cf67f..477899ba7616 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -359,6 +359,7 @@ int batadv_recv_icmp_packet(struct sk_buff *skb,
 		if (skb_cow(skb, ETH_HLEN) < 0)
 			goto out;
 
+		ethhdr = eth_hdr(skb);
 		icmph = (struct batadv_icmp_header *)skb->data;
 		icmp_packet_rr = (struct batadv_icmp_packet_rr *)icmph;
 		if (icmp_packet_rr->rr_cur >= BATADV_RR_LEN)
-- 
2.20.1

