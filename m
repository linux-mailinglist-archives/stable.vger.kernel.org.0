Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77C9370031
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 20:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhD3SKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 14:10:52 -0400
Received: from mx.cjr.nz ([51.158.111.142]:52502 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhD3SKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 14:10:51 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id A00C77FC03;
        Fri, 30 Apr 2021 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1619806201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R2D1KNbjxCvG+n0AN3n4pMa2wwbdETwATl63Zt1Q+N0=;
        b=pKn8ci4d7j9SMXwJj90RegyZM62nTB9PVcCvn1kk4I5Nu5sKZO3//tSeG7fyjQdiFJ21C7
        xGTEMkcI6qvioNiPCN9QReU6ftlemNBp7zlU4IvzLhZaw9mmqzJpFQWUcw8NEElyg18Hjb
        Lxw7Jh/ugPtXeAzhTxXF1RrDclGlqXp/gcWf+A+L5w/KeEguY2H0PVNn91TqUP0qh4sqVz
        cG8QwPMFPLt7NGDoBGV+S3nit/p9niuoaoke/c1esDRWjWy3fk/+1IqGo/3HbMPoRAn/KB
        5bVUfCUMZjhGpMA797K953JnR6kfr9oWwReCxjfpSe05anFMoqr4uM50E8FFsQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     ddiss@suse.de, aaptel@suse.com, Paulo Alcantara <pc@cjr.nz>,
        stable@vger.kernel.org
Subject: [PATCH] cifs: fix automount regression of dfs links
Date:   Fri, 30 Apr 2021 15:08:43 -0300
Message-Id: <20210430180843.16920-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unfortunately we can't kfree() the UNC and prefix paths in
cifs_smb3_do_mount() because they could have come from a chased DFS
referral (automount) and we rely on the new values set in cifs_sb->ctx
prior to calling cifs_mount().

Instead, fix smb3_parse_devname() to not leak the UNC and prefix paths
when parsing new share paths.

Cc: <stable@vger.kernel.org> # v5.11+
Fixes: 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsfs.c     |  6 ------
 fs/cifs/connect.c    | 10 +++++++---
 fs/cifs/fs_context.c |  2 ++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8a6894577697..bfe98136f9c1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -863,12 +863,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 		goto out;
 	}
 
-	/* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
-	kfree(cifs_sb->ctx->UNC);
-	cifs_sb->ctx->UNC = NULL;
-	kfree(cifs_sb->ctx->prepath);
-	cifs_sb->ctx->prepath = NULL;
-
 	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
 	if (rc) {
 		root = ERR_PTR(rc);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index becd5f807787..ee4a92cbcb29 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3159,9 +3159,13 @@ static int do_dfs_failover(const char *path, const char *full_path, struct cifs_
 int
 cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname)
 {
-	int rc = 0;
+	int rc;
 
-	smb3_parse_devname(devname, ctx);
+	rc = smb3_parse_devname(devname, ctx);
+	if (rc) {
+		cifs_dbg(VFS, "%s: failed to parse %s: %d\n", __func__, devname, rc);
+		return rc;
+	}
 
 	if (mntopts) {
 		char *ip;
@@ -3189,7 +3193,7 @@ cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const c
 		return -EINVAL;
 	}
 
-	return rc;
+	return 0;
 }
 
 static int
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 1d6e0e15b034..b502a44e15a1 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -476,6 +476,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 
 	/* move "pos" up to delimiter or NULL */
 	pos += len;
+	kfree(ctx->UNC);
 	ctx->UNC = kstrndup(devname, pos - devname, GFP_KERNEL);
 	if (!ctx->UNC)
 		return -ENOMEM;
@@ -490,6 +491,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 	if (!*pos)
 		return 0;
 
+	kfree(ctx->prepath);
 	ctx->prepath = kstrdup(pos, GFP_KERNEL);
 	if (!ctx->prepath)
 		return -ENOMEM;
-- 
2.31.1

