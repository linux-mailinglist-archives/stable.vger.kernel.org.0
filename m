Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C90216288
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 01:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgGFXuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 19:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgGFXuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 19:50:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB6F220672;
        Mon,  6 Jul 2020 23:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594079423;
        bh=35tFHxUMsPBj1njpE1TzvKWJoVywGxAPuxa0fX8yVzI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=n+H0O/vki869e6gRCXEY5UCbkH6+52TAXg5Llx7D5EjHb1Trne9HIKVYUSrh5ljdJ
         whHCMPY/B+JOqLdwmaql6pdMFp29XEhgQoePrwayEEZf+9NDaamY2TRfuV4E0ou8lg
         b+D9tJk0ErCahOpYArhjiobMEt/akRANZoiDQ3s8=
Date:   Mon, 06 Jul 2020 16:50:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adilger@dilger.ca, cgxu519@mykernel.net, chris@chrisdown.name,
        dxu@dxuuu.xyz, gregkh@linuxfoundation.org, hughd@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch
 added to -mm tree
Message-ID: <20200706235022.Xujoc1zol%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way
has been added to the -mm tree.  Its filename is
     vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch
mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch

