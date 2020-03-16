Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6279187593
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732788AbgCPWa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:30:57 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:48960 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732743AbgCPWa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2pYKPKQrxKV5AcP6h/QjYx+UMRLttHBIj6wXJn5gpA=;
        b=NHr2i9dF12W+yn0P+0gxBxA9+NBD4HxGu1MvsPvQUOp8dP8CADCvKRDhWlyibWzcYXt0dA
        C/QAuCSKVopPF+I1VXGR39kAhBN79BnylZbMJz8wTeZ51uopjSfvY+2fGJDqrq50tCpgC0
        bd23C3csruqnH4ia/98Z4PnC12UPXyg=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 07/15] batman-adv: Avoid race in TT TVLV allocator helper
Date:   Mon, 16 Mar 2020 23:30:24 +0100
Message-Id: <20200316223032.6236-8-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223032.6236-1-sven@narfation.org>
References: <20200316223032.6236-1-sven@narfation.org>
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
index 2c2670b85fa9..adc686087a26 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -872,7 +872,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	struct batadv_orig_node_vlan *vlan;
 	u8 *tt_change_ptr;
 
-	rcu_read_lock();
+	spin_lock_bh(&orig_node->vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
@@ -910,7 +910,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	*tt_change = (struct batadv_tvlv_tt_change *)tt_change_ptr;
 
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&orig_node->vlan_list_lock);
 	return tvlv_len;
 }
 
@@ -946,7 +946,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	u8 *tt_change_ptr;
 	int change_offset;
 
-	rcu_read_lock();
+	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
@@ -984,7 +984,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	*tt_change = (struct batadv_tvlv_tt_change *)tt_change_ptr;
 
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
 	return tvlv_len;
 }
 
-- 
2.20.1

