Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41F92492D2
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 04:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHSCSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 22:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHSCSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 22:18:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A99205CB;
        Wed, 19 Aug 2020 02:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597803523;
        bh=DTvzP00JB4bLs9fhk+oXibtsPOxdlN5fCD3Y5A5lhbk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f2PP0KloUJEBUe08gxT3clnhYZje4QkG5SAn5Lj6kL4VNL1X1yRFyw+A0nLabprqj
         E/o18Q9IEZON45cRk7yjX2gfNUcy7yaYzvaGmzmB3fVsCzS5ZyeLf6jR8Y0Wot59JB
         ed3HW65pzfvAn10Lj0Y9mh9RT28oNMZBIPWbXsVs=
Date:   Tue, 18 Aug 2020 19:18:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dhowells@redhat.com, gregkh@linuxfoundation.org, jannh@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 romfs-fix-uninitialized-memory-leak-in-romfs_dev_read.patch added to -mm
 tree
Message-ID: <20200819021843.hSn2BuO_-%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: romfs: fix uninitialized memory leak in romfs_dev_read()
has been added to the -mm tree.  Its filename is
     romfs-fix-uninitialized-memory-leak-in-romfs_dev_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/romfs-fix-uninitialized-memory-leak-in-romfs_dev_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/romfs-fix-uninitialized-memory-leak-in-romfs_dev_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: romfs: fix uninitialized memory leak in romfs_dev_read()

romfs has a superblock field that limits the size of the filesystem; data
beyond that limit is never accessed.

romfs_dev_read() fetches a caller-supplied number of bytes from the
backing device.  It returns 0 on success or an error code on failure;
therefore, its API can't represent short reads, it's all-or-nothing.

However, when romfs_dev_read() detects that the requested operation would
cross the filesystem size limit, it currently silently truncates the
requested number of bytes.  This e.g.  means that when the content of a
file with size 0x1000 starts one byte before the filesystem size limit,
->readpage() will only fill a single byte of the supplied page while
leaving the rest uninitialized, leaking that uninitialized memory to
userspace.

Fix it by returning an error code instead of truncating the read when the
requested read operation would go beyond the end of the filesystem.

Link: http://lkml.kernel.org/r/20200818013202.2246365-1-jannh@google.com
Fixes: da4458bda237 ("NOMMU: Make it possible for RomFS to use MTD devices directly")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/storage.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/romfs/storage.c~romfs-fix-uninitialized-memory-leak-in-romfs_dev_read
+++ a/fs/romfs/storage.c
@@ -217,10 +217,8 @@ int romfs_dev_read(struct super_block *s
 	size_t limit;
 
 	limit = romfs_maxsize(sb);
-	if (pos >= limit)
+	if (pos >= limit || buflen > limit - pos)
 		return -EIO;
-	if (buflen > limit - pos)
-		buflen = limit - pos;
 
 #ifdef CONFIG_ROMFS_ON_MTD
 	if (sb->s_mtd)
_

Patches currently in -mm which might be from jannh@google.com are

romfs-fix-uninitialized-memory-leak-in-romfs_dev_read.patch

