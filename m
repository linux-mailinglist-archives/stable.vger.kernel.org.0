Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7723ED5A6
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhHPNM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239493AbhHPNLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B278610E8;
        Mon, 16 Aug 2021 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119405;
        bh=0MeEVHFDK2m9FlPByBumTZwEL8wjjvU86kApD3tOg5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4tew/3lz/8vmaM9GQ4YLxMy/k1sEWeJqkiy1R9u1fB8o9su5O7wBE7yCR3+TvacH
         sagc5qTOyAR2c4m6gaGrDDKD0r2QiGDdIpp48IJCkL1S0y5RLh0TMWQ1MYBI9F4CdO
         BHAPZDtRp2urYfVYYra+/KLD4hrbaKXB65IRA3RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 014/151] cifs: Handle race conditions during rename
Date:   Mon, 16 Aug 2021 15:00:44 +0200
Message-Id: <20210816125444.542906568@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

commit 41535701da3324b80029cabb501e86c4fafe339d upstream.

When rename is executed on directory which has files for which
close is deferred, then rename will fail with EACCES.

This patch will try to close all deferred files when EACCES is received
and retry rename on a directory.

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Cc: stable@vger.kernel.org # 5.13
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/inode.c |   19 +++++++++++++++++--
 fs/cifs/misc.c  |   16 +++++++++++-----
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1637,7 +1637,7 @@ int cifs_unlink(struct inode *dir, struc
 		goto unlink_out;
 	}
 
-	cifs_close_all_deferred_files(tcon);
+	cifs_close_deferred_file(CIFS_I(inode));
 	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		rc = CIFSPOSIXDelFile(xid, tcon, full_path,
@@ -2096,6 +2096,7 @@ cifs_rename2(struct user_namespace *mnt_
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	unsigned int xid;
 	int rc, tmprc;
+	int retry_count = 0;
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -2125,10 +2126,24 @@ cifs_rename2(struct user_namespace *mnt_
 		goto cifs_rename_exit;
 	}
 
-	cifs_close_all_deferred_files(tcon);
+	cifs_close_deferred_file(CIFS_I(d_inode(source_dentry)));
+	if (d_inode(target_dentry) != NULL)
+		cifs_close_deferred_file(CIFS_I(d_inode(target_dentry)));
+
 	rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
 			    to_name);
 
+	if (rc == -EACCES) {
+		while (retry_count < 3) {
+			cifs_close_all_deferred_files(tcon);
+			rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
+					    to_name);
+			if (rc != -EACCES)
+				break;
+			retry_count++;
+		}
+	}
+
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -735,13 +735,19 @@ void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *cfile = NULL;
-	struct cifs_deferred_close *dclose;
+
+	if (cifs_inode == NULL)
+		return;
 
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
-		spin_lock(&cifs_inode->deferred_lock);
-		if (cifs_is_deferred_close(cfile, &dclose))
-			mod_delayed_work(deferredclose_wq, &cfile->deferred, 0);
-		spin_unlock(&cifs_inode->deferred_lock);
+		if (delayed_work_pending(&cfile->deferred)) {
+			/*
+			 * If there is no pending work, mod_delayed_work queues new work.
+			 * So, Increase the ref count to avoid use-after-free.
+			 */
+			if (!mod_delayed_work(deferredclose_wq, &cfile->deferred, 0))
+				cifsFileInfo_get(cfile);
+		}
 	}
 }
 


