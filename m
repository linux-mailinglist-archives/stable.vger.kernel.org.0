Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710A05076D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfFXKHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbfFXKHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:00 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD72208E3;
        Mon, 24 Jun 2019 10:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370819;
        bh=x9xZl6yC252+YAjdmdXwcc8dd6i6py5IJ2lgNuFN2e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzUEXIrJekdKoDyA3qYzcOBsvEvjh4uIHDOboavT7x4w9IV0wK7HDC6GHJ4uVWLNR
         ERl1baDSQtgU4mS7dT8bv8CRb/TzGpWXXeBY7glghHbtjoqF1tumrjP+JKmbaljFbZ
         UMXfh1ACdlaw+RaAG1wNwaeDWcTcOIlzTyYYr9oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.1 013/121] cifs: add spinlock for the openFileList to cifsInodeInfo
Date:   Mon, 24 Jun 2019 17:55:45 +0800
Message-Id: <20190624092321.322715737@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 487317c99477d00f22370625d53be3239febabbe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsfs.c   |    1 +
 fs/cifs/cifsglob.h |    5 +++++
 fs/cifs/file.c     |    8 ++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -303,6 +303,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
 	cifs_inode->epoch = 0;
+	spin_lock_init(&cifs_inode->open_file_lock);
 	generate_random_uuid(cifs_inode->lease_key);
 
 	/*
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1357,6 +1357,7 @@ struct cifsInodeInfo {
 	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
+	spinlock_t	open_file_lock;	/* protects openFileList */
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	unsigned int epoch;		/* used to track lease state changes */
@@ -1760,10 +1761,14 @@ require use of the stronger protocol */
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
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid,
 	atomic_inc(&tcon->num_local_opens);
 
 	/* if readable file instance put first in list*/
+	spin_lock(&cinode->open_file_lock);
 	if (file->f_mode & FMODE_READ)
 		list_add(&cfile->flist, &cinode->openFileList);
 	else
 		list_add_tail(&cfile->flist, &cinode->openFileList);
+	spin_unlock(&cinode->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
 	if (fid->purge_cache)
@@ -413,7 +415,9 @@ void _cifsFileInfo_put(struct cifsFileIn
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
+	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
+	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
 	atomic_dec(&tcon->num_local_opens);
 
@@ -1950,9 +1954,9 @@ refind_writable:
 			return 0;
 		}
 
-		spin_lock(&tcon->open_file_lock);
+		spin_lock(&cifs_inode->open_file_lock);
 		list_move_tail(&inv_file->flist, &cifs_inode->openFileList);
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&cifs_inode->open_file_lock);
 		cifsFileInfo_put(inv_file);
 		++refind;
 		inv_file = NULL;


