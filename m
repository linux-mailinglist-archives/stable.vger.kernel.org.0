Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAC238A554
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhETKPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235943AbhETKNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9FFC61447;
        Thu, 20 May 2021 09:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503856;
        bh=R7Cs3zu7R8x7HragikYOhoog7sCI37/COSBzxK3kMuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvEGWH7O5g3vHzsH7g5MPCBjFUp/KjLGcq+6VvyQOI6ikU9rBKjUbADyI4QbukUQb
         j2ADl1/dTih5UUhkj4uhekNlW1fh+olc9H3hyjFf+hoNEX0l2prXh1EoO9zr9chBWK
         oSkjFwToUNNW8RPLcKB+afnUAYXVcYNnjVsqU9sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 411/425] ceph: fix fscache invalidation
Date:   Thu, 20 May 2021 11:23:00 +0200
Message-Id: <20210520092144.912737300@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



