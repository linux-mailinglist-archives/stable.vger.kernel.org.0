Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781641875A9
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgCPWbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:21 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49130 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732770AbgCPWbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXgCvvtTjkEfBbGGQDX2O9oN+rdRSCoeCcsdT4u0WYU=;
        b=wx0l1ayWGdkr2Y2J+qdBTlfCv6UgmubFPehMGiUkRBG6kP/pOxuaBZUCzgUtN5cOr6BkED
        khHSGkC2wcxqYto+dzZEhzHBhJvOtmnZg+/N3p8CpsgtXt82vb/TgD2rn0MiSU4dzT9wLr
        O2SbHwVYFVRwvO8XmcQewfS06Viz9ug=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 13/24] batman-adv: Avoid race in TT TVLV allocator helper
Date:   Mon, 16 Mar 2020 23:30:54 +0100
Message-Id: <20200316223105.6333-14-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8ba0f9bd3bdea1058c2b2676bec7905724418e40 upstream.

The functions batadv_tt_prepare_tvlv_local_data and
batadv_tt_prepare_tvlv_global_data are responsible for preparing a buffer
which can be used to store the TVLV container for TT and add the VLAN
information to it.

This will be done in three phases:

1. count the number of VLANs and their entries
2. allocate the buffer using the counters from the previous step and limits
   from the caller (parameter tt_len)
3. insert the VLAN information to the buffer

The step 1 and 3 operate on a list which contains the VLANs. The access to
these lists must be protected with an appropriate lock or otherwise they
might operate on on different entries. This could for example happen when
another context is adding VLAN entries to this list.

This could lead to a buffer overflow in these functions when enough entries
were added between step 1 and 3 to the VLAN lists that the buffer room for
the entries (*tt_change) is smaller then the now required extra buffer for
new VLAN entries.

Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/translation-table.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 4a81caa10c16..6118df392432 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -867,7 +867,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	struct batadv_orig_node_vlan *vlan;
 	u8 *tt_change_ptr;
 
-	rcu_read_lock();
+	spin_lock_bh(&orig_node->vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
@@ -905,7 +905,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	*tt_change = (struct batadv_tvlv_tt_change *)tt_change_ptr;
 
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&orig_node->vlan_list_lock);
 	return tvlv_len;
 }
 
@@ -941,7 +941,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	u8 *tt_change_ptr;
 	int change_offset;
 
-	rcu_read_lock();
+	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
@@ -979,7 +979,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	*tt_change = (struct batadv_tvlv_tt_change *)tt_change_ptr;
 
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
 	return tvlv_len;
 }
 
-- 
2.20.1

