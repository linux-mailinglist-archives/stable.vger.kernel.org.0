Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5D220B414
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 17:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgFZPB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 11:01:26 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:20375 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFZPBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 11:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593183685; x=1624719685;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=71Um+1TYPFOxPr4eD3s8fnFPttTI3bEZgQ1l+I4R5pU=;
  b=aiAtnIKabPfpSTMPUYMUEjqvrvAYVhiN2ksZ4Uh/kGMxXAupRoS7t/ok
   savQFSEuk38cJKNMo1d8U5n0Xia3sY7Ja/F5NBSwksSkDRCCBYhgyKuTR
   MNhi/Sc5do8o8DuSAcuPhX417IVUa0A/8hLn/cc+9Kxmo/ErrpsliU/k2
   7cCUIkIeRNjDbMZz4hw992fQSoFoVqG9O9I/n8zMB9K7x3INVOyYlFKEq
   k9iGkQGWipwbOShCiaqJvQkGPFaiVJhD0c19lSv9rO+F+JxbYSXB0Jyg6
   iqN6pDet2WBAxE+Sj67zO5g1Zr2Jmmn5K9dRosbU/bSvCMdjAM0zaWRmO
   A==;
IronPort-SDR: S82CB/NPH2DDnOvxTvn83x4n9bxZqCjAo9rXnf2j63n7tMIWrGIjsX3WOOe9F3ElY8alnUHyAv
 ZdZ62LRFq5NTFmb8t3jZlBSSkKAmz7iN1woPh/1mBd7fLh+Kng+jtXDe3l0lB/b639I6WqW4jd
 eMBRvKpSohHTFMcjB1H7/0k6s7CM0/o71Pj7pEVaID8aC0mSHIinvpt5Fx2sWSqUJRej4DTyjs
 BbLmaybH6Pit2E610bp2mQrnPMsQmoebTJh1j9W3ng/URmnJg47OkZOH2c1tHF+4iPHrP++GNS
 RDw=
X-IronPort-AV: E=Sophos;i="5.75,284,1589212800"; 
   d="scan'208";a="142372879"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jun 2020 23:01:25 +0800
IronPort-SDR: rAi5oGCXKRlh5RoR/JcnkIt9q4Al335dGpIYmP8aVgNo5jfMNShXhD1oEOV/jnEomTJGriAQts
 ghj2aMmOO8W13Xd0JfGnvp0a6/J5CLcgg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 07:50:24 -0700
IronPort-SDR: tKUo55bvFSD+gGu6eu5/gmKH/7yYyn7sa6iqC18EbWVYC07paHgVocfTTd8Xf9lgA62+FXxWpP
 fStlgLXeEEuw==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Jun 2020 08:01:24 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Date:   Sat, 27 Jun 2020 00:01:07 +0900
Message-Id: <20200626150107.19666-1-johannes.thumshirn@wdc.com>
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

Add a new csum_type field to the BTRFS_IOC_FS_INFO ioctl command which
usually is used to query filesystem features. Also add a flags member
indicating that the kernel responded with a set csum_type field.

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
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v2:
* add additional csum_size (David)
* rename flag value to BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE to reflect
  additional size

Changes to v1:
* add 'out' comment to be consistent (Hans)
* remove le16_to_cpu() (kbuild robot)
* switch padding to be all u8 (David)
---
 fs/btrfs/ioctl.c           |  3 +++
 include/uapi/linux/btrfs.h | 14 ++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b3e4c632d80c..cfedcdf446c3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3217,6 +3217,9 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 	fi_args->nodesize = fs_info->nodesize;
 	fi_args->sectorsize = fs_info->sectorsize;
 	fi_args->clone_alignment = fs_info->sectorsize;
+	fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
+	fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
+	fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE;
 
 	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
 		ret = -EFAULT;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index e6b6cb0f8bc6..2de3ef3c5c71 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -250,10 +250,20 @@ struct btrfs_ioctl_fs_info_args {
 	__u32 nodesize;				/* out */
 	__u32 sectorsize;			/* out */
 	__u32 clone_alignment;			/* out */
-	__u32 reserved32;
-	__u64 reserved[122];			/* pad to 1k */
+	__u32 flags;				/* out */
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

