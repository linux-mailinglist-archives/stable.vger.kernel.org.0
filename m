Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F99C18921C
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgCQX20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:26 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53960 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgCQX2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BoOVgAuUvoXD8vj0+wet4E//0XGPylU/NMTLBgD3Xho=;
        b=PECE0fBesdO35h8HxwUVDVLti9J3bw1zACQMwqNsEz0z1k5J2UMRRoR15USqqM34YrGFSI
        mYSaBkSehqjVSQ56gwisS6H0t1ES1m5cODtpF9bBEez/vfvxPnzzupcty+/yl9inxxO+NO
        iRgLaPpJhUGAslrli09OXUaEIfkXQHQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 43/48] batman-adv: Reduce claim hash refcnt only for removed entry
Date:   Wed, 18 Mar 2020 00:27:29 +0100
Message-Id: <20200317232734.6127-44-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 net/batman-adv/bridge_loop_avoidance.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 6e2a5d02ce1f..cea7fdeac5aa 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -694,6 +694,8 @@ static void batadv_bla_del_claim(struct batadv_priv *bat_priv,
 				 const u8 *mac, const unsigned short vid)
 {
 	struct batadv_bla_claim search_claim, *claim;
+	struct batadv_bla_claim *claim_removed_entry;
+	struct hlist_node *claim_removed_node;
 
 	ether_addr_copy(search_claim.addr, mac);
 	search_claim.vid = vid;
@@ -704,10 +706,18 @@ static void batadv_bla_del_claim(struct batadv_priv *bat_priv,
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
-- 
2.20.1

