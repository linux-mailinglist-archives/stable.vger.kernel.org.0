Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FB14F01BD
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243413AbiDBM4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347406AbiDBM4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691E153716
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05CC96144B
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1C3C340EC;
        Sat,  2 Apr 2022 12:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648904098;
        bh=P3nnT/vdU5ph026Eb8FkjNsr42r6xB4exBxEtK0KBBI=;
        h=Subject:To:Cc:From:Date:From;
        b=cIAuOHFL3S0lbxA8wohvj/Gv3sbyVqTZ3Dhhp8nnTuRtV28cQoKUztp6LKWWiV+Qi
         8PLnb8cpUsxcb9jP1PcxCyY3QlMWKG5KYRSwJj15NDxtxDq4NzosRgnpULO/tiVD9b
         2WC/+YGAa7KOo6ZMzMZ9X+1vv+3xMQX85SOPiLy4=
Subject: FAILED: patch "[PATCH] btrfs: don't access possibly stale fs_info data in" failed to apply to 5.10-stable tree
To:     mudongliangabcd@gmail.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:54:45 +0200
Message-ID: <164890408553142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 79c9234ba596e903907de20573fd4bcc85315b06 Mon Sep 17 00:00:00 2001
From: Dongliang Mu <mudongliangabcd@gmail.com>
Date: Thu, 3 Mar 2022 22:40:27 +0800
Subject: [PATCH] btrfs: don't access possibly stale fs_info data in
 device_list_add

Syzbot reported a possible use-after-free in printing information
in device_list_add.

Very similar with the bug fixed by commit 0697d9a61099 ("btrfs: don't
access possibly stale fs_info data for printing duplicate device"),
but this time the use occurs in btrfs_info_in_rcu.

  Call Trace:
   kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
   btrfs_printk+0x395/0x425 fs/btrfs/super.c:244
   device_list_add.cold+0xd7/0x2ed fs/btrfs/volumes.c:957
   btrfs_scan_one_device+0x4c7/0x5c0 fs/btrfs/volumes.c:1387
   btrfs_control_ioctl+0x12a/0x2d0 fs/btrfs/super.c:2409
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:874 [inline]
   __se_sys_ioctl fs/ioctl.c:860 [inline]
   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fix this by modifying device->fs_info to NULL too.

Reported-and-tested-by: syzbot+82650a4e0ed38f218363@syzkaller.appspotmail.com
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5e3e13d4940b..1be7cb2f955f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -921,16 +921,15 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		/*
 		 * We are going to replace the device path for a given devid,
 		 * make sure it's the same device if the device is mounted
+		 *
+		 * NOTE: the device->fs_info may not be reliable here so pass
+		 * in a NULL to message helpers instead. This avoids a possible
+		 * use-after-free when the fs_info and fs_info->sb are already
+		 * torn down.
 		 */
 		if (device->bdev) {
 			if (device->devt != path_devt) {
 				mutex_unlock(&fs_devices->device_list_mutex);
-				/*
-				 * device->fs_info may not be reliable here, so
-				 * pass in a NULL instead. This avoids a
-				 * possible use-after-free when the fs_info and
-				 * fs_info->sb are already torn down.
-				 */
 				btrfs_warn_in_rcu(NULL,
 	"duplicate device %s devid %llu generation %llu scanned by %s (%d)",
 						  path, devid, found_transid,
@@ -938,7 +937,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 						  task_pid_nr(current));
 				return ERR_PTR(-EEXIST);
 			}
-			btrfs_info_in_rcu(device->fs_info,
+			btrfs_info_in_rcu(NULL,
 	"devid %llu device path %s changed to %s scanned by %s (%d)",
 					  devid, rcu_str_deref(device->name),
 					  path, current->comm,

