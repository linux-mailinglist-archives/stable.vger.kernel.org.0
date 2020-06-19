Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD73B2011E4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404320AbgFSPqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393474AbgFSP0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:26:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ABBD21582;
        Fri, 19 Jun 2020 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580378;
        bh=cxtuvjAdp9f4Te01/+BlbAfNdOyNnBZ251CMnNbZcN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTkuR2ZecXRG5LHRT82s/Bhfvt7C8i0FT6G0FycwCrrhW1SF8WV1AdBFkoi9xDRD+
         Ej31rRAkSibISWkvSMz4vzlz+YOZ457N/DcHICrxsitV2nKLET+IqwdpwOPJwHdKIw
         vMYOQOVCD16zimKS/YmpodOIw+Jpy6Csvgn+sHZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 227/376] bcache: fix refcount underflow in bcache_device_free()
Date:   Fri, 19 Jun 2020 16:32:25 +0200
Message-Id: <20200619141721.065966923@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d98354fa28e3..4d8bf731b118 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -797,7 +797,9 @@ static void bcache_device_free(struct bcache_device *d)
 		bcache_device_detach(d);
 
 	if (disk) {
-		if (disk->flags & GENHD_FL_UP)
+		bool disk_added = (disk->flags & GENHD_FL_UP) != 0;
+
+		if (disk_added)
 			del_gendisk(disk);
 
 		if (disk->queue)
@@ -805,7 +807,8 @@ static void bcache_device_free(struct bcache_device *d)
 
 		ida_simple_remove(&bcache_device_idx,
 				  first_minor_to_idx(disk->first_minor));
-		put_disk(disk);
+		if (disk_added)
+			put_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);
-- 
2.25.1



