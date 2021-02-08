Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB169314148
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhBHVHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:07:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235235AbhBHVHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 16:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5F1564D73;
        Mon,  8 Feb 2021 21:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612818388;
        bh=3S2d6f69B6RMm+yGHd0aHknkoKMawqweHdndLtYm+SU=;
        h=Date:From:To:Subject:From;
        b=ywf3ERizektQ+D8qKgSpPN19+pr3irCbHNIxQ6zkBeOTU1bGx+0UTn9heHZuVknqA
         iYVpLutOL0T0i6WnTNCkOyspNNnqv8YD4Tk91bixxswsNfhjcmm0f1LU3W64eVHKCJ
         czK9ynw6kHiXxIOq2PwsIp55jnuJa2vHLIztdX+Y=
Date:   Mon, 08 Feb 2021 13:06:27 -0800
From:   akpm@linux-foundation.org
To:     joachim.henke@t-systems.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  + nilfs2-make-splice-write-available-again.patch added to
 -mm tree
Message-ID: <20210208210627.AdnLy6rXt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: make splice write available again
has been added to the -mm tree.  Its filename is
     nilfs2-make-splice-write-available-again.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-make-splice-write-available-again.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-make-splice-write-available-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joachim Henke <joachim.henke@t-systems.com>
Subject: nilfs2: make splice write available again

Since 5.10, splice() or sendfile() to NILFS2 return EINVAL.  This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write without
explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Link: https://lkml.kernel.org/r/1612784101-14353-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Joachim Henke <joachim.henke@t-systems.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/file.c~nilfs2-make-splice-write-available-again
+++ a/fs/nilfs2/file.c
@@ -141,6 +141,7 @@ const struct file_operations nilfs_file_
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
 	.splice_read	= generic_file_splice_read,
+	.splice_write   = iter_file_splice_write,
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
_

Patches currently in -mm which might be from joachim.henke@t-systems.com are

nilfs2-make-splice-write-available-again.patch

