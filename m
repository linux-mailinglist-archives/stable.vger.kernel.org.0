Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAF5794AE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388322AbfG2TeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388300AbfG2TeV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D4A12070B;
        Mon, 29 Jul 2019 19:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428861;
        bh=JXXnD+mSNHBXC3kUYw63taAy32BnqtO0iu62oDfcaok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ4zcNCDc8FMuTGGkrm4rMTzaTIacgEYog1U1ZUBFy/nxhlSng3oEsBlO42l0ZRd0
         dbT4g2JHXfYu8z4+RhMgHyX2RAaNgd8vTWYst4pgq2rE4kQAP6RoEMGeL78jTHadEq
         9p5FZtq4CrVK1tw51EBYWrgTG8w7LaU999REPifU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, stable@kernel.org
Subject: [PATCH 4.14 209/293] ext4: enforce the immutable flag on open files
Date:   Mon, 29 Jul 2019 21:21:40 +0200
Message-Id: <20190729190840.474798256@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
@@ -163,6 +163,10 @@ static ssize_t ext4_write_checks(struct
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
@@ -5341,6 +5341,14 @@ int ext4_setattr(struct dentry *dentry,
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
@@ -6045,6 +6053,9 @@ int ext4_page_mkwrite(struct vm_fault *v
 	get_block_t *get_block;
 	int retries = 0;
 
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return VM_FAULT_SIGBUS;
+
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
 


