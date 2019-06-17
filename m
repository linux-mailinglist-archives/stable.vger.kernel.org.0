Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1F8491D8
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFQVAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfFQVAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:00:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE71D2080A;
        Mon, 17 Jun 2019 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560805214;
        bh=3K1wq8SumDUjOos8o3r6Jn8Nne8mBnHJ7iCT3yQAKzE=;
        h=Subject:To:From:Date:From;
        b=duIM1sRRlw7q8+L/3flE7jyQynL+ZmJdpawa0WGbA4i9H+SJiBRNZR3fhXivbqlfd
         u+sWu/WxLJuJTO5JrYbqT3qwqhsNoK604xGXrtNSZYw2ctpfsdi+EDl8cZrSExGkV6
         sw6hVRt+cEkDJ4SooxeTc5qdC1gcxoDJ9Z2OF34c=
Subject: patch "staging: erofs: add requirements field in superblock" added to staging-linus
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Jun 2019 23:00:11 +0200
Message-ID: <156080521116227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: erofs: add requirements field in superblock

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5efe5137f05bbb4688890620934538c005e7d1d6 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Thu, 13 Jun 2019 16:35:41 +0800
Subject: staging: erofs: add requirements field in superblock

There are some backward incompatible features pending
for months, mainly due to on-disk format expensions.

However, we should ensure that it cannot be mounted with
old kernels. Otherwise, it will causes unexpected behaviors.

Fixes: ba2b77a82022 ("staging: erofs: add super block operations")
Cc: <stable@vger.kernel.org> # 4.19+
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/erofs_fs.h | 13 ++++++++++---
 drivers/staging/erofs/internal.h |  2 ++
 drivers/staging/erofs/super.c    | 19 +++++++++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

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
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index c47778b3fabd..382258fc124d 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -115,6 +115,8 @@ struct erofs_sb_info {
 
 	u8 uuid[16];                    /* 128-bit uuid for volume */
 	u8 volume_name[16];             /* volume name */
+	u32 requirements;
+
 	char *dev_name;
 
 	unsigned int mount_opt;
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index f580d4ef77a1..cadbcc11702a 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -71,6 +71,22 @@ static void free_inode(struct inode *inode)
 	kmem_cache_free(erofs_inode_cachep, vi);
 }
 
+static bool check_layout_compatibility(struct super_block *sb,
+				       struct erofs_super_block *layout)
+{
+	const unsigned int requirements = le32_to_cpu(layout->requirements);
+
+	EROFS_SB(sb)->requirements = requirements;
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
@@ -104,6 +120,9 @@ static int superblock_read(struct super_block *sb)
 		goto out;
 	}
 
+	if (!check_layout_compatibility(sb, layout))
+		goto out;
+
 	sbi->blocks = le32_to_cpu(layout->blocks);
 	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
 #ifdef CONFIG_EROFS_FS_XATTR
-- 
2.22.0


