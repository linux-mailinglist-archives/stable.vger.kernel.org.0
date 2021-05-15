Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872A1381490
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 02:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhEOA23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 20:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 20:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2B6C61440;
        Sat, 15 May 2021 00:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038436;
        bh=q9VfCXkCafejL6EKzUf8WpxrHYOGYl3QKNbY6MS0ZwE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IZoHGCudut9IE1aBxKhz8YzLZukXQiHZUJbLvARVBgPG2jb5/W/ge6KpzQlRpFybw
         oC53iud82uz/59+6qcF6gk3k1HQjXdzbc69WYoq9XE7XwHdJG5cm2YcwvxJAnyJV3v
         FOmiX8taKo0WbVrAquX9sL65ta+OwJfyL2xKmKPE=
Date:   Fri, 14 May 2021 17:27:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        stable@vger.kernel.org,
        syzbot+7b98870d4fec9447b951@syzkaller.appspotmail.com,
        syzbot+e8f781243ce16ac2f962@syzkaller.appspotmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 05/13] squashfs: fix divide error in
 calculate_skip()
Message-ID: <20210515002716.xFCvUKslt%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
