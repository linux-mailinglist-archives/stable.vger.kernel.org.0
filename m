Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F3611B56C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731893AbfLKPSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731852AbfLKPSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175BF2465C;
        Wed, 11 Dec 2019 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077521;
        bh=zVD3PMl7eTpIEw1qbbF8rndFpadGWkrOfpETKL+kGXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8tLeGskMdJT10aJfKfEN2GkQYepVBJLVs3dy/VBU4m5g1FYGx7rbN0I2zSRysNP4
         R6mCvM0RDJ9Mi0I4LDfpZaRBxQqjCQ7VFsKaNbqZeUKCyNg1uu8apBqPtWrM+RJVGv
         Hfot99dV0gM7h+lJAj+WxNbeG/Z8HpwIN2CHIohk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/243] audit: Embed key into chunk
Date:   Wed, 11 Dec 2019 16:03:15 +0100
Message-Id: <20191211150341.508849666@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 8d20d6e9301d7b3777d66d47dd5b89acd645cd39 ]

Currently chunk hash key (which is in fact pointer to the inode) is
derived as chunk->mark.conn->obj. It is tricky to make this dereference
reliable for hash table lookups only under RCU as mark can get detached
from the connector and connector gets freed independently of the
running lookup. Thus there is a possible use after free / NULL ptr
dereference issue:

CPU1					CPU2
					untag_chunk()
					  ...
audit_tree_lookup()
  list_for_each_entry_rcu(p, list, hash) {
					  list_del_rcu(&chunk->hash);
					  fsnotify_destroy_mark(entry);
					  fsnotify_put_mark(entry)
    chunk_to_key(p)
      if (!chunk->mark.connector)
					    ...
					    hlist_del_init_rcu(&mark->obj_list);
					    if (hlist_empty(&conn->list)) {
					      inode = fsnotify_detach_connector_from_object(conn);
					    mark->connector = NULL;
					    ...
					    frees connector from workqueue
      chunk->mark.connector->obj

This race is probably impossible to hit in practice as the race window
on CPU1 is very narrow and CPU2 has a lot of code to execute. Still it's
better to have this fixed. Since the inode the chunk is attached to is
constant during chunk's lifetime it is easy to cache the key in the
chunk itself and thus avoid these issues.

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit_tree.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index ea43181cde4a2..04f59dfd3e71f 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -24,6 +24,7 @@ struct audit_tree {
 
 struct audit_chunk {
 	struct list_head hash;
+	unsigned long key;
 	struct fsnotify_mark mark;
 	struct list_head trees;		/* with root here */
 	int dead;
@@ -172,21 +173,6 @@ static unsigned long inode_to_key(const struct inode *inode)
 	return (unsigned long)&inode->i_fsnotify_marks;
 }
 
-/*
- * Function to return search key in our hash from chunk. Key 0 is special and
- * should never be present in the hash.
- */
-static unsigned long chunk_to_key(struct audit_chunk *chunk)
-{
-	/*
-	 * We have a reference to the mark so it should be attached to a
-	 * connector.
-	 */
-	if (WARN_ON_ONCE(!chunk->mark.connector))
-		return 0;
-	return (unsigned long)chunk->mark.connector->obj;
-}
-
 static inline struct list_head *chunk_hash(unsigned long key)
 {
 	unsigned long n = key / L1_CACHE_BYTES;
@@ -196,12 +182,12 @@ static inline struct list_head *chunk_hash(unsigned long key)
 /* hash_lock & entry->lock is held by caller */
 static void insert_hash(struct audit_chunk *chunk)
 {
-	unsigned long key = chunk_to_key(chunk);
 	struct list_head *list;
 
 	if (!(chunk->mark.flags & FSNOTIFY_MARK_FLAG_ATTACHED))
 		return;
-	list = chunk_hash(key);
+	WARN_ON_ONCE(!chunk->key);
+	list = chunk_hash(chunk->key);
 	list_add_rcu(&chunk->hash, list);
 }
 
@@ -213,7 +199,7 @@ struct audit_chunk *audit_tree_lookup(const struct inode *inode)
 	struct audit_chunk *p;
 
 	list_for_each_entry_rcu(p, list, hash) {
-		if (chunk_to_key(p) == key) {
+		if (p->key == key) {
 			atomic_long_inc(&p->refs);
 			return p;
 		}
@@ -297,6 +283,7 @@ static void untag_chunk(struct node *p)
 
 	chunk->dead = 1;
 	spin_lock(&hash_lock);
+	new->key = chunk->key;
 	list_replace_init(&chunk->trees, &new->trees);
 	if (owner->root == chunk) {
 		list_del_init(&owner->same_root);
@@ -378,6 +365,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		tree->root = chunk;
 		list_add(&tree->same_root, &chunk->trees);
 	}
+	chunk->key = inode_to_key(inode);
 	insert_hash(chunk);
 	spin_unlock(&hash_lock);
 	spin_unlock(&entry->lock);
@@ -462,6 +450,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 		fsnotify_put_mark(old_entry);
 		return 0;
 	}
+	chunk->key = old->key;
 	list_replace_init(&old->trees, &chunk->trees);
 	for (n = 0, p = chunk->owners; n < old->count; n++, p++) {
 		struct audit_tree *s = old->owners[n].owner;
@@ -661,7 +650,7 @@ void audit_trim_trees(void)
 			/* this could be NULL if the watch is dying else where... */
 			node->index |= 1U<<31;
 			if (iterate_mounts(compare_root,
-					   (void *)chunk_to_key(chunk),
+					   (void *)(chunk->key),
 					   root_mnt))
 				node->index &= ~(1U<<31);
 		}
-- 
2.20.1



