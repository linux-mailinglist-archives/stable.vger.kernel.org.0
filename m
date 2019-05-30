Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0302F0BB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfE3EGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731150AbfE3DRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5684C24529;
        Thu, 30 May 2019 03:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186252;
        bh=caT+T2CitUocF0Jn+HuJkazZXKeZpQsFfml6fIoB5wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHZ0wLxX7Xv5/r7wZzLPEUTUXCZjt7pAsSzAn30hsPkF84eCk3z10MF6QsgyNr6Vh
         +7inHSNGXj/BO3CJUJ3fzf9kHwtA/5sva778Ao0DHvHbTTh9aXYvJhtoD0Iuf3ED+N
         Syyw1LxrjrwHUgKCHFpgPNfAmqQeEimiE2vxHSI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <keith.busch@intel.com>, Jan Kara <jack@suse.cz>,
        Yufen Yu <yuyufen@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/276] block: fix use-after-free on gendisk
Date:   Wed, 29 May 2019 20:04:48 -0700
Message-Id: <20190530030533.910471797@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2c88e3c7ec32d7a40cc7c9b4a487cf90e4671bdd ]

commit 2da78092dda "block: Fix dev_t minor allocation lifetime"
specifically moved blk_free_devt(dev->devt) call to part_release()
to avoid reallocating device number before the device is fully
shutdown.

However, it can cause use-after-free on gendisk in get_gendisk().
We use md device as example to show the race scenes:

Process1		Worker			Process2
md_free
						blkdev_open
del_gendisk
  add delete_partition_work_fn() to wq
  						__blkdev_get
						get_gendisk
put_disk
  disk_release
    kfree(disk)
    						find part from ext_devt_idr
						get_disk_and_module(disk)
    					  	cause use after free

    			delete_partition_work_fn
			put_device(part)
    		  	part_release
		    	remove part from ext_devt_idr

Before <devt, hd_struct pointer> is removed from ext_devt_idr by
delete_partition_work_fn(), we can find the devt and then access
gendisk by hd_struct pointer. But, if we access the gendisk after
it have been freed, it can cause in use-after-freeon gendisk in
get_gendisk().

We fix this by adding a new helper blk_invalidate_devt() in
delete_partition() and del_gendisk(). It replaces hd_struct
pointer in idr with value 'NULL', and deletes the entry from
idr in part_release() as we do now.

Thanks to Jan Kara for providing the solution and more clear comments
for the code.

Fixes: 2da78092dda1 ("block: Fix dev_t minor allocation lifetime")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c             | 19 +++++++++++++++++++
 block/partition-generic.c |  7 +++++++
 include/linux/genhd.h     |  1 +
 3 files changed, 27 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index be5bab20b2abf..2b2a936cf8480 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -518,6 +518,18 @@ void blk_free_devt(dev_t devt)
 	}
 }
 
+/**
+ *	We invalidate devt by assigning NULL pointer for devt in idr.
+ */
+void blk_invalidate_devt(dev_t devt)
+{
+	if (MAJOR(devt) == BLOCK_EXT_MAJOR) {
+		spin_lock_bh(&ext_devt_lock);
+		idr_replace(&ext_devt_idr, NULL, blk_mangle_minor(MINOR(devt)));
+		spin_unlock_bh(&ext_devt_lock);
+	}
+}
+
 static char *bdevt_str(dev_t devt, char *buf)
 {
 	if (MAJOR(devt) <= 0xff && MINOR(devt) <= 0xff) {
@@ -769,6 +781,13 @@ void del_gendisk(struct gendisk *disk)
 
 	if (!(disk->flags & GENHD_FL_HIDDEN))
 		blk_unregister_region(disk_devt(disk), disk->minors);
+	/*
+	 * Remove gendisk pointer from idr so that it cannot be looked up
+	 * while RCU period before freeing gendisk is running to prevent
+	 * use-after-free issues. Note that the device number stays
+	 * "in-use" until we really free the gendisk.
+	 */
+	blk_invalidate_devt(disk_devt(disk));
 
 	kobject_put(disk->part0.holder_dir);
 	kobject_put(disk->slave_dir);
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 5f8db5c5140f4..98d60a59b843c 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -289,6 +289,13 @@ void delete_partition(struct gendisk *disk, int partno)
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 
+	/*
+	 * Remove gendisk pointer from idr so that it cannot be looked up
+	 * while RCU period before freeing gendisk is running to prevent
+	 * use-after-free issues. Note that the device number stays
+	 * "in-use" until we really free the gendisk.
+	 */
+	blk_invalidate_devt(part_devt(part));
 	hd_struct_kill(part);
 }
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index f767293b00e66..f13272d843320 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -596,6 +596,7 @@ struct unixware_disklabel {
 
 extern int blk_alloc_devt(struct hd_struct *part, dev_t *devt);
 extern void blk_free_devt(dev_t devt);
+extern void blk_invalidate_devt(dev_t devt);
 extern dev_t blk_lookup_devt(const char *name, int partno);
 extern char *disk_name (struct gendisk *hd, int partno, char *buf);
 
-- 
2.20.1



