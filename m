Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068D327C427
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgI2LLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgI2LLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:11:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 580EE20848;
        Tue, 29 Sep 2020 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377896;
        bh=D6Gt21NdP1RHVX6qAJIxw+Gh3//0YjI+ZRly1D7O83k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ta1djdTYksgjq2S9LP/05k5sl0R9CJD11mMXX4XC93jhbn/Sw9dvD4C9f9SNw+CB7
         RUodtVbvYoVs/tGTsNzXtK2MHIGg/ddLhfKjSKxWvEt2eZ9PQ8rKecyNsDqmAI/KPH
         oOyQMNMppd6sx9vUfaCgfDSNpzYUMjNWL6sLvBxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 111/121] batman-adv: mcast/TT: fix wrongly dropped or rerouted packets
Date:   Tue, 29 Sep 2020 13:00:55 +0200
Message-Id: <20200929105935.682499040@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

[ Upstream commit 7dda5b3384121181c4e79f6eaeac2b94c0622c8d ]

The unicast packet rerouting code makes several assumptions. For
instance it assumes that there is always exactly one destination in the
TT. This breaks for multicast frames in a unicast packets in several ways:

For one thing if there is actually no TT entry and the destination node
was selected due to the multicast tvlv flags it announced. Then an
intermediate node will wrongly drop the packet.

For another thing if there is a TT entry but the TTVN of this entry is
newer than the originally addressed destination node: Then the
intermediate node will wrongly redirect the packet, leading to
duplicated multicast packets at a multicast listener and missing
packets at other multicast listeners or multicast routers.

Fixing this by not applying the unicast packet rerouting to batman-adv
unicast packets with a multicast payload. We are not able to detect a
roaming multicast listener at the moment and will just continue to send
the multicast frame to both the new and old destination for a while in
case of such a roaming multicast listener.

Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/routing.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 19059ae26e519..1ba205c3ea9fa 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -803,6 +803,10 @@ static bool batadv_check_unicast_ttvn(struct batadv_priv *bat_priv,
 	vid = batadv_get_vid(skb, hdr_len);
 	ethhdr = (struct ethhdr *)(skb->data + hdr_len);
 
+	/* do not reroute multicast frames in a unicast header */
+	if (is_multicast_ether_addr(ethhdr->h_dest))
+		return true;
+
 	/* check if the destination client was served by this node and it is now
 	 * roaming. In this case, it means that the node has got a ROAM_ADV
 	 * message and that it knows the new destination in the mesh to re-route
-- 
2.25.1



