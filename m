Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D140118921A
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgCQX2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:24 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53930 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgCQX2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Ub6U6OFP4jZJMq52sNx7vtmr6XWpY10bRSc3nzVivQ=;
        b=DS7WJloNcVpqSJO737J57tnc0hZqQRpQ/YVNACn1gmBPqZ71WX7Ajip0el03xFjedD6+GP
        egc4YJmIZtA6t68PjK7/adBfPgnNUCo1F0MBcyTvKLEvVk4PepZT+Fjg4v0WbBYJmiP7Tu
        HkWISSgF4yjj1Z0i058WJNKCmx75ZNQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 41/48] batman-adv: Prevent duplicated global TT entry
Date:   Wed, 18 Mar 2020 00:27:27 +0100
Message-Id: <20200317232734.6127-42-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e7136e48ffdfb9f37b0820f619380485eb407361 upstream.

The function batadv_tt_global_orig_entry_add is responsible for adding new
tt_orig_list_entry to the orig_list. It first checks whether the entry
already is in the list or not. If it is, then the creation of a new entry
is aborted.

But the lock for the list is only held when the list is really modified.
This could lead to duplicated entries because another context could create
an entry with the same key between the check and the list manipulation.

The check and the manipulation of the list must therefore be in the same
locked code section.

Fixes: d657e621a0f5 ("batman-adv: add reference counting for type batadv_tt_orig_list_entry")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/translation-table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 4a685cf2439d..1d445293efea 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1315,6 +1315,8 @@ batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
 {
 	struct batadv_tt_orig_list_entry *orig_entry;
 
+	spin_lock_bh(&tt_global->list_lock);
+
 	orig_entry = batadv_tt_global_orig_entry_find(tt_global, orig_node);
 	if (orig_entry) {
 		/* refresh the ttvn: the current value could be a bogus one that
@@ -1337,10 +1339,8 @@ batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
 	orig_entry->flags = flags;
 	atomic_set(&orig_entry->refcount, 2);
 
-	spin_lock_bh(&tt_global->list_lock);
 	hlist_add_head_rcu(&orig_entry->list,
 			   &tt_global->orig_list);
-	spin_unlock_bh(&tt_global->list_lock);
 	atomic_inc(&tt_global->orig_list_count);
 
 sync_flags:
@@ -1348,6 +1348,8 @@ sync_flags:
 out:
 	if (orig_entry)
 		batadv_tt_orig_list_entry_free_ref(orig_entry);
+
+	spin_unlock_bh(&tt_global->list_lock);
 }
 
 /**
-- 
2.20.1

