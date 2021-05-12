Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE0737D2FF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351975AbhELSPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353272AbhELSLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92B8A61943;
        Wed, 12 May 2021 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842755;
        bh=q9p/jL1dxlKZfVTF1Fv6oBvpVsnuufUQ/yUS+MlceCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKwMW955/S4btWqT8M5MOn6oMsFJ6b0cu/DLveiFr2l6MclioWZLUorwaL01QEcRF
         htPRXYXkASjUIa3o1DEfI7fLNWq/QtV5sSMYkznkYVp5Pk5dY2h3IHgTaQPLPA55yW
         dPXTjA2wnNYWiQiXoh4vHrohVqUlk7sQRLwW+u0RzcRul6zPf1IJhBXDAw5yIRU/gx
         uBJb/j1hjQY4ulWrl5zHvqm3pXCr5IDx4LPsofKKTYvnxN5gO1VUQgpgj53g/XHDih
         41MdVggTDnvboILAF3NLdjIIfNJ0kEp/pcZUDN4CsEKarCXLxOTwiLerUqq5q7Bb9A
         gEaltjsab6Itg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/7] ceph: fix fscache invalidation
Date:   Wed, 12 May 2021 14:05:42 -0400
Message-Id: <20210512180545.665946-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180545.665946-1-sashal@kernel.org>
References: <20210512180545.665946-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 10a7052c7868bc7bc72d947f5aac6f768928db87 ]

Ensure that we invalidate the fscache whenever we invalidate the
pagecache.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c  | 1 +
 fs/ceph/inode.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2a351821d8f3..0eb2ada032c7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1577,6 +1577,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 049cff197d2a..5e12ea92f7cd 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1762,6 +1762,7 @@ static void ceph_invalidate_work(struct work_struct *work)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2

