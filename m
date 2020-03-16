Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB561187595
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbgCPWa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:30:59 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:48928 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732743AbgCPWa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vlYn9JP1y6a6qXWHKwcfIfabk6AQz44+hqr1qzXy5yc=;
        b=1iPj/Iysghjh8FsavIuZxh3TB0gwkdSzO7ypL+INAvcerTYs4TnqywdHxaR4RyRyowNJVn
        kLcap8+brBMpKz7/hPl6MQ2SK1l/n3+aXqY94lRgb9MdpaMviO/jJzii46RosEKUHevhVf
        gedAqBFTVteYqBbx7ECpDHHkVSZjYXY=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 09/15] batman-adv: prevent TT request storms by not sending inconsistent TT TLVLs
Date:   Mon, 16 Mar 2020 23:30:26 +0100
Message-Id: <20200316223032.6236-10-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223032.6236-1-sven@narfation.org>
References: <20200316223032.6236-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Lindner <mareklindner@neomailbox.ch>

commit 16116dac23396e73c01eeee97b102e4833a4b205 upstream.

A translation table TVLV changset sent with an OGM consists
of a number of headers (one per VLAN) plus the changeset
itself (addition and/or deletion of entries).

The per-VLAN headers are used by OGM recipients for consistency
checks. Said consistency check might determine that a full
translation table request is needed to restore consistency. If
the TT sender adds per-VLAN headers of empty VLANs into the OGM,
recipients are led to believe to have reached an inconsistent
state and thus request a full table update. The full table does
not contain empty VLANs (due to missing entries) the cycle
restarts when the next OGM is issued.

Consequently, when the translation table TVLV headers are
composed, empty VLANs are to be excluded.

Fixes: 21a57f6e7a3b ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/translation-table.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index c37611bea429..dbc516824175 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -941,15 +941,20 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	struct batadv_tvlv_tt_vlan_data *tt_vlan;
 	struct batadv_softif_vlan *vlan;
 	u16 num_vlan = 0;
-	u16 num_entries = 0;
+	u16 vlan_entries = 0;
+	u16 total_entries = 0;
 	u16 tvlv_len;
 	u8 *tt_change_ptr;
 	int change_offset;
 
 	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+		vlan_entries = atomic_read(&vlan->tt.num_entries);
+		if (vlan_entries < 1)
+			continue;
+
 		num_vlan++;
-		num_entries += atomic_read(&vlan->tt.num_entries);
+		total_entries += vlan_entries;
 	}
 
 	change_offset = sizeof(**tt_data);
@@ -957,7 +962,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 
 	/* if tt_len is negative, allocate the space needed by the full table */
 	if (*tt_len < 0)
-		*tt_len = batadv_tt_len(num_entries);
+		*tt_len = batadv_tt_len(total_entries);
 
 	tvlv_len = *tt_len;
 	tvlv_len += change_offset;
@@ -974,6 +979,10 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 
 	tt_vlan = (struct batadv_tvlv_tt_vlan_data *)(*tt_data + 1);
 	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+		vlan_entries = atomic_read(&vlan->tt.num_entries);
+		if (vlan_entries < 1)
+			continue;
+
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
 
-- 
2.20.1

