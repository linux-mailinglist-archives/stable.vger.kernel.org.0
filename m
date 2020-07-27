Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EA022F08C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbgG0OZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbgG0OZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:25:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C85B02083E;
        Mon, 27 Jul 2020 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859928;
        bh=TbXNN2H51Ot2o0VSNGgDM3dKNoviQTATdC575C+5Cf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8x5YLseXp9wD6UTmuBfUDvAVENvbDqeGhEgj/R7HXTuZs1fuvQw4t1FY27mkdYzt
         c6j90PCAq5gI9idFJYsLw6MHJlMBpnC396VXD7MdZV+OmMCkiiUF8gtrQMy+oEL/Yt
         bCYWmM+4qipawrpXXNYRIf9bwvVkESW3E6o6ZX6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>, Chris Down <chris@chrisdown.name>,
        Andreas Dilger <adilger@dilger.ca>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 160/179] vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way
Date:   Mon, 27 Jul 2020 16:05:35 +0200
Message-Id: <20200727134940.469948028@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

commit 3bef735ad7b7d987069181e7b58588043cbd1509 upstream.

After commit fdc85222d58e ("kernfs: kvmalloc xattr value instead of
kmalloc"), simple xattr entry is allocated with kvmalloc() instead of
kmalloc(), so we should release it with kvfree() instead of kfree().

Fixes: fdc85222d58e ("kernfs: kvmalloc xattr value instead of kmalloc")
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Xu <dxu@dxuuu.xyz>
Cc: Chris Down <chris@chrisdown.name>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>	[5.7]
Link: http://lkml.kernel.org/r/20200704051608.15043-1-cgxu519@mykernel.net
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/xattr.h |    3 ++-
 mm/shmem.c            |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/mm.h>
 #include <uapi/linux/xattr.h>
 
 struct inode;
@@ -94,7 +95,7 @@ static inline void simple_xattrs_free(st
 
 	list_for_each_entry_safe(xattr, node, &xattrs->head, list) {
 		kfree(xattr->name);
-		kfree(xattr);
+		kvfree(xattr);
 	}
 }
 
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3205,7 +3205,7 @@ static int shmem_initxattrs(struct inode
 		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
 					  GFP_KERNEL);
 		if (!new_xattr->name) {
-			kfree(new_xattr);
+			kvfree(new_xattr);
 			return -ENOMEM;
 		}
 


