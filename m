Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B0177ED9
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgCCRrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731332AbgCCRrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:47:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA60E20CC7;
        Tue,  3 Mar 2020 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257641;
        bh=UeHlxsf9EkdklZ/gEJ4UdDiX9mhmtzs1cPM0Loq8CW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/T6NHWS0C7BcMcI9Rt9ENgc135xP97hUcFk+2x5oGPikRNi7PF/yTUus/5GePzZu
         aKCvbPNz2dXomJ1TUvX8pdz3uo3JuKsf4wBeI40ZjyIKrsPnzSIrxwXI8oDr5P+5hD
         2/FYiWlU7rO4KnVGWA5wWtJ6ydrINU9t30/2an2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 071/176] cifs: Fix mode output in debugging statements
Date:   Tue,  3 Mar 2020 18:42:15 +0100
Message-Id: <20200303174312.861809326@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit f52aa79df43c4509146140de0241bc21a4a3b4c7 ]

A number of the debug statements output file or directory mode
in hex.  Change these to print using octal.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 4 ++--
 fs/cifs/connect.c | 2 +-
 fs/cifs/inode.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index fb41e51dd5743..25704beb9d4ca 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -601,7 +601,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
 		*pmode |= (S_IXUGO & (*pbits_to_set));
 
-	cifs_dbg(NOISY, "access flags 0x%x mode now 0x%x\n", flags, *pmode);
+	cifs_dbg(NOISY, "access flags 0x%x mode now %04o\n", flags, *pmode);
 	return;
 }
 
@@ -630,7 +630,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	if (mode & S_IXUGO)
 		*pace_flags |= SET_FILE_EXEC_RIGHTS;
 
-	cifs_dbg(NOISY, "mode: 0x%x, access flags now 0x%x\n",
+	cifs_dbg(NOISY, "mode: %04o, access flags now 0x%x\n",
 		 mode, *pace_flags);
 	return;
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0aa3623ae0e16..641825cfa7670 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4151,7 +4151,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	cifs_sb->mnt_gid = pvolume_info->linux_gid;
 	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
 	cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
-	cifs_dbg(FYI, "file mode: 0x%hx  dir mode: 0x%hx\n",
+	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
 
 	cifs_sb->actimeo = pvolume_info->actimeo;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ca76a9287456f..b3f3675e18788 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1649,7 +1649,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	struct TCP_Server_Info *server;
 	char *full_path;
 
-	cifs_dbg(FYI, "In cifs_mkdir, mode = 0x%hx inode = 0x%p\n",
+	cifs_dbg(FYI, "In cifs_mkdir, mode = %04ho inode = 0x%p\n",
 		 mode, inode);
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-- 
2.20.1



