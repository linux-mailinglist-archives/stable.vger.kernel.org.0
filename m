Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF2F217249
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgGGPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728553AbgGGPXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E2F420771;
        Tue,  7 Jul 2020 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135399;
        bh=V3MNR6DlO42sbFJ3PN981lOuq0u8IKSRQY/oEhSv9XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fa7kQnspRaz2pzzprK3fw5rc6+mBLWkbmhw+z+fjQaoJa/qsttSAMDXql6CyCyGTj
         ZxL/pEf1X31UOkYZ4TCOLhW7lTbf4clSc2VZnNX7TxOirdtpM1WuvCRSm/UIdCX3rH
         UnRkFklre/l7Nr/71qZFXwIHVdJYiHD7hFV4qgZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 005/112] exfat: flush dirty metadata in fsync
Date:   Tue,  7 Jul 2020 17:16:10 +0200
Message-Id: <20200707145801.192252551@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sungjong Seo <sj1557.seo@samsung.com>

[ Upstream commit 5267456e953fd8c5abd8e278b1cc6a9f9027ac0a ]

generic_file_fsync() exfat used could not guarantee the consistency of
a file because it has flushed not dirty metadata but only dirty data pages
for a file.

Instead of that, use exfat_file_fsync() for files and directories so that
it guarantees to commit both the metadata and data pages for a file.

Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c      |  2 +-
 fs/exfat/exfat_fs.h |  1 +
 fs/exfat/file.c     | 19 ++++++++++++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 349ca0c282c2c..6db302d76d4c1 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -314,7 +314,7 @@ const struct file_operations exfat_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate	= exfat_iterate,
-	.fsync		= generic_file_fsync,
+	.fsync		= exfat_file_fsync,
 };
 
 int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index d67fb8a6f770c..d865050fa6cd7 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -424,6 +424,7 @@ void exfat_truncate(struct inode *inode, loff_t size);
 int exfat_setattr(struct dentry *dentry, struct iattr *attr);
 int exfat_getattr(const struct path *path, struct kstat *stat,
 		unsigned int request_mask, unsigned int query_flags);
+int exfat_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 /* namei.c */
 extern const struct dentry_operations exfat_dentry_ops;
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 5b4ddff187312..b93aa9e6cb16c 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/buffer_head.h>
+#include <linux/blkdev.h>
 
 #include "exfat_raw.h"
 #include "exfat_fs.h"
@@ -347,12 +348,28 @@ int exfat_setattr(struct dentry *dentry, struct iattr *attr)
 	return error;
 }
 
+int exfat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
+{
+	struct inode *inode = filp->f_mapping->host;
+	int err;
+
+	err = __generic_file_fsync(filp, start, end, datasync);
+	if (err)
+		return err;
+
+	err = sync_blockdev(inode->i_sb->s_bdev);
+	if (err)
+		return err;
+
+	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+}
+
 const struct file_operations exfat_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
-	.fsync		= generic_file_fsync,
+	.fsync		= exfat_file_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 };
-- 
2.25.1



