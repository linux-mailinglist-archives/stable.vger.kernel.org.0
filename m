Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8067618921F
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgCQX23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:29 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53960 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAHhUn/gOlKQOsmVQc0AiPro8N7BQV4eGP2NdDzLGKs=;
        b=vBYrC2OdCgFxgR9AliiDFMUQvgRt0jZfuRm6CVDX3prekDLiaBSfhRtrq6rGXWfOd4zkOv
        ujyd2lH93/mp73yH1j/2RZaIqPwH1480G9qPWP3jHDkpVv1qZSFR9VuTp1+IklUAJ87nQN
        vOA+HpyVMTM9YDKBAtde1IZFFOhkQ7s=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 46/48] batman-adv: Only read OGM tvlv_len after buffer len check
Date:   Wed, 18 Mar 2020 00:27:32 +0100
Message-Id: <20200317232734.6127-47-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a15d56a60760aa9dbe26343b9a0ac5228f35d445 upstream.

Multiple batadv_ogm_packet can be stored in an skbuff. The functions
batadv_iv_ogm_send_to_if()/batadv_iv_ogm_receive() use
batadv_iv_ogm_aggr_packet() to check if there is another additional
batadv_ogm_packet in the skb or not before they continue processing the
packet.

The length for such an OGM is BATADV_OGM_HLEN +
batadv_ogm_packet->tvlv_len. The check must first check that at least
BATADV_OGM_HLEN bytes are available before it accesses tvlv_len (which is
part of the header. Otherwise it might try read outside of the currently
available skbuff to get the content of tvlv_len.

Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
Reported-by: syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_iv_ogm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 5010b81e746f..f1c8b1311dee 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -397,14 +397,19 @@ static u8 batadv_hop_penalty(u8 tq, const struct batadv_priv *bat_priv)
 	return new_tq;
 }
 
-/* is there another aggregated packet here? */
-static bool batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
-				      __be16 tvlv_len)
+static bool
+batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
+			  const struct batadv_ogm_packet *ogm_packet)
 {
 	int next_buff_pos = 0;
 
-	next_buff_pos += buff_pos + BATADV_OGM_HLEN;
-	next_buff_pos += ntohs(tvlv_len);
+	/* check if there is enough space for the header */
+	next_buff_pos += buff_pos + sizeof(*ogm_packet);
+	if (next_buff_pos > packet_len)
+		return false;
+
+	/* check if there is enough space for the optional TVLV */
+	next_buff_pos += ntohs(ogm_packet->tvlv_len);
 
 	return (next_buff_pos <= packet_len) &&
 	       (next_buff_pos <= BATADV_MAX_AGGREGATION_BYTES);
@@ -432,7 +437,7 @@ static void batadv_iv_ogm_send_to_if(struct batadv_forw_packet *forw_packet,
 
 	/* adjust all flags and log packets */
 	while (batadv_iv_ogm_aggr_packet(buff_pos, forw_packet->packet_len,
-					 batadv_ogm_packet->tvlv_len)) {
+					 batadv_ogm_packet)) {
 		/* we might have aggregated direct link packets with an
 		 * ordinary base packet
 		 */
@@ -1751,7 +1756,7 @@ static int batadv_iv_ogm_receive(struct sk_buff *skb,
 
 	/* unpack the aggregated packets and process them one by one */
 	while (batadv_iv_ogm_aggr_packet(ogm_offset, skb_headlen(skb),
-					 ogm_packet->tvlv_len)) {
+					 ogm_packet)) {
 		batadv_iv_ogm_process(skb, ogm_offset, if_incoming);
 
 		ogm_offset += BATADV_OGM_HLEN;
-- 
2.20.1

