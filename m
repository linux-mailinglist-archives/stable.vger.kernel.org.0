Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D25378751
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbhEJLPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236275AbhEJLHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8C1E61958;
        Mon, 10 May 2021 10:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644371;
        bh=Mg6h6tYQVc6DTNKkINiy1TBDhryAgpq7+VHBIm5i/GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZ4dgich5ReXAWHje7+GXCBzPwcIXQHWLDR9hNdX3NYvKblYgUsogBjcclJIMg2wg
         5YEdLbod56M/5J+cKVq0YGJw7yvj11hsNcbDV3K0Vz2LF2Lc7XkuRI5QI5BiRE+ACs
         pGsRtq+5R13PGrh+WmOS32A4EFYQNM3lxPL5C5HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        David Disseldorp <ddiss@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 055/384] cifs: fix regression when mounting shares with prefix paths
Date:   Mon, 10 May 2021 12:17:24 +0200
Message-Id: <20210510102016.690879265@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 5c1acf3fe05ce443edba5e2110c9e581765f66a8 upstream.

The commit 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
revealed an existing bug when mounting shares that contain a prefix
path or DFS links.

cifs_setup_volume_info() requires the @devname to contain the full
path (UNC + prefix) to update the fs context with the new UNC and
prepath values, however we were passing only the UNC
path (old_ctx->UNC) in @device thus discarding any prefix paths.

Instead of concatenating both old_ctx->{UNC,prepath} and pass it in
@devname, just keep the dup'ed values of UNC and prepath in
cifs_sb->ctx after calling smb3_fs_context_dup(), and fix
smb3_parse_devname() to correctly parse and not leak the new UNC and
prefix paths.

Cc: <stable@vger.kernel.org> # v5.11+
Fixes: 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Acked-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c     |    8 +-------
 fs/cifs/connect.c    |   24 ++++++++++++++++++------
 fs/cifs/fs_context.c |    4 ++++
 3 files changed, 23 insertions(+), 13 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -834,13 +834,7 @@ cifs_smb3_do_mount(struct file_system_ty
 		goto out;
 	}
 
-	/* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
-	kfree(cifs_sb->ctx->UNC);
-	cifs_sb->ctx->UNC = NULL;
-	kfree(cifs_sb->ctx->prepath);
-	cifs_sb->ctx->prepath = NULL;
-
-	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
+	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, NULL);
 	if (rc) {
 		root = ERR_PTR(rc);
 		goto out;
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3176,17 +3176,29 @@ out:
 int
 cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname)
 {
-	int rc = 0;
+	int rc;
 
-	smb3_parse_devname(devname, ctx);
+	if (devname) {
+		cifs_dbg(FYI, "%s: devname=%s\n", __func__, devname);
+		rc = smb3_parse_devname(devname, ctx);
+		if (rc) {
+			cifs_dbg(VFS, "%s: failed to parse %s: %d\n", __func__, devname, rc);
+			return rc;
+		}
+	}
 
 	if (mntopts) {
 		char *ip;
 
-		cifs_dbg(FYI, "%s: mntopts=%s\n", __func__, mntopts);
 		rc = smb3_parse_opt(mntopts, "ip", &ip);
-		if (!rc && !cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip,
-						 strlen(ip))) {
+		if (rc) {
+			cifs_dbg(VFS, "%s: failed to parse ip options: %d\n", __func__, rc);
+			return rc;
+		}
+
+		rc = cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip, strlen(ip));
+		kfree(ip);
+		if (!rc) {
 			cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
 			return -EINVAL;
 		}
@@ -3206,7 +3218,7 @@ cifs_setup_volume_info(struct smb3_fs_co
 		return -EINVAL;
 	}
 
-	return rc;
+	return 0;
 }
 
 static int
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -475,6 +475,7 @@ smb3_parse_devname(const char *devname,
 
 	/* move "pos" up to delimiter or NULL */
 	pos += len;
+	kfree(ctx->UNC);
 	ctx->UNC = kstrndup(devname, pos - devname, GFP_KERNEL);
 	if (!ctx->UNC)
 		return -ENOMEM;
@@ -485,6 +486,9 @@ smb3_parse_devname(const char *devname,
 	if (*pos == '/' || *pos == '\\')
 		pos++;
 
+	kfree(ctx->prepath);
+	ctx->prepath = NULL;
+
 	/* If pos is NULL then no prepath */
 	if (!*pos)
 		return 0;


