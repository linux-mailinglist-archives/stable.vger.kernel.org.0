Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1955EA6F2B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfICQaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730502AbfICQ2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E06238F7;
        Tue,  3 Sep 2019 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528134;
        bh=EIdcxOkdkMNL4Z0E6xJ4tDo5+bIlgiXBorMzcKhbaj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBmzOeksz1FQtG1+TqhAKJ7F2Bvo3UriCue9BJy+Op8aIhLxeDvpgvDsDYxkt/UQt
         tFVwrVsl4STn/7aH1jUyZGdcAwVdTxrn/ox6O0dUsDX9PSxfh8freeLKykRfwdEWF7
         PUrpSKsZjWBCGL2FSG3WFEwiNI58qKCwqq16fRKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paulo Alcantara (SUSE)" <paulo@paulo.ac>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilove@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 129/167] cifs: Properly handle auto disabling of serverino option
Date:   Tue,  3 Sep 2019 12:24:41 -0400
Message-Id: <20190903162519.7136-129-sashal@kernel.org>
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

From: "Paulo Alcantara (SUSE)" <paulo@paulo.ac>

[ Upstream commit 29fbeb7a908a60a5ae8c50fbe171cb8fdcef1980 ]

Fix mount options comparison when serverino option is turned off later
in cifs_autodisable_serverino() and thus avoiding mismatch of new cifs
mounts.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <paulo@paulo.ac>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilove@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_fs_sb.h | 5 +++++
 fs/cifs/connect.c    | 8 ++++++--
 fs/cifs/misc.c       | 1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 9731d0d891e7e..aba2b48d4da1a 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -72,5 +72,10 @@ struct cifs_sb_info {
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 	char *prepath;
+	/*
+	 * Indicate whether serverino option was turned off later
+	 * (cifs_autodisable_serverino) in order to match new mounts.
+	 */
+	bool mnt_cifs_serverino_autodisabled;
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c53a2e86ed544..208430bb66fc6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3247,12 +3247,16 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
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
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index facc94e159a16..e45f8e321371c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -523,6 +523,7 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		cifs_sb->mnt_cifs_serverino_autodisabled = true;
 		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s. This server doesn't seem to support them properly. Hardlinks will not be recognized on this mount. Consider mounting with the \"noserverino\" option to silence this message.\n",
 			 cifs_sb_master_tcon(cifs_sb)->treeName);
 	}
-- 
2.20.1

