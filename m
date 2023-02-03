Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D62F688E78
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 05:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjBCEMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 23:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbjBCEMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 23:12:08 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E37C289F98;
        Thu,  2 Feb 2023 20:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=WrR//
        zva4ZesymP/eKoj5KyCPnat+CUvA7ZEtVA4JNA=; b=nxOlHKommfrlibSizMmPx
        DutsLeIDJQP8sGT9cquP1vr2436CwSUO2ewBsF8J9eyOmRVFaX/+GzZ0SLHJmkRg
        petgKK4VnkZIGuJixy0LkGcz/CIAB5liAGPMhNhdCi5de9Ovf2ReMYnpfTLVicSU
        jrj2cbuxWjEyNVPO8GL75U=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g2-2 (Coremail) with SMTP id _____wBnbNCFidxj79KlCg--.56852S2;
        Fri, 03 Feb 2023 12:11:49 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     colyli@suse.de
Cc:     hackerzheng666@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] bcache: Remove some unnecessary NULL point check for the  return value of __bch_btree_node_alloc-related pointer
Date:   Fri,  3 Feb 2023 12:11:47 +0800
Message-Id: <20230203041147.581389-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBnbNCFidxj79KlCg--.56852S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr48WF4xXrW3Aw4ktFWxtFb_yoW5CF1Dpr
        W29ryayr97Xr4UCr9Yg3WvvFyfXw12vFWUWr93u3WfZry7AFyrCay0934jvrWUuFWxuF4U
        Zr40yw1UXr4UtF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziIPfLUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbBzgwLU2I0XNypJwAAsC
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Due to the previously fix of __bch_btree_node_alloc, the return value will
never be a NULL pointer. So IS_ERR is enough to handle the failure
 situation. Fix it by replacing IS_ERR_OR_NULL check to IS_ERR check.

Fixes: cafe56359144 ("bcache: A block layer cache")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v3:
- Add Cc: stable@vger.kernel.org suggested by Eric
v2:
- Replace more checks
---
 drivers/md/bcache/btree.c | 10 +++++-----
 drivers/md/bcache/super.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..7c21e54468bf 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1138,7 +1138,7 @@ static struct btree *btree_node_alloc_replacement(struct btree *b,
 {
 	struct btree *n = bch_btree_node_alloc(b->c, op, b->level, b->parent);
 
-	if (!IS_ERR_OR_NULL(n)) {
+	if (!IS_ERR(n)) {
 		mutex_lock(&n->write_lock);
 		bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
 		bkey_copy_key(&n->key, &b->key);
@@ -1340,7 +1340,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 	memset(new_nodes, 0, sizeof(new_nodes));
 	closure_init_stack(&cl);
 
-	while (nodes < GC_MERGE_NODES && !IS_ERR_OR_NULL(r[nodes].b))
+	while (nodes < GC_MERGE_NODES && !IS_ERR(r[nodes].b))
 		keys += r[nodes++].keys;
 
 	blocks = btree_default_blocks(b->c) * 2 / 3;
@@ -1352,7 +1352,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 
 	for (i = 0; i < nodes; i++) {
 		new_nodes[i] = btree_node_alloc_replacement(r[i].b, NULL);
-		if (IS_ERR_OR_NULL(new_nodes[i]))
+		if (IS_ERR(new_nodes[i]))
 			goto out_nocoalesce;
 	}
 
@@ -1487,7 +1487,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 	bch_keylist_free(&keylist);
 
 	for (i = 0; i < nodes; i++)
-		if (!IS_ERR_OR_NULL(new_nodes[i])) {
+		if (!IS_ERR(new_nodes[i])) {
 			btree_node_free(new_nodes[i]);
 			rw_unlock(true, new_nodes[i]);
 		}
@@ -1669,7 +1669,7 @@ static int bch_btree_gc_root(struct btree *b, struct btree_op *op,
 	if (should_rewrite) {
 		n = btree_node_alloc_replacement(b, NULL);
 
-		if (!IS_ERR_OR_NULL(n)) {
+		if (!IS_ERR(n)) {
 			bch_btree_node_write_sync(n);
 
 			bch_btree_set_root(n);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..7660962e7b8b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1724,7 +1724,7 @@ static void cache_set_flush(struct closure *cl)
 	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
 
-	if (!IS_ERR_OR_NULL(c->root))
+	if (!IS_ERR(c->root))
 		list_add(&c->root->list, &c->btree_cache);
 
 	/*
@@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
 
 		err = "cannot allocate new btree root";
 		c->root = __bch_btree_node_alloc(c, NULL, 0, true, NULL);
-		if (IS_ERR_OR_NULL(c->root))
+		if (IS_ERR(c->root))
 			goto err;
 
 		mutex_lock(&c->root->write_lock);
-- 
2.25.1

