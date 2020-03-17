Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CAA188ECC
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 21:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCQUQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 16:16:01 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49628 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQUQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 16:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584476159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wshSAmDiiyqfn+MWVK5HAhOQDw1UWXr3J0AUFHfjZ5Q=;
        b=i0cC4QrMw9bUDrpaRRnZHr12GwJvdJVNx90mOZ8Aal0omUeWcIhsR8US+jVf/SxwOC+hPu
        ulz1W1vjmbgzCLGXghsqSirn6lIrI/lxWahEIlWJOFxAH9nECz/KoL4fqeX8urnaVlPrnj
        BUV0m5hqQeJkFPBfGJfj+QsCjw+XNWs=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 2/3] batman-adv: Avoid probe ELP information leak
Date:   Tue, 17 Mar 2020 21:15:39 +0100
Message-Id: <20200317201540.23496-3-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317201540.23496-1-sven@narfation.org>
References: <20200317201540.23496-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 88d0895d0ea9d4431507d576c963f2ff9918144d upstream.

The probe ELPs for WiFi interfaces are expanded to contain at least
BATADV_ELP_MIN_PROBE_SIZE bytes. This is usually a lot more than the
number of bytes which the template ELP packet requires.

These extra padding bytes were not initialized and thus could contain data
which were previously stored at the same location. It is therefore required
to set it to some predefined or random values to avoid leaking private
information from the system transmitting these kind of packets.

Fixes: e4623c913508 ("batman-adv: Avoid probe ELP information leak")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v_elp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 3ff0dc83d04b..11e1a28ff526 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -191,6 +191,7 @@ batadv_v_elp_wifi_neigh_probe(struct batadv_hardif_neigh_node *neigh)
 	struct sk_buff *skb;
 	int probe_len, i;
 	int elp_skb_len;
+	void *tmp;
 
 	/* this probing routine is for Wifi neighbours only */
 	if (!batadv_is_wifi_netdev(hard_iface->net_dev))
@@ -222,7 +223,8 @@ batadv_v_elp_wifi_neigh_probe(struct batadv_hardif_neigh_node *neigh)
 		 * the packet to be exactly of that size to make the link
 		 * throughput estimation effective.
 		 */
-		skb_put(skb, probe_len - hard_iface->bat_v.elp_skb->len);
+		tmp = skb_put(skb, probe_len - hard_iface->bat_v.elp_skb->len);
+		memset(tmp, 0, probe_len - hard_iface->bat_v.elp_skb->len);
 
 		batadv_dbg(BATADV_DBG_BATMAN, bat_priv,
 			   "Sending unicast (probe) ELP packet on interface %s to %pM\n",
-- 
2.20.1

