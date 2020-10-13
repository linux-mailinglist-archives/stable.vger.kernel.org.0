Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAD628D57E
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 22:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgJMUlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 16:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJMUlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 16:41:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C931320878;
        Tue, 13 Oct 2020 20:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602621699;
        bh=mAG0SLRsFnwysDTSScqO2dNkMnCvdSHfTkYmkK5uNn8=;
        h=Date:From:To:Subject:From;
        b=i6NE2OpqA/VVyK3cNFp2UA/0VYloGiCIdL0BSJkezrGHuTPyICQLZ2z2ZB8ggAu0h
         AlxRKkAkzQbSEGVpp1tooz3UyZlnZZ/V+Hg6dLYOXtj30rXy7WqdZAi9Z8wSC/6GRl
         2z/W/K4CzYymbIkyPpjT4KIgKSpZnkVDQoGHFvlY=
Date:   Tue, 13 Oct 2020 13:41:38 -0700
From:   akpm@linux-foundation.org
To:     andres@anarazel.de, david@fromorbit.com, dhowells@redhat.com,
        hch@infradead.org, jack@suse.cz, jlayton@kernel.org,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [merged] mm-validate-inode-in-mapping_set_error.patch
 removed from -mm tree
Message-ID: <20201013204138.9pyqk1J44%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: validate inode in mapping_set_error()
has been removed from the -mm tree.  Its filename was
     mm-validate-inode-in-mapping_set_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

