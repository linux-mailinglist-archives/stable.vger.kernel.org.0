Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFB214F81C
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 15:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgBAOnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 09:43:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:59104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgBAOnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Feb 2020 09:43:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2A441AAFD;
        Sat,  1 Feb 2020 14:43:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org,
        Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 3/5] bcache: add readahead cache policy options via sysfs interface
Date:   Sat,  1 Feb 2020 22:42:33 +0800
Message-Id: <20200201144235.94110-4-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200201144235.94110-1-colyli@suse.de>
References: <20200201144235.94110-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In year 2007 high performance SSD was still expensive, in order to
save more space for real workload or meta data, the readahead I/Os
for non-meta data was bypassed and not cached on SSD.

In now days, SSD price drops a lot and people can find larger size
SSD with more comfortable price. It is unncessary to alway bypass
normal readahead I/Os to save SSD space for now.

This patch adds options for readahead data cache policies via sysfs
file /sys/block/bcache<N>/readahead_cache_policy, the options are,
- "all": cache all readahead data I/Os.
- "meta-only": only cache meta data, and bypass other regular I/Os.

If users want to make bcache continue to only cache readahead request
for metadata and bypass regular data readahead, please set "meta-only"
to this sysfs file. By default, bcache will back to cache all read-
ahead requests now.

Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Acked-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/bcache.h  |  3 +++
 drivers/md/bcache/request.c | 17 ++++++++++++-----
 drivers/md/bcache/sysfs.c   | 22 ++++++++++++++++++++++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index adf26a21fcd1..74a9849ea164 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -330,6 +330,9 @@ struct cached_dev {
 	 */
 	atomic_t		has_dirty;
 
+#define BCH_CACHE_READA_ALL		0
+#define BCH_CACHE_READA_META_ONLY	1
+	unsigned int		cache_readahead_policy;
 	struct bch_ratelimit	writeback_rate;
 	struct delayed_work	writeback_rate_update;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 73478a91a342..820d8402a1dc 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -379,13 +379,20 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 		goto skip;
 
 	/*
-	 * Flag for bypass if the IO is for read-ahead or background,
-	 * unless the read-ahead request is for metadata
+	 * If the bio is for read-ahead or background IO, bypass it or
+	 * not depends on the following situations,
+	 * - If the IO is for meta data, always cache it and no bypass
+	 * - If the IO is not meta data, check dc->cache_reada_policy,
+	 *      BCH_CACHE_READA_ALL: cache it and not bypass
+	 *      BCH_CACHE_READA_META_ONLY: not cache it and bypass
+	 * That is, read-ahead request for metadata always get cached
 	 * (eg, for gfs2 or xfs).
 	 */
-	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
-	    !(bio->bi_opf & (REQ_META|REQ_PRIO)))
-		goto skip;
+	if ((bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))) {
+		if (!(bio->bi_opf & (REQ_META|REQ_PRIO)) &&
+		    (dc->cache_readahead_policy != BCH_CACHE_READA_ALL))
+			goto skip;
+	}
 
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
 	    bio_sectors(bio) & (c->sb.block_size - 1)) {
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 733e2ddf3c78..3470fae4eabc 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -27,6 +27,12 @@ static const char * const bch_cache_modes[] = {
 	NULL
 };
 
+static const char * const bch_reada_cache_policies[] = {
+	"all",
+	"meta-only",
+	NULL
+};
+
 /* Default is 0 ("auto") */
 static const char * const bch_stop_on_failure_modes[] = {
 	"auto",
@@ -100,6 +106,7 @@ rw_attribute(congested_write_threshold_us);
 rw_attribute(sequential_cutoff);
 rw_attribute(data_csum);
 rw_attribute(cache_mode);
+rw_attribute(readahead_cache_policy);
 rw_attribute(stop_when_cache_set_failed);
 rw_attribute(writeback_metadata);
 rw_attribute(writeback_running);
@@ -168,6 +175,11 @@ SHOW(__bch_cached_dev)
 					       bch_cache_modes,
 					       BDEV_CACHE_MODE(&dc->sb));
 
+	if (attr == &sysfs_readahead_cache_policy)
+		return bch_snprint_string_list(buf, PAGE_SIZE,
+					      bch_reada_cache_policies,
+					      dc->cache_readahead_policy);
+
 	if (attr == &sysfs_stop_when_cache_set_failed)
 		return bch_snprint_string_list(buf, PAGE_SIZE,
 					       bch_stop_on_failure_modes,
@@ -353,6 +365,15 @@ STORE(__cached_dev)
 		}
 	}
 
+	if (attr == &sysfs_readahead_cache_policy) {
+		v = __sysfs_match_string(bch_reada_cache_policies, -1, buf);
+		if (v < 0)
+			return v;
+
+		if ((unsigned int) v != dc->cache_readahead_policy)
+			dc->cache_readahead_policy = v;
+	}
+
 	if (attr == &sysfs_stop_when_cache_set_failed) {
 		v = __sysfs_match_string(bch_stop_on_failure_modes, -1, buf);
 		if (v < 0)
@@ -467,6 +488,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_data_csum,
 #endif
 	&sysfs_cache_mode,
+	&sysfs_readahead_cache_policy,
 	&sysfs_stop_when_cache_set_failed,
 	&sysfs_writeback_metadata,
 	&sysfs_writeback_running,
-- 
2.16.4

