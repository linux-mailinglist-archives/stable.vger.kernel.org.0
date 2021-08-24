Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD983F65EC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239140AbhHXRSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239844AbhHXRQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:16:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A2F3615E3;
        Tue, 24 Aug 2021 17:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824513;
        bh=XKTzpkvWsPkajOHJrlG+cpL530dTo0wptawiQyunpRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGb2fD3vDomS2Cuh6UEUGiylWeJiMSXOvc+fTpYD0681zhS3Qd/VGGChFD+u53SA9
         upFjkRHwEZumFeGoGsTpc5JpPqni4TVkteZeQ7Gbcagfqam9O2fFA3/SKaggbBbOoF
         kw52wU/GuA4+T+HNKUkrhgGgThOmnYT27fSnYEIboHmJtwr4OwPEt/SeO2z1Ybexk5
         2gTM93hMAAUrvtAph0Y67nCIktIT8EIy3F3NvzN/PNCd3mp01AEErltjKeG1s1WXli
         0PP2rfvqnsaLNbtFhYe+8fRVFnduLAr9n4G27zUl2YiPR9vSyoOJq6ipNinvU5aSr0
         AbjF//UZMoCTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/61] ovl: add splice file read write helper
Date:   Tue, 24 Aug 2021 13:00:50 -0400
Message-Id: <20210824170106.710221-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

[ Upstream commit 1a980b8cbf0059a5308eea61522f232fd03002e2 ]

Now overlayfs falls back to use default file splice read
and write, which is not compatiple with overlayfs, returning
EFAULT. xfstests generic/591 can reproduce part of this.

Tested this patch with xfstests auto group tests.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7a08a576f7b2..ab5e92897270 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -9,6 +9,9 @@
 #include <linux/xattr.h>
 #include <linux/uio.h>
 #include <linux/uaccess.h>
+#include <linux/splice.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
 #include "overlayfs.h"
 
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -293,6 +296,48 @@ out_unlock:
 	return ret;
 }
 
+static ssize_t ovl_splice_read(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe, size_t len,
+			 unsigned int flags)
+{
+	ssize_t ret;
+	struct fd real;
+	const struct cred *old_cred;
+
+	ret = ovl_real_fdget(in, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(in)->i_sb);
+	ret = generic_file_splice_read(real.file, ppos, pipe, len, flags);
+	revert_creds(old_cred);
+
+	ovl_file_accessed(in);
+	fdput(real);
+	return ret;
+}
+
+static ssize_t
+ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
+			  loff_t *ppos, size_t len, unsigned int flags)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	ssize_t ret;
+
+	ret = ovl_real_fdget(out, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(out)->i_sb);
+	ret = iter_file_splice_write(pipe, real.file, ppos, len, flags);
+	revert_creds(old_cred);
+
+	ovl_file_accessed(out);
+	fdput(real);
+	return ret;
+}
+
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct fd real;
@@ -649,6 +694,8 @@ const struct file_operations ovl_file_operations = {
 	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
 	.compat_ioctl	= ovl_compat_ioctl,
+	.splice_read    = ovl_splice_read,
+	.splice_write   = ovl_splice_write,
 
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,
-- 
2.30.2

