Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F031738A1F6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhETJgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhETJen (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86DEE61401;
        Thu, 20 May 2021 09:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502958;
        bh=6xE87fb93+R24VnrhjQvU4MC3YwFzRjAut5ARQywGzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w47a2GVl0lHiVnhk85zgDotJYSSNERxjl8pezHUT86pVLfHw6/9e5a2XeuSWBOT/f
         8l2H5AodPYEWapq6+g7LhiUTc8ySDT0eeS82Dqmsnbwrbrmfx5vHWKlJiwglDkxfOn
         WI7qMq0bbYAg6CASjKDsZm65IXbQOmKuuwMCwvGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/37] ceph: fix fscache invalidation
Date:   Thu, 20 May 2021 11:22:43 +0200
Message-Id: <20210520092053.006342427@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
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



