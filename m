Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E5237D2A3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353205AbhELSKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240648AbhELSEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42A326143C;
        Wed, 12 May 2021 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842621;
        bh=BgWX0d9h3klkaGXVA7a6ZgusKUgNUKaqRxDr0yosfq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKwCAQWsIRxz4VkKLom0yJizftLYMhRbsv7JV7WfDFQ4z/EouvUQZ5Jy6cth6cFFj
         MhaKMJrY3xaIBtT9qxh2a9UPLPVyTm3S3ULQhh+t1UER0mEiI4Rt/HdgVoSKN2rXKm
         BWY2Eq0/Tqbe9TWBT/J81C9FPWRQ/AMO64QhlOnF7Sf1ZvxRmznr7/bQzDI0HIimPR
         JjR8MLSxnVrgjbd+D8xZyBYzlOJGvLanYNQc2RTT84xvk+0rWAMQImsuTztFCHOaej
         eKPoYZQ1vR1664HbwQcgZ340xe7PwiPnGQV+k44PE4wZEYi3+kdMCAeGrBLxV7cE8s
         P1Ubn5A/tYQNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/34] ceph: fix fscache invalidation
Date:   Wed, 12 May 2021 14:02:51 -0400
Message-Id: <20210512180306.664925-20-sashal@kernel.org>
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
index 576d01275bbd..e4fc99afa25a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1866,6 +1866,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2462a9a84b95..6bd2a6ced22a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1912,6 +1912,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2

