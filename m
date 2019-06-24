Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A427350742
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfFXKGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbfFXKGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:01 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0370C212F5;
        Mon, 24 Jun 2019 10:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370760;
        bh=OQps3H3ljcKHdkYTP3akozmibnMzVqfCH4EZLVabmbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmp27kTv1RlcRhxf7Q/JdqryTPQ0mk+j6T95yWfBS0S7Glv6wFt/Y4VxL80n83y8F
         NFg5heK8Nw0vHHKrYHRQotG8QG0b4O5rBFp4JkHUig/jLp7UT/4Cvb1ySJbD+A93lF
         DXUXxNrXCBYKd76y4JmQ8DzCwOdgn0BtGPEzNPg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 4.19 80/90] staging: erofs: add requirements field in superblock
Date:   Mon, 24 Jun 2019 17:57:10 +0800
Message-Id: <20190624092319.173827456@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 5efe5137f05bbb4688890620934538c005e7d1d6 upstream.

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
 drivers/staging/erofs/erofs_fs.h |   13 ++++++++++---
 drivers/staging/erofs/internal.h |    2 ++
 drivers/staging/erofs/super.c    |   19 +++++++++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

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
 
 #define __EROFS_BIT(_prefix, _cur, _pre)	enum {	\
 	_prefix ## _cur ## _BIT = _prefix ## _pre ## _BIT + \
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -111,6 +111,8 @@ struct erofs_sb_info {
 
 	u8 uuid[16];                    /* 128-bit uuid for volume */
 	u8 volume_name[16];             /* volume name */
+	u32 requirements;
+
 	char *dev_name;
 
 	unsigned int mount_opt;
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -75,6 +75,22 @@ static void destroy_inode(struct inode *
 	call_rcu(&inode->i_rcu, i_callback);
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
@@ -108,6 +124,9 @@ static int superblock_read(struct super_
 		goto out;
 	}
 
+	if (!check_layout_compatibility(sb, layout))
+		goto out;
+
 	sbi->blocks = le32_to_cpu(layout->blocks);
 	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
 #ifdef CONFIG_EROFS_FS_XATTR


