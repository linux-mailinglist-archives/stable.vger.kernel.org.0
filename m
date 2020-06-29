Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F129A20DEAC
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbgF2U1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732508AbgF2TZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68CE5253D6;
        Mon, 29 Jun 2020 15:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445309;
        bh=JyX+4nj4mkg4zMc5SSi7x5dRUUXpeWSJtyztT34EZ00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBMTIUzhc/q16EiTi2ZM8pPUksGz+p2ZsKABt5BdgKHqqkXwN+2zX7MAEcHsbzo7e
         0VrSUsKCM4WJg5f+LJyQIR73m8GtrgIg+unBItltN4XgJu8XZq5Qu1kVn+OmWqDiQK
         /adNLL/7NNFcXUJkB16myLDhUlyAiWM1wc0qG5v8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhiqiang Liu <liuzhiqiang26@huawei.com>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 078/191] bcache: fix potential deadlock problem in btree_gc_coalesce
Date:   Mon, 29 Jun 2020 11:38:14 -0400
Message-Id: <20200629154007.2495120-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index c8c5e3368b8b8..12849829077dd 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1370,7 +1370,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 			if (__set_blocks(n1, n1->keys + n2->keys,
 					 block_bytes(b->c)) >
 			    btree_blocks(new_nodes[i]))
-				goto out_nocoalesce;
+				goto out_unlock_nocoalesce;
 
 			keys = n2->keys;
 			/* Take the key of the node we're getting rid of */
@@ -1399,7 +1399,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 
 		if (__bch_keylist_realloc(&keylist,
 					  bkey_u64s(&new_nodes[i]->key)))
-			goto out_nocoalesce;
+			goto out_unlock_nocoalesce;
 
 		bch_btree_node_write(new_nodes[i], &cl);
 		bch_keylist_add(&keylist, &new_nodes[i]->key);
@@ -1445,6 +1445,10 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
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

