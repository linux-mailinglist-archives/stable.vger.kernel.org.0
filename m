Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CD728A529
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 05:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgJKDg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 23:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbgJKDg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Oct 2020 23:36:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31A320773;
        Sun, 11 Oct 2020 03:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602387388;
        bh=66FaKwXrf0aBug71opDfeWO0v0BrvsAwDj3jgDOe67g=;
        h=Date:From:To:Subject:From;
        b=rQyu6D+NqLG8viZysGe56g7a+l3d1PA+/zRSERthWkQyaWMnHl3ZBMcQ8EpeZZJFc
         MuXrQyoHJpekEWrYxYZ7/yn/9OSiRTddPAfg7Vvm4GncyJZnGOKtloSGZcRut5oLbI
         6KEOzpNBrHI2Ko7vOUNLlkw23OyUuPvQBGU05bIk=
Date:   Sat, 10 Oct 2020 20:36:27 -0700
From:   akpm@linux-foundation.org
To:     andres@anarazel.de, david@fromorbit.com, dhowells@redhat.com,
        hch@infradead.org, jack@suse.cz, jlayton@kernel.org,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  + mm-validate-inode-in-mapping_set_error.patch added to
 -mm tree
Message-ID: <20201011033627.VInQu4bdg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: validate inode in mapping_set_error()
has been added to the -mm tree.  Its filename is
     mm-validate-inode-in-mapping_set_error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-validate-inode-in-mapping_set_error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-validate-inode-in-mapping_set_error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: validate inode in mapping_set_error()

The swap address_space doesn't have host. Thus, it makes kernel crash once
swap write meets error. Fix it.

Link: https://lkml.kernel.org/r/20201010000650.750063-1-minchan@kernel.org
Fixes: 735e4ae5ba28 ("vfs: track per-sb writeback errors and report them to syncfs")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jeff Layton <jlayton@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Andres Freund <andres@anarazel.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-validate-inode-in-mapping_set_error
+++ a/include/linux/pagemap.h
@@ -54,7 +54,8 @@ static inline void mapping_set_error(str
 	__filemap_set_wb_err(mapping, error);
 
 	/* Record it in superblock */
-	errseq_set(&mapping->host->i_sb->s_wb_err, error);
+	if (mapping->host)
+		errseq_set(&mapping->host->i_sb->s_wb_err, error);
 
 	/* Record it in flags for now, for legacy callers */
 	if (error == -ENOSPC)
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-validate-inode-in-mapping_set_error.patch
mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

