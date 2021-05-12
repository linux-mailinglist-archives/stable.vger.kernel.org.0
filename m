Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE5837D27D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349995AbhELSKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352654AbhELSDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9270861412;
        Wed, 12 May 2021 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842565;
        bh=Hviw3mCgT60mcrWAxxwGQCfeTxPxWjlOQx5HPSXh2QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR4SNQ/PBoh0R08R+987Anujvp8ktk657iw6r3TJ5sNRvK+/iGb22JQDhgpK37S2O
         rqV9Lcp7t1EoX5nIwmGzIk3Fxbuq/sODt8gU/llhSiyJMkp57cRg4XIkBZ4pZKspdQ
         mZDQouSe2kz2SEeKhaI3ShtXebcINN+/JNfJrm6REZ24rn+R84CrJNgSK4uaYELp2O
         jj6tk0gyhVenbQA4NGApDdW63ZYzodYg5iocmx4vI3JEW3MfTvXHjgywqjfFvQIm7r
         mEBSRi9B7uTAU8hoH4qwmUgBihouUgwcRWKRYhnWhCdF362SFOvQr0vrVQL/KHz8z3
         mo8cqNFQDxl0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 23/35] ceph: don't allow access to MDS-private inodes
Date:   Wed, 12 May 2021 14:01:53 -0400
Message-Id: <20210512180206.664536-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d4f6b31d721779d91b5e2f8072478af73b196c34 ]

The MDS reserves a set of inodes for its own usage, and these should
never be accessible to clients. Add a new helper to vet a proposed
inode number against that range, and complain loudly and refuse to
create or look it up if it's in it.

Also, ensure that the MDS doesn't try to delegate inodes that are in
that range or lower. Print a warning if it does, and don't save the
range in the xarray.

URL: https://tracker.ceph.com/issues/49922
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/export.c     |  8 ++++++++
 fs/ceph/inode.c      |  3 +++
 fs/ceph/mds_client.c |  7 +++++++
 fs/ceph/super.h      | 24 ++++++++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index e088843a7734..80717234410f 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -129,6 +129,10 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
 
 	vino.ino = ino;
 	vino.snap = CEPH_NOSNAP;
+
+	if (ceph_vino_is_reserved(vino))
+		return ERR_PTR(-ESTALE);
+
 	inode = ceph_find_inode(sb, vino);
 	if (!inode) {
 		struct ceph_mds_request *req;
@@ -212,6 +216,10 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
 		vino.ino = sfh->ino;
 		vino.snap = sfh->snapid;
 	}
+
+	if (ceph_vino_is_reserved(vino))
+		return ERR_PTR(-ESTALE);
+
 	inode = ceph_find_inode(sb, vino);
 	if (inode)
 		return d_obtain_alias(inode);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 5eb7eeab3828..9c7cf8d1564d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -56,6 +56,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
 {
 	struct inode *inode;
 
+	if (ceph_vino_is_reserved(vino))
+		return ERR_PTR(-EREMOTEIO);
+
 	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
 			     ceph_set_ino_cb, &vino);
 	if (!inode)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d87bd852ed96..298cb0b3d28c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -433,6 +433,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
 
 		ceph_decode_64_safe(p, end, start, bad);
 		ceph_decode_64_safe(p, end, len, bad);
+
+		/* Don't accept a delegation of system inodes */
+		if (start < CEPH_INO_SYSTEM_BASE) {
+			pr_warn_ratelimited("ceph: ignoring reserved inode range delegation (start=0x%llx len=0x%llx)\n",
+					start, len);
+			continue;
+		}
 		while (len--) {
 			int err = xa_insert(&s->s_delegated_inos, ino = start++,
 					    DELEGATED_INO_AVAILABLE,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b62d8fee3b86..5fed3261598b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -529,10 +529,34 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
 		ci->i_vino.snap == pvino->snap;
 }
 
+/*
+ * The MDS reserves a set of inodes for its own usage. These should never
+ * be accessible by clients, and so the MDS has no reason to ever hand these
+ * out. The range is CEPH_MDS_INO_MDSDIR_OFFSET..CEPH_INO_SYSTEM_BASE.
+ *
+ * These come from src/mds/mdstypes.h in the ceph sources.
+ */
+#define CEPH_MAX_MDS		0x100
+#define CEPH_NUM_STRAY		10
+#define CEPH_MDS_INO_MDSDIR_OFFSET	(1 * CEPH_MAX_MDS)
+#define CEPH_INO_SYSTEM_BASE		((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
+
+static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
+{
+	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
+	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
+		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
+		return true;
+	}
+	return false;
+}
 
 static inline struct inode *ceph_find_inode(struct super_block *sb,
 					    struct ceph_vino vino)
 {
+	if (ceph_vino_is_reserved(vino))
+		return NULL;
+
 	/*
 	 * NB: The hashval will be run through the fs/inode.c hash function
 	 * anyway, so there is no need to squash the inode number down to
-- 
2.30.2

