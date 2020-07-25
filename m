Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B565C22D73C
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 14:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgGYMDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 08:03:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:52272 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5373DAEAF;
        Sat, 25 Jul 2020 12:03:07 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, Ken Raeburn <raeburn@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 08/25] bcache: fix overflow in offset_to_stripe()
Date:   Sat, 25 Jul 2020 20:00:22 +0800
Message-Id: <20200725120039.91071-9-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

offset_to_stripe() returns the stripe number (in type unsigned int) from
an offset (in type uint64_t) by the following calculation,
	do_div(offset, d->stripe_size);
For large capacity backing device (e.g. 18TB) with small stripe size
(e.g. 4KB), the result is 4831838208 and exceeds UINT_MAX. The actual
returned value which caller receives is 536870912, due to the overflow.

Indeed in bcache_device_init(), bcache_device->nr_stripes is limited in
range [1, INT_MAX]. Therefore all valid stripe numbers in bcache are
in range [0, bcache_dev->nr_stripes - 1].

This patch adds a upper limition check in offset_to_stripe(): the max
valid stripe number should be less than bcache_device->nr_stripes. If
the calculated stripe number from do_div() is equal to or larger than
bcache_device->nr_stripe, -EINVAL will be returned. (Normally nr_stripes
is less than INT_MAX, exceeding upper limitation doesn't mean overflow,
therefore -EOVERFLOW is not used as error code.)

This patch also changes nr_stripes' type of struct bcache_device from
'unsigned int' to 'int', and return value type of offset_to_stripe()
from 'unsigned int' to 'int', to match their exact data ranges.

All locations where bcache_device->nr_stripes and offset_to_stripe() are
referenced also get updated for the above type change.

Reported-and-tested-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1783075
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/bcache.h    |  2 +-
 drivers/md/bcache/writeback.c | 14 +++++++++-----
 drivers/md/bcache/writeback.h | 19 +++++++++++++++++--
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 221e0191b687..80e3c4813fb0 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -264,7 +264,7 @@ struct bcache_device {
 #define BCACHE_DEV_UNLINK_DONE		2
 #define BCACHE_DEV_WB_RUNNING		3
 #define BCACHE_DEV_RATE_DW_RUNNING	4
-	unsigned int		nr_stripes;
+	int			nr_stripes;
 	unsigned int		stripe_size;
 	atomic_t		*stripe_sectors_dirty;
 	unsigned long		*full_dirty_stripes;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 5397a2c5d6cc..4f4ad6b3d43a 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -521,15 +521,19 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 				  uint64_t offset, int nr_sectors)
 {
 	struct bcache_device *d = c->devices[inode];
-	unsigned int stripe_offset, stripe, sectors_dirty;
+	unsigned int stripe_offset, sectors_dirty;
+	int stripe;
 
 	if (!d)
 		return;
 
+	stripe = offset_to_stripe(d, offset);
+	if (stripe < 0)
+		return;
+
 	if (UUID_FLASH_ONLY(&c->uuids[inode]))
 		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
 
-	stripe = offset_to_stripe(d, offset);
 	stripe_offset = offset & (d->stripe_size - 1);
 
 	while (nr_sectors) {
@@ -569,12 +573,12 @@ static bool dirty_pred(struct keybuf *buf, struct bkey *k)
 static void refill_full_stripes(struct cached_dev *dc)
 {
 	struct keybuf *buf = &dc->writeback_keys;
-	unsigned int start_stripe, stripe, next_stripe;
+	unsigned int start_stripe, next_stripe;
+	int stripe;
 	bool wrapped = false;
 
 	stripe = offset_to_stripe(&dc->disk, KEY_OFFSET(&buf->last_scanned));
-
-	if (stripe >= dc->disk.nr_stripes)
+	if (stripe < 0)
 		stripe = 0;
 
 	start_stripe = stripe;
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index b029843ce5b6..3f1230e22de0 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -52,10 +52,22 @@ static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
 	return ret;
 }
 
-static inline unsigned int offset_to_stripe(struct bcache_device *d,
+static inline int offset_to_stripe(struct bcache_device *d,
 					uint64_t offset)
 {
 	do_div(offset, d->stripe_size);
+
+	/* d->nr_stripes is in range [1, INT_MAX] */
+	if (unlikely(offset >= d->nr_stripes)) {
+		pr_err("Invalid stripe %llu (>= nr_stripes %d).\n",
+			offset, d->nr_stripes);
+		return -EINVAL;
+	}
+
+	/*
+	 * Here offset is definitly smaller than INT_MAX,
+	 * return it as int will never overflow.
+	 */
 	return offset;
 }
 
@@ -63,7 +75,10 @@ static inline bool bcache_dev_stripe_dirty(struct cached_dev *dc,
 					   uint64_t offset,
 					   unsigned int nr_sectors)
 {
-	unsigned int stripe = offset_to_stripe(&dc->disk, offset);
+	int stripe = offset_to_stripe(&dc->disk, offset);
+
+	if (stripe < 0)
+		return false;
 
 	while (1) {
 		if (atomic_read(dc->disk.stripe_sectors_dirty + stripe))
-- 
2.26.2

