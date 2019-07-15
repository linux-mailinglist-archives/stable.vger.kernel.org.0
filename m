Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1574696F3
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbfGON6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733136AbfGON6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:22 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8633217D9;
        Mon, 15 Jul 2019 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199101;
        bh=HB0QchJTclaI1AaR+DYkMuk+3q8igeEzPd6lClLogWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apBw2y6+tXST6+/HQ8Hba0INxUoelUUKlCduviOW5P/E0+KwBfIi6F4xmuHISgASb
         iC9jdSQg4sY5iyPnjnSalKtGAm0tYCcBxqAx4h6iSs/4bK2qm32bB82f4C90Y9FG5a
         VkrvL+I3gHo4UAveWKupDMjigBB/NWJ16dXKS7ro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 193/249] bcache: check CACHE_SET_IO_DISABLE in allocator code
Date:   Mon, 15 Jul 2019 09:45:58 -0400
Message-Id: <20190715134655.4076-193-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit e775339e1ae1205b47d94881db124c11385e597c ]

If CACHE_SET_IO_DISABLE of a cache set flag is set by too many I/O
errors, currently allocator routines can still continue allocate
space which may introduce inconsistent metadata state.

This patch checkes CACHE_SET_IO_DISABLE bit in following allocator
routines,
- bch_bucket_alloc()
- __bch_bucket_alloc_set()
Once CACHE_SET_IO_DISABLE is set on cache set, the allocator routines
may reject allocation request earlier to avoid potential inconsistent
metadata.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index f8986effcb50..6f776823b9ba 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -393,6 +393,11 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 	struct bucket *b;
 	long r;
 
+
+	/* No allocation if CACHE_SET_IO_DISABLE bit is set */
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &ca->set->flags)))
+		return -1;
+
 	/* fastpath */
 	if (fifo_pop(&ca->free[RESERVE_NONE], r) ||
 	    fifo_pop(&ca->free[reserve], r))
@@ -484,6 +489,10 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
 {
 	int i;
 
+	/* No allocation if CACHE_SET_IO_DISABLE bit is set */
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags)))
+		return -1;
+
 	lockdep_assert_held(&c->bucket_lock);
 	BUG_ON(!n || n > c->caches_loaded || n > MAX_CACHES_PER_SET);
 
-- 
2.20.1

