Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E15B2060
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390755AbfIMNVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390762AbfIMNVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:12 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B72A206BB;
        Fri, 13 Sep 2019 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380871;
        bh=AMZNhUAgLN5JSZUaCop1kSrYTIzX+WNofQb1lm193GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSA3zdORMdR881chBMu+z9RGLzjXUyuaoCMWjtk2ogzlSwB344as2s4w2PCwWbjuk
         zq+f7EwbXnQgL2C3kG9rK1/jVR6TPZnfXI+elvdfZAqSoVICtglcgAnitJyCwqY9P8
         K3dleLu98VoeACyx/8fqjKrMLX9ifDK0L8KA5vv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 18/37] bcache: only clear BTREE_NODE_dirty bit when it is set
Date:   Fri, 13 Sep 2019 14:07:23 +0100
Message-Id: <20190913130518.464380069@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



