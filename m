Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F176A84
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387812AbfGZN7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbfGZNkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48A092238C;
        Fri, 26 Jul 2019 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148432;
        bh=15y9Qj8BGPk/nbfuEw1gdMaRm0D8+zt9Ip0goD7o98U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5OH2/zkspBvrwBEmlLI/6jikOscXG1HhQBn0CxRhf5tH1ycg1Fx9vOIgFOKO5Gez
         fms0DSbYFKpX8buXZ1uX6+SZVR8gT11kFXe5Ldyayk9cEbZJiTbTmD0wQhxeAPXJNt
         My6nkJpWgi00rmdq3uNkPF2vCcEhFslSkCSUu0Bw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 34/85] ceph: fix dir_lease_is_valid()
Date:   Fri, 26 Jul 2019 09:38:44 -0400
Message-Id: <20190726133936.11177-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

[ Upstream commit feab6ac25dbfe3ab96299cb741925dc8d2da0caf ]

It should call __ceph_dentry_dir_lease_touch() under dentry->d_lock.
Besides, ceph_dentry(dentry) can be NULL when called by LOOKUP_RCU
d_revalidate()

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0637149fb9f9..1271024a3797 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1512,18 +1512,26 @@ static int __dir_lease_try_check(const struct dentry *dentry)
 static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry)
 {
 	struct ceph_inode_info *ci = ceph_inode(dir);
-	struct ceph_dentry_info *di = ceph_dentry(dentry);
-	int valid = 0;
+	int valid;
+	int shared_gen;
 
 	spin_lock(&ci->i_ceph_lock);
-	if (atomic_read(&ci->i_shared_gen) == di->lease_shared_gen)
-		valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
+	valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
+	shared_gen = atomic_read(&ci->i_shared_gen);
 	spin_unlock(&ci->i_ceph_lock);
-	if (valid)
-		__ceph_dentry_dir_lease_touch(di);
-	dout("dir_lease_is_valid dir %p v%u dentry %p v%u = %d\n",
-	     dir, (unsigned)atomic_read(&ci->i_shared_gen),
-	     dentry, (unsigned)di->lease_shared_gen, valid);
+	if (valid) {
+		struct ceph_dentry_info *di;
+		spin_lock(&dentry->d_lock);
+		di = ceph_dentry(dentry);
+		if (dir == d_inode(dentry->d_parent) &&
+		    di && di->lease_shared_gen == shared_gen)
+			__ceph_dentry_dir_lease_touch(di);
+		else
+			valid = 0;
+		spin_unlock(&dentry->d_lock);
+	}
+	dout("dir_lease_is_valid dir %p v%u dentry %p = %d\n",
+	     dir, (unsigned)atomic_read(&ci->i_shared_gen), dentry, valid);
 	return valid;
 }
 
-- 
2.20.1

