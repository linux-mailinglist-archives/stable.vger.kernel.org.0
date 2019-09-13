Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A93B1F61
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390327AbfIMNS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390322AbfIMNS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:56 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A2E20717;
        Fri, 13 Sep 2019 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380736;
        bh=hOxgvApp/1gfEFAkPo+InjWQiHi/zzIKADkmRTtA6vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFBbK+aP1pvRXqsOgQEpoPXeI0QTICive7aYjf/sJK/gh75SfjL6PkLgiHeFp2BkY
         Fxkbtr7PrIAIO1t175XERKouFiLWoPQPgD7c6TXnPxQeqCQ2vFnEy72BRi4jNxGu6J
         PxdIRBUdt3fa1ozgNiPJ0zj6L1mcdn9hPX2/G3Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/190] cifs: add spinlock for the openFileList to cifsInodeInfo
Date:   Fri, 13 Sep 2019 14:06:35 +0100
Message-Id: <20190913130611.187003688@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -1929,10 +1933,10 @@ refind_writable:
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



