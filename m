Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CF620D52D
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbgF2TP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:15:26 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8610 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731300AbgF2TPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593458124; x=1624994124;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1NcEUCEtXCv3vJJpGVm2yhMkKJDAfph1QV8N+OpIDLo=;
  b=XbujnfBEfGxYQYa6chZSy8AnlyjkmQVYm1Qp7TcgrBdUbE0rxjDuT/eY
   Wr+59io765dkWnSNE+2+8z5kTTbrjQ0TyfBQGjQcUhYbS6vLnIv8YCFU9
   PiLD8FJckUIv1QftAIuaw8vz/Fl0MKxa17hAurnBFzuSZ1FSnXdaL9k5b
   PzQBYNsjHIvjUr2lQQgaW6mnfJdFCYrcJX8M7BsVy/hrLfOCm/Vf20eZD
   cYYvwzBMiC0TocFauSJAiUaEG7s5Z2HXOomBK+mJTAy9snfJBDcQMBZjw
   iq+wgbkcs6dIivbYW2G9Pizjk/NBoNMtK6EbU7VejnR2F8yK3Wq+YX8lL
   A==;
IronPort-SDR: 1yLSdjVUL4sw+MXrPDkr4lY/hMBzHSX2u1AQLgeilV6ikWJjwL7yHjL8FlDQRCWwkdktjJm4WN
 YfPpISQdHUUzLnqFtLojl3NsV9loioI+o0M/MFLSSelr0Sh+3x2SxExEVZ/VCcPG6tqhhGDCoC
 /9FrtlOot8FlJLfvdTzLm6Rtq4YlDL/9KbAfYJQSOqHnL3w1e/oxfyYlKvA8ZYo9A6+ZkdP/rH
 zpgkTaQSkVoyJl0vaUh/bIwaIdr2CodPUvBRENEFjdM87kMM5GnJ37cKkaP5YZPLWjryuOHGDV
 zAQ=
X-IronPort-AV: E=Sophos;i="5.75,294,1589212800"; 
   d="scan'208";a="145486269"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 15:53:35 +0800
IronPort-SDR: c+XsMpjwBqtMvXak5xL/RqqnpG4dLhzrNyZcJ49D9zpqTu/jWG5dKn9IXo+2tlVAYBmuGEMpn4
 3axKglTxMuRdhG5GSh43JEAH7HL+8RMII=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 00:41:55 -0700
IronPort-SDR: B0TJaap1y5R0zQeymxEIQXIOXG4nP/pNO6MZZAr7kuReGJw+q1UqJYuOdwIcGGE9B9i3YaAjTM
 f5+jXmyUrxSA==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Jun 2020 00:53:33 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org,
        Hans van Kranenburg <hans@knorrie.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        stable@vger.kernel.org
Subject: [PATCH v4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Date:   Mon, 29 Jun 2020 16:53:29 +0900
Message-Id: <20200629075329.36969-1-johannes.thumshirn@wdc.com>
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
index b3e4c632d80c..4d70b918f656 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3198,11 +3198,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
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
+	fi_args->flags = 0;
 
 	rcu_read_lock();
 	fi_args->num_devices = fs_devices->num_devices;
@@ -3218,6 +3222,12 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
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

