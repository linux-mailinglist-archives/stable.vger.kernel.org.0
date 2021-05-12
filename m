Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC93F37D2A4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353214AbhELSK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240880AbhELSEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AD4361438;
        Wed, 12 May 2021 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842624;
        bh=y3ffrmCDycCem1ujA75aNnFgDchIEtLea4xaD14qP7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8/rS3Y0bOuuIv/ALhG53zNIL8daqB3ZrPG6eeOoWL0oaBezv+seaN+xoqcD3Qyxf
         uduVWIjod8wGXVSN6Wf5xOe+cZImdVGWV6eS7TJ/qxZ+Bx5PED7z4hzO0lSayKAOxj
         GbwqdoklVioxqIKXEvl5a1ywM9z80yrapxdFlC4WJ83UGkiNb2GhHX0ki9+CRuurek
         2f6cMZgZzEDaBgcrqi7DiU1FnE6lOalYxhWFEEZSsqmcUEgP42N5s5z3iiMurSLriX
         aEtgr/uviWxMQOyt2tIXxRWL2EKxupwKjPN8yHgi18zQNvhbQvC0+FArtI9z7r76Kz
         tzn4ojSF8QJ8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/34] ceph: don't allow access to MDS-private inodes
Date:   Wed, 12 May 2021 14:02:53 -0400
Message-Id: <20210512180306.664925-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
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
index 790433cb849e..346fcdfcd3e9 100644
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
index 8f1d7500a7ec..d560752b764d 100644
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
index 482473e4cce1..c33f744a8e11 100644
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

