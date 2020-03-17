Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD22518920F
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgCQX2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:15 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53786 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Ax1coUHhxgKJYhD7bQcB86R/E318ZBGXhVXPTN2B0c=;
        b=cCdO2LcSXLgrg1h1J/n/ExFSIh//KEbS2hnFWzS7td1vqzSbq8Snv/95M1CjinmAWI0pkX
        iCz23ibiNzfEIxaq92dXtz5gSf+ucXzSprByHS4LdcLFryqzGMnFRgSuimsdc1GjtP2Npq
        a2DzVqi6s6qPuwu2ykZi0FXseCXp6h0=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Matthias Schiffer <mschiffer@universe-factory.net>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 31/48] batman-adv: update data pointers after skb_cow()
Date:   Wed, 18 Mar 2020 00:27:17 +0100
Message-Id: <20200317232734.6127-32-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <mschiffer@universe-factory.net>

commit bc44b78157f621ff2a2618fe287a827bcb094ac4 upstream.

batadv_check_unicast_ttvn() calls skb_cow(), so pointers into the SKB data
must be (re)set after calling it. The ethhdr variable is dropped
altogether.

Fixes: 78fc6bbe0aca ("batman-adv: add UNICAST_4ADDR packet type")
Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/routing.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 6c3dfd65023f..b8ff2a17b7ef 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -904,7 +904,6 @@ int batadv_recv_unicast_packet(struct sk_buff *skb,
 	bool is4addr;
 
 	unicast_packet = (struct batadv_unicast_packet *)skb->data;
-	unicast_4addr_packet = (struct batadv_unicast_4addr_packet *)skb->data;
 
 	is4addr = unicast_packet->packet_type == BATADV_UNICAST_4ADDR;
 	/* the caller function should have already pulled 2 bytes */
@@ -925,9 +924,13 @@ int batadv_recv_unicast_packet(struct sk_buff *skb,
 	if (!batadv_check_unicast_ttvn(bat_priv, skb, hdr_size))
 		return NET_RX_DROP;
 
+	unicast_packet = (struct batadv_unicast_packet *)skb->data;
+
 	/* packet for me */
 	if (batadv_is_my_mac(bat_priv, unicast_packet->dest)) {
 		if (is4addr) {
+			unicast_4addr_packet =
+				(struct batadv_unicast_4addr_packet *)skb->data;
 			subtype = unicast_4addr_packet->subtype;
 			batadv_dat_inc_counter(bat_priv, subtype);
 
-- 
2.20.1

