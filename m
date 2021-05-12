Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD44137D2CD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhELSNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353160AbhELSHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E5861444;
        Wed, 12 May 2021 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842674;
        bh=6xE87fb93+R24VnrhjQvU4MC3YwFzRjAut5ARQywGzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmfWP1VoPQ5uO/bK9MYwcRF/YP6phTuxlfFCAaoGD4LSJow/EUQnPiBtOjlEPSwo8
         BNbfaraxI+XfOpXikJHLUinLM8Z0G4oX+URb8s+3k39fjSiUsEfKEry3a2L9rZOXK3
         XMJfe51rghcg8294FTZncv+v2YXtF+yVIFoKsAQjGmb8MPaaJ4K/hlZLfShSoXkvec
         q07enR2NC0bDuFhJQIC7g0wNsJbgYWrWPOQPYxYoGilLmLvxSH5ftj0CtKDn/VUgbW
         BujOkNpdVkBJRde/TmrS2c9AX2pL8UZo7ERxi4exIgzu6clbGwI7dpJYeUHW/yw97R
         f/4MC2T4S4dJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/23] ceph: fix fscache invalidation
Date:   Wed, 12 May 2021 14:03:59 -0400
Message-Id: <20210512180408.665338-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180408.665338-1-sashal@kernel.org>
References: <20210512180408.665338-1-sashal@kernel.org>
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
index 22833fa5bb58..a6047caf77ec 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1780,6 +1780,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 660a878e20ef..5beebbbb42f0 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1875,6 +1875,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2

