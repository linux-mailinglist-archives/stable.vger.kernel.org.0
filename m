Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6D92A5893
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgKCUqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbgKCUqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB1420719;
        Tue,  3 Nov 2020 20:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436396;
        bh=IQaslEXhTR1j6g1c53PL4N2DWWmyWZvGrkYSbSSVvWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDGUVeZaYV6MBhGZKzmYiGqtzMJg1qounYvOY8E7XTmr6ctdQOK2rRQVSYxoOSiyc
         MUJQMuvwySqLgTrgEmkcgGIVVM5HA63PCsftSrrTeturckPLg+glXAXyA1HqGkadAE
         TPf35WNJSzVnqZ6gop8ybFHGAP49DG0kavA1OaVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 233/391] btrfs: skip devices without magic signature when mounting
Date:   Tue,  3 Nov 2020 21:34:44 +0100
Message-Id: <20201103203402.712420655@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 96c2e067ed3e3e004580a643c76f58729206b829 upstream.

Many things can happen after the device is scanned and before the device
is mounted.  One such thing is losing the BTRFS_MAGIC on the device.
If it happens we still won't free that device from the memory and cause
the userland confusion.

For example: As the BTRFS_IOC_DEV_INFO still carries the device path
which does not have the BTRFS_MAGIC, 'btrfs fi show' still lists
device which does not belong to the filesystem anymore:

  $ mkfs.btrfs -fq -draid1 -mraid1 /dev/sda /dev/sdb
  $ wipefs -a /dev/sdb
  # /dev/sdb does not contain magic signature
  $ mount -o degraded /dev/sda /btrfs
  $ btrfs fi show -m
  Label: none  uuid: 470ec6fb-646b-4464-b3cb-df1b26c527bd
	  Total devices 2 FS bytes used 128.00KiB
	  devid    1 size 3.00GiB used 571.19MiB path /dev/sda
	  devid    2 size 3.00GiB used 571.19MiB path /dev/sdb

We need to distinguish the missing signature and invalid superblock, so
add a specific error code ENODATA for that. This also fixes failure of
fstest btrfs/198.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    8 ++++++--
 fs/btrfs/volumes.c |   18 ++++++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3482,8 +3482,12 @@ struct btrfs_super_block *btrfs_read_dev
 		return ERR_CAST(page);
 
 	super = page_address(page);
-	if (btrfs_super_bytenr(super) != bytenr ||
-		    btrfs_super_magic(super) != BTRFS_MAGIC) {
+	if (btrfs_super_magic(super) != BTRFS_MAGIC) {
+		btrfs_release_disk_super(super);
+		return ERR_PTR(-ENODATA);
+	}
+
+	if (btrfs_super_bytenr(super) != bytenr) {
 		btrfs_release_disk_super(super);
 		return ERR_PTR(-EINVAL);
 	}
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1200,17 +1200,23 @@ static int open_fs_devices(struct btrfs_
 {
 	struct btrfs_device *device;
 	struct btrfs_device *latest_dev = NULL;
+	struct btrfs_device *tmp_device;
 
 	flags |= FMODE_EXCL;
 
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		/* Just open everything we can; ignore failures here */
-		if (btrfs_open_one_device(fs_devices, device, flags, holder))
-			continue;
+	list_for_each_entry_safe(device, tmp_device, &fs_devices->devices,
+				 dev_list) {
+		int ret;
 
-		if (!latest_dev ||
-		    device->generation > latest_dev->generation)
+		ret = btrfs_open_one_device(fs_devices, device, flags, holder);
+		if (ret == 0 &&
+		    (!latest_dev || device->generation > latest_dev->generation)) {
 			latest_dev = device;
+		} else if (ret == -ENODATA) {
+			fs_devices->num_devices--;
+			list_del(&device->dev_list);
+			btrfs_free_device(device);
+		}
 	}
 	if (fs_devices->open_devices == 0)
 		return -EINVAL;


