Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA8AB3A9F0
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbfFIQ4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732932AbfFIQ4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:56:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6390207E0;
        Sun,  9 Jun 2019 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099374;
        bh=t8+aEphbJ7n7GugeXeIFEvlLemjYYNP6cZfeKKQBKm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGMJKHC2TDxcq27HO3HM9Q7O9HlwIYcymxM4/P6Se8+XauzhCLTb28cPj78E2PTxH
         /vLwjZhhwfWmtuC0Bdx+/wt808gjCQyIFi0GJYC0HOIHByOQzQQMsgAtiMitAPqqKX
         uxwFH9DpoyZWvvqK+AMRJYHThSH3Ui9CXVH2r8aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.4 020/241] bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()
Date:   Sun,  9 Jun 2019 18:39:22 +0200
Message-Id: <20190609164148.365791808@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 1bee2addc0c8470c8aaa65ef0599eeae96dd88bc upstream.

In journal_reclaim() ja->cur_idx of each cache will be update to
reclaim available journal buckets. Variable 'int n' is used to count how
many cache is successfully reclaimed, then n is set to c->journal.key
by SET_KEY_PTRS(). Later in journal_write_unlocked(), a for_each_cache()
loop will write the jset data onto each cache.

The problem is, if all jouranl buckets on each cache is full, the
following code in journal_reclaim(),

529 for_each_cache(ca, c, iter) {
530       struct journal_device *ja = &ca->journal;
531       unsigned int next = (ja->cur_idx + 1) % ca->sb.njournal_buckets;
532
533       /* No space available on this device */
534       if (next == ja->discard_idx)
535               continue;
536
537       ja->cur_idx = next;
538       k->ptr[n++] = MAKE_PTR(0,
539                         bucket_to_sector(c, ca->sb.d[ja->cur_idx]),
540                         ca->sb.nr_this_dev);
541 }
542
543 bkey_init(k);
544 SET_KEY_PTRS(k, n);

If there is no available bucket to reclaim, the if() condition at line
534 will always true, and n remains 0. Then at line 544, SET_KEY_PTRS()
will set KEY_PTRS field of c->journal.key to 0.

Setting KEY_PTRS field of c->journal.key to 0 is wrong. Because in
journal_write_unlocked() the journal data is written in following loop,

649	for (i = 0; i < KEY_PTRS(k); i++) {
650-671		submit journal data to cache device
672	}

If KEY_PTRS field is set to 0 in jouranl_reclaim(), the journal data
won't be written to cache device here. If system crahed or rebooted
before bkeys of the lost journal entries written into btree nodes, data
corruption will be reported during bcache reload after rebooting the
system.

Indeed there is only one cache in a cache set, there is no need to set
KEY_PTRS field in journal_reclaim() at all. But in order to keep the
for_each_cache() logic consistent for now, this patch fixes the above
problem by not setting 0 KEY_PTRS of journal key, if there is no bucket
available to reclaim.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/journal.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -513,11 +513,11 @@ static void journal_reclaim(struct cache
 				  ca->sb.nr_this_dev);
 	}
 
-	bkey_init(k);
-	SET_KEY_PTRS(k, n);
-
-	if (n)
+	if (n) {
+		bkey_init(k);
+		SET_KEY_PTRS(k, n);
 		c->journal.blocks_free = c->sb.bucket_size >> c->block_bits;
+	}
 out:
 	if (!journal_full(&c->journal))
 		__closure_wake_up(&c->journal.wait);
@@ -641,6 +641,9 @@ static void journal_write_unlocked(struc
 		ca->journal.seq[ca->journal.cur_idx] = w->data->seq;
 	}
 
+	/* If KEY_PTRS(k) == 0, this jset gets lost in air */
+	BUG_ON(i == 0);
+
 	atomic_dec_bug(&fifo_back(&c->journal.pin));
 	bch_journal_next(&c->journal);
 	journal_reclaim(c);


