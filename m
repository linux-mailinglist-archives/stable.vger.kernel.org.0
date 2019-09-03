Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99873A6F3C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfICQay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbfICQ2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B9E23431;
        Tue,  3 Sep 2019 16:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528122;
        bh=P+e9KRq2RbmuZr+hTt0ka7y0UD+ZQcVJc5pyEkgLWLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7JgiXNFAnaDt+EjZO38JIMck6eCi9yGfhmVRdraGEsVppoTXE7M6CpLhOo9+5xs+
         9QmcALgdxl/9Lfl2zT/BBpNhr0rm5Fx5cnxARej7U7Q/ttX0RVskSZ1B8gLQNHsIip
         jMO4HdcxHwngQsIEhFKsm1DBwtzDsYSQpAOpMApM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 119/167] cifs: add spinlock for the openFileList to cifsInodeInfo
Date:   Tue,  3 Sep 2019 12:24:31 -0400
Message-Id: <20190903162519.7136-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 487317c99477d00f22370625d53be3239febabbe ]

We can not depend on the tcon->open_file_lock here since in multiuser mode
we may have the same file/inode open via multiple different tcons.

The current code is race prone and will crash if one user deletes a file
at the same time a different user opens/create the file.

To avoid this we need to have a spinlock attached to the inode and not the tcon.

RHBZ:  1580165

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c   | 1 +
 fs/cifs/cifsglob.h | 5 +++++
 fs/cifs/file.c     | 8 ++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fb32f3d6925e8..64e3888f30e6d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -292,6 +292,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
 	cifs_inode->epoch = 0;
+	spin_lock_init(&cifs_inode->open_file_lock);
 	generate_random_uuid(cifs_inode->lease_key);
 
 	/*
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0ee0072c1f362..57af9bac0045a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1287,6 +1287,7 @@ struct cifsInodeInfo {
 	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
+	spinlock_t	open_file_lock;	/* protects openFileList */
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	unsigned int epoch;		/* used to track lease state changes */
@@ -1687,10 +1688,14 @@ require use of the stronger protocol */
  *  tcp_ses_lock protects:
  *	list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the tcon
+ *  inode->open_file_lock protects the openFileList hanging off the inode
  *  cfile->file_info_lock protects counters and fields in cifs file struct
  *  f_owner.lock protects certain per file struct operations
  *  mapping->page_lock protects certain per page operations
  *
+ *  Note that the cifs_tcon.open_file_lock should be taken before
+ *  not after the cifsInodeInfo.open_file_lock
+ *
  *  Semaphores
  *  ----------
  *  sesSem     operations on smb session
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 933013543edab..8703b5f26f452 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -336,10 +336,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	list_add(&cfile->tlist, &tcon->openFileList);
 
 	/* if readable file instance put first in list*/
+	spin_lock(&cinode->open_file_lock);
 	if (file->f_mode & FMODE_READ)
 		list_add(&cfile->flist, &cinode->openFileList);
 	else
 		list_add_tail(&cfile->flist, &cinode->openFileList);
+	spin_unlock(&cinode->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
 	if (fid->purge_cache)
@@ -411,7 +413,9 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
+	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
+	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
 
 	if (list_empty(&cifsi->openFileList)) {
@@ -1929,10 +1933,10 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 		if (!rc)
 			return inv_file;
 		else {
-			spin_lock(&tcon->open_file_lock);
+			spin_lock(&cifs_inode->open_file_lock);
 			list_move_tail(&inv_file->flist,
 					&cifs_inode->openFileList);
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&cifs_inode->open_file_lock);
 			cifsFileInfo_put(inv_file);
 			++refind;
 			inv_file = NULL;
-- 
2.20.1

