Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43A452FE7C
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 19:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343931AbiEURFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 13:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343827AbiEURFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 13:05:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6DD3BA6C;
        Sat, 21 May 2022 10:05:17 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DE8D721906;
        Sat, 21 May 2022 17:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653152715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wmJpe9/Kua8zJtz04nyJuieA4qrmKJ7yZERYmqpEk9U=;
        b=oHQiJSiJEVocFfhy2xcCHFcBG91Wk094UL5UNKocexe6T0GOGWtyHIaJXVTZiGBUcQmTF2
        bmTf5p/SWgpnwMQYIXmPy+jUI7udZF2OQuz2P/J+QldQSW/8pjwdDhLixdS/srtw0/9QgI
        52xNQnQGg3pLEIO7oL/a6Ysvx+dbyGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653152715;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wmJpe9/Kua8zJtz04nyJuieA4qrmKJ7yZERYmqpEk9U=;
        b=4zlsZ/aLs6m3i2Wc9rHtYae5NRuMFcWp6eNN0mB3GDMVWPBrhDu+N2urABsgqG2isYTIm5
        KpX8tWDFXmga9IBw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 189B72C141;
        Sat, 21 May 2022 17:05:13 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] bcache: avoid journal no-space deadlock by reserving 1 journal bucket
Date:   Sun, 22 May 2022 01:05:02 +0800
Message-Id: <20220521170502.20026-4-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220521170502.20026-1-colyli@suse.de>
References: <20220521170502.20026-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/md/bcache/journal.c | 31 ++++++++++++++++++++++++++-----
 drivers/md/bcache/journal.h |  2 ++
 drivers/md/bcache/super.c   |  1 +
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index df5347ea450b..e5da469a4235 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -405,6 +405,11 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 	return ret;
 }
 
+void bch_journal_space_reserve(struct journal *j)
+{
+	j->do_reserve = true;
+}
+
 /* Journalling */
 
 static void btree_flush_write(struct cache_set *c)
@@ -621,12 +626,30 @@ static void do_journal_discard(struct cache *ca)
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
 
@@ -649,12 +672,10 @@ static void journal_reclaim(struct cache_set *c)
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
diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
index f2ea34d5f431..cd316b4a1e95 100644
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
@@ -182,5 +183,6 @@ int bch_journal_replay(struct cache_set *c, struct list_head *list);
 
 void bch_journal_free(struct cache_set *c);
 int bch_journal_alloc(struct cache_set *c);
+void bch_journal_space_reserve(struct journal *j);
 
 #endif /* _BCACHE_JOURNAL_H */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index bf3de149d3c9..2bb55278d22d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2128,6 +2128,7 @@ static int run_cache_set(struct cache_set *c)
 
 	flash_devs_run(c);
 
+	bch_journal_space_reserve(&c->journal);
 	set_bit(CACHE_SET_RUNNING, &c->flags);
 	return 0;
 err:
-- 
2.35.3

