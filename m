Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEAFE10A796
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 01:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfK0Ahc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 19:37:32 -0500
Received: from mx.cjr.nz ([51.158.111.142]:16226 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbfK0Ahb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 19:37:31 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0587580A26;
        Wed, 27 Nov 2019 00:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574815049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GAH2d6eEHWMxkJtDZKc8DF4ep+TO4uklYfQT19YFnvg=;
        b=ANT7fklvhZyfq0NE1ofHzY+Qini9MHhQDEji6vRa36iVdkkk5n0FJZ3qsfkPxPHOBdia+9
        PrL3BywGQ3cUBniis/f0V/bG2wUuw8VJmRrKoW3ifCwTvBDBLcGE32Ho1M6MpxIxhH7BUx
        7RglB2zU6oYKNISWBZscevqp2SdYxdhYOPaG3JsmwxGpdV1A7TMYmQaBjc3TM72lsuOuvp
        n/8YybQk0Kw4GIFsGjPNYV390OrxwgBPvX8dHTzzE6q4T0laQyLo1K1hYCutML5025Mfwn
        9zGpq+YDmvQtKwm4xxB0i6aBVquSrfu5aGRqvpCbBo9erIph1595YKdHzW+1rA==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        stable@vger.kernel.org,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: [PATCH v3 10/11] cifs: Fix retrieval of DFS referrals in cifs_mount()
Date:   Tue, 26 Nov 2019 21:36:33 -0300
Message-Id: <20191127003634.14072-11-pc@cjr.nz>
In-Reply-To: <20191127003634.14072-1-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that DFS referrals are sent to newly resolved root targets
as in a multi tier DFS setup.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Link: https://lkml.kernel.org/r/05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com
Cc: stable@vger.kernel.org
Tested-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 fs/cifs/connect.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 668d477cc9c7..86d98d73749d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4776,6 +4776,17 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
+static inline void set_root_tcon(struct cifs_sb_info *cifs_sb,
+				 struct cifs_tcon *tcon,
+				 struct cifs_tcon **root)
+{
+	spin_lock(&cifs_tcp_ses_lock);
+	tcon->tc_count++;
+	tcon->remap = cifs_remap(cifs_sb);
+	spin_unlock(&cifs_tcp_ses_lock);
+	*root = tcon;
+}
+
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 {
 	int rc = 0;
@@ -4877,18 +4888,10 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	/* Cache out resolved root server */
 	(void)dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
 			     root_path + 1, NULL, NULL);
-	/*
-	 * Save root tcon for additional DFS requests to update or create a new
-	 * DFS cache entry, or even perform DFS failover.
-	 */
-	spin_lock(&cifs_tcp_ses_lock);
-	tcon->tc_count++;
-	tcon->dfs_path = root_path;
+	kfree(root_path);
 	root_path = NULL;
-	tcon->remap = cifs_remap(cifs_sb);
-	spin_unlock(&cifs_tcp_ses_lock);
 
-	root_tcon = tcon;
+	set_root_tcon(cifs_sb, tcon, &root_tcon);
 
 	for (count = 1; ;) {
 		if (!rc && tcon) {
@@ -4925,6 +4928,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 			mount_put_conns(cifs_sb, xid, server, ses, tcon);
 			rc = mount_get_conns(vol, cifs_sb, &xid, &server, &ses,
 					     &tcon);
+			/*
+			 * Ensure that DFS referrals go through new root server.
+			 */
+			if (!rc && tcon &&
+			    (tcon->share_flags & (SHI1005_FLAGS_DFS |
+						  SHI1005_FLAGS_DFS_ROOT))) {
+				cifs_put_tcon(root_tcon);
+				set_root_tcon(cifs_sb, tcon, &root_tcon);
+			}
 		}
 		if (rc) {
 			if (rc == -EACCES || rc == -EOPNOTSUPP)
-- 
2.24.0

