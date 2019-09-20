Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E06BB92D1
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392093AbfITOfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36018 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388112AbfITOZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0004xe-Qu; Fri, 20 Sep 2019 15:25:00 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007sf-Be; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Coly Li" <colyli@suse.de>, "Jens Axboe" <axboe@kernel.dk>,
        "Hannes Reinecke" <hare@suse.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.117364865@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 051/132] bcache: never set KEY_PTRS of journal key to
 0 in journal_reclaim()
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/bcache/journal.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -507,11 +507,11 @@ static void journal_reclaim(struct cache
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
@@ -635,6 +635,9 @@ static void journal_write_unlocked(struc
 		ca->journal.seq[ca->journal.cur_idx] = w->data->seq;
 	}
 
+	/* If KEY_PTRS(k) == 0, this jset gets lost in air */
+	BUG_ON(i == 0);
+
 	atomic_dec_bug(&fifo_back(&c->journal.pin));
 	bch_journal_next(&c->journal);
 	journal_reclaim(c);

