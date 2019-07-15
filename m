Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9FE6950D
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390159AbfGOO0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390045AbfGOO0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:26:02 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B920F2053B;
        Mon, 15 Jul 2019 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200761;
        bh=qgjNp5aYXio21vERJvdWZh3T3/lCkoGpDblXbDPkYJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CD9QzZTjVu9+tqWNJnNS+mz3JF/YEBOSWeImZhuOGou0CA1heTNbGhZPV46Hz/6UV
         06jNRfDOUkcJtHn4utQ6zZMEkteUc3h681zqQguDU5v+FBHBzGH+fqUt0MZzWYlF1F
         kX0JeIeklaLjOz/+wFQ4Z4uMIfqr41Zq5sHw2i/A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 124/158] bcache: check CACHE_SET_IO_DISABLE in allocator code
Date:   Mon, 15 Jul 2019 10:17:35 -0400
Message-Id: <20190715141809.8445-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
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
index de85b3af3b39..9c3beb1e382b 100644
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
 	BUG_ON(!n || n > c->caches_loaded || n > 8);
 
-- 
2.20.1

