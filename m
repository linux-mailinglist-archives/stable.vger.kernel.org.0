Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624C8451E72
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344007AbhKPAgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344980AbhKOTZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E0B636FA;
        Mon, 15 Nov 2021 19:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003284;
        bh=yT9kCNGsMtaMYfdVhvUnVhEI2DuFWGKfPsijpFwuxrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywCYYe6QRTiflP1lGTpDc/POiOBlJqS+lB6Oma+hlkpNmzWvOSgiK1SlqfT/xV0mF
         Xq++0lohotUlENyOLLek+x0PjkiTimwGC7Q+1YyV05YOean78hIiud2YiAJcj2Blbr
         Db5nCD5snB15KQFDHfS6qSepaw8TWPSR5bYYCuL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sikorski <belegdol@gmail.com>,
        Jeremy Allison <jra@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 846/917] smb3: do not error on fsync when readonly
Date:   Mon, 15 Nov 2021 18:05:41 +0100
Message-Id: <20211115165457.725993733@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 71e6864eacbef0b2645ca043cdfbac272cb6cea3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2692,12 +2692,23 @@ int cifs_strict_fsync(struct file *file,
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
@@ -2709,6 +2720,7 @@ int cifs_fsync(struct file *file, loff_t
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *smbfile = file->private_data;
+	struct inode *inode = file_inode(file);
 	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
 
 	rc = file_write_and_wait_range(file, start, end);
@@ -2725,12 +2737,23 @@ int cifs_fsync(struct file *file, loff_t
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


