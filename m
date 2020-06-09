Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A81F28FD
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgFHXWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731252AbgFHXWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4755220842;
        Mon,  8 Jun 2020 23:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658524;
        bh=dnV4zmA/lKOZrdwqptWQogvmvKeHWdsg3vUNDmP9uRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVSex5CJRMbulUyGBmV8smT23mqOJWC5X2e/Ny/0yU/qmR/k3kZ7a/AUiwpR6cwRV
         Lu82JMO8nHV52pTTT0seFoxhgobpGgeEHBoJS2tGbAMHqvTQfTUIgpi1WRbu/rGes8
         YocE1gKx2JHe70bMPPwK3xkECComNQUxh4ZRmQKk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 150/175] bcache: fix refcount underflow in bcache_device_free()
Date:   Mon,  8 Jun 2020 19:18:23 -0400
Message-Id: <20200608231848.3366970-150-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 86da9f736740eba602389908574dfbb0f517baa5 ]

The problematic code piece in bcache_device_free() is,

 785 static void bcache_device_free(struct bcache_device *d)
 786 {
 787     struct gendisk *disk = d->disk;
 [snipped]
 799     if (disk) {
 800             if (disk->flags & GENHD_FL_UP)
 801                     del_gendisk(disk);
 802
 803             if (disk->queue)
 804                     blk_cleanup_queue(disk->queue);
 805
 806             ida_simple_remove(&bcache_device_idx,
 807                               first_minor_to_idx(disk->first_minor));
 808             put_disk(disk);
 809         }
 [snipped]
 816 }

At line 808, put_disk(disk) may encounter kobject refcount of 'disk'
being underflow.

Here is how to reproduce the issue,
- Attche the backing device to a cache device and do random write to
  make the cache being dirty.
- Stop the bcache device while the cache device has dirty data of the
  backing device.
- Only register the backing device back, NOT register cache device.
- The bcache device node /dev/bcache0 won't show up, because backing
  device waits for the cache device shows up for the missing dirty
  data.
- Now echo 1 into /sys/fs/bcache/pendings_cleanup, to stop the pending
  backing device.
- After the pending backing device stopped, use 'dmesg' to check kernel
  message, a use-after-free warning from KASA reported the refcount of
  kobject linked to the 'disk' is underflow.

The dropping refcount at line 808 in the above code piece is added by
add_disk(d->disk) in bch_cached_dev_run(). But in the above condition
the cache device is not registered, bch_cached_dev_run() has no chance
to be called and the refcount is not added. The put_disk() for a non-
added refcount of gendisk kobject triggers a underflow warning.

This patch checks whether GENHD_FL_UP is set in disk->flags, if it is
not set then the bcache device was not added, don't call put_disk()
and the the underflow issue can be avoided.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 658b0f4a01f5..68901745eb20 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -789,7 +789,9 @@ static void bcache_device_free(struct bcache_device *d)
 		bcache_device_detach(d);
 
 	if (disk) {
-		if (disk->flags & GENHD_FL_UP)
+		bool disk_added = (disk->flags & GENHD_FL_UP) != 0;
+
+		if (disk_added)
 			del_gendisk(disk);
 
 		if (disk->queue)
@@ -797,7 +799,8 @@ static void bcache_device_free(struct bcache_device *d)
 
 		ida_simple_remove(&bcache_device_idx,
 				  first_minor_to_idx(disk->first_minor));
-		put_disk(disk);
+		if (disk_added)
+			put_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);
-- 
2.25.1

