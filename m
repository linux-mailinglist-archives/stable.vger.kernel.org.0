Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D201387F8F
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344315AbhERS0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 14:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242486AbhERS0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 14:26:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895B0611CE;
        Tue, 18 May 2021 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621362316;
        bh=IEf/ollL+W9Hg5KHpcZ7NXJiEyOESlGesrMNtC3y0zE=;
        h=Date:From:To:Subject:From;
        b=XpodZSvU4ewaDCv3MdgCl/j2pn89b4wSwCSYNHrfnaEgO6GA2uaFJr3UIUJWdzOOX
         jr0LAJvz9gCzOmov9MEwxRzO3WyjTnIM8M+zn+ixzelRZFZMpa877uAhBjy8pV0ufz
         bXB6bfAd7Uu4ovgUrk+r9cDELf97BUHGJM2xEZ3U=
Date:   Tue, 18 May 2021 11:25:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        stable@vger.kernel.org,
        syzbot+7b98870d4fec9447b951@syzkaller.appspotmail.com,
        syzbot+e8f781243ce16ac2f962@syzkaller.appspotmail.com
Subject:  [merged]
 squashfs-fix-divide-error-in-calculate_skip.patch removed from -mm tree
Message-ID: <20210518182516.987kKj0bk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix divide error in calculate_skip()
has been removed from the -mm tree.  Its filename was
     squashfs-fix-divide-error-in-calculate_skip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix divide error in calculate_skip()

Sysbot has reported a "divide error" which has been identified as being
caused by a corrupted file_size value within the file inode.  This value
has been corrupted to a much larger value than expected.

Calculate_skip() is passed i_size_read(inode) >> msblk->block_log.  Due to
the file_size value corruption this overflows the int argument/variable in
that function, leading to the divide error.

This patch changes the function to use u64.  This will accommodate any
unexpectedly large values due to corruption.

The value returned from calculate_skip() is clamped to be never more than
SQUASHFS_CACHED_BLKS - 1, or 7.  So file_size corruption does not lead to
an unexpectedly large return result here.

Link: https://lkml.kernel.org/r/20210507152618.9447-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: <syzbot+e8f781243ce16ac2f962@syzkaller.appspotmail.com>
Reported-by: <syzbot+7b98870d4fec9447b951@syzkaller.appspotmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/file.c~squashfs-fix-divide-error-in-calculate_skip
+++ a/fs/squashfs/file.c
@@ -211,11 +211,11 @@ failure:
  * If the skip factor is limited in this way then the file will use multiple
  * slots.
  */
-static inline int calculate_skip(int blocks)
+static inline int calculate_skip(u64 blocks)
 {
-	int skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
+	u64 skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
 		 * SQUASHFS_META_INDEXES);
-	return min(SQUASHFS_CACHED_BLKS - 1, skip + 1);
+	return min((u64) SQUASHFS_CACHED_BLKS - 1, skip + 1);
 }
 
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


