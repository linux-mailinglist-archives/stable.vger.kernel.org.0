Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB6F4510C6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbhKOSzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242990AbhKOSwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67C3A63475;
        Mon, 15 Nov 2021 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999808;
        bh=s9RwuipwTWbvw46NZ9RTFjg5pM/MH87HtP9MdKbU9ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSkdHr9k+el23/tYGex/6Nff6nTmk5+7iIlPVwwvgLbqnKQXfACKizagRe/GZJDiF
         P6snWlKPqDAKvaTuh2AaoP760IOu8M2rxg1QieVAY8vLNRiiOD5lSphxsDyWFrKkHj
         dKt5NY2gYQVsaJ6k+WJqEIxy+nVus1LIGOBry6DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 424/849] net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE
Date:   Mon, 15 Nov 2021 17:58:27 +0100
Message-Id: <20211115165434.603675554@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e4400bbf5b15750e1b59bf4722d18d99be60c69f ]

The NTF_EXT_LEARNED neigh flag is usually propagated back to user space
upon dump of the neighbor table. However, when used in combination with
NTF_USE flag this is not the case despite exempting the entry from the
garbage collector. This results in inconsistent state since entries are
typically marked in neigh->flags with NTF_EXT_LEARNED, but here they are
not. Fix it by propagating the creation flag to ___neigh_create().

Before fix:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a REACHABLE
  [...]

After fix:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a extern_learn REACHABLE
  [...]

Fixes: 9ce33e46531d ("neighbour: support for NTF_EXT_LEARNED flag")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 53e85c70c6e58..077883f9f570b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -379,7 +379,7 @@ EXPORT_SYMBOL(neigh_ifdown);
 
 static struct neighbour *neigh_alloc(struct neigh_table *tbl,
 				     struct net_device *dev,
-				     bool exempt_from_gc)
+				     u8 flags, bool exempt_from_gc)
 {
 	struct neighbour *n = NULL;
 	unsigned long now = jiffies;
@@ -412,6 +412,7 @@ do_alloc:
 	n->updated	  = n->used = now;
 	n->nud_state	  = NUD_NONE;
 	n->output	  = neigh_blackhole;
+	n->flags	  = flags;
 	seqlock_init(&n->hh.hh_lock);
 	n->parms	  = neigh_parms_clone(&tbl->parms);
 	timer_setup(&n->timer, neigh_timer_handler, 0);
@@ -575,19 +576,18 @@ struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
 }
 EXPORT_SYMBOL(neigh_lookup_nodev);
 
-static struct neighbour *___neigh_create(struct neigh_table *tbl,
-					 const void *pkey,
-					 struct net_device *dev,
-					 bool exempt_from_gc, bool want_ref)
+static struct neighbour *
+___neigh_create(struct neigh_table *tbl, const void *pkey,
+		struct net_device *dev, u8 flags,
+		bool exempt_from_gc, bool want_ref)
 {
-	struct neighbour *n1, *rc, *n = neigh_alloc(tbl, dev, exempt_from_gc);
-	u32 hash_val;
-	unsigned int key_len = tbl->key_len;
-	int error;
+	u32 hash_val, key_len = tbl->key_len;
+	struct neighbour *n1, *rc, *n;
 	struct neigh_hash_table *nht;
+	int error;
 
+	n = neigh_alloc(tbl, dev, flags, exempt_from_gc);
 	trace_neigh_create(tbl, dev, pkey, n, exempt_from_gc);
-
 	if (!n) {
 		rc = ERR_PTR(-ENOBUFS);
 		goto out;
@@ -674,7 +674,7 @@ out_neigh_release:
 struct neighbour *__neigh_create(struct neigh_table *tbl, const void *pkey,
 				 struct net_device *dev, bool want_ref)
 {
-	return ___neigh_create(tbl, pkey, dev, false, want_ref);
+	return ___neigh_create(tbl, pkey, dev, 0, false, want_ref);
 }
 EXPORT_SYMBOL(__neigh_create);
 
@@ -1947,7 +1947,9 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		exempt_from_gc = ndm->ndm_state & NUD_PERMANENT ||
 				 ndm->ndm_flags & NTF_EXT_LEARNED;
-		neigh = ___neigh_create(tbl, dst, dev, exempt_from_gc, true);
+		neigh = ___neigh_create(tbl, dst, dev,
+					ndm->ndm_flags & NTF_EXT_LEARNED,
+					exempt_from_gc, true);
 		if (IS_ERR(neigh)) {
 			err = PTR_ERR(neigh);
 			goto out;
-- 
2.33.0



