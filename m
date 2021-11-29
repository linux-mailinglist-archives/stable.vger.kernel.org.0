Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D318F4626DA
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbhK2W55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhK2W53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:57:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F5EC141B36;
        Mon, 29 Nov 2021 10:32:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3ECACE13D0;
        Mon, 29 Nov 2021 18:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75401C53FAD;
        Mon, 29 Nov 2021 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210752;
        bh=ea4tfQQOfMATtlI7evWrjciHYa2mDFvBvDEMF8y32IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvMnfxxMGjFbquhe608SULEUkGLqTFB0escCB+s8k1abYBPHyxO4QQsiar0bDZEvr
         9dCC/EfK9QWusgjnBGd7E/MuPOqotIYaVkONG/qTMpWnjqSNG3+vTk3rXpHGqqvm1x
         NOD7kMnOCY3Y7RSDz7DHM31Ojf1BjppcqUJ0CLec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sikorski <belegdol@gmail.com>,
        Jeremy Allison <jra@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/121] smb3: do not error on fsync when readonly
Date:   Mon, 29 Nov 2021 19:18:56 +0100
Message-Id: <20211129181715.196035836@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



