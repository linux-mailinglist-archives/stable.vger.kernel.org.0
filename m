Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6B17FE79
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCJMoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbgCJMoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:44:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD31124695;
        Tue, 10 Mar 2020 12:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844259;
        bh=iN4YR3LRiHA8dU7APjF13wvNhiEphICltgkeAJM7t0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0XggLb809Y7HfyKEPfvp6Wt+glTVJ4jGnGqSoeJBLNU43O3QfuIiBfeUzBKl4vKe
         DFwXaWFhoO4kiS6nr+2iRmZ3A3zEhw4yJKuQDtcLBtosACOMhQkuOhZZYqXOD2+NM2
         5J1DpNuro8scWGOPCeoEJ7t6qUrHZ2kAics1aASo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/88] cifs: Fix mode output in debugging statements
Date:   Tue, 10 Mar 2020 13:38:25 +0100
Message-Id: <20200310123610.384414270@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
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
index 15bac390dff94..10aedc2a4c2dc 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -603,7 +603,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
 		*pmode |= (S_IXUGO & (*pbits_to_set));
 
-	cifs_dbg(NOISY, "access flags 0x%x mode now 0x%x\n", flags, *pmode);
+	cifs_dbg(NOISY, "access flags 0x%x mode now %04o\n", flags, *pmode);
 	return;
 }
 
@@ -632,7 +632,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	if (mode & S_IXUGO)
 		*pace_flags |= SET_FILE_EXEC_RIGHTS;
 
-	cifs_dbg(NOISY, "mode: 0x%x, access flags now 0x%x\n",
+	cifs_dbg(NOISY, "mode: %04o, access flags now 0x%x\n",
 		 mode, *pace_flags);
 	return;
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 961fcb40183a4..f2707ff795d45 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3401,7 +3401,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	cifs_sb->mnt_gid = pvolume_info->linux_gid;
 	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
 	cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
-	cifs_dbg(FYI, "file mode: 0x%hx  dir mode: 0x%hx\n",
+	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
 
 	cifs_sb->actimeo = pvolume_info->actimeo;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index b1c0961e6b3f2..7dda3f137c7aa 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1573,7 +1573,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	struct TCP_Server_Info *server;
 	char *full_path;
 
-	cifs_dbg(FYI, "In cifs_mkdir, mode = 0x%hx inode = 0x%p\n",
+	cifs_dbg(FYI, "In cifs_mkdir, mode = %04ho inode = 0x%p\n",
 		 mode, inode);
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-- 
2.20.1



