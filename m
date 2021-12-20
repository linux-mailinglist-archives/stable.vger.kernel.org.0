Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05E147AF04
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239625AbhLTPHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239062AbhLTPFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:05:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA787C09B194;
        Mon, 20 Dec 2021 06:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9508AB80EED;
        Mon, 20 Dec 2021 14:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD08FC36AE9;
        Mon, 20 Dec 2021 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011983;
        bh=PPO8mtmj+KK9nsfan1pbSfGUWi3313aWO19glQAKDuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1VbCZgbuVF8VjAQ9SzAMi1co+6D0QFSSJskAQvMk6zeXurHYCng4q1RKydMHlUiC
         Ch4a6lVUWe1ZhQ2H9ejPAwi0eSKVRveSNzCSCAOi3Z3R3lM6pZaxG3TZRaanJCNJsb
         hwIxAKqmtvB8JEjDnFbU5cfi+gViZNSEp8mg2fjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yue <l@damenly.su>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 031/177] btrfs: use latest_dev in btrfs_show_devname
Date:   Mon, 20 Dec 2021 15:33:01 +0100
Message-Id: <20211220143041.146751861@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

Commit 6605fd2f394bba0a0059df2b6cfc87b0b6d393a2 upstream.

The test case btrfs/238 reports the warning below:

 WARNING: CPU: 3 PID: 481 at fs/btrfs/super.c:2509 btrfs_show_devname+0x104/0x1e8 [btrfs]
 CPU: 2 PID: 1 Comm: systemd Tainted: G        W  O 5.14.0-rc1-custom #72
 Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
 Call trace:
   btrfs_show_devname+0x108/0x1b4 [btrfs]
   show_mountinfo+0x234/0x2c4
   m_show+0x28/0x34
   seq_read_iter+0x12c/0x3c4
   vfs_read+0x29c/0x2c8
   ksys_read+0x80/0xec
   __arm64_sys_read+0x28/0x34
   invoke_syscall+0x50/0xf8
   do_el0_svc+0x88/0x138
   el0_svc+0x2c/0x8c
   el0t_64_sync_handler+0x84/0xe4
   el0t_64_sync+0x198/0x19c

Reason:
While btrfs_prepare_sprout() moves the fs_devices::devices into
fs_devices::seed_list, the btrfs_show_devname() searches for the devices
and found none, leading to the warning as in above.

Fix:
latest_dev is updated according to the changes to the device list.
That means we could use the latest_dev->name to show the device name in
/proc/self/mounts, the pointer will be always valid as it's assigned
before the device is deleted from the list in remove or replace.
The RCU protection is sufficient as the device structure is freed after
synchronization.

Reported-by: Su Yue <l@damenly.su>
Tested-by: Su Yue <l@damenly.su>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2463,30 +2463,16 @@ static int btrfs_unfreeze(struct super_b
 static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
-	struct btrfs_device *dev, *first_dev = NULL;
 
 	/*
-	 * Lightweight locking of the devices. We should not need
-	 * device_list_mutex here as we only read the device data and the list
-	 * is protected by RCU.  Even if a device is deleted during the list
-	 * traversals, we'll get valid data, the freeing callback will wait at
-	 * least until the rcu_read_unlock.
+	 * There should be always a valid pointer in latest_dev, it may be stale
+	 * for a short moment in case it's being deleted but still valid until
+	 * the end of RCU grace period.
 	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(dev, &fs_info->fs_devices->devices, dev_list) {
-		if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
-			continue;
-		if (!dev->name)
-			continue;
-		if (!first_dev || dev->devid < first_dev->devid)
-			first_dev = dev;
-	}
-
-	if (first_dev)
-		seq_escape(m, rcu_str_deref(first_dev->name), " \t\n\\");
-	else
-		WARN_ON(1);
+	seq_escape(m, rcu_str_deref(fs_info->fs_devices->latest_dev->name), " \t\n\\");
 	rcu_read_unlock();
+
 	return 0;
 }
 


