Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A77206234
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393064AbgFWU5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390256AbgFWUmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54E4D218AC;
        Tue, 23 Jun 2020 20:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944974;
        bh=dO13tl9zfoeK3NDXLaxwbhdiKE/Y+gJk4FrbYulXl54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCwmb+20c6xLPbybxLs13rTpcIJEBlZizH1Gmm7jYp1tIOkoAkAfYF/U+VFc7XdOR
         JhYIzYqNu+yZy6CNWYZHH1Jl8TnymKWR+MWYuAyzhjES0UxNlQ43yoXY0PVNQDLzf1
         /ANABMRZSv+7wBp+fklCJeZWLRMAmXcZ+eJ9fn9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/206] bcache: fix potential deadlock problem in btree_gc_coalesce
Date:   Tue, 23 Jun 2020 21:58:15 +0200
Message-Id: <20200623195325.222463575@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

[ Upstream commit be23e837333a914df3f24bf0b32e87b0331ab8d1 ]

coccicheck reports:
  drivers/md//bcache/btree.c:1538:1-7: preceding lock on line 1417

In btree_gc_coalesce func, if the coalescing process fails, we will goto
to out_nocoalesce tag directly without releasing new_nodes[i]->write_lock.
Then, it will cause a deadlock when trying to acquire new_nodes[i]->
write_lock for freeing new_nodes[i] before return.

btree_gc_coalesce func details as follows:
	if alloc new_nodes[i] fails:
		goto out_nocoalesce;
	// obtain new_nodes[i]->write_lock
	mutex_lock(&new_nodes[i]->write_lock)
	// main coalescing process
	for (i = nodes - 1; i > 0; --i)
		[snipped]
		if coalescing process fails:
			// Here, directly goto out_nocoalesce
			 // tag will cause a deadlock
			goto out_nocoalesce;
		[snipped]
	// release new_nodes[i]->write_lock
	mutex_unlock(&new_nodes[i]->write_lock)
	// coalesing succ, return
	return;
out_nocoalesce:
	btree_node_free(new_nodes[i])	// free new_nodes[i]
	// obtain new_nodes[i]->write_lock
	mutex_lock(&new_nodes[i]->write_lock);
	// set flag for reuse
	clear_bit(BTREE_NODE_dirty, &ew_nodes[i]->flags);
	// release new_nodes[i]->write_lock
	mutex_unlock(&new_nodes[i]->write_lock);

To fix the problem, we add a new tag 'out_unlock_nocoalesce' for
releasing new_nodes[i]->write_lock before out_nocoalesce tag. If
coalescing process fails, we will go to out_unlock_nocoalesce tag
for releasing new_nodes[i]->write_lock before free new_nodes[i] in
out_nocoalesce tag.

(Coly Li helps to clean up commit log format.)

Fixes: 2a285686c109816 ("bcache: btree locking rework")
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/btree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index bb40bd66a10e4..38a8f8d2a908d 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1432,7 +1432,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 			if (__set_blocks(n1, n1->keys + n2->keys,
 					 block_bytes(b->c)) >
 			    btree_blocks(new_nodes[i]))
-				goto out_nocoalesce;
+				goto out_unlock_nocoalesce;
 
 			keys = n2->keys;
 			/* Take the key of the node we're getting rid of */
@@ -1461,7 +1461,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 
 		if (__bch_keylist_realloc(&keylist,
 					  bkey_u64s(&new_nodes[i]->key)))
-			goto out_nocoalesce;
+			goto out_unlock_nocoalesce;
 
 		bch_btree_node_write(new_nodes[i], &cl);
 		bch_keylist_add(&keylist, &new_nodes[i]->key);
@@ -1507,6 +1507,10 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 	/* Invalidated our iterator */
 	return -EINTR;
 
+out_unlock_nocoalesce:
+	for (i = 0; i < nodes; i++)
+		mutex_unlock(&new_nodes[i]->write_lock);
+
 out_nocoalesce:
 	closure_sync(&cl);
 	bch_keylist_free(&keylist);
-- 
2.25.1



