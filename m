Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B4DA6E0A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfICQY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfICQY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:24:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C6A23431;
        Tue,  3 Sep 2019 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527866;
        bh=PRw3RDuhrCa64X2CNf+loXfXKXVaqK0V7MFX6ZrbaBY=;
        h=From:To:Cc:Subject:Date:From;
        b=rP2Ry4O3QsjL3OUMIhsW2E2NT/d3uio4qLoLPUy3mbcRiGkU0vyFBbu/5cTEsOqM2
         V+yI6fc1lCwXrGkgmToYE46BLT6+OmX09vI1U4eCn7QRdJZ6z9NIaVsGARvK22rcqD
         XXKQXwagNJPEONxgi811zQ96a+i5d4U0WrStXtug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 01/23] bcache: only clear BTREE_NODE_dirty bit when it is set
Date:   Tue,  3 Sep 2019 12:24:02 -0400
Message-Id: <20190903162424.6877-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

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
---
 drivers/md/bcache/btree.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 773f5fdad25fb..3fbadf2058a65 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -778,10 +778,10 @@ void bch_btree_cache_free(struct cache_set *c)
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
 
@@ -1069,9 +1069,10 @@ static void btree_node_free(struct btree *b)
 
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

