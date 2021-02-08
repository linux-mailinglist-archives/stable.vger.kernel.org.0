Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA0A3142A5
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 23:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhBHWMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 17:12:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhBHWMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 17:12:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E849B64E82;
        Mon,  8 Feb 2021 22:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612822289;
        bh=8Qd2XOyZpSHRqxM+XytuIpAlEHoruMXtS3IoaPxIDmo=;
        h=Date:From:To:Subject:From;
        b=N8B2GcN1ZO8Qh68ND2cmE3H6tmnY57C9SAvOZyHGmMibnxgqS4SgHWybifmQrKjT1
         3NllzAGKfRorufNTF4cHnRjafbJB3L7imsx2bFbKqHqUsqM+JjOwInhwVAHugSA23S
         ZIgwQ1Zvg/V0Aq8dodOPxHUoe7iLBb0wPOpGV/o0=
Date:   Mon, 08 Feb 2021 14:11:28 -0800
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, chris@chrisdown.name, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, mm-commits@vger.kernel.org, rth@twiddle.net,
        seth.forshee@canonical.com, stable@vger.kernel.org
Subject:  + tmpfs-disallow-config_tmpfs_inode64-on-alpha.patch
 added to -mm tree
Message-ID: <20210208221128.SYbII5IxC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
has been added to the -mm tree.  Its filename is
     tmpfs-disallow-config_tmpfs_inode64-on-alpha.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-disallow-config_tmpfs_inode64-on-alpha.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-disallow-config_tmpfs_inode64-on-alpha.patch

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
Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha

As with s390, alpha is a 64-bit architecture with a 32-bit ino_t.  With
CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode numbers and
display "inode64" in the mount options, whereas passing "inode64" in the
mount options will fail.  This leads to erroneous behaviours such as this:

 # mkdir mnt
 # mount -t tmpfs nodev mnt
 # mount -o remount,rw mnt
 mount: /home/ubuntu/mnt: mount point not mounted or bad option.

Prevent CONFIG_TMPFS_INODE64 from being selected on alpha.

Link: https://lkml.kernel.org/r/20210208215726.608197-1-seth.forshee@canonical.com
Fixes: ea3271f7196c ("tmpfs: support 64-bit inums per-sb")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/Kconfig~tmpfs-disallow-config_tmpfs_inode64-on-alpha
+++ a/fs/Kconfig
@@ -203,7 +203,7 @@ config TMPFS_XATTR
 
 config TMPFS_INODE64
 	bool "Use 64-bit ino_t by default in tmpfs"
-	depends on TMPFS && 64BIT && !S390
+	depends on TMPFS && 64BIT && !(S390 || ALPHA)
 	default n
 	help
 	  tmpfs has historically used only inode numbers as wide as an unsigned
_

Patches currently in -mm which might be from seth.forshee@canonical.com are

tmpfs-disallow-config_tmpfs_inode64-on-s390.patch
tmpfs-disallow-config_tmpfs_inode64-on-alpha.patch

