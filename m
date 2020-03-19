Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE8518B432
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgCSNHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgCSNHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D8482078B;
        Thu, 19 Mar 2020 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623253;
        bh=7yOSsWr3VHdsieCy40RYaaTZmK5QzJ7CxWL2maasfW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccF8QU+qZvtz1Mtcyk02SLd1Y2Fq+OMgkdTKgyYUPryedeyBWP00lMLTS8E6hndnD
         L/YlUCsrfuELJynlXlQcTW8UDpjynRJSo6K+4eokH9LnQju/PRJ5GwLHQiSVIy26P6
         KaKyhiA6UL1SdOv32KmUtzf05uDJZR9CFWwu8xG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 40/93] batman-adv: Only put orig_node_vlan list reference when removed
Date:   Thu, 19 Mar 2020 13:59:44 +0100
Message-Id: <20200319123937.892341383@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -303,9 +303,11 @@ static void batadv_tt_global_size_mod(st
 
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


