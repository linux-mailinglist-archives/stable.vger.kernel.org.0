Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEB337D29F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353184AbhELSKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352184AbhELSCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8F5B61421;
        Wed, 12 May 2021 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842498;
        bh=oB5BCbTZi4Acn3EkhWGpGApvXT3QI5oWwpD0q6yrVEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbEta4j22caCsoOabAsS7gXEO+hMGjcPjWUsKQDM7MboTjE8sAZ3RpKdY+19DLdpo
         Cv255SjK7pk5vxSU4zEhb+tMFKSjsyfTDD7nDUiVwpGh8T3nybfC+nls7TowsoTo4j
         RqsL377CpaXuNml3b3fUmAaadFivu+E2dSb+NoqgdlySsTEUATeSpi4jtx4Bge+/hy
         NWr47iUamgjyo0nM0htgcUA4j4YkPm59W5LJ2U2YSagX6ZaDhHZmmJA5qloa/l9R8O
         yQQSdXhE/GRwiewwkJAUTFDoPBvj4DUOFtO85UFhq4m4hWP8NWPQYmVsA7D6yPpyrN
         1n/ppc6AtPpHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 23/37] ceph: fix fscache invalidation
Date:   Wed, 12 May 2021 14:00:50 -0400
Message-Id: <20210512180104.664121-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
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
index 570731c4d019..d405ba801492 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1867,6 +1867,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 156f849f5385..4418d4be2907 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1863,6 +1863,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2

