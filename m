Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12326348F3F
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhCYL0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhCYL0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 485E161A39;
        Thu, 25 Mar 2021 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671563;
        bh=zYNeFVcIfi3bPfvaIZC8EBWDHiXB4fm8GkIpteE1/Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClXQHRmIN5z0XrFhMKv9NryzOsxDgpvmX7xomkD8jmC3om491gy1X4SguFwvt9KV+
         P8XmL9g4ZIgqdcSKJJ6jJH/47q3Y5nlxTXwINkyLB1ZBmztf1GKRk8Xcjpg/sUQQ3Y
         sNuAUO9BwFyYubjORNvw2WTWhYef33auTI/WTtyvwiOPgJdTAEvPhjRtvQU1q1q+k6
         cNxlgy2Wtl0DtwwEKFZhtxjGLFhEcRo7G4zl7mZDYd9r1qUrLN6fYpgynNixbIStQP
         fXq9zwqBW4War9u1MN2dVkCsCJAeBvukzcOWXXeWvuWeuThSiLJ8UfhtgbXa4n/rXa
         HlrTsQlGHv2kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/39] ext4: add reclaim checks to xattr code
Date:   Thu, 25 Mar 2021 07:25:22 -0400
Message-Id: <20210325112558.1927423-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 163f0ec1df33cf468509ff38cbcbb5eb0d7fac60 ]

Syzbot is reporting that ext4 can enter fs reclaim from kvmalloc() while
the transaction is started like:

  fs_reclaim_acquire+0x117/0x150 mm/page_alloc.c:4340
  might_alloc include/linux/sched/mm.h:193 [inline]
  slab_pre_alloc_hook mm/slab.h:493 [inline]
  slab_alloc_node mm/slub.c:2817 [inline]
  __kmalloc_node+0x5f/0x430 mm/slub.c:4015
  kmalloc_node include/linux/slab.h:575 [inline]
  kvmalloc_node+0x61/0xf0 mm/util.c:587
  kvmalloc include/linux/mm.h:781 [inline]
  ext4_xattr_inode_cache_find fs/ext4/xattr.c:1465 [inline]
  ext4_xattr_inode_lookup_create fs/ext4/xattr.c:1508 [inline]
  ext4_xattr_set_entry+0x1ce6/0x3780 fs/ext4/xattr.c:1649
  ext4_xattr_ibody_set+0x78/0x2b0 fs/ext4/xattr.c:2224
  ext4_xattr_set_handle+0x8f4/0x13e0 fs/ext4/xattr.c:2380
  ext4_xattr_set+0x13a/0x340 fs/ext4/xattr.c:2493

This should be impossible since transaction start sets PF_MEMALLOC_NOFS.
Add some assertions to the code to catch if something isn't working as
expected early.

Link: https://lore.kernel.org/linux-ext4/000000000000563a0205bafb7970@google.com/
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210222171626.21884-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 6127e94ea4f5..0d9fedfc6baa 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1459,6 +1459,9 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	if (!ce)
 		return NULL;
 
+	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
+		     !(current->flags & PF_MEMALLOC_NOFS));
+
 	ea_data = kvmalloc(value_len, GFP_KERNEL);
 	if (!ea_data) {
 		mb_cache_entry_put(ea_inode_cache, ce);
@@ -2325,6 +2328,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 			error = -ENOSPC;
 			goto cleanup;
 		}
+		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
 	}
 
 	error = ext4_reserve_inode_write(handle, inode, &is.iloc);
-- 
2.30.1

