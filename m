Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B10F18921E
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCQX22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:28 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:54078 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgCQX22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Tdbj8ai8UioQ2M11urDtKJnT5WO+q+TkHqqUxhx1y4=;
        b=I0BIRz8Xx9Cdmd0bq8etsQbMAQsRFlvKRsNzCn/ezgi78Pyj1PItK8jmd15Nskm9kfp5gY
        SoJNo61s6MRXBJ7Wii9aMIGFUh2NF0iMFYhAEp9Hg6gqTkdLh77kfmgNkNVrYQU/X3Ecmh
        I3UARw9eVk/kKxwvuc0gFv60UaNCVyw=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Martin Weinelt <martin@linuxlounge.net>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 45/48] batman-adv: Reduce tt_global hash refcnt only for removed entry
Date:   Wed, 18 Mar 2020 00:27:31 +0100
Message-Id: <20200317232734.6127-46-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f131a56880d10932931e74773fb8702894a94a75 upstream.

The batadv_hash_remove is a function which searches the hashtable for an
entry using a needle, a hashtable bucket selection function and a compare
function. It will lock the bucket list and delete an entry when the compare
function matches it with the needle. It returns the pointer to the
hlist_node which matches or NULL when no entry matches the needle.

The batadv_tt_global_free is not itself protected in anyway to avoid that
any other function is modifying the hashtable between the search for the
entry and the call to batadv_hash_remove. It can therefore happen that the
entry either doesn't exist anymore or an entry was deleted which is not the
same object as the needle. In such an situation, the reference counter (for
the reference stored in the hashtable) must not be reduced for the needle.
Instead the reference counter of the actually removed entry has to be
reduced.

Otherwise the reference counter will underflow and the object might be
freed before all its references were dropped. The kref helpers reported
this problem as:

  refcount_t: underflow; use-after-free.

Fixes: 7683fdc1e886 ("batman-adv: protect the local and the global trans-tables with rcu")
Reported-by: Martin Weinelt <martin@linuxlounge.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/translation-table.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index a6db0ebf911f..67ee7c83a28d 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -508,14 +508,26 @@ static void batadv_tt_global_free(struct batadv_priv *bat_priv,
 				  struct batadv_tt_global_entry *tt_global,
 				  const char *message)
 {
+	struct batadv_tt_global_entry *tt_removed_entry;
+	struct hlist_node *tt_removed_node;
+
 	batadv_dbg(BATADV_DBG_TT, bat_priv,
 		   "Deleting global tt entry %pM (vid: %d): %s\n",
 		   tt_global->common.addr,
 		   BATADV_PRINT_VID(tt_global->common.vid), message);
 
-	batadv_hash_remove(bat_priv->tt.global_hash, batadv_compare_tt,
-			   batadv_choose_tt, &tt_global->common);
-	batadv_tt_global_entry_free_ref(tt_global);
+	tt_removed_node = batadv_hash_remove(bat_priv->tt.global_hash,
+					     batadv_compare_tt,
+					     batadv_choose_tt,
+					     &tt_global->common);
+	if (!tt_removed_node)
+		return;
+
+	/* drop reference of remove hash entry */
+	tt_removed_entry = hlist_entry(tt_removed_node,
+				       struct batadv_tt_global_entry,
+				       common.hash_entry);
+	batadv_tt_global_entry_free_ref(tt_removed_entry);
 }
 
 /**
-- 
2.20.1

