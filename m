Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4BB84DB
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392116AbfISWPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393839AbfISWO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:14:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 393CB218AF;
        Thu, 19 Sep 2019 22:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931298;
        bh=9ZkUmIAtqapg5V4o9+m2L/LvSQjknh64QISz0pC6Op8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz3kV8nie4T7bPraOQXw3Ot1JT0MHXqZGQnBsLWUoqYOaiuecEYqwI1l5P9Y5mOaU
         8+vZhDCf2gi3is5zxS/HbEqMYZl1CCaKV+7M/uzL+LYx9A3p4gY/+8zKvTSEK8Pk9z
         /Gtk3wo4byw6lQp8ArlayktwZdiHTOAzjB4BGyCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/79] batman-adv: Only read OGM2 tvlv_len after buffer len check
Date:   Fri, 20 Sep 2019 00:03:28 +0200
Message-Id: <20190919214811.470416788@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 0ff0f15a32c093381ad1abc06abe85afb561ab28 ]

Multiple batadv_ogm2_packet can be stored in an skbuff. The functions
batadv_v_ogm_send_to_if() uses batadv_v_ogm_aggr_packet() to check if there
is another additional batadv_ogm2_packet in the skb or not before they
continue processing the packet.

The length for such an OGM2 is BATADV_OGM2_HLEN +
batadv_ogm2_packet->tvlv_len. The check must first check that at least
BATADV_OGM2_HLEN bytes are available before it accesses tvlv_len (which is
part of the header. Otherwise it might try read outside of the currently
available skbuff to get the content of tvlv_len.

Fixes: 9323158ef9f4 ("batman-adv: OGMv2 - implement originators logic")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v_ogm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 2948b41b06d47..d241ccc0ca027 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -643,17 +643,23 @@ batadv_v_ogm_process_per_outif(struct batadv_priv *bat_priv,
  * batadv_v_ogm_aggr_packet() - checks if there is another OGM aggregated
  * @buff_pos: current position in the skb
  * @packet_len: total length of the skb
- * @tvlv_len: tvlv length of the previously considered OGM
+ * @ogm2_packet: potential OGM2 in buffer
  *
  * Return: true if there is enough space for another OGM, false otherwise.
  */
-static bool batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
-				     __be16 tvlv_len)
+static bool
+batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
+			 const struct batadv_ogm2_packet *ogm2_packet)
 {
 	int next_buff_pos = 0;
 
-	next_buff_pos += buff_pos + BATADV_OGM2_HLEN;
-	next_buff_pos += ntohs(tvlv_len);
+	/* check if there is enough space for the header */
+	next_buff_pos += buff_pos + sizeof(*ogm2_packet);
+	if (next_buff_pos > packet_len)
+		return false;
+
+	/* check if there is enough space for the optional TVLV */
+	next_buff_pos += ntohs(ogm2_packet->tvlv_len);
 
 	return (next_buff_pos <= packet_len) &&
 	       (next_buff_pos <= BATADV_MAX_AGGREGATION_BYTES);
@@ -830,7 +836,7 @@ int batadv_v_ogm_packet_recv(struct sk_buff *skb,
 	ogm_packet = (struct batadv_ogm2_packet *)skb->data;
 
 	while (batadv_v_ogm_aggr_packet(ogm_offset, skb_headlen(skb),
-					ogm_packet->tvlv_len)) {
+					ogm_packet)) {
 		batadv_v_ogm_process(skb, ogm_offset, if_incoming);
 
 		ogm_offset += BATADV_OGM2_HLEN;
-- 
2.20.1



