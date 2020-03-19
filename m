Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE3A18B467
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgCSNJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbgCSNJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:09:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE1420789;
        Thu, 19 Mar 2020 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623370;
        bh=eubgEQiBZwVdc6+E2bfCM0l6cQ4Eh9EROaluQ882r7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjJHVBVXw0nlWOrrhT9dze0UCF0MdLwQmdwMpRHaLg2tvceYIJeO4o/hsks8wX2b3
         Xplh4Gjf9PJA8sP+rh+qKZJUtEQWblcc5PKb1r2vxE80lJ7CxVbsI3BIA9eDExFdwC
         Mj6o3X5cZu7mdVd76OIbDryckLsqdFw8lfoPJYn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 80/93] batman-adv: Reduce claim hash refcnt only for removed entry
Date:   Thu, 19 Mar 2020 14:00:24 +0100
Message-Id: <20200319123949.968334750@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -694,6 +694,8 @@ static void batadv_bla_del_claim(struct
 				 const u8 *mac, const unsigned short vid)
 {
 	struct batadv_bla_claim search_claim, *claim;
+	struct batadv_bla_claim *claim_removed_entry;
+	struct hlist_node *claim_removed_node;
 
 	ether_addr_copy(search_claim.addr, mac);
 	search_claim.vid = vid;
@@ -704,10 +706,18 @@ static void batadv_bla_del_claim(struct
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


