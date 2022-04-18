Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CC5505661
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbiDRNeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiDRNbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8122532D;
        Mon, 18 Apr 2022 05:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18454612BB;
        Mon, 18 Apr 2022 12:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218C9C385A1;
        Mon, 18 Apr 2022 12:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286623;
        bh=SsersTUaUS1BStE3dEv9Zex6Yn5K5IXmz3P2GUDA5xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnMdBJGV5ZsspKDx2JBCuowQG6URKfMApqy4bEU6NsihRW4sqEywFGoFQ7JpD7xVm
         OioO4sWDq4OnJybXPoecrT8Sgl9CoqNAkxZwk7c0jYfz/56QndPwkw4ah1P7Uw0Mfd
         B/ggNpGducNvWR+W1dMIhpXVz0ahgt0qcbd8AqVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.14 193/284] ubi: Fix race condition between ctrl_cdev_ioctl and ubi_cdev_ioctl
Date:   Mon, 18 Apr 2022 14:12:54 +0200
Message-Id: <20220418121217.220441018@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit 3cbf0e392f173ba0ce425968c8374a6aa3e90f2e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/build.c |    9 +--------
 drivers/mtd/ubi/vmt.c   |    8 +-------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -363,9 +363,6 @@ static ssize_t dev_attribute_show(struct
 	 * we still can use 'ubi->ubi_num'.
 	 */
 	ubi = container_of(dev, struct ubi_device, dev);
-	ubi = ubi_get_device(ubi->ubi_num);
-	if (!ubi)
-		return -ENODEV;
 
 	if (attr == &dev_eraseblock_size)
 		ret = sprintf(buf, "%d\n", ubi->leb_size);
@@ -394,7 +391,6 @@ static ssize_t dev_attribute_show(struct
 	else
 		ret = -EINVAL;
 
-	ubi_put_device(ubi);
 	return ret;
 }
 
@@ -960,9 +956,6 @@ int ubi_attach_mtd_dev(struct mtd_info *
 			goto out_detach;
 	}
 
-	/* Make device "available" before it becomes accessible via sysfs */
-	ubi_devices[ubi_num] = ubi;
-
 	err = uif_init(ubi);
 	if (err)
 		goto out_detach;
@@ -1007,6 +1000,7 @@ int ubi_attach_mtd_dev(struct mtd_info *
 	wake_up_process(ubi->bgt_thread);
 	spin_unlock(&ubi->wl_lock);
 
+	ubi_devices[ubi_num] = ubi;
 	ubi_notify_all(ubi, UBI_VOLUME_ADDED, NULL);
 	return ubi_num;
 
@@ -1015,7 +1009,6 @@ out_debugfs:
 out_uif:
 	uif_close(ubi);
 out_detach:
-	ubi_devices[ubi_num] = NULL;
 	ubi_wl_close(ubi);
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -69,16 +69,11 @@ static ssize_t vol_attribute_show(struct
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
@@ -116,7 +111,6 @@ static ssize_t vol_attribute_show(struct
 	vol->ref_count -= 1;
 	ubi_assert(vol->ref_count >= 0);
 	spin_unlock(&ubi->volumes_lock);
-	ubi_put_device(ubi);
 	return ret;
 }
 


