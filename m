Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35AC24E901
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 19:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgHVR36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 13:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbgHVR3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D66207DA;
        Sat, 22 Aug 2020 17:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117393;
        bh=7h38Gm3LBaXduAYClp9J6Sk3oEn5s7qnWfMlP+cinfc=;
        h=Date:From:To:Subject:From;
        b=wykFZzVUDA60nRLlyUkVt5G473nX2zFFH5VBU+gazObOIaI32cg4lBGmIFIfR6tJK
         W6InlFo5MeAfaTpznP981w3IHWzxJYxsXpU6sjX0aoIZSbzLCOlooi+vxI2H8c8rz6
         7styM8OmWiomOsWXxZx0ewDKI1V4pvT8U1lgQ4sA=
Date:   Sat, 22 Aug 2020 10:29:53 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, gregkh@linuxfoundation.org, jannh@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 romfs-fix-uninitialized-memory-leak-in-romfs_dev_read.patch removed from
 -mm tree
Message-ID: <20200822172953.DM3IHEThM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: romfs: fix uninitialized memory leak in romfs_dev_read()
has been removed from the -mm tree.  Its filename was
     romfs-fix-uninitialized-memory-leak-in-romfs_dev_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


