Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3DD8188ECB
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 21:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQUP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 16:15:56 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49612 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQUP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 16:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584476154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUoMlc+Vm0meZVD53i6SSCKimLe8ROP4XvD0gyI8nSg=;
        b=KRRkCeSfKQ/Dt4xuebs/yVr2mVkU9uxvpx+L3Oi2BA+IcU/R1sOqfUT3iTpyJTt5ysD7uU
        oVwuKgQl1AY+B7QNyqJe5o8IHzpNAGI2JCGQ6fSIIjgPqvGs44Gg4QiogGWyeaMo8jM9X3
        QupvT/xA3YQoVqCbwXkaQ/CJjXDtnlQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Matthias Schiffer <mschiffer@universe-factory.net>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.9 1/3] batman-adv: update data pointers after skb_cow()
Date:   Tue, 17 Mar 2020 21:15:38 +0100
Message-Id: <20200317201540.23496-2-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317201540.23496-1-sven@narfation.org>
References: <20200317201540.23496-1-sven@narfation.org>
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
index f9ffb1825f6d..19059ae26e51 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -930,7 +930,6 @@ int batadv_recv_unicast_packet(struct sk_buff *skb,
 	bool is4addr;
 
 	unicast_packet = (struct batadv_unicast_packet *)skb->data;
-	unicast_4addr_packet = (struct batadv_unicast_4addr_packet *)skb->data;
 
 	is4addr = unicast_packet->packet_type == BATADV_UNICAST_4ADDR;
 	/* the caller function should have already pulled 2 bytes */
@@ -951,9 +950,13 @@ int batadv_recv_unicast_packet(struct sk_buff *skb,
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

