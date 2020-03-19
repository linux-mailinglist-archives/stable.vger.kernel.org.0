Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504ED18B77A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgCSNdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbgCSNNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:13:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1183620722;
        Thu, 19 Mar 2020 13:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623596;
        bh=VuE7TmDy3e1X1Gvxz8ud/ys5uK9G3jifL4rHLjlRcJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuXx42nlDCq/aTAnczf1oOwUOBToZA0kBwftG0zWXz6EPzpBA0CUZYwzoL9YvojRN
         mO5BraZ0/TXJPcinfBfSXUmGtGh1JrBGJGbatbSGWKKfh1HC0T0h6e89HBfopdZjLN
         gR9Obe+KYAemLVKVk7xvpdButVRD2WgE5OAJU7tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 63/90] batman-adv: Avoid race in TT TVLV allocator helper
Date:   Thu, 19 Mar 2020 14:00:25 +0100
Message-Id: <20200319123948.071644105@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -867,7 +867,7 @@ batadv_tt_prepare_tvlv_global_data(struc
 	struct batadv_orig_node_vlan *vlan;
 	u8 *tt_change_ptr;
 
-	rcu_read_lock();
+	spin_lock_bh(&orig_node->vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
@@ -905,7 +905,7 @@ batadv_tt_prepare_tvlv_global_data(struc
 	*tt_change = (struct batadv_tvlv_tt_change *)tt_change_ptr;
 
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&orig_node->vlan_list_lock);
 	return tvlv_len;
 }
 
@@ -941,7 +941,7 @@ batadv_tt_prepare_tvlv_local_data(struct
 	u8 *tt_change_ptr;
 	int change_offset;
 
-	rcu_read_lock();
+	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
@@ -979,7 +979,7 @@ batadv_tt_prepare_tvlv_local_data(struct
 	*tt_change = (struct batadv_tvlv_tt_change *)tt_change_ptr;
 
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
 	return tvlv_len;
 }
 


