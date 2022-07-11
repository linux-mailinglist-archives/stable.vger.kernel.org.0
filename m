Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660FE56FCF7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiGKJtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiGKJtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EA06068E;
        Mon, 11 Jul 2022 02:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03F8EB80E7A;
        Mon, 11 Jul 2022 09:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F656C34115;
        Mon, 11 Jul 2022 09:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531429;
        bh=Oc3uZAn2SjytfeW43gNwv+Wr/ecIVvXA2iXT/tRe3yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMNHPouqxk1ctAFunqzgbrbgKD7BjeRIoLc8i0JckvEfBnBmv7dPJLPeeKHVpmL84
         YWbizMxfQ1nw3dhYCZER+7z4cnuqT6u3bjRgZ9Yjvba9SZKkBmZz1kh55MrxnHRqxt
         uU6zF98nC58Eq1LHTfZ2yO2oMrGiZc9tNXhIsKNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+82650a4e0ed38f218363@syzkaller.appspotmail.com
Subject: [PATCH 5.15 103/230] btrfs: dont access possibly stale fs_info data in device_list_add
Date:   Mon, 11 Jul 2022 11:05:59 +0200
Message-Id: <20220711090606.990492753@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 79c9234ba596e903907de20573fd4bcc85315b06 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cec54c6e1cdd..89ce0b449c22 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -955,6 +955,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
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
 			int error;
@@ -968,12 +973,6 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 
 			if (device->bdev->bd_dev != path_dev) {
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
@@ -981,7 +980,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 						  task_pid_nr(current));
 				return ERR_PTR(-EEXIST);
 			}
-			btrfs_info_in_rcu(device->fs_info,
+			btrfs_info_in_rcu(NULL,
 	"devid %llu device path %s changed to %s scanned by %s (%d)",
 					  devid, rcu_str_deref(device->name),
 					  path, current->comm,
-- 
2.35.1



