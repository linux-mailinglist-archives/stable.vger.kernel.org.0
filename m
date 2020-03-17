Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FCA1891F2
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCQX1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:46 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53462 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgCQX1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzIJjXGAjA/1vJSMzOFFvd/ihz5xhfr46yrZ9enBqKw=;
        b=zgBt59IHV3+YOEXUWZd8RTbpu1xgP0nBzszvI3bzAS+RFNRDbl/uzhoUWgqDwBDwdTDMBC
        rXME1xSSHez/JyUA356pEpNT6UAyqQL6lyNwVRuzYS1D+IFngd+vVG/oSgQasT7NsPJB1Y
        L1bnLrLU7eea+V6hDa0lxfVw7SXwkXk=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 03/48] batman-adv: Only put orig_node_vlan list reference when removed
Date:   Wed, 18 Mar 2020 00:26:49 +0100
Message-Id: <20200317232734.6127-4-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3db152093efb750bc47fd4d69355b90b18113105 upstream.

The batadv_orig_node_vlan reference counter in batadv_tt_global_size_mod
can only be reduced when the list entry was actually removed. Otherwise the
reference counter may reach zero when batadv_tt_global_size_mod is called
from two different contexts for the same orig_node_vlan but only one
context is actually removing the entry from the list.

The release function for this orig_node_vlan is not called inside the
vlan_list_lock spinlock protected region because the function
batadv_tt_global_size_mod still holds a orig_node_vlan reference for the
object pointer on the stack. Thus the actual release function (when
required) will be called only at the end of the function.

Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/translation-table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index ffd49b40e76a..117febee5fa6 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -303,9 +303,11 @@ static void batadv_tt_global_size_mod(struct batadv_orig_node *orig_node,
 
 	if (atomic_add_return(v, &vlan->tt.num_entries) == 0) {
 		spin_lock_bh(&orig_node->vlan_list_lock);
-		hlist_del_init_rcu(&vlan->list);
+		if (!hlist_unhashed(&vlan->list)) {
+			hlist_del_init_rcu(&vlan->list);
+			batadv_orig_node_vlan_free_ref(vlan);
+		}
 		spin_unlock_bh(&orig_node->vlan_list_lock);
-		batadv_orig_node_vlan_free_ref(vlan);
 	}
 
 	batadv_orig_node_vlan_free_ref(vlan);
-- 
2.20.1

