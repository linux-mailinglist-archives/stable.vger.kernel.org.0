Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80DAA6F88
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfICQcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbfICQcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:32:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E937B215EA;
        Tue,  3 Sep 2019 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528326;
        bh=7HxUsZrCC2YuuEWP5G+vrf5uHsWvNtSyhSzk/oGK5fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VdV5xGAgH8K9lIvrhSBy7fWVUQ0zuDHCoqzKDEwNnSXH93Yg8LjajSDjawEhkV7v
         tL9qM8P+ppGxyzkjfhHn36txzDA7GZ8qSeyCMxnSEtBjGt/JZYWPzLdJWcFfIPWXom
         EUovq4RZtyxHXn6KfEdv8Ez2pHmNZT262bw/Y5T8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 158/167] bcache: add comments for mutex_lock(&b->write_lock)
Date:   Tue,  3 Sep 2019 12:25:10 -0400
Message-Id: <20190903162519.7136-158-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 41508bb7d46b74dba631017e5a702a86caf1db8c ]

When accessing or modifying BTREE_NODE_dirty bit, it is not always
necessary to acquire b->write_lock. In bch_btree_cache_free() and
mca_reap() acquiring b->write_lock is necessary, and this patch adds
comments to explain why mutex_lock(&b->write_lock) is necessary for
checking or clearing BTREE_NODE_dirty bit there.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/btree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 8c80833e73a9a..e0468fd41b6ea 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -649,6 +649,11 @@ static int mca_reap(struct btree *b, unsigned int min_order, bool flush)
 		up(&b->io_mutex);
 	}
 
+	/*
+	 * BTREE_NODE_dirty might be cleared in btree_flush_btree() by
+	 * __bch_btree_node_write(). To avoid an extra flush, acquire
+	 * b->write_lock before checking BTREE_NODE_dirty bit.
+	 */
 	mutex_lock(&b->write_lock);
 	if (btree_node_dirty(b))
 		__bch_btree_node_write(b, &cl);
@@ -772,6 +777,11 @@ void bch_btree_cache_free(struct cache_set *c)
 	while (!list_empty(&c->btree_cache)) {
 		b = list_first_entry(&c->btree_cache, struct btree, list);
 
+		/*
+		 * This function is called by cache_set_free(), no I/O
+		 * request on cache now, it is unnecessary to acquire
+		 * b->write_lock before clearing BTREE_NODE_dirty anymore.
+		 */
 		if (btree_node_dirty(b)) {
 			btree_complete_write(b, btree_current_write(b));
 			clear_bit(BTREE_NODE_dirty, &b->flags);
-- 
2.20.1

