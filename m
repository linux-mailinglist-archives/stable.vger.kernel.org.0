Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC9A6F8B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbfICQc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731398AbfICQcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:32:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7B412343A;
        Tue,  3 Sep 2019 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528325;
        bh=yTa37E69ew+PyFM9YaEtmaGvfFlvf1Qrwn5zd/5ae4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qw0JMBOqgVsdSNt8nsfYPC86pvlIMuAwIPse9eerNzhGDErg+H1a7AZqnei4JfO2R
         yNdNEP3Gm89ItPIlZuZbs092/x2hqSwc94eR59rln5kIfo0d30hTe41l+ZfEevxLrk
         THSJwCu0LRwN0jeYc1bzw2kA1Z7BdMdB7sDhhvrw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 157/167] bcache: only clear BTREE_NODE_dirty bit when it is set
Date:   Tue,  3 Sep 2019 12:25:09 -0400
Message-Id: <20190903162519.7136-157-sashal@kernel.org>
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

[ Upstream commit e5ec5f4765ada9c75fb3eee93a6e72f0e50599d5 ]

In bch_btree_cache_free() and btree_node_free(), BTREE_NODE_dirty is
always set no matter btree node is dirty or not. The code looks like
this,
	if (btree_node_dirty(b))
		btree_complete_write(b, btree_current_write(b));
	clear_bit(BTREE_NODE_dirty, &b->flags);

Indeed if btree_node_dirty(b) returns false, it means BTREE_NODE_dirty
bit is cleared, then it is unnecessary to clear the bit again.

This patch only clears BTREE_NODE_dirty when btree_node_dirty(b) is
true (the bit is set), to save a few CPU cycles.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/btree.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 3f4211b5cd334..8c80833e73a9a 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -772,10 +772,10 @@ void bch_btree_cache_free(struct cache_set *c)
 	while (!list_empty(&c->btree_cache)) {
 		b = list_first_entry(&c->btree_cache, struct btree, list);
 
-		if (btree_node_dirty(b))
+		if (btree_node_dirty(b)) {
 			btree_complete_write(b, btree_current_write(b));
-		clear_bit(BTREE_NODE_dirty, &b->flags);
-
+			clear_bit(BTREE_NODE_dirty, &b->flags);
+		}
 		mca_data_free(b);
 	}
 
@@ -1063,9 +1063,10 @@ static void btree_node_free(struct btree *b)
 
 	mutex_lock(&b->write_lock);
 
-	if (btree_node_dirty(b))
+	if (btree_node_dirty(b)) {
 		btree_complete_write(b, btree_current_write(b));
-	clear_bit(BTREE_NODE_dirty, &b->flags);
+		clear_bit(BTREE_NODE_dirty, &b->flags);
+	}
 
 	mutex_unlock(&b->write_lock);
 
-- 
2.20.1

