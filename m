Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A65A88E21
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfHJUwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54150 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbfHJUnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053e-Q6; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003b8-SR; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sven Eckelmann" <sven@narfation.org>,
        "Simon Wunderlich" <sw@simonwunderlich.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.336708598@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 046/157] batman-adv: Reduce tt_local hash refcnt only
 for removed entry
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 3d65b9accab4a7ed5038f6df403fbd5e298398c7 upstream.

The batadv_hash_remove is a function which searches the hashtable for an
entry using a needle, a hashtable bucket selection function and a compare
function. It will lock the bucket list and delete an entry when the compare
function matches it with the needle. It returns the pointer to the
hlist_node which matches or NULL when no entry matches the needle.

The batadv_tt_local_remove is not itself protected in anyway to avoid that
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

Fixes: ef72706a0543 ("batman-adv: protect tt_local_entry from concurrent delete events")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/batman-adv/translation-table.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1021,9 +1021,10 @@ uint16_t batadv_tt_local_remove(struct b
 				const uint8_t *addr, unsigned short vid,
 				const char *message, bool roaming)
 {
+	struct batadv_tt_local_entry *tt_removed_entry;
 	struct batadv_tt_local_entry *tt_local_entry;
 	uint16_t flags, curr_flags = BATADV_NO_FLAGS;
-	void *tt_entry_exists;
+	struct hlist_node *tt_removed_node;
 
 	tt_local_entry = batadv_tt_local_hash_find(bat_priv, addr, vid);
 	if (!tt_local_entry)
@@ -1052,15 +1053,18 @@ uint16_t batadv_tt_local_remove(struct b
 	 */
 	batadv_tt_local_event(bat_priv, tt_local_entry, BATADV_TT_CLIENT_DEL);
 
-	tt_entry_exists = batadv_hash_remove(bat_priv->tt.local_hash,
+	tt_removed_node = batadv_hash_remove(bat_priv->tt.local_hash,
 					     batadv_compare_tt,
 					     batadv_choose_tt,
 					     &tt_local_entry->common);
-	if (!tt_entry_exists)
+	if (!tt_removed_node)
 		goto out;
 
-	/* extra call to free the local tt entry */
-	batadv_tt_local_entry_free_ref(tt_local_entry);
+	/* drop reference of remove hash entry */
+	tt_removed_entry = hlist_entry(tt_removed_node,
+				       struct batadv_tt_local_entry,
+				       common.hash_entry);
+	batadv_tt_local_entry_free_ref(tt_removed_entry);
 
 out:
 	if (tt_local_entry)

