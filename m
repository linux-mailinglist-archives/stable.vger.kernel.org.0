Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256746D4AB9
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbjDCOtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbjDCOt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ED62A5A3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ABFA6136F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930E0C433D2;
        Mon,  3 Apr 2023 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533317;
        bh=XKz394flnZQ9FgSh1lKMDSVEksEC90bjsQLLab34Ub0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NKnuyKZwkd4XfzW+GboBoi4zDCHGKvrYnNwY6iXUy97QUMDEXRKDGtnq15lliGkt
         YE8AxF3Hjdyajag8d9RfrGdMuvxzQGhpgOG+ZI/j58HzHwSblO7KjQrGw1ORGVTSJX
         8DiojYQwR8z2by1jC1ZmH+umVUlW7xwiaQNGnYDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Yang <sherry.yang@oracle.com>,
        kernel test robot <oliver.sang@intel.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 137/187] btrfs: scan device in non-exclusive mode
Date:   Mon,  3 Apr 2023 16:09:42 +0200
Message-Id: <20230403140420.519716465@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 50d281fc434cb8e2497f5e70a309ccca6b1a09f0 upstream.

This fixes mkfs/mount/check failures due to race with systemd-udevd
scan.

During the device scan initiated by systemd-udevd, other user space
EXCL operations such as mkfs, mount, or check may get blocked and result
in a "Device or resource busy" error. This is because the device
scan process opens the device with the EXCL flag in the kernel.

Two reports were received:

 - btrfs/179 test case, where the fsck command failed with the -EBUSY
   error

 - LTP pwritev03 test case, where mkfs.vfs failed with
   the -EBUSY error, when mkfs.vfs tried to overwrite old btrfs filesystem
   on the device.

In both cases, fsck and mkfs (respectively) were racing with a
systemd-udevd device scan, and systemd-udevd won, resulting in the
-EBUSY error for fsck and mkfs.

Reproducing the problem has been difficult because there is a very
small window during which these userspace threads can race to
acquire the exclusive device open. Even on the system where the problem
was observed, the problem occurrences were anywhere between 10 to 400
iterations and chances of reproducing decreases with debug printk()s.

However, an exclusive device open is unnecessary for the scan process,
as there are no write operations on the device during scan. Furthermore,
during the mount process, the superblock is re-read in the below
function call chain:

  btrfs_mount_root
   btrfs_open_devices
    open_fs_devices
     btrfs_open_one_device
       btrfs_get_bdev_and_sb

So, to fix this issue, removes the FMODE_EXCL flag from the scan
operation, and add a comment.

The case where mkfs may still write to the device and a scan is running,
the btrfs signature is not written at that time so scan will not
recognize such device.

Reported-by: Sherry Yang <sherry.yang@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202303170839.fdf23068-oliver.sang@intel.com
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1366,8 +1366,17 @@ struct btrfs_device *btrfs_scan_one_devi
 	 * So, we need to add a special mount option to scan for
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
-	flags |= FMODE_EXCL;
 
+	/*
+	 * Avoid using flag |= FMODE_EXCL here, as the systemd-udev may
+	 * initiate the device scan which may race with the user's mount
+	 * or mkfs command, resulting in failure.
+	 * Since the device scan is solely for reading purposes, there is
+	 * no need for FMODE_EXCL. Additionally, the devices are read again
+	 * during the mount process. It is ok to get some inconsistent
+	 * values temporarily, as the device paths of the fsid are the only
+	 * required information for assembling the volume.
+	 */
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);


