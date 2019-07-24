Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFDF73CF5
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404306AbfGXT4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404601AbfGXT4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:56:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB30205C9;
        Wed, 24 Jul 2019 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998168;
        bh=lYC1Bq2EdelW/fsduAGh/6+cr/H+5YluvAT8MIfGVkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDGVwh1iuwEUyG/3Hh0xX5AAN8Ca9e5bDpQNdbQDWNmkB6pEn1peW4Et+3EZDajaF
         pWRzYCrNh0cMtKmsHlQsKKkKDTxvtolodfrwjQH8rDjWBuN/PZ5KAmoYXI45E/Ntto
         fI8pkhgBtdfrYdbDzibNR/qfpQs69PDDoW3k0xJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <paulo@paulo.ac>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilove@microsoft.com>
Subject: [PATCH 5.1 253/371] cifs: Properly handle auto disabling of serverino option
Date:   Wed, 24 Jul 2019 21:20:05 +0200
Message-Id: <20190724191743.673178427@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara (SUSE) <paulo@paulo.ac>

commit 29fbeb7a908a60a5ae8c50fbe171cb8fdcef1980 upstream.

Fix mount options comparison when serverino option is turned off later
in cifs_autodisable_serverino() and thus avoiding mismatch of new cifs
mounts.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <paulo@paulo.ac>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilove@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifs_fs_sb.h |    5 +++++
 fs/cifs/connect.c    |    8 ++++++--
 fs/cifs/misc.c       |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -83,5 +83,10 @@ struct cifs_sb_info {
 	 * failover properly.
 	 */
 	char *origin_fullpath; /* \\HOST\SHARE\[OPTIONAL PATH] */
+	/*
+	 * Indicate whether serverino option was turned off later
+	 * (cifs_autodisable_serverino) in order to match new mounts.
+	 */
+	bool mnt_cifs_serverino_autodisabled;
 };
 #endif				/* _CIFS_FS_SB_H */
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3455,12 +3455,16 @@ compare_mount_options(struct super_block
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
+	unsigned int oldflags = old->mnt_cifs_flags & CIFS_MOUNT_MASK;
+	unsigned int newflags = new->mnt_cifs_flags & CIFS_MOUNT_MASK;
 
 	if ((sb->s_flags & CIFS_MS_MASK) != (mnt_data->flags & CIFS_MS_MASK))
 		return 0;
 
-	if ((old->mnt_cifs_flags & CIFS_MOUNT_MASK) !=
-	    (new->mnt_cifs_flags & CIFS_MOUNT_MASK))
+	if (old->mnt_cifs_serverino_autodisabled)
+		newflags &= ~CIFS_MOUNT_SERVER_INUM;
+
+	if (oldflags != newflags)
 		return 0;
 
 	/*
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -539,6 +539,7 @@ cifs_autodisable_serverino(struct cifs_s
 			tcon = cifs_sb_master_tcon(cifs_sb);
 
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		cifs_sb->mnt_cifs_serverino_autodisabled = true;
 		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s.\n",
 			 tcon ? tcon->treeName : "new server");
 		cifs_dbg(VFS, "The server doesn't seem to support them properly or the files might be on different servers (DFS).\n");


