Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A50A24BDF9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHTNQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbgHTJfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:35:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEB4207DE;
        Thu, 20 Aug 2020 09:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916122;
        bh=7IB28Rnay661f0RG14jsd6Y6Lhy63PrtI9OC36nTOPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4/tsbrpppfpzqD6ppdGHyIeAnan3OhDBu9d/h39jejS44QpK9gpKJbWiVFaUxGVV
         n67SMe+cRXo9dF+tsnzjKR0EUHm7O+18VV88ha3TVN0QNMVotoAXwYhUYn8gMq2oLS
         iT9rjXXkbH8ZtdgnF6Zz4HClgK6Kmey7fsu/LSEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 019/204] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Date:   Thu, 20 Aug 2020 11:18:36 +0200
Message-Id: <20200820091607.210409911@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 137c541821a83debb63b3fa8abdd1cbc41bdf3a1 upstream.

With the recent addition of filesystem checksum types other than CRC32c,
it is not anymore hard-coded which checksum type a btrfs filesystem uses.

Up to now there is no good way to read the filesystem checksum, apart from
reading the filesystem UUID and then query sysfs for the checksum type.

Add a new csum_type and csum_size fields to the BTRFS_IOC_FS_INFO ioctl
command which usually is used to query filesystem features. Also add a
flags member indicating that the kernel responded with a set csum_type and
csum_size field.

For compatibility reasons, only return the csum_type and csum_size if
the BTRFS_FS_INFO_FLAG_CSUM_INFO flag was passed to the kernel. Also
clear any unknown flags so we don't pass false positives to user-space
newer than the kernel.

To simplify further additions to the ioctl, also switch the padding to a
u8 array. Pahole was used to verify the result of this switch:

The csum members are added before flags, which might look odd, but this
is to keep the alignment requirements and not to introduce holes in the
structure.

  $ pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
  struct btrfs_ioctl_fs_info_args {
	  __u64                      max_id;               /*     0     8 */
	  __u64                      num_devices;          /*     8     8 */
	  __u8                       fsid[16];             /*    16    16 */
	  __u32                      nodesize;             /*    32     4 */
	  __u32                      sectorsize;           /*    36     4 */
	  __u32                      clone_alignment;      /*    40     4 */
	  __u16                      csum_type;            /*    44     2 */
	  __u16                      csum_size;            /*    46     2 */
	  __u64                      flags;                /*    48     8 */
	  __u8                       reserved[968];        /*    56   968 */

	  /* size: 1024, cachelines: 16, members: 10 */
  };

Fixes: 3951e7f050ac ("btrfs: add xxhash64 to checksumming algorithms")
Fixes: 3831bf0094ab ("btrfs: add sha256 to checksumming algorithm")
CC: stable@vger.kernel.org # 5.5+
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c           |   16 +++++++++++++---
 include/uapi/linux/btrfs.h |   14 ++++++++++++--
 2 files changed, 25 insertions(+), 5 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3197,11 +3197,15 @@ static long btrfs_ioctl_fs_info(struct b
 	struct btrfs_ioctl_fs_info_args *fi_args;
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	u64 flags_in;
 	int ret = 0;
 
-	fi_args = kzalloc(sizeof(*fi_args), GFP_KERNEL);
-	if (!fi_args)
-		return -ENOMEM;
+	fi_args = memdup_user(arg, sizeof(*fi_args));
+	if (IS_ERR(fi_args))
+		return PTR_ERR(fi_args);
+
+	flags_in = fi_args->flags;
+	memset(fi_args, 0, sizeof(*fi_args));
 
 	rcu_read_lock();
 	fi_args->num_devices = fs_devices->num_devices;
@@ -3217,6 +3221,12 @@ static long btrfs_ioctl_fs_info(struct b
 	fi_args->sectorsize = fs_info->sectorsize;
 	fi_args->clone_alignment = fs_info->sectorsize;
 
+	if (flags_in & BTRFS_FS_INFO_FLAG_CSUM_INFO) {
+		fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
+		fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
+		fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_INFO;
+	}
+
 	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
 		ret = -EFAULT;
 
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -243,6 +243,13 @@ struct btrfs_ioctl_dev_info_args {
 	__u8 path[BTRFS_DEVICE_PATH_NAME_MAX];	/* out */
 };
 
+/*
+ * Retrieve information about the filesystem
+ */
+
+/* Request information about checksum type and size */
+#define BTRFS_FS_INFO_FLAG_CSUM_INFO			(1 << 0)
+
 struct btrfs_ioctl_fs_info_args {
 	__u64 max_id;				/* out */
 	__u64 num_devices;			/* out */
@@ -250,8 +257,11 @@ struct btrfs_ioctl_fs_info_args {
 	__u32 nodesize;				/* out */
 	__u32 sectorsize;			/* out */
 	__u32 clone_alignment;			/* out */
-	__u32 reserved32;
-	__u64 reserved[122];			/* pad to 1k */
+	/* See BTRFS_FS_INFO_FLAG_* */
+	__u16 csum_type;			/* out */
+	__u16 csum_size;			/* out */
+	__u64 flags;				/* in/out */
+	__u8 reserved[968];			/* pad to 1k */
 };
 
 /*


