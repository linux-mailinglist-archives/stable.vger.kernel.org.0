Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33E1157762
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgBJM74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbgBJMlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE25924650;
        Mon, 10 Feb 2020 12:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338463;
        bh=Tvf4txON6eeUtHEOdVEOOBvXVy6B/tu1BYD/Xx9UAUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdpWC0eTTMqHmvLYkJ+G8hDseq9mOvD6J/KbvdN+GZupfEIio5PgSyX2O/ARbCO5c
         eAmd0sbvT/D8UQ3ghKLa/gCvwkzw0A3biR6K+1tqb79GMmJFV1ZC2xr9dXBKaby41s
         YqkmbiHQoGGX4ql5D4LEkgXwUUU0DNKhqtooehTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Eric Wheeler <bcache@linux.ewheeler.net>,
        Michael Lyle <mlyle@lyle.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 222/367] bcache: add readahead cache policy options via sysfs interface
Date:   Mon, 10 Feb 2020 04:32:15 -0800
Message-Id: <20200210122444.562098668@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 038ba8cc1bffc51250add4a9b9249d4331576d8f upstream.

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bcache.h  |    3 +++
 drivers/md/bcache/request.c |   17 ++++++++++++-----
 drivers/md/bcache/sysfs.c   |   22 ++++++++++++++++++++++
 3 files changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -329,6 +329,9 @@ struct cached_dev {
 	 */
 	atomic_t		has_dirty;
 
+#define BCH_CACHE_READA_ALL		0
+#define BCH_CACHE_READA_META_ONLY	1
+	unsigned int		cache_readahead_policy;
 	struct bch_ratelimit	writeback_rate;
 	struct delayed_work	writeback_rate_update;
 
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -379,13 +379,20 @@ static bool check_should_bypass(struct c
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
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -27,6 +27,12 @@ static const char * const bch_cache_mode
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
@@ -100,6 +106,7 @@ rw_attribute(congested_write_threshold_u
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
@@ -467,6 +488,7 @@ static struct attribute *bch_cached_dev_
 	&sysfs_data_csum,
 #endif
 	&sysfs_cache_mode,
+	&sysfs_readahead_cache_policy,
 	&sysfs_stop_when_cache_set_failed,
 	&sysfs_writeback_metadata,
 	&sysfs_writeback_running,


