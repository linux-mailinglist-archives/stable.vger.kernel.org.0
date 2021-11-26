Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F7245E4A9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357818AbhKZCgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:36:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357679AbhKZCeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:34:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE2461164;
        Fri, 26 Nov 2021 02:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893841;
        bh=ea4tfQQOfMATtlI7evWrjciHYa2mDFvBvDEMF8y32IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8YaEROnGqR/gAnayRP5CXwzhfpq13afMPvPmuM0RepwAgHwPL2ZX2KxSqTfINwwt
         Y1O6BTWZwdE1f9eD6rw+dWt7mSoDnvqPZs9NXaPqf8ovMtqqSZ1WD7CPq3j1BlcJxR
         DVwZfVF+jxkCL1Z2MlCsl+kYj5xbzDHwwkHgKxYbaTlTbU8jXcXe+cL8DDORjOUlQ8
         QvuGMuczX5mDLXcGWfjNq3V9nWaDFABOVB6v9VvAi2xQVur0XgOlledA5o9PI+cJ5B
         l+f08X2GoX3wz/FwCVaFbF02pwZVhCSAL9vr7cFTe+0qPbIcxZQ2nGIFvpHxkRg7Mk
         66D9RRlH/UPXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Julian Sikorski <belegdol@gmail.com>,
        Jeremy Allison <jra@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 4/4] smb3: do not error on fsync when readonly
Date:   Thu, 25 Nov 2021 21:30:34 -0500
Message-Id: <20211126023034.440961-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023034.440961-1-sashal@kernel.org>
References: <20211126023034.440961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 71e6864eacbef0b2645ca043cdfbac272cb6cea3 ]

Linux allows doing a flush/fsync on a file open for read-only,
but the protocol does not allow that.  If the file passed in
on the flush is read-only try to find a writeable handle for
the same inode, if that is not possible skip sending the
fsync call to the server to avoid breaking the apps.

Reported-by: Julian Sikorski <belegdol@gmail.com>
Tested-by: Julian Sikorski <belegdol@gmail.com>
Suggested-by: Jeremy Allison <jra@samba.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 67139f9d583f2..6c06870f90184 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2618,12 +2618,23 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
-		if (server->ops->flush)
-			rc = server->ops->flush(xid, tcon, &smbfile->fid);
-		else
+		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
+			goto strict_fsync_exit;
+		}
+
+		if ((OPEN_FMODE(smbfile->f_flags) & FMODE_WRITE) == 0) {
+			smbfile = find_writable_file(CIFS_I(inode), FIND_WR_ANY);
+			if (smbfile) {
+				rc = server->ops->flush(xid, tcon, &smbfile->fid);
+				cifsFileInfo_put(smbfile);
+			} else
+				cifs_dbg(FYI, "ignore fsync for file not open for write\n");
+		} else
+			rc = server->ops->flush(xid, tcon, &smbfile->fid);
 	}
 
+strict_fsync_exit:
 	free_xid(xid);
 	return rc;
 }
@@ -2635,6 +2646,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *smbfile = file->private_data;
+	struct inode *inode = file_inode(file);
 	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
 
 	rc = file_write_and_wait_range(file, start, end);
@@ -2651,12 +2663,23 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
-		if (server->ops->flush)
-			rc = server->ops->flush(xid, tcon, &smbfile->fid);
-		else
+		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
+			goto fsync_exit;
+		}
+
+		if ((OPEN_FMODE(smbfile->f_flags) & FMODE_WRITE) == 0) {
+			smbfile = find_writable_file(CIFS_I(inode), FIND_WR_ANY);
+			if (smbfile) {
+				rc = server->ops->flush(xid, tcon, &smbfile->fid);
+				cifsFileInfo_put(smbfile);
+			} else
+				cifs_dbg(FYI, "ignore fsync for file not open for write\n");
+		} else
+			rc = server->ops->flush(xid, tcon, &smbfile->fid);
 	}
 
+fsync_exit:
 	free_xid(xid);
 	return rc;
 }
-- 
2.33.0

