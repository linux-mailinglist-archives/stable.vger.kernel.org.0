Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EC126182F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731627AbgIHRtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731612AbgIHQN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2036248E5;
        Tue,  8 Sep 2020 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580379;
        bh=6Fez109ttIMLRmVVxANrHk+iYVZxm0H8XRvVFoMJ/EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lcm6zXRsbrxA3SoCFjmVGl6UNFw+wMJ9MA6VBZUWXwwBL81cVaaMJr7eQAASEHXUY
         9Rgyl53O6dtB/SMy4JWFLJ2zti+kmGzT4XeVbiOj2akJi5DYN9nN442O2SU5BodKJo
         TJVjDhXAYzsi1a4AqhwwQtYpO0r0NF6h399ZHC1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/65] batman-adv: Fix own OGM check in aggregated OGMs
Date:   Tue,  8 Sep 2020 17:25:58 +0200
Message-Id: <20200908152217.709656446@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

[ Upstream commit d8bf0c01642275c7dca1e5d02c34e4199c200b1f ]

The own OGM check is currently misplaced and can lead to the following
issues:

For one thing we might receive an aggregated OGM from a neighbor node
which has our own OGM in the first place. We would then not only skip
our own OGM but erroneously also any other, following OGM in the
aggregate.

For another, we might receive an OGM aggregate which has our own OGM in
a place other then the first one. Then we would wrongly not skip this
OGM, leading to populating the orginator and gateway table with ourself.

Fixes: 9323158ef9f4 ("batman-adv: OGMv2 - implement originators logic")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v_ogm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index f0abbbdafe07f..c49c48866a3fc 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -715,6 +715,12 @@ static void batadv_v_ogm_process(const struct sk_buff *skb, int ogm_offset,
 		   ntohl(ogm_packet->seqno), ogm_throughput, ogm_packet->ttl,
 		   ogm_packet->version, ntohs(ogm_packet->tvlv_len));
 
+	if (batadv_is_my_mac(bat_priv, ogm_packet->orig)) {
+		batadv_dbg(BATADV_DBG_BATMAN, bat_priv,
+			   "Drop packet: originator packet from ourself\n");
+		return;
+	}
+
 	/* If the throughput metric is 0, immediately drop the packet. No need
 	 * to create orig_node / neigh_node for an unusable route.
 	 */
@@ -842,11 +848,6 @@ int batadv_v_ogm_packet_recv(struct sk_buff *skb,
 	if (batadv_is_my_mac(bat_priv, ethhdr->h_source))
 		goto free_skb;
 
-	ogm_packet = (struct batadv_ogm2_packet *)skb->data;
-
-	if (batadv_is_my_mac(bat_priv, ogm_packet->orig))
-		goto free_skb;
-
 	batadv_inc_counter(bat_priv, BATADV_CNT_MGMT_RX);
 	batadv_add_counter(bat_priv, BATADV_CNT_MGMT_RX_BYTES,
 			   skb->len + ETH_HLEN);
-- 
2.25.1



