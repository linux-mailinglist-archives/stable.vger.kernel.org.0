Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B823112B9
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhBETBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 14:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhBETAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 14:00:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DABF764F99;
        Fri,  5 Feb 2021 20:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612557725;
        bh=gvlF9Vx55/7A7jvkokoSjbsKaYE4dbw2jfU7B2EVjxs=;
        h=Date:From:To:Subject:From;
        b=GLNiqXW+hyBpHPFOdynhK39SollGG3Q33MJ73Ld9ioqz+0VWkrwT6rJNSvAEfWhgC
         dJmLPT5dD8309PViqoEKRq5/equtDRmLIkJTWlHYmo6FMmAyfkoTpGP19+8cSZ//hi
         4XdIeT6Yv96ziEQUQAK9t91WuV9oMb8LdtcAKhGk=
Date:   Fri, 05 Feb 2021 12:42:04 -0800
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, chris@chrisdown.name, hughd@google.com,
        mm-commits@vger.kernel.org, seth.forshee@canonical.com,
        stable@vger.kernel.org
Subject:  +
 tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch added to
 -mm tree
Message-ID: <20210205204204.h0rdk8Nti%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tmpfs: don't use 64-bit inodes by defulat with 32-bit ino_t
has been added to the -mm tree.  Its filename is
     tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Seth Forshee <seth.forshee@canonical.com>
Subject: tmpfs: don't use 64-bit inodes by defulat with 32-bit ino_t

Currently there seems to be an assumption in tmpfs that 64-bit
architectures also have a 64-bit ino_t.  This is not true; s390 at least
has a 32-bit ino_t.  With CONFIG_TMPFS_INODE64=y tmpfs mounts will get
64-bit inode numbers and display "inode64" in the mount options, but
passing the "inode64" mount option will fail.  This leads to the following
behavior:

 # mkdir mnt
 # mount -t tmpfs nodev mnt
 # mount -o remount,rw mnt
 mount: /home/ubuntu/mnt: mount point not mounted or bad option.

As mount sees "inode64" in the mount options and thus passes it in the
options for the remount.

Ideally CONFIG_TMPFS_INODE64 would depend on sizeof(ino_t) < 8, but I
don't think it's possible to test for this (potentially
CONFIG_ARCH_HAS_64BIT_INO_T or similar could be added, but I'm not sure
whether or not that is wanted).  So fix this by simply refusing to honor
the CONFIG_TMPFS_INODE64 setting when sizeof(ino_t) < 8.

Link: https://lkml.kernel.org/r/20210205202159.505612-1-seth.forshee@canonical.com
Fixes: ea3271f7196c ("tmpfs: support 64-bit inums per-sb")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t
+++ a/mm/shmem.c
@@ -3733,7 +3733,7 @@ static int shmem_fill_super(struct super
 			ctx->blocks = shmem_default_max_blocks();
 		if (!(ctx->seen & SHMEM_SEEN_INODES))
 			ctx->inodes = shmem_default_max_inodes();
-		if (!(ctx->seen & SHMEM_SEEN_INUMS))
+		if (!(ctx->seen & SHMEM_SEEN_INUMS) && sizeof(ino_t) >= 8)
 			ctx->full_inums = IS_ENABLED(CONFIG_TMPFS_INODE64);
 	} else {
 		sb->s_flags |= SB_NOUSER;
_

Patches currently in -mm which might be from seth.forshee@canonical.com are

tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch

