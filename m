Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43CD215A4F
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 17:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgGFPJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 11:09:30 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48384 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729235AbgGFPJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 11:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594048170; x=1625584170;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2pNpRzFkcVF1COKX8mt6dXf/Ifz9X8ic6aabtkv6JxI=;
  b=JnFLUbg9yFXekeNF78saGw3Gh+6IHgaZhl5SYDy5eYDXu9bO+JbmVAvn
   PsLmxqHqQpPO7wuTtBdhw75u073r5QTfEZd8A3EPrHD+rr03LAtBQZDg6
   0xvUM2nIe58VetMifNzxEuv+IlorqoTBoEpdbNQyS5fWIO9J6tcHZeLQN
   gWyGNS2fxzWcHxwD3yYzGAwG+801P3ENe3IL3I+mh4T8mfoh9cZiky/+1
   zyZYC7ayZ10JfTbrzFhv+QQt+WvWs2c5ShnydVRmHO0jHjL28eelzYzU2
   SrPJkuI+yTvbpeFOJuFOgXqladvlSsNb2z9DS31FDz20d/C8wjIJ7jmML
   g==;
IronPort-SDR: 7m82vEiGQtl/i99NGjikCSQeInhW7Yx9N3e6zxSdAC5Ny8FLrnzOt0DF+Z+HOJIWVFHQsRzj4E
 Gbe8NWq1x0bBew7eBkMVitZHJy8nlrRWO0k9oR4fWsayvctl9Xqt0sRzduwN81K4kG9BFSRqi8
 zi79aeJ6l61ooKylVx+KvNkPchE+10RSkOuP1DCp/reaqK4QyBFEelGpaVf5Nr+QIG0J3WPNUr
 vF5OU2gWMlE79UwtleSTD80uj8Ok0/HUeyFWf/HveQg2SY9Q3dWMzaOELRlwpCg0lHYohC/ioO
 raI=
X-IronPort-AV: E=Sophos;i="5.75,320,1589212800"; 
   d="scan'208";a="143073969"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 23:09:29 +0800
IronPort-SDR: OBWpHrNoM9jxieK9xylTz7PXSVhI4MriSLKCdM8bacdqYA+Ysxsp60VsOjYoOkOkQoopMF4FVN
 nqrZm94oFzzOKf+eYbkDs6GOTJ10MoDcw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 07:58:10 -0700
IronPort-SDR: gn7E3jS01VcDrRfv8aZOrhn7DaLY8J4Q3UxBYyqPhYePp9lt/AjuZL2JBmTt8dhixNZ/btFa75
 LxKmPYxWp4xw==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 08:09:28 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org,
        Hans van Kranenburg <hans@knorrie.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        stable@vger.kernel.org
Subject: [PATCH v5] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Date:   Tue,  7 Jul 2020 00:09:24 +0900
Message-Id: <20200706150924.40218-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.26.2
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

For compatibility reasons, only return the csum_type and csum_size if the
BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE flag was passed to the kernel. Also
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
        __u32                      flags;                /*    44     4 */
        __u16                      csum_type;            /*    48     2 */
        __u16                      csum_size;            /*    50     2 */
        __u8                       reserved[972];        /*    52   972 */

        /* size: 1024, cachelines: 16, members: 10 */
};

Fixes: 3951e7f050ac ("btrfs: add xxhash64 to checksumming algorithms")
Fixes: 3831bf0094ab ("btrfs: add sha256 to checksumming algorithm")
CC: stable@vger.kernel.org # 5.5+
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v4:
* zero all data passed in from user-space
  (I've chosen this variant as I think it is the most complete)

Changes to v3:
* make flags in/out (David)
* make csum return opt-in (Hans)

Changes to v2:
* add additional csum_size (David)
* rename flag value to BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE to reflect
  additional size

Changes to v1:
* add 'out' comment to be consistent (Hans)
* remove le16_to_cpu() (kbuild robot)
* switch padding to be all u8 (David)
---
 fs/btrfs/ioctl.c           | 16 +++++++++++++---
 include/uapi/linux/btrfs.h | 14 ++++++++++++--
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab34179d7cbc..df8a6ba91055 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3217,11 +3217,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 	struct btrfs_ioctl_fs_info_args *fi_args;
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	u32 inflags;
 	int ret = 0;
 
-	fi_args = kzalloc(sizeof(*fi_args), GFP_KERNEL);
-	if (!fi_args)
-		return -ENOMEM;
+	fi_args = memdup_user(arg, sizeof(*fi_args));
+	if (IS_ERR(fi_args))
+		return PTR_ERR(fi_args);
+
+	inflags = fi_args->flags;
+	memset(fi_args, 0, sizeof(*fi_args));
 
 	rcu_read_lock();
 	fi_args->num_devices = fs_devices->num_devices;
@@ -3237,6 +3241,12 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 	fi_args->sectorsize = fs_info->sectorsize;
 	fi_args->clone_alignment = fs_info->sectorsize;
 
+	if (inflags & BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE) {
+		fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
+		fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
+		fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE;
+	}
+
 	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
 		ret = -EFAULT;
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index e6b6cb0f8bc6..c130eaea416e 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -250,10 +250,20 @@ struct btrfs_ioctl_fs_info_args {
 	__u32 nodesize;				/* out */
 	__u32 sectorsize;			/* out */
 	__u32 clone_alignment;			/* out */
-	__u32 reserved32;
-	__u64 reserved[122];			/* pad to 1k */
+	__u32 flags;				/* in/out */
+	__u16 csum_type;			/* out */
+	__u16 csum_size;			/* out */
+	__u8 reserved[972];			/* pad to 1k */
 };
 
+/*
+ * fs_info ioctl flags
+ *
+ * Used by:
+ * struct btrfs_ioctl_fs_info_args
+ */
+#define BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE		(1 << 0)
+
 /*
  * feature flags
  *
-- 
2.26.2

