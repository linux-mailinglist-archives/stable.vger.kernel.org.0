Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29113119C7
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 04:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhBFDTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 22:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhBFDME (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 22:12:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCC0E6500F;
        Sat,  6 Feb 2021 00:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612569956;
        bh=1eMAz7k6GicW8nFsMEKojiGvPoT8cGQ2g2NYhSzNPeI=;
        h=Date:From:To:Subject:From;
        b=hfTZfX95qaInMx0HAMRJItI/Nc9e1Y5YTvGzcZcEVoDC+TlKEwA32b8YzdtzheW0p
         7IGBnhK1KKsRorpOGMw+RNgW/ix+znsAdBRBj9csKMMBaeO0vR7RAPM0AtrS00qvlV
         79FAx3GXhyIEltQJr2ZwKCkb3JPkyJ3MRn6mfGiw=
Date:   Fri, 05 Feb 2021 16:05:55 -0800
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, borntraeger@de.ibm.com, chris@chrisdown.name,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        mm-commits@vger.kernel.org, seth.forshee@canonical.com,
        stable@vger.kernel.org
Subject:  + tmpfs-disallow-config_tmpfs_inode64-on-s390.patch added
 to -mm tree
Message-ID: <20210206000555.gnxTOYin5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on s390
has been added to the -mm tree.  Its filename is
     tmpfs-disallow-config_tmpfs_inode64-on-s390.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-disallow-config_tmpfs_inode64-on-s390.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-disallow-config_tmpfs_inode64-on-s390.patch

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
Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on s390

Currently there is an assumption in tmpfs that 64-bit architectures also
have a 64-bit ino_t.  This is not true on s390 which has a 32-bit ino_t. 
With CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode numbers and
display "inode64" in the mount options, but passing the "inode64" mount
option will fail.  This leads to the following behavior:

 # mkdir mnt
 # mount -t tmpfs nodev mnt
 # mount -o remount,rw mnt
 mount: /home/ubuntu/mnt: mount point not mounted or bad option.

As mount sees "inode64" in the mount options and thus passes it in the
options for the remount.


So prevent CONFIG_TMPFS_INODE64 from being selected on s390.

Link: https://lkml.kernel.org/r/20210205230620.518245-1-seth.forshee@canonical.com
Fixes: ea3271f7196c ("tmpfs: support 64-bit inums per-sb")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/Kconfig~tmpfs-disallow-config_tmpfs_inode64-on-s390
+++ a/fs/Kconfig
@@ -203,7 +203,7 @@ config TMPFS_XATTR
 
 config TMPFS_INODE64
 	bool "Use 64-bit ino_t by default in tmpfs"
-	depends on TMPFS && 64BIT
+	depends on TMPFS && 64BIT && !S390
 	default n
 	help
 	  tmpfs has historically used only inode numbers as wide as an unsigned
_

Patches currently in -mm which might be from seth.forshee@canonical.com are

tmpfs-disallow-config_tmpfs_inode64-on-s390.patch
tmpfs-dont-use-64-bit-inodes-by-defulat-with-32-bit-ino_t.patch

