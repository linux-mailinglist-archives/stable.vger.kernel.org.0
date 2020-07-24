Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D6A22D23F
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgGXXiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 19:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgGXXiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EFCC2070B;
        Fri, 24 Jul 2020 23:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633896;
        bh=pKNFPrwjR5yhzmH3KriPeyu6UFjty0BTgAG85RqO+XA=;
        h=Date:From:To:Subject:From;
        b=snmhM88hN4PCNuxduUE8HQCi+ctkeR6u98L4HYvfP2y/TlL7g30FRomq4zRZvJEEc
         BPOHYDP8TYQVf9mFae1aJl2vMFHgZjqiDSKhL7qu8Mk5SVAukV+ObBtibWpy0PdecA
         ogQAS0BlmKDxdrEiUGxSxIjOvVxstvqPtagTKvcg=
Date:   Fri, 24 Jul 2020 16:38:16 -0700
From:   akpm@linux-foundation.org
To:     adilger@dilger.ca, cgxu519@mykernel.net, chris@chrisdown.name,
        dxu@dxuuu.xyz, gregkh@linuxfoundation.org, hughd@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch
 removed from -mm tree
Message-ID: <20200724233816.tpwAOy62n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way
has been removed from the -mm tree.  Its filename was
     vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chengguang Xu <cgxu519@mykernel.net>
Subject: vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way

After commit fdc85222d58e ("kernfs: kvmalloc xattr value instead of
kmalloc"), simple xattr entry is allocated with kvmalloc() instead of
kmalloc(), so we should release it with kvfree() instead of kfree().

Link: http://lkml.kernel.org/r/20200704051608.15043-1-cgxu519@mykernel.net
Fixes: fdc85222d58e ("kernfs: kvmalloc xattr value instead of kmalloc")
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Xu <dxu@dxuuu.xyz>
Cc: Chris Down <chris@chrisdown.name>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>	[5.7]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xattr.h |    3 ++-
 mm/shmem.c            |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/xattr.h~vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way
+++ a/include/linux/xattr.h
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
 
--- a/mm/shmem.c~vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way
+++ a/mm/shmem.c
@@ -3178,7 +3178,7 @@ static int shmem_initxattrs(struct inode
 		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
 					  GFP_KERNEL);
 		if (!new_xattr->name) {
-			kfree(new_xattr);
+			kvfree(new_xattr);
 			return -ENOMEM;
 		}
 
_

Patches currently in -mm which might be from cgxu519@mykernel.net are


