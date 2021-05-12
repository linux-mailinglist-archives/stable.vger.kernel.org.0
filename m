Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF437D2E6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242101AbhELSPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241880AbhELSJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE3D761928;
        Wed, 12 May 2021 18:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842711;
        bh=R7Cs3zu7R8x7HragikYOhoog7sCI37/COSBzxK3kMuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lloq0e5CXH4QTTrsp63ecubiLV3aXyZDvE4pgIIYKBfGRAR/3isnmNjmg+4wN/C5I
         FdAWZZcWGl3wx6PxEORmHDOnpBQhVX3ib3+r7hBkXSnJODkG38952xqMcX/sUk850g
         oO85ITm3iu17ujFpu9x2QFTHVGaQ6vFK9PQ81OX1exJvHdngYWIXbpCXJgmP1epoGd
         aa2HC21kcqgS28Bw6mYnxSOIB9rw+4pgOVPaLo/vV5V3MHp2ILpx8qFqz/a9OqJMFx
         i2uhOavm6gI0qT1PEGlc+2CopjxHrYf1xSEipxwWBrcTh0C25nitkgQGbNJMq8Mfmb
         xJz3tFMISmdcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/18] ceph: fix fscache invalidation
Date:   Wed, 12 May 2021 14:04:43 -0400
Message-Id: <20210512180450.665586-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180450.665586-1-sashal@kernel.org>
References: <20210512180450.665586-1-sashal@kernel.org>
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
index 6e871a382209..918781c51f0b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1779,6 +1779,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 3c24fb77ef32..5f041fede7aa 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1823,6 +1823,7 @@ static void ceph_invalidate_work(struct work_struct *work)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2

