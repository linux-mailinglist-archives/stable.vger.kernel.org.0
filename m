Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D47B20EF
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389111AbfIMN36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389649AbfIMNSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:21 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C01A206A5;
        Fri, 13 Sep 2019 13:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380700;
        bh=S6V1cmfw8HfzgKirGyyQ7ce3l/rqYCetLuamvel8DUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnZYwaFqy2+qDPQV1Ys/QWobnBUr7qYwyaLi+yzIxh/3M6+A19Msu2shj983/7L/k
         ND1TqaS3F6vNPbxcKfnkNgSAb4BwKL6Ui8kp4uiEHDE56Hfq80N+LwOy3rNlpbovV7
         oeCNKX2ZRc2tFf5SFp2AQqmm1v8N05IkfDwVgAcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <paulo@paulo.ac>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilove@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/190] cifs: Properly handle auto disabling of serverino option
Date:   Fri, 13 Sep 2019 14:06:44 +0100
Message-Id: <20190913130611.864977851@linuxfoundation.org>
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



