Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4573291E4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbhCAUft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243379AbhCAU2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:28:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E0DE65416;
        Mon,  1 Mar 2021 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622047;
        bh=hxYdr4dB1bXlOK5zIKH2KUT8LQ/NI5Cnto29N8W9ja0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzyFogSJH2LvIN3dumd/eX/wICSeRMdv5raAA0FJeAOQplnzdnr+iE9cXRc33HHKp
         ln9ASg+UQ/41MHQoU063cxBgmmt/sbqeHCUfvLx/gfM4Mw29JMdsCsOEakf4NnCwIT
         h+owEc4F3TqbEzIOKzN4eOOs7G/hBWQLT1yHnGtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.11 738/775] f2fs: enforce the immutable flag on open files
Date:   Mon,  1 Mar 2021 17:15:06 +0100
Message-Id: <20210301161237.807784811@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit e0fcd01510ad025c9bbce704c5c2579294056141 upstream.

This patch ports commit 02b016ca7f99 ("ext4: enforce the immutable
flag on open files") to f2fs.

According to the chattr man page, "a file with the 'i' attribute
cannot be modified..."  Historically, this was only enforced when the
file was opened, per the rest of the description, "... and the file
can not be opened in write mode".

There is general agreement that we should standardize all file systems
to prevent modifications even for files that were opened at the time
the immutable flag is set.  Eventually, a change to enforce this at
the VFS layer should be landing in mainline.

Cc: stable@kernel.org
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -60,6 +60,9 @@ static vm_fault_t f2fs_vm_page_mkwrite(s
 	bool need_alloc = true;
 	int err = 0;
 
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return VM_FAULT_SIGBUS;
+
 	if (unlikely(f2fs_cp_error(sbi))) {
 		err = -EIO;
 		goto err;
@@ -870,6 +873,14 @@ int f2fs_setattr(struct dentry *dentry,
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
 		return -EIO;
 
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
+	if (unlikely(IS_APPEND(inode) &&
+			(attr->ia_valid & (ATTR_MODE | ATTR_UID |
+				  ATTR_GID | ATTR_TIMES_SET))))
+		return -EPERM;
+
 	if ((attr->ia_valid & ATTR_SIZE) &&
 		!f2fs_is_compress_backend_ready(inode))
 		return -EOPNOTSUPP;
@@ -4356,6 +4367,11 @@ static ssize_t f2fs_file_write_iter(stru
 		inode_lock(inode);
 	}
 
+	if (unlikely(IS_IMMUTABLE(inode))) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
 	ret = generic_write_checks(iocb, from);
 	if (ret > 0) {
 		bool preallocated = false;
@@ -4420,6 +4436,7 @@ write:
 		if (ret > 0)
 			f2fs_update_iostat(F2FS_I_SB(inode), APP_WRITE_IO, ret);
 	}
+unlock:
 	inode_unlock(inode);
 out:
 	trace_f2fs_file_write_iter(inode, iocb->ki_pos,


