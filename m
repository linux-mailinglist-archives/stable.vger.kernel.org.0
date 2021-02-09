Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2931599A
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 23:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhBIWkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 17:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234216AbhBIWRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 17:17:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92EB764ECF;
        Tue,  9 Feb 2021 21:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906935;
        bh=Z3tdZ8g+QGli3UaRB37iBSBQLEU+YRh7a0FWPInUBM8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SWYKD6NGlC9KMNLk++hTqYt31hZxGQv6gboga0c39AkG5sfqJECfOj2r0GKn3Ze0y
         I32vPVIow0SsyJyVNqJ8TYyndmVya4dNB1hN+628ipc6MdtEy0lGwaLDcPeIfoEW0M
         ZOnvatC652mK98beEw2aIVxU2C6Ei7vOxpktsnMg=
Date:   Tue, 09 Feb 2021 13:42:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amir73il@gmail.com,
        borntraeger@de.ibm.com, chris@chrisdown.name, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, seth.forshee@canonical.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 08/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on
 s390
Message-ID: <20210209214214.Eh4EHTHRW%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
