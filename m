Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746DA2F1429
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733272AbhAKNT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733267AbhAKNTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:19:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F14225AC;
        Mon, 11 Jan 2021 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371124;
        bh=lAjBZ1/oUW3xoJpMuVShWfXYTTmN2gH2t6LM5QOWYe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbGNc0O0RERe6GK5jMfxvsXaI6GLJz2gn3PUO73cDWfOhjkIMASIumaFl5ZOQWaqK
         qcvBw/xIY5XkkSRwPgbGHG2zm4xHBdPw97bfbgHBNn0WnwSWYtnRRzub8yt1cMTF6w
         72EFaNsf5p0YBGV5ARGSOWaW5iAiN5iQnyQxvV68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 134/145] bcache: introduce BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE for large bucket
Date:   Mon, 11 Jan 2021 14:02:38 +0100
Message-Id: <20210111130054.948103978@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit b16671e8f493e3df40b1fb0dff4078f391c5099a upstream.

When large bucket feature was added, BCH_FEATURE_INCOMPAT_LARGE_BUCKET
was introduced into the incompat feature set. It used bucket_size_hi
(which was added at the tail of struct cache_sb_disk) to extend current
16bit bucket size to 32bit with existing bucket_size in struct
cache_sb_disk.

This is not a good idea, there are two obvious problems,
- Bucket size is always value power of 2, if store log2(bucket size) in
  existing bucket_size of struct cache_sb_disk, it is unnecessary to add
  bucket_size_hi.
- Macro csum_set() assumes d[SB_JOURNAL_BUCKETS] is the last member in
  struct cache_sb_disk, bucket_size_hi was added after d[] which makes
  csum_set calculate an unexpected super block checksum.

To fix the above problems, this patch introduces a new incompat feature
bit BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE, when this bit is set, it
means bucket_size in struct cache_sb_disk stores the order of power-of-2
bucket size value. When user specifies a bucket size larger than 32768
sectors, BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE will be set to
incompat feature set, and bucket_size stores log2(bucket size) more
than store the real bucket size value.

The obsoleted BCH_FEATURE_INCOMPAT_LARGE_BUCKET won't be used anymore,
it is renamed to BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET and still only
recognized by kernel driver for legacy compatible purpose. The previous
bucket_size_hi is renmaed to obso_bucket_size_hi in struct cache_sb_disk
and not used in bcache-tools anymore.

For cache device created with BCH_FEATURE_INCOMPAT_LARGE_BUCKET feature,
bcache-tools and kernel driver still recognize the feature string and
display it as "obso_large_bucket".

With this change, the unnecessary extra space extend of bcache on-disk
super block can be avoided, and csum_set() may generate expected check
sum as well.

Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/features.c |    2 +-
 drivers/md/bcache/features.h |   11 ++++++++---
 drivers/md/bcache/super.c    |   22 +++++++++++++++++++---
 include/uapi/linux/bcache.h  |    2 +-
 4 files changed, 29 insertions(+), 8 deletions(-)

--- a/drivers/md/bcache/features.c
+++ b/drivers/md/bcache/features.c
@@ -17,7 +17,7 @@ struct feature {
 };
 
 static struct feature feature_list[] = {
-	{BCH_FEATURE_INCOMPAT, BCH_FEATURE_INCOMPAT_LARGE_BUCKET,
+	{BCH_FEATURE_INCOMPAT, BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE,
 		"large_bucket"},
 	{0, 0, 0 },
 };
--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -13,11 +13,15 @@
 
 /* Feature set definition */
 /* Incompat feature set */
-#define BCH_FEATURE_INCOMPAT_LARGE_BUCKET	0x0001 /* 32bit bucket size */
+/* 32bit bucket size, obsoleted */
+#define BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET		0x0001
+/* real bucket size is (1 << bucket_size) */
+#define BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE	0x0002
 
 #define BCH_FEATURE_COMPAT_SUPP		0
 #define BCH_FEATURE_RO_COMPAT_SUPP	0
-#define BCH_FEATURE_INCOMPAT_SUPP	BCH_FEATURE_INCOMPAT_LARGE_BUCKET
+#define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
+					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE)
 
 #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
 		((sb)->feature_compat & (mask))
@@ -77,7 +81,8 @@ static inline void bch_clear_feature_##n
 		~BCH##_FEATURE_INCOMPAT_##flagname; \
 }
 
-BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LARGE_BUCKET);
+BCH_FEATURE_INCOMPAT_FUNCS(obso_large_bucket, OBSO_LARGE_BUCKET);
+BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LOG_LARGE_BUCKET_SIZE);
 
 static inline bool bch_has_unknown_compat_features(struct cache_sb *sb)
 {
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -64,9 +64,25 @@ static unsigned int get_bucket_size(stru
 {
 	unsigned int bucket_size = le16_to_cpu(s->bucket_size);
 
-	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES &&
-	     bch_has_feature_large_bucket(sb))
-		bucket_size |= le16_to_cpu(s->bucket_size_hi) << 16;
+	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
+		if (bch_has_feature_large_bucket(sb)) {
+			unsigned int max, order;
+
+			max = sizeof(unsigned int) * BITS_PER_BYTE - 1;
+			order = le16_to_cpu(s->bucket_size);
+			/*
+			 * bcache tool will make sure the overflow won't
+			 * happen, an error message here is enough.
+			 */
+			if (order > max)
+				pr_err("Bucket size (1 << %u) overflows\n",
+					order);
+			bucket_size = 1 << order;
+		} else if (bch_has_feature_obso_large_bucket(sb)) {
+			bucket_size +=
+				le16_to_cpu(s->obso_bucket_size_hi) << 16;
+		}
+	}
 
 	return bucket_size;
 }
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -213,7 +213,7 @@ struct cache_sb_disk {
 		__le16		keys;
 	};
 	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
-	__le16			bucket_size_hi;
+	__le16			obso_bucket_size_hi;	/* obsoleted */
 };
 
 /*


