Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6422787C7
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgIYMuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgIYMuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF40221741;
        Fri, 25 Sep 2020 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038215;
        bh=8kydnDhgBMXjJozEVjDoRkWmjNfyp/0Zz8VsAjYxhVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkYCzosIHE/HaaxwP5+lE7QLTVp0w9L6DQXjCTjdO8e7tgNHExSr3i/Il3Ap29yiP
         LZyOCNqtg6UYiMx5GCmlcA6EnOvaJX2WHYcsqaFGcPxVEMElG/CHEbrYzib/a99vUw
         XPPjahmZm5+t4g4JfF/+TrEExdOspqkPoOJ5WHcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 45/56] wireguard: peerlookup: take lock before checking hash in replace operation
Date:   Fri, 25 Sep 2020 14:48:35 +0200
Message-Id: <20200925124734.595394645@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 6147f7b1e90ff09bd52afc8b9206a7fcd133daf7 ]

Eric's suggested fix for the previous commit's mentioned race condition
was to simply take the table->lock in wg_index_hashtable_replace(). The
table->lock of the hash table is supposed to protect the bucket heads,
not the entires, but actually, since all the mutator functions are
already taking it, it makes sense to take it too for the test to
hlist_unhashed, as a defense in depth measure, so that it no longer
races with deletions, regardless of what other locks are protecting
individual entries. This is sensible from a performance perspective
because, as Eric pointed out, the case of being unhashed is already the
unlikely case, so this won't add common contention. And comparing
instructions, this basically doesn't make much of a difference other
than pushing and popping %r13, used by the new `bool ret`. More
generally, I like the idea of locking consistency across table mutator
functions, and this might let me rest slightly easier at night.

Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/wireguard/20200908145911.4090480-1-edumazet@google.com/
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/peerlookup.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/wireguard/peerlookup.c
+++ b/drivers/net/wireguard/peerlookup.c
@@ -167,9 +167,13 @@ bool wg_index_hashtable_replace(struct i
 				struct index_hashtable_entry *old,
 				struct index_hashtable_entry *new)
 {
-	if (unlikely(hlist_unhashed(&old->index_hash)))
-		return false;
+	bool ret;
+
 	spin_lock_bh(&table->lock);
+	ret = !hlist_unhashed(&old->index_hash);
+	if (unlikely(!ret))
+		goto out;
+
 	new->index = old->index;
 	hlist_replace_rcu(&old->index_hash, &new->index_hash);
 
@@ -180,8 +184,9 @@ bool wg_index_hashtable_replace(struct i
 	 * simply gets dropped, which isn't terrible.
 	 */
 	INIT_HLIST_NODE(&old->index_hash);
+out:
 	spin_unlock_bh(&table->lock);
-	return true;
+	return ret;
 }
 
 void wg_index_hashtable_remove(struct index_hashtable *table,


