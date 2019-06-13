Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26543F7A
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbfFMP5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731502AbfFMIua (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A767E206BA;
        Thu, 13 Jun 2019 08:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415829;
        bh=6M/ulVchJbvpWuNiGqvu5QrZX3gytPGmjM5m6y2GuoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0z6VDZn0cooJadPuvIJDmuLAMsZ0jtS9zBsMjUYmSgikse1lzQIWPGKAUQqoyg2wn
         b4REgZJ5KyU5ZqgIVaASlwVQ1Zxj3O/iW7eYDs+2UyxmvQSu/SOHXZ3lBnrMR+oWLl
         Z5DiP8VR/xkuKg1gSPp5ELwcT1HhQ242ofFLrUso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 138/155] batman-adv: Adjust name for batadv_dat_send_data
Date:   Thu, 13 Jun 2019 10:34:10 +0200
Message-Id: <20190613075700.420302795@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c2d8b9a6c17a3848136b3eb31f26d3c5880acd89 ]

The send functions in batman-adv are expected to consume the skb when
either the data is queued up for the underlying driver or when some
precondition failed. batadv_dat_send_data didn't do this and instead
created a copy of the skb, modified it and queued the copy up for
transmission. The caller has to take care that the skb is handled correctly
(for example free'd) when batadv_dat_send_data returns.

This unclear behavior already lead to memory leaks in the recent past.
Renaming the function to batadv_dat_forward_data should make it easier to
identify that the data is forwarded but the skb is not actually
send+consumed.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 8d290da0d596..9ba7b9bb198a 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -667,7 +667,7 @@ batadv_dat_select_candidates(struct batadv_priv *bat_priv, __be32 ip_dst,
 }
 
 /**
- * batadv_dat_send_data() - send a payload to the selected candidates
+ * batadv_dat_forward_data() - copy and send payload to the selected candidates
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: payload to send
  * @ip: the DHT key
@@ -680,9 +680,9 @@ batadv_dat_select_candidates(struct batadv_priv *bat_priv, __be32 ip_dst,
  * Return: true if the packet is sent to at least one candidate, false
  * otherwise.
  */
-static bool batadv_dat_send_data(struct batadv_priv *bat_priv,
-				 struct sk_buff *skb, __be32 ip,
-				 unsigned short vid, int packet_subtype)
+static bool batadv_dat_forward_data(struct batadv_priv *bat_priv,
+				    struct sk_buff *skb, __be32 ip,
+				    unsigned short vid, int packet_subtype)
 {
 	int i;
 	bool ret = false;
@@ -1277,8 +1277,8 @@ bool batadv_dat_snoop_outgoing_arp_request(struct batadv_priv *bat_priv,
 		ret = true;
 	} else {
 		/* Send the request to the DHT */
-		ret = batadv_dat_send_data(bat_priv, skb, ip_dst, vid,
-					   BATADV_P_DAT_DHT_GET);
+		ret = batadv_dat_forward_data(bat_priv, skb, ip_dst, vid,
+					      BATADV_P_DAT_DHT_GET);
 	}
 out:
 	if (dat_entry)
@@ -1392,8 +1392,10 @@ void batadv_dat_snoop_outgoing_arp_reply(struct batadv_priv *bat_priv,
 	/* Send the ARP reply to the candidates for both the IP addresses that
 	 * the node obtained from the ARP reply
 	 */
-	batadv_dat_send_data(bat_priv, skb, ip_src, vid, BATADV_P_DAT_DHT_PUT);
-	batadv_dat_send_data(bat_priv, skb, ip_dst, vid, BATADV_P_DAT_DHT_PUT);
+	batadv_dat_forward_data(bat_priv, skb, ip_src, vid,
+				BATADV_P_DAT_DHT_PUT);
+	batadv_dat_forward_data(bat_priv, skb, ip_dst, vid,
+				BATADV_P_DAT_DHT_PUT);
 }
 
 /**
@@ -1710,8 +1712,10 @@ static void batadv_dat_put_dhcp(struct batadv_priv *bat_priv, u8 *chaddr,
 	batadv_dat_entry_add(bat_priv, yiaddr, chaddr, vid);
 	batadv_dat_entry_add(bat_priv, ip_dst, hw_dst, vid);
 
-	batadv_dat_send_data(bat_priv, skb, yiaddr, vid, BATADV_P_DAT_DHT_PUT);
-	batadv_dat_send_data(bat_priv, skb, ip_dst, vid, BATADV_P_DAT_DHT_PUT);
+	batadv_dat_forward_data(bat_priv, skb, yiaddr, vid,
+				BATADV_P_DAT_DHT_PUT);
+	batadv_dat_forward_data(bat_priv, skb, ip_dst, vid,
+				BATADV_P_DAT_DHT_PUT);
 
 	consume_skb(skb);
 
-- 
2.20.1



