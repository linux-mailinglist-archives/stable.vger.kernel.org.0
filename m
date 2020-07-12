Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD921CAD8
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgGLRry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 13:47:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:38550 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgGLRrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jul 2020 13:47:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6E64AD4B;
        Sun, 12 Jul 2020 17:47:53 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Ken Raeburn <raeburn@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] bcche: fix overflow in offset_to_stripe()
Date:   Mon, 13 Jul 2020 01:47:36 +0800
Message-Id: <20200712174736.9840-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200712174736.9840-1-colyli@suse.de>
References: <20200712174736.9840-1-colyli@suse.de>
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

This patch changes offset_to_stripe()'s return value from type unsigned
int to long int, and returns -EINVAL if do_div() result >= current max
stripe number bcache_device->nr_stripes. Because nr_stripe is in type
unsigned int, the non-negative return value will never overflow.

Reported-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1783075
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/writeback.c | 14 +++++++++-----
 drivers/md/bcache/writeback.h | 18 ++++++++++++++++--
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 5397a2c5d6cc..2de6e9260443 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -521,15 +521,19 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 				  uint64_t offset, int nr_sectors)
 {
 	struct bcache_device *d = c->devices[inode];
-	unsigned int stripe_offset, stripe, sectors_dirty;
+	unsigned int stripe_offset, sectors_dirty;
+	long stripe;
 
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
+	long stripe;
 	bool wrapped = false;
 
 	stripe = offset_to_stripe(&dc->disk, KEY_OFFSET(&buf->last_scanned));
-
-	if (stripe >= dc->disk.nr_stripes)
+	if (stripe < 0)
 		stripe = 0;
 
 	start_stripe = stripe;
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index b029843ce5b6..8550b984954a 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -52,10 +52,21 @@ static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
 	return ret;
 }
 
-static inline unsigned int offset_to_stripe(struct bcache_device *d,
+static inline long offset_to_stripe(struct bcache_device *d,
 					uint64_t offset)
 {
 	do_div(offset, d->stripe_size);
+
+	if (unlikely(offset >= d->nr_stripes)) {
+		pr_err("Invalid stripe %llu (>= nr_stripes %u).\n",
+			offset, d->nr_stripes);
+		return -EINVAL;
+	}
+
+	/*
+	 * Here offset is definitly smaller than UINT_MAX,
+	 * return it as long int will never overflow.
+	 */
 	return offset;
 }
 
@@ -63,7 +74,10 @@ static inline bool bcache_dev_stripe_dirty(struct cached_dev *dc,
 					   uint64_t offset,
 					   unsigned int nr_sectors)
 {
-	unsigned int stripe = offset_to_stripe(&dc->disk, offset);
+	long stripe = offset_to_stripe(&dc->disk, offset);
+
+	if (stripe < 0)
+		return false;
 
 	while (1) {
 		if (atomic_read(dc->disk.stripe_sectors_dirty + stripe))
-- 
2.26.2

