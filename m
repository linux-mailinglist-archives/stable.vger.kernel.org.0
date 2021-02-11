Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C4D319258
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBKSfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232818AbhBKScz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 13:32:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A1B64E76;
        Thu, 11 Feb 2021 18:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068254;
        bh=IjDcYvHHRFt37jOS1uKnA8qEfLTCYS7IAtpAxpOgsig=;
        h=Date:From:To:Subject:From;
        b=aAdIGey6Z+eC6WBTLjrG4alqM5s1q2JNJg7Pc8Ki5Fu0Wr9953txWNjQu72DkB7G6
         K3LjIikbTgHx91V03S2Z3clR3qAFtwPw0+Db48dVv/rIMWxsOo9hBqkYfK6s9vRn80
         5LkA86oQUQTj+NFXekeaEnDx0ADFiGnTZGYn6T34=
Date:   Thu, 11 Feb 2021 10:30:54 -0800
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, borntraeger@de.ibm.com, chris@chrisdown.name,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        mm-commits@vger.kernel.org, seth.forshee@canonical.com,
        stable@vger.kernel.org
Subject:  [merged]
 tmpfs-disallow-config_tmpfs_inode64-on-s390.patch removed from -mm tree
Message-ID: <20210211183054.I46E9E5FK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on s390
has been removed from the -mm tree.  Its filename was
     tmpfs-disallow-config_tmpfs_inode64-on-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Hugh Dickins <hughd@google.com>
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


