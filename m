Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ED13119C6
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 04:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhBFDSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 22:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhBFDL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 22:11:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0A9965018;
        Sat,  6 Feb 2021 00:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612569970;
        bh=sMLs3L/SAP+WzsJitFnnORkNS+sfiIL1sSzW6f/+5bA=;
        h=Date:From:To:Subject:From;
        b=gIOn/xit3OrCyrJE1FJoLpPYPtkV8vYHdm4pq736+Lo4SHs9K01CoaJtRdnWwVVF3
         dRwIaOFrVvOrzqTq06p1TyRlXlKhcOuhxuPyW54/TXUdjoMMiU8Gdd0QwoXqWgVRZh
         AvMFPmDtLPNp4PrK39Nfzp4E6eEsjhyz7f3B6dmY=
Date:   Fri, 05 Feb 2021 16:06:09 -0800
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, chris@chrisdown.name, hughd@google.com,
        mm-commits@vger.kernel.org, seth.forshee@canonical.com,
        stable@vger.kernel.org
Subject:  [alternative-merged]
 tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch removed
 from -mm tree
Message-ID: <20210206000609.xM6fuPWxb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tmpfs: don't use 64-bit inodes by defulat with 32-bit ino_t
has been removed from the -mm tree.  Its filename was
     tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch

This patch was dropped because an alternative patch was merged

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

tmpfs-disallow-config_tmpfs_inode64-on-s390.patch

