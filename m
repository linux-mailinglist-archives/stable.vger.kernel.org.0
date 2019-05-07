Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184AE15C5A
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfEGGDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbfEGFfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9C220C01;
        Tue,  7 May 2019 05:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207320;
        bh=nUE/tGG4Eiqp4QbhmubyW9/DNF8bdzhhE8jZr+0HMOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6E9I6GjbqEh7ScuU0qFOGvDOk7MMkbJAdMldd7Bn1T370ojVo4p5J7FlqEm7r5PK
         nidyQgghU+dtIrj0yMyNbL/MbTivS+8jwNONDjGW8nUFj1X4KJU/ujUP8j0KYChuBg
         W9UYxQU4zyiFh7UkL8/I5IUaxfKBwwLVYV7SCnVQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 84/99] ceph: handle the case where a dentry has been renamed on outstanding req
Date:   Tue,  7 May 2019 01:32:18 -0400
Message-Id: <20190507053235.29900-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 4b8222870032715f9d995f3eb7c7acd8379a275d ]

It's possible for us to issue a lookup to revalidate a dentry
concurrently with a rename. If done in the right order, then we could
end up processing dentry info in the reply that no longer reflects the
state of the dentry.

If req->r_dentry->d_name differs from the one in the trace, then just
ignore the trace in the reply. We only need to do this however if the
parent's i_rwsem is not held.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9d1f34d46627..5880ee20ada4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1152,6 +1152,19 @@ static int splice_dentry(struct dentry **pdn, struct inode *in)
 	return 0;
 }
 
+static int d_name_cmp(struct dentry *dentry, const char *name, size_t len)
+{
+	int ret;
+
+	/* take d_lock to ensure dentry->d_name stability */
+	spin_lock(&dentry->d_lock);
+	ret = dentry->d_name.len - len;
+	if (!ret)
+		ret = memcmp(dentry->d_name.name, name, len);
+	spin_unlock(&dentry->d_lock);
+	return ret;
+}
+
 /*
  * Incorporate results into the local cache.  This is either just
  * one inode, or a directory, dentry, and possibly linked-to inode (e.g.,
@@ -1401,7 +1414,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		err = splice_dentry(&req->r_dentry, in);
 		if (err < 0)
 			goto done;
-	} else if (rinfo->head->is_dentry) {
+	} else if (rinfo->head->is_dentry &&
+		   !d_name_cmp(req->r_dentry, rinfo->dname, rinfo->dname_len)) {
 		struct ceph_vino *ptvino = NULL;
 
 		if ((le32_to_cpu(rinfo->diri.in->cap.caps) & CEPH_CAP_FILE_SHARED) ||
-- 
2.20.1

