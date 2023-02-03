Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED9688D0C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBCC2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBCC2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:28:12 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64E8C36471;
        Thu,  2 Feb 2023 18:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Ezq48
        SMfSzSfU6vEdNHKpwfR4sSbk6riVgvGC0cf2ec=; b=Nj4sq7h/LlJ/oGmvFBB3q
        w/DVWM+HekdCCSnK5XqEeDd/aBUVYLMuxtFF7dH7kp2q1lxVkZOGROsNX41dxDp2
        eEyDfFIIHZtgA6PMH0ZHI5ZhV87j2PWht2Fm/SiildhQG2wI4itM8B+Vpn1W8FyB
        UcBiizNP2Tw+KKB1H8Rrp4=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g2-0 (Coremail) with SMTP id _____wDn5Kwwcdxj1juOCg--.53946S2;
        Fri, 03 Feb 2023 10:28:00 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     colyli@suse.de
Cc:     stable@vger.kernel.org, hackerzheng666@gmail.com,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] bcache: Remove some unnecessary NULL point check for the return value of __bch_btree_node_alloc-related pointer
Date:   Fri,  3 Feb 2023 10:27:59 +0800
Message-Id: <20230203022759.576832-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDn5Kwwcdxj1juOCg--.53946S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4UGry5ArWfXrW5Gr15Arb_yoW8Zw1UpF
        W29ry3A34kWr4UCr98C3W0vFyrZw12vFWUGr93u3WfZr9rZr1rCFWj9ryUZrWUurWxWF42
        vr40yw1UXr4UtF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziI385UUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXBILU1Xl5gKj0gAAsz
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
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/md/bcache/btree.c | 6 +++---
 drivers/md/bcache/super.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..417cd7c436c4 100644
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
@@ -1352,7 +1352,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 
 	for (i = 0; i < nodes; i++) {
 		new_nodes[i] = btree_node_alloc_replacement(r[i].b, NULL);
-		if (IS_ERR_OR_NULL(new_nodes[i]))
+		if (IS_ERR(new_nodes[i]))
 			goto out_nocoalesce;
 	}
 
@@ -1669,7 +1669,7 @@ static int bch_btree_gc_root(struct btree *b, struct btree_op *op,
 	if (should_rewrite) {
 		n = btree_node_alloc_replacement(b, NULL);
 
-		if (!IS_ERR_OR_NULL(n)) {
+		if (!IS_ERR(n)) {
 			bch_btree_node_write_sync(n);
 
 			bch_btree_set_root(n);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..92de714fe75e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
 
 		err = "cannot allocate new btree root";
 		c->root = __bch_btree_node_alloc(c, NULL, 0, true, NULL);
-		if (IS_ERR_OR_NULL(c->root))
+		if (IS_ERR(c->root))
 			goto err;
 
 		mutex_lock(&c->root->write_lock);
-- 
2.25.1

