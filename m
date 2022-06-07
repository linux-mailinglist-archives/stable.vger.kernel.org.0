Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9740C541022
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351691AbiFGTSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356044AbiFGTRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:17:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBFF3526A;
        Tue,  7 Jun 2022 11:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FF50B81F38;
        Tue,  7 Jun 2022 18:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA217C34119;
        Tue,  7 Jun 2022 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625286;
        bh=v9GulALvy4HeZE827ZxtExdyhVtIrBFdZq9NnG5OvXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvmNY7F9H2Gmm3wv0cEw/4ivCgDVcFd9OaK8X90JNRHYMT0ql6nUDv4abZVuFKVeX
         EaUSOfKXzHPIiQZT71/XY04s/ZuJkb7CJ+E6lUkj/fbWNsSu6tX4+ABs0yQejlXF7M
         41DIGCL0gK9BEYTKHbBZ57Td0/3EK6yLBhvtwGgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 632/667] bcache: avoid journal no-space deadlock by reserving 1 journal bucket
Date:   Tue,  7 Jun 2022 19:04:57 +0200
Message-Id: <20220607164953.621118340@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 upstream.

The journal no-space deadlock was reported time to time. Such deadlock
can happen in the following situation.

When all journal buckets are fully filled by active jset with heavy
write I/O load, the cache set registration (after a reboot) will load
all active jsets and inserting them into the btree again (which is
called journal replay). If a journaled bkey is inserted into a btree
node and results btree node split, new journal request might be
triggered. For example, the btree grows one more level after the node
split, then the root node record in cache device super block will be
upgrade by bch_journal_meta() from bch_btree_set_root(). But there is no
space in journal buckets, the journal replay has to wait for new journal
bucket to be reclaimed after at least one journal bucket replayed. This
is one example that how the journal no-space deadlock happens.

The solution to avoid the deadlock is to reserve 1 journal bucket in
run time, and only permit the reserved journal bucket to be used during
cache set registration procedure for things like journal replay. Then
the journal space will never be fully filled, there is no chance for
journal no-space deadlock to happen anymore.

This patch adds a new member "bool do_reserve" in struct journal, it is
inititalized to 0 (false) when struct journal is allocated, and set to
1 (true) by bch_journal_space_reserve() when all initialization done in
run_cache_set(). In the run time when journal_reclaim() tries to
allocate a new journal bucket, free_journal_buckets() is called to check
whether there are enough free journal buckets to use. If there is only
1 free journal bucket and journal->do_reserve is 1 (true), the last
bucket is reserved and free_journal_buckets() will return 0 to indicate
no free journal bucket. Then journal_reclaim() will give up, and try
next time to see whetheer there is free journal bucket to allocate. By
this method, there is always 1 jouranl bucket reserved in run time.

During the cache set registration, journal->do_reserve is 0 (false), so
the reserved journal bucket can be used to avoid the no-space deadlock.

Reported-by: Nikhil Kshirsagar <nkshirsagar@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220524102336.10684-5-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/journal.c |   31 ++++++++++++++++++++++++++-----
 drivers/md/bcache/journal.h |    2 ++
 drivers/md/bcache/super.c   |    1 +
 3 files changed, 29 insertions(+), 5 deletions(-)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -407,6 +407,11 @@ err:
 	return ret;
 }
 
+void bch_journal_space_reserve(struct journal *j)
+{
+	j->do_reserve = true;
+}
+
 /* Journalling */
 
 static void btree_flush_write(struct cache_set *c)
@@ -625,12 +630,30 @@ static void do_journal_discard(struct ca
 	}
 }
 
+static unsigned int free_journal_buckets(struct cache_set *c)
+{
+	struct journal *j = &c->journal;
+	struct cache *ca = c->cache;
+	struct journal_device *ja = &c->cache->journal;
+	unsigned int n;
+
+	/* In case njournal_buckets is not power of 2 */
+	if (ja->cur_idx >= ja->discard_idx)
+		n = ca->sb.njournal_buckets +  ja->discard_idx - ja->cur_idx;
+	else
+		n = ja->discard_idx - ja->cur_idx;
+
+	if (n > (1 + j->do_reserve))
+		return n - (1 + j->do_reserve);
+
+	return 0;
+}
+
 static void journal_reclaim(struct cache_set *c)
 {
 	struct bkey *k = &c->journal.key;
 	struct cache *ca = c->cache;
 	uint64_t last_seq;
-	unsigned int next;
 	struct journal_device *ja = &ca->journal;
 	atomic_t p __maybe_unused;
 
@@ -653,12 +676,10 @@ static void journal_reclaim(struct cache
 	if (c->journal.blocks_free)
 		goto out;
 
-	next = (ja->cur_idx + 1) % ca->sb.njournal_buckets;
-	/* No space available on this device */
-	if (next == ja->discard_idx)
+	if (!free_journal_buckets(c))
 		goto out;
 
-	ja->cur_idx = next;
+	ja->cur_idx = (ja->cur_idx + 1) % ca->sb.njournal_buckets;
 	k->ptr[0] = MAKE_PTR(0,
 			     bucket_to_sector(c, ca->sb.d[ja->cur_idx]),
 			     ca->sb.nr_this_dev);
--- a/drivers/md/bcache/journal.h
+++ b/drivers/md/bcache/journal.h
@@ -105,6 +105,7 @@ struct journal {
 	spinlock_t		lock;
 	spinlock_t		flush_write_lock;
 	bool			btree_flushing;
+	bool			do_reserve;
 	/* used when waiting because the journal was full */
 	struct closure_waitlist	wait;
 	struct closure		io;
@@ -182,5 +183,6 @@ int bch_journal_replay(struct cache_set
 
 void bch_journal_free(struct cache_set *c);
 int bch_journal_alloc(struct cache_set *c);
+void bch_journal_space_reserve(struct journal *j);
 
 #endif /* _BCACHE_JOURNAL_H */
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2131,6 +2131,7 @@ static int run_cache_set(struct cache_se
 
 	flash_devs_run(c);
 
+	bch_journal_space_reserve(&c->journal);
 	set_bit(CACHE_SET_RUNNING, &c->flags);
 	return 0;
 err:


