Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46402E4044
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502167AbgL1OUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436591AbgL1OUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B129521D94;
        Mon, 28 Dec 2020 14:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165186;
        bh=eGQQCOXn+RhnImPbPiE5mK0SYXfOqSninblDmJdNxJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHipJ8NLczWhTNvW2ZEtZwgjWI96L3zWvFCqhRmoCzt0gF1u2gz11BHbCsx2T+Z1D
         F5ZB5Zb7HuHYGivW7N82792TIdmZSm9iJREmzIwXkYMXhV/7iIMWObtM7RsbumxyaJ
         Ppqfl2IRJMF8Srl0ysN0ATTLe3bLevl6yUhb/oUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Li <lihao2018.fnst@cn.fujitsu.com>,
        Dave Chinner <dchinner@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/717] fs: Handle I_DONTCACHE in iput_final() instead of generic_drop_inode()
Date:   Mon, 28 Dec 2020 13:46:50 +0100
Message-Id: <20201228125040.709020346@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Li <lihao2018.fnst@cn.fujitsu.com>

[ Upstream commit 88149082bb8ef31b289673669e080ec6a00c2e59 ]

If generic_drop_inode() returns true, it means iput_final() can evict
this inode regardless of whether it is dirty or not. If we check
I_DONTCACHE in generic_drop_inode(), any inode with this bit set will be
evicted unconditionally. This is not the desired behavior because
I_DONTCACHE only means the inode shouldn't be cached on the LRU list.
As for whether we need to evict this inode, this is what
generic_drop_inode() should do. This patch corrects the usage of
I_DONTCACHE.

This patch was proposed in [1].

[1]: https://lore.kernel.org/linux-fsdevel/20200831003407.GE12096@dread.disaster.area/

Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
Signed-off-by: Hao Li <lihao2018.fnst@cn.fujitsu.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c         | 4 +++-
 include/linux/fs.h | 3 +--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9d78c37b00b81..5eea9912a0b9d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1627,7 +1627,9 @@ static void iput_final(struct inode *inode)
 	else
 		drop = generic_drop_inode(inode);
 
-	if (!drop && (sb->s_flags & SB_ACTIVE)) {
+	if (!drop &&
+	    !(inode->i_state & I_DONTCACHE) &&
+	    (sb->s_flags & SB_ACTIVE)) {
 		inode_add_lru(inode);
 		spin_unlock(&inode->i_lock);
 		return;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8667d0cdc71e7..8bde32cf97115 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2878,8 +2878,7 @@ extern int inode_needs_sync(struct inode *inode);
 extern int generic_delete_inode(struct inode *inode);
 static inline int generic_drop_inode(struct inode *inode)
 {
-	return !inode->i_nlink || inode_unhashed(inode) ||
-		(inode->i_state & I_DONTCACHE);
+	return !inode->i_nlink || inode_unhashed(inode);
 }
 extern void d_mark_dontcache(struct inode *inode);
 
-- 
2.27.0



