Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6AEF2CC9
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 11:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbfKGKuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 05:50:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55981 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfKGKuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 05:50:00 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iSfMT-0007Gf-UD; Thu, 07 Nov 2019 10:49:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, stable@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] ovl: fix lookup failure on multi lower squashfs
Date:   Thu,  7 Nov 2019 10:49:57 +0000
Message-Id: <20191107104957.306383-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the past, overlayfs required that lower fs have non null uuid in
order to support nfs export and decode copy up origin file handles.

Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of
lower fs") relaxed this requirement for nfs export support, as long
as uuid (even if null) is unique among all lower fs.

However, said commit unintentionally also relaxed the non null uuid
requirement for decoding copy up origin file handles, regardless of
the unique uuid requirement.

Amend this mistake by disabling decoding of copy up origin file handle
from lower fs with a conflicting uuid.

We still encode copy up origin file handles from those fs, because
file handles like those already exist in the wild and because they
might provide useful information in the future.

Reported-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/lkml/20191106234301.283006-1-colin.king@canonical.com/
Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid ...")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/overlayfs/namei.c     |  8 ++++++++
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 16 ++++++++++------
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e9717c2f7d45..f47c591402d7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -325,6 +325,14 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 	int i;
 
 	for (i = 0; i < ofs->numlower; i++) {
+		/*
+		 * If lower fs uuid is not unique among lower fs we cannot match
+		 * fh->uuid to layer.
+		 */
+		if (ofs->lower_layers[i].fsid &&
+		    ofs->lower_layers[i].fs->bad_uuid)
+			continue;
+
 		origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt,
 					    connected);
 		if (origin)
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index a8279280e88d..28348c44ea5b 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -22,6 +22,8 @@ struct ovl_config {
 struct ovl_sb {
 	struct super_block *sb;
 	dev_t pseudo_dev;
+	/* Unusable (conflicting) uuid */
+	bool bad_uuid;
 };
 
 struct ovl_layer {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index afbcb116a7f1..5d4faab57ba0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1255,17 +1255,18 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 {
 	unsigned int i;
 
-	if (!ofs->config.nfs_export && !(ofs->config.index && ofs->upper_mnt))
-		return true;
-
 	for (i = 0; i < ofs->numlowerfs; i++) {
 		/*
 		 * We use uuid to associate an overlay lower file handle with a
 		 * lower layer, so we can accept lower fs with null uuid as long
 		 * as all lower layers with null uuid are on the same fs.
+		 * if we detect multiple lower fs with the same uuid, we
+		 * disable lower file handle decoding on all of them.
 		 */
-		if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid))
+		if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid)) {
+			ofs->lower_fs[i].bad_uuid = true;
 			return false;
+		}
 	}
 	return true;
 }
@@ -1277,6 +1278,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	unsigned int i;
 	dev_t dev;
 	int err;
+	bool bad_uuid = false;
 
 	/* fsid 0 is reserved for upper fs even with non upper overlay */
 	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
@@ -1287,10 +1289,11 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 			return i + 1;
 	}
 
-	if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
+	if (ofs->upper_mnt && !ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
+		bad_uuid = true;
 		ofs->config.index = false;
 		ofs->config.nfs_export = false;
-		pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
+		pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', enforcing index=off,nfs_export=off.\n",
 			uuid_is_null(&sb->s_uuid) ? "null" : "conflicting",
 			path->dentry);
 	}
@@ -1303,6 +1306,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 
 	ofs->lower_fs[ofs->numlowerfs].sb = sb;
 	ofs->lower_fs[ofs->numlowerfs].pseudo_dev = dev;
+	ofs->lower_fs[ofs->numlowerfs].bad_uuid = bad_uuid;
 	ofs->numlowerfs++;
 
 	return ofs->numlowerfs;
-- 
2.20.1

