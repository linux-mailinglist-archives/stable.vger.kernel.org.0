Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC7D24B3CA
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbgHTJwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgHTJwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:52:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F162075E;
        Thu, 20 Aug 2020 09:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917144;
        bh=xvgRLagZyUL83HZLDKCajHiufux7dX3D60vAe9TV1h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jS7wnDphH6DsACF9nGbqdK+c/i8xpDHLyBuKis64amrn0pgBBvFoI2vK39JZjIsg
         tMJUIey+SLyBkqzAdCQf3ay3qgS/Hm4rr9inCjUAaoPm82+hUMtjyisT+ovXtO7hr5
         Bxx+YmoiNrFwLTKuznSAlOb6DALAGfZUPXmgvisc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 12/92] btrfs: dont traverse into the seed devices in show_devname
Date:   Thu, 20 Aug 2020 11:20:57 +0200
Message-Id: <20200820091538.158240443@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 4faf55b03823e96c44dc4e364520000ed3b12fdb upstream.

->show_devname currently shows the lowest devid in the list. As the seed
devices have the lowest devid in the sprouted filesystem, the userland
tool such as findmnt end up seeing seed device instead of the device from
the read-writable sprouted filesystem. As shown below.

 mount /dev/sda /btrfs
 mount: /btrfs: WARNING: device write-protected, mounted read-only.

 findmnt --output SOURCE,TARGET,UUID /btrfs
 SOURCE   TARGET UUID
 /dev/sda /btrfs 899f7027-3e46-4626-93e7-7d4c9ad19111

 btrfs dev add -f /dev/sdb /btrfs

 umount /btrfs
 mount /dev/sdb /btrfs

 findmnt --output SOURCE,TARGET,UUID /btrfs
 SOURCE   TARGET UUID
 /dev/sda /btrfs 899f7027-3e46-4626-93e7-7d4c9ad19111

All sprouts from a single seed will show the same seed device and the
same fsid. That's confusing.
This is causing problems in our prototype as there isn't any reference
to the sprout file-system(s) which is being used for actual read and
write.

This was added in the patch which implemented the show_devname in btrfs
commit 9c5085c14798 ("Btrfs: implement ->show_devname").
I tried to look for any particular reason that we need to show the seed
device, there isn't any.

So instead, do not traverse through the seed devices, just show the
lowest devid in the sprouted fsid.

After the patch:

 mount /dev/sda /btrfs
 mount: /btrfs: WARNING: device write-protected, mounted read-only.

 findmnt --output SOURCE,TARGET,UUID /btrfs
 SOURCE   TARGET UUID
 /dev/sda /btrfs 899f7027-3e46-4626-93e7-7d4c9ad19111

 btrfs dev add -f /dev/sdb /btrfs
 mount -o rw,remount /dev/sdb /btrfs

 findmnt --output SOURCE,TARGET,UUID /btrfs
 SOURCE   TARGET UUID
 /dev/sdb /btrfs 595ca0e6-b82e-46b5-b9e2-c72a6928be48

 mount /dev/sda /btrfs1
 mount: /btrfs1: WARNING: device write-protected, mounted read-only.

 btrfs dev add -f /dev/sdc /btrfs1

 findmnt --output SOURCE,TARGET,UUID /btrfs1
 SOURCE   TARGET  UUID
 /dev/sdc /btrfs1 ca1dbb7a-8446-4f95-853c-a20f3f82bdbb

 cat /proc/self/mounts | grep btrfs
 /dev/sdb /btrfs btrfs rw,relatime,noacl,space_cache,subvolid=5,subvol=/ 0 0
 /dev/sdc /btrfs1 btrfs ro,relatime,noacl,space_cache,subvolid=5,subvol=/ 0 0

Reported-by: Martin K. Petersen <martin.petersen@oracle.com>
CC: stable@vger.kernel.org # 4.19+
Tested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/super.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2314,9 +2314,7 @@ static int btrfs_unfreeze(struct super_b
 static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
-	struct btrfs_fs_devices *cur_devices;
 	struct btrfs_device *dev, *first_dev = NULL;
-	struct list_head *head;
 
 	/*
 	 * Lightweight locking of the devices. We should not need
@@ -2326,18 +2324,13 @@ static int btrfs_show_devname(struct seq
 	 * least until until the rcu_read_unlock.
 	 */
 	rcu_read_lock();
-	cur_devices = fs_info->fs_devices;
-	while (cur_devices) {
-		head = &cur_devices->devices;
-		list_for_each_entry_rcu(dev, head, dev_list) {
-			if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
-				continue;
-			if (!dev->name)
-				continue;
-			if (!first_dev || dev->devid < first_dev->devid)
-				first_dev = dev;
-		}
-		cur_devices = cur_devices->seed;
+	list_for_each_entry_rcu(dev, &fs_info->fs_devices->devices, dev_list) {
+		if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
+			continue;
+		if (!dev->name)
+			continue;
+		if (!first_dev || dev->devid < first_dev->devid)
+			first_dev = dev;
 	}
 
 	if (first_dev)


