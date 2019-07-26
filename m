Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBDB76D6D
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389305AbfGZPdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388496AbfGZPdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:33:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57AC4205F4;
        Fri, 26 Jul 2019 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155219;
        bh=taBCINhjsSyrUQtsJcV9YDjvgYO9fe4mXAzHX0ZQLMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNu72dgald7bRfV//Ky4FZDG/Oxh3IwvksLUSitIxUBUjoK+xopgxiJAVZR6Zo9db
         diJrtTkYfvuEFWP691u/XQbaVr1z2Reidh5lsc8KUB6yw1ku/Y1V1cMHuvzEZI1hXv
         gE4CN9SJhjrsykwqRY9JOld40mrKC/wZ5dqza7hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, stable@kernel.org
Subject: [PATCH 4.19 43/50] ext4: enforce the immutable flag on open files
Date:   Fri, 26 Jul 2019 17:25:18 +0200
Message-Id: <20190726152305.162768329@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 02b016ca7f99229ae6227e7b2fc950c4e140d74a upstream.

According to the chattr man page, "a file with the 'i' attribute
cannot be modified..."  Historically, this was only enforced when the
file was opened, per the rest of the description, "... and the file
can not be opened in write mode".

There is general agreement that we should standardize all file systems
to prevent modifications even for files that were opened at the time
the immutable flag is set.  Eventually, a change to enforce this at
the VFS layer should be landing in mainline.  Until then, enforce this
at the ext4 level to prevent xfstests generic/553 from failing.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/file.c  |    4 ++++
 fs/ext4/inode.c |   11 +++++++++++
 2 files changed, 15 insertions(+)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -165,6 +165,10 @@ static ssize_t ext4_write_checks(struct
 	ret = generic_write_checks(iocb, from);
 	if (ret <= 0)
 		return ret;
+
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
 	/*
 	 * If we have encountered a bitmap-format file, the size limit
 	 * is smaller than s_maxbytes, which is for extent-mapped files.
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5491,6 +5491,14 @@ int ext4_setattr(struct dentry *dentry,
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
+	if (unlikely(IS_APPEND(inode) &&
+		     (ia_valid & (ATTR_MODE | ATTR_UID |
+				  ATTR_GID | ATTR_TIMES_SET))))
+		return -EPERM;
+
 	error = setattr_prepare(dentry, attr);
 	if (error)
 		return error;
@@ -6190,6 +6198,9 @@ int ext4_page_mkwrite(struct vm_fault *v
 	get_block_t *get_block;
 	int retries = 0;
 
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return VM_FAULT_SIGBUS;
+
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
 


