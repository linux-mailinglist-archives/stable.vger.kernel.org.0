Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93DB88E22
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfHJUwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54148 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726582AbfHJUnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053h-Q6; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003b3-Rm; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Simon Wunderlich" <sw@simonwunderlich.de>,
        "Sven Eckelmann" <sven@narfation.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.970365987@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 045/157] batman-adv: Reduce claim hash refcnt only
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

commit 4ba104f468bbfc27362c393815d03aa18fb7a20f upstream.

The batadv_hash_remove is a function which searches the hashtable for an
entry using a needle, a hashtable bucket selection function and a compare
function. It will lock the bucket list and delete an entry when the compare
function matches it with the needle. It returns the pointer to the
hlist_node which matches or NULL when no entry matches the needle.

The batadv_bla_del_claim is not itself protected in anyway to avoid that
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

Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[bwh: Backported to 3.16: keep using batadv_claim_free_ref()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/batman-adv/bridge_loop_avoidance.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -677,6 +677,8 @@ static void batadv_bla_del_claim(struct
 				 const uint8_t *mac, const unsigned short vid)
 {
 	struct batadv_bla_claim search_claim, *claim;
+	struct batadv_bla_claim *claim_removed_entry;
+	struct hlist_node *claim_removed_node;
 
 	ether_addr_copy(search_claim.addr, mac);
 	search_claim.vid = vid;
@@ -687,10 +689,18 @@ static void batadv_bla_del_claim(struct
 	batadv_dbg(BATADV_DBG_BLA, bat_priv, "bla_del_claim(): %pM, vid %d\n",
 		   mac, BATADV_PRINT_VID(vid));
 
-	batadv_hash_remove(bat_priv->bla.claim_hash, batadv_compare_claim,
-			   batadv_choose_claim, claim);
-	batadv_claim_free_ref(claim); /* reference from the hash is gone */
+	claim_removed_node = batadv_hash_remove(bat_priv->bla.claim_hash,
+						batadv_compare_claim,
+						batadv_choose_claim, claim);
+	if (!claim_removed_node)
+		goto free_claim;
 
+	/* reference from the hash is gone */
+	claim_removed_entry = hlist_entry(claim_removed_node,
+					  struct batadv_bla_claim, hash_entry);
+	batadv_claim_free_ref(claim_removed_entry);
+
+free_claim:
 	/* don't need the reference from hash_find() anymore */
 	batadv_claim_free_ref(claim);
 }

