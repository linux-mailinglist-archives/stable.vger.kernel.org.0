Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2317821D5F5
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgGMM3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 08:29:09 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19771 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729733AbgGMM3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 08:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594643347; x=1626179347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y3OK9XPjVJgqrjUADyVNxzK1N6rj4hSLotW/jmvvUkk=;
  b=o8MMOWzqAyLG+lzoTlh+UFTJrBVLWx9AiEGxt8LIYmUenuEdkosQZ/0l
   QuDvrDxexsQ6C1xsyxTNhYdGwU8soso9P0+k1UTw8+BPByeBsf3abGfgm
   WwSDA7QMRVYQavJHvy/pFU+UGU5cP0/t2gr7m4WPlIrBuCJQSPnoJz8qj
   YB8ZP9W3HJbCjnqd39LBu4ex54raZ6fHrIuVSzu7ast4slU9DCTynRySo
   ca2tbtM/zLSBtosgiGsDj3c16nZLa6v9L/XdgbbgguDVaFyXm5FycpX3f
   IJD6I8IsbMPjfrj8XFQupKUr4byF5ZguJ8OECzZPYh9gn3RghMYwsjTOb
   g==;
IronPort-SDR: zhuWtX76Qf0ZqQ8ImvrtNfx2WY3ukmZ5AeVwYv4rPZTU1JDrM9qFFf1M9XDhvUG9bIZBIshwOq
 Q7e5Cwi5oMcBk7I0Fl+ZgT2ujv8RZ860+53vPfxh5GSZSXjypmwTV1F2EeJRRjK6MJk1cUGPll
 D2xeAgOsuVb97KIYoAGBRdEfZswsCLS2tJRVsNc4x0JxvKArNcr+pFdRDFnb4QLWIKzERalTlK
 trG5jublM+ixV4x8aeQ4S56CNmMPq/9DntXQFYPRW9JD3ExKF0pLIPk23DnVxTKp0vhOWNUKPi
 dWU=
X-IronPort-AV: E=Sophos;i="5.75,347,1589212800"; 
   d="scan'208";a="142312950"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2020 20:29:07 +0800
IronPort-SDR: OjEkjh0Fa39aLcCxkZ/QsjzooxOOPA16kcAH6p53i6+c76JDndnoOzBxZmVrrq0oehNDvrfnKA
 9KRMqjYp0f8NOHG9mhY64lWPvSjbdT67c=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 05:17:37 -0700
IronPort-SDR: tYXLYYOVP3RJWJS/mz3FVwLWJzuSl4oGx0xkgzg/7UHSGVT8NISHELDRsDgLxnHQ7ZaaYAesA6
 pbTlPgPlE8pQ==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Jul 2020 05:29:07 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Date:   Mon, 13 Jul 2020 21:28:58 +0900
Message-Id: <20200713122901.1773-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713122901.1773-1-johannes.thumshirn@wdc.com>
References: <20200713122901.1773-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
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
---
 fs/btrfs/ioctl.c           | 16 +++++++++++++---
 include/uapi/linux/btrfs.h | 15 +++++++++++++--
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab34179d7cbc..3a566cf71fc6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3217,11 +3217,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 	struct btrfs_ioctl_fs_info_args *fi_args;
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	u32 flags_in;
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
@@ -3237,6 +3241,12 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
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
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index e6b6cb0f8bc6..b3e0af77642f 100644
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
@@ -250,10 +257,14 @@ struct btrfs_ioctl_fs_info_args {
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
 
+
 /*
  * feature flags
  *
-- 
2.26.2

