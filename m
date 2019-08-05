Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5681C6F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbfHENXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730867AbfHENXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC36217D9;
        Mon,  5 Aug 2019 13:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011419;
        bh=j5V3O5era90t3qvigSrU+W5mJ4rfJhC0zY/oMIG+Ivw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTy4+3tPWZ8QkSCX1/DScCgt2YG5CmhSQAfPnLV5wAUi6wQ026Bhqeps9quBRSNg+
         mrHOSTP72FyxmLo9mP7lNyUQXYYS2loO7ciO5zzIQohowUipUt8ZIKam2WXdr3+LiU
         RCnh9sni/NZgv9T21RZdRnWCfYW/rgBYnzmFhil0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 040/131] cifs: fix crash in cifs_dfs_do_automount
Date:   Mon,  5 Aug 2019 15:02:07 +0200
Message-Id: <20190805124954.117575403@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ce465bf94b70f03136171a62b607864f00093b19 ]

RHBZ: 1649907

Fix a crash that happens while attempting to mount a DFS referral from the same server on the root of a filesystem.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6ad43ac129d2f..18c7c6b2fe08a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4463,11 +4463,13 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 					unsigned int xid,
 					struct cifs_tcon *tcon,
 					struct cifs_sb_info *cifs_sb,
-					char *full_path)
+					char *full_path,
+					int added_treename)
 {
 	int rc;
 	char *s;
 	char sep, tmp;
+	int skip = added_treename ? 1 : 0;
 
 	sep = CIFS_DIR_SEP(cifs_sb);
 	s = full_path;
@@ -4482,7 +4484,14 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 		/* next separator */
 		while (*s && *s != sep)
 			s++;
-
+		/*
+		 * if the treename is added, we then have to skip the first
+		 * part within the separators
+		 */
+		if (skip) {
+			skip = 0;
+			continue;
+		}
 		/*
 		 * temporarily null-terminate the path at the end of
 		 * the current component
@@ -4530,8 +4539,7 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 
 	if (rc != -EREMOTE) {
 		rc = cifs_are_all_path_components_accessible(server, xid, tcon,
-							     cifs_sb,
-							     full_path);
+			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_dbg(VFS, "cannot query dirs between root and final path, "
 				 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-- 
2.20.1



