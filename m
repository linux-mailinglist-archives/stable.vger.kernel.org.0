Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345BE1216EF
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfLPSJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730493AbfLPSJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A54A206B7;
        Mon, 16 Dec 2019 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519786;
        bh=8li020Po+yB8tIM/vH97YFOqrlj1+GSSXyV+MrYkqqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMHxoE8OF8VDq5N0UvkMOjXYLdpNvNBlWqq4DCza2R8/3GR+cmd+LxokWqOGvhjCs
         NO8I4BApjT0K2/nHtNnBssg0eDGJ7PDaJ0DhlZ8COyL6qbGZ8v9stwbKxvVmrO+DL4
         A0iY/eRfgyn0KLzmKDOy/OJNOi31Hr9kh7QXzWQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.3 067/180] ovl: fix lookup failure on multi lower squashfs
Date:   Mon, 16 Dec 2019 18:48:27 +0100
Message-Id: <20191216174829.950628779@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 7e63c87fc2dcf3be9d3aab82d4a0ea085880bdca upstream.

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

There is an unhandled corner case described by Miklos this way:
- two filesystems, A and B, both have null uuid
- upper layer is on A
- lower layer 1 is also on A
- lower layer 2 is on B

In this case bad_uuid won't be set for B, because the check only
involves the list of lower fs.  Hence we'll try to decode a layer 2
origin on layer 1 and fail.

We will deal with this corner case later.

Reported-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/lkml/20191106234301.283006-1-colin.king@canonical.com/
Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid ...")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/namei.c     |    8 ++++++++
 fs/overlayfs/ovl_entry.h |    2 ++
 fs/overlayfs/super.c     |   24 +++++++++++++++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -325,6 +325,14 @@ int ovl_check_origin_fh(struct ovl_fs *o
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
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1255,7 +1255,7 @@ static bool ovl_lower_uuid_ok(struct ovl
 {
 	unsigned int i;
 
-	if (!ofs->config.nfs_export && !(ofs->config.index && ofs->upper_mnt))
+	if (!ofs->config.nfs_export && !ofs->upper_mnt)
 		return true;
 
 	for (i = 0; i < ofs->numlowerfs; i++) {
@@ -1263,9 +1263,13 @@ static bool ovl_lower_uuid_ok(struct ovl
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
@@ -1277,6 +1281,7 @@ static int ovl_get_fsid(struct ovl_fs *o
 	unsigned int i;
 	dev_t dev;
 	int err;
+	bool bad_uuid = false;
 
 	/* fsid 0 is reserved for upper fs even with non upper overlay */
 	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
@@ -1288,11 +1293,15 @@ static int ovl_get_fsid(struct ovl_fs *o
 	}
 
 	if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
-		ofs->config.index = false;
-		ofs->config.nfs_export = false;
-		pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
-			uuid_is_null(&sb->s_uuid) ? "null" : "conflicting",
-			path->dentry);
+		bad_uuid = true;
+		if (ofs->config.index || ofs->config.nfs_export) {
+			ofs->config.index = false;
+			ofs->config.nfs_export = false;
+			pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
+				uuid_is_null(&sb->s_uuid) ? "null" :
+							    "conflicting",
+				path->dentry);
+		}
 	}
 
 	err = get_anon_bdev(&dev);
@@ -1303,6 +1312,7 @@ static int ovl_get_fsid(struct ovl_fs *o
 
 	ofs->lower_fs[ofs->numlowerfs].sb = sb;
 	ofs->lower_fs[ofs->numlowerfs].pseudo_dev = dev;
+	ofs->lower_fs[ofs->numlowerfs].bad_uuid = bad_uuid;
 	ofs->numlowerfs++;
 
 	return ofs->numlowerfs;


