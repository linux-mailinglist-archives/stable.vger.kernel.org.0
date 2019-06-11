Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998453C150
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 04:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390244AbfFKCnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 22:43:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44136 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390461AbfFKCnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 22:43:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 87F4069DBA60105D8B68;
        Tue, 11 Jun 2019 10:43:15 +0800 (CST)
Received: from architecture4.huawei.com (10.140.130.215) by smtp.huawei.com
 (10.3.19.212) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 11 Jun
 2019 10:43:06 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Chao Yu <yuchao0@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        <linux-erofs@lists.ozlabs.org>, "Chao Yu" <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>, <weidu.du@huawei.com>,
        Fang Wei <fangwei1@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] staging: erofs: add requirements field in superblock
Date:   Tue, 11 Jun 2019 10:42:19 +0800
Message-ID: <20190611024220.86121-1-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.140.130.215]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are some backward incompatible features pending
for months, mainly due to on-disk format expensions.

However, we should ensure that it cannot be mounted with
old kernels. Otherwise, it will causes unexpected behaviors.

Fixes: ba2b77a82022 ("staging: erofs: add super block operations")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
change log v2:
 - update printed message

 drivers/staging/erofs/erofs_fs.h | 13 ++++++++++---
 drivers/staging/erofs/super.c    | 17 +++++++++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index fa52898df006..8ddb2b3e7d39 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -17,10 +17,16 @@
 #define EROFS_SUPER_MAGIC_V1    0xE0F5E1E2
 #define EROFS_SUPER_OFFSET      1024
 
+/*
+ * Any bits that aren't in EROFS_ALL_REQUIREMENTS should be
+ * incompatible with this kernel version.
+ */
+#define EROFS_ALL_REQUIREMENTS  0
+
 struct erofs_super_block {
 /*  0 */__le32 magic;           /* in the little endian */
 /*  4 */__le32 checksum;        /* crc32c(super_block) */
-/*  8 */__le32 features;
+/*  8 */__le32 features;        /* (aka. feature_compat) */
 /* 12 */__u8 blkszbits;         /* support block_size == PAGE_SIZE only */
 /* 13 */__u8 reserved;
 
@@ -34,9 +40,10 @@ struct erofs_super_block {
 /* 44 */__le32 xattr_blkaddr;
 /* 48 */__u8 uuid[16];          /* 128-bit uuid for volume */
 /* 64 */__u8 volume_name[16];   /* volume name */
+/* 80 */__le32 requirements;    /* (aka. feature_incompat) */
 
-/* 80 */__u8 reserved2[48];     /* 128 bytes */
-} __packed;
+/* 84 */__u8 reserved2[44];
+} __packed;                     /* 128 bytes */
 
 /*
  * erofs inode data mapping:
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index f580d4ef77a1..fdcf65b3e52d 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -71,6 +71,20 @@ static void free_inode(struct inode *inode)
 	kmem_cache_free(erofs_inode_cachep, vi);
 }
 
+static bool check_layout_compatibility(struct super_block *sb,
+				       struct erofs_super_block *layout)
+{
+	const unsigned int requirements = le32_to_cpu(layout->requirements);
+
+	/* check if current kernel meets all mandatory requirements */
+	if (requirements & (~EROFS_ALL_REQUIREMENTS)) {
+		errln("unidentified requirements %x, please upgrade kernel version",
+		      requirements & ~EROFS_ALL_REQUIREMENTS);
+		return false;
+	}
+	return true;
+}
+
 static int superblock_read(struct super_block *sb)
 {
 	struct erofs_sb_info *sbi;
@@ -104,6 +118,9 @@ static int superblock_read(struct super_block *sb)
 		goto out;
 	}
 
+	if (!check_layout_compatibility(sb, layout))
+		goto out;
+
 	sbi->blocks = le32_to_cpu(layout->blocks);
 	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
 #ifdef CONFIG_EROFS_FS_XATTR
-- 
2.17.1

