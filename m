Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA8B14CD7
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfEFOop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbfEFOoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:44:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2B720C01;
        Mon,  6 May 2019 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153883;
        bh=Z7ikgiFRCPOljMKSUhSYS78sMaW7K9kNnm2rD19GWQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dZyt829GQaBwWpiDgDLAcEpuHaeCH/5RtPiNaWsQR1cgdIHaccK5NLhphs2daYlu
         I7kO0HTfwPWaljWcbGqO+gB+fXnmt1G+Y9UdKD0dNldBVdiV9PMk/w1pYr+hRVgqGF
         lzrshfJxJOUbwFnqJ5QgiXCsnI2SeogpmnteKw5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Weinelt <martin@linuxlounge.net>,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/75] batman-adv: Reduce tt_global hash refcnt only for removed entry
Date:   Mon,  6 May 2019 16:32:39 +0200
Message-Id: <20190506143056.011292754@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f131a56880d10932931e74773fb8702894a94a75 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 6c3e446abeed..020a8adc4cce 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -614,14 +614,26 @@ static void batadv_tt_global_free(struct batadv_priv *bat_priv,
 				  struct batadv_tt_global_entry *tt_global,
 				  const char *message)
 {
+	struct batadv_tt_global_entry *tt_removed_entry;
+	struct hlist_node *tt_removed_node;
+
 	batadv_dbg(BATADV_DBG_TT, bat_priv,
 		   "Deleting global tt entry %pM (vid: %d): %s\n",
 		   tt_global->common.addr,
 		   batadv_print_vid(tt_global->common.vid), message);
 
-	batadv_hash_remove(bat_priv->tt.global_hash, batadv_compare_tt,
-			   batadv_choose_tt, &tt_global->common);
-	batadv_tt_global_entry_put(tt_global);
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
+	batadv_tt_global_entry_put(tt_removed_entry);
 }
 
 /**
-- 
2.20.1



