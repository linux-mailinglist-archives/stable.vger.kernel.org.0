Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580FA4F09FC
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 15:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiDCNi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 09:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiDCNi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 09:38:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4FC33A17
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6758B80D1B
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 13:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EC7C340ED;
        Sun,  3 Apr 2022 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648992990;
        bh=FohMgVfNx0atJ21I1e+bQKneB8Ebba8ZNq3vZu5n4KA=;
        h=Subject:To:Cc:From:Date:From;
        b=z7Iwwvj7TUjbs1Q5zmnxGesCguh8FxIaMUMbUIsKz1xeFTjrSDZ/LWn5Qch2Ual9P
         Qj2tk4ongYUAJ/H2J0lxkHPmvQo8hAzonIwaZ+FyHeCROzA2W/4LYwK43rSoPZi0Dy
         zBmdz8sneV39edAs5n4dj8o0akGaSa/dl0YGsQw8=
Subject: FAILED: patch "[PATCH] ubi: Fix race condition between ctrl_cdev_ioctl and" failed to apply to 4.9-stable tree
To:     libaokun1@huawei.com, hulkci@huawei.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 15:36:27 +0200
Message-ID: <1648992987220143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3cbf0e392f173ba0ce425968c8374a6aa3e90f2e Mon Sep 17 00:00:00 2001
From: Baokun Li <libaokun1@huawei.com>
Date: Fri, 5 Nov 2021 17:30:22 +0800
Subject: [PATCH] ubi: Fix race condition between ctrl_cdev_ioctl and
 ubi_cdev_ioctl

Hulk Robot reported a KASAN report about use-after-free:
 ==================================================================
 BUG: KASAN: use-after-free in __list_del_entry_valid+0x13d/0x160
 Read of size 8 at addr ffff888035e37d98 by task ubiattach/1385
 [...]
 Call Trace:
  klist_dec_and_del+0xa7/0x4a0
  klist_put+0xc7/0x1a0
  device_del+0x4d4/0xed0
  cdev_device_del+0x1a/0x80
  ubi_attach_mtd_dev+0x2951/0x34b0 [ubi]
  ctrl_cdev_ioctl+0x286/0x2f0 [ubi]

 Allocated by task 1414:
  device_add+0x60a/0x18b0
  cdev_device_add+0x103/0x170
  ubi_create_volume+0x1118/0x1a10 [ubi]
  ubi_cdev_ioctl+0xb7f/0x1ba0 [ubi]

 Freed by task 1385:
  cdev_device_del+0x1a/0x80
  ubi_remove_volume+0x438/0x6c0 [ubi]
  ubi_cdev_ioctl+0xbf4/0x1ba0 [ubi]
 [...]
 ==================================================================

The lock held by ctrl_cdev_ioctl is ubi_devices_mutex, but the lock held
by ubi_cdev_ioctl is ubi->device_mutex. Therefore, the two locks can be
concurrent.

ctrl_cdev_ioctl contains two operations: ubi_attach and ubi_detach.
ubi_detach is bug-free because it uses reference counting to prevent
concurrency. However, uif_init and uif_close in ubi_attach may race with
ubi_cdev_ioctl.

uif_init will race with ubi_cdev_ioctl as in the following stack.
           cpu1                   cpu2                  cpu3
_______________________|________________________|______________________
ctrl_cdev_ioctl
 ubi_attach_mtd_dev
  uif_init
                           ubi_cdev_ioctl
                            ubi_create_volume
                             cdev_device_add
   ubi_add_volume
   // sysfs exist
   kill_volumes
                                                    ubi_cdev_ioctl
                                                     ubi_remove_volume
                                                      cdev_device_del
                                                       // first free
    ubi_free_volume
     cdev_del
     // double free
   cdev_device_del

And uif_close will race with ubi_cdev_ioctl as in the following stack.
           cpu1                   cpu2                  cpu3
_______________________|________________________|______________________
ctrl_cdev_ioctl
 ubi_attach_mtd_dev
  uif_init
                           ubi_cdev_ioctl
                            ubi_create_volume
                             cdev_device_add
  ubi_debugfs_init_dev
  //error goto out_uif;
  uif_close
   kill_volumes
                                                    ubi_cdev_ioctl
                                                     ubi_remove_volume
                                                      cdev_device_del
                                                       // first free
    ubi_free_volume
    // double free

The cause of this problem is that commit 714fb87e8bc0 make device
"available" before it becomes accessible via sysfs. Therefore, we
roll back the modification. We will fix the race condition between
ubi device creation and udev by removing ubi_get_device in
vol_attribute_show and dev_attribute_show.This avoids accessing
uninitialized ubi_devices[ubi_num].

ubi_get_device is used to prevent devices from being deleted during
sysfs execution. However, now kernfs ensures that devices will not
be deleted before all reference counting are released.
The key process is shown in the following stack.

device_del
  device_remove_attrs
    device_remove_groups
      sysfs_remove_groups
        sysfs_remove_group
          remove_files
            kernfs_remove_by_name
              kernfs_remove_by_name_ns
                __kernfs_remove
                  kernfs_drain

Fixes: 714fb87e8bc0 ("ubi: Fix race condition between ubi device creation and udev")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index a7e3eb9befb6..a32050fecabf 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -351,9 +351,6 @@ static ssize_t dev_attribute_show(struct device *dev,
 	 * we still can use 'ubi->ubi_num'.
 	 */
 	ubi = container_of(dev, struct ubi_device, dev);
-	ubi = ubi_get_device(ubi->ubi_num);
-	if (!ubi)
-		return -ENODEV;
 
 	if (attr == &dev_eraseblock_size)
 		ret = sprintf(buf, "%d\n", ubi->leb_size);
@@ -382,7 +379,6 @@ static ssize_t dev_attribute_show(struct device *dev,
 	else
 		ret = -EINVAL;
 
-	ubi_put_device(ubi);
 	return ret;
 }
 
@@ -979,9 +975,6 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 			goto out_detach;
 	}
 
-	/* Make device "available" before it becomes accessible via sysfs */
-	ubi_devices[ubi_num] = ubi;
-
 	err = uif_init(ubi);
 	if (err)
 		goto out_detach;
@@ -1026,6 +1019,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	wake_up_process(ubi->bgt_thread);
 	spin_unlock(&ubi->wl_lock);
 
+	ubi_devices[ubi_num] = ubi;
 	ubi_notify_all(ubi, UBI_VOLUME_ADDED, NULL);
 	return ubi_num;
 
@@ -1034,7 +1028,6 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 out_uif:
 	uif_close(ubi);
 out_detach:
-	ubi_devices[ubi_num] = NULL;
 	ubi_wl_close(ubi);
 	ubi_free_all_volumes(ubi);
 	vfree(ubi->vtbl);
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 139ee132bfbc..1bc7b3a05604 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -56,16 +56,11 @@ static ssize_t vol_attribute_show(struct device *dev,
 {
 	int ret;
 	struct ubi_volume *vol = container_of(dev, struct ubi_volume, dev);
-	struct ubi_device *ubi;
-
-	ubi = ubi_get_device(vol->ubi->ubi_num);
-	if (!ubi)
-		return -ENODEV;
+	struct ubi_device *ubi = vol->ubi;
 
 	spin_lock(&ubi->volumes_lock);
 	if (!ubi->volumes[vol->vol_id]) {
 		spin_unlock(&ubi->volumes_lock);
-		ubi_put_device(ubi);
 		return -ENODEV;
 	}
 	/* Take a reference to prevent volume removal */
@@ -103,7 +98,6 @@ static ssize_t vol_attribute_show(struct device *dev,
 	vol->ref_count -= 1;
 	ubi_assert(vol->ref_count >= 0);
 	spin_unlock(&ubi->volumes_lock);
-	ubi_put_device(ubi);
 	return ret;
 }
 

