Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA2C24BBF8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgHTMgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729367AbgHTJrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:47:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F306720724;
        Thu, 20 Aug 2020 09:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916870;
        bh=9nV5h4V0QloBulcUVoxFcunNI3xsUOuoH2vtTUV0dq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Zf+32lyTSlqqdQbwCn4siujiFtRNNIJoOYJy4pr2y2zKZHmciuZxsWA+z5g/U5Cq
         6jZn8XHMvIl0h7dp/+PFHpC5xCV8yHJr+24vmMW7rG2RY0Qz9ilyCV6p86/ggfiESP
         1EJE+H8SWkAmaDhJlzJvuV+tOwn70gWGTxsswDPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Ken Raeburn <raeburn@redhat.com>
Subject: [PATCH 5.4 046/152] bcache: fix overflow in offset_to_stripe()
Date:   Thu, 20 Aug 2020 11:20:13 +0200
Message-Id: <20200820091556.062690152@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 7a1481267999c02abf4a624515c1b5c7c1fccbd6 upstream.

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
Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1783075
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bcache.h    |    2 +-
 drivers/md/bcache/writeback.c |   14 +++++++++-----
 drivers/md/bcache/writeback.h |   19 +++++++++++++++++--
 3 files changed, 27 insertions(+), 8 deletions(-)

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
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -519,15 +519,19 @@ void bcache_dev_sectors_dirty_add(struct
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
@@ -567,12 +571,12 @@ static bool dirty_pred(struct keybuf *bu
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
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -33,10 +33,22 @@ static inline uint64_t bcache_dev_sector
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
 
@@ -44,7 +56,10 @@ static inline bool bcache_dev_stripe_dir
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


