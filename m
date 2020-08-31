Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E6E258216
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 21:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgHaTub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 15:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbgHaTub (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 15:50:31 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EDCA2083E;
        Mon, 31 Aug 2020 19:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598903430;
        bh=91iSUjJrhFtccxGcUDJHA9DbrAgsxr0J3nSJgEJ7bHs=;
        h=Date:From:To:Subject:From;
        b=PdnENpJY0eUADtnfrQxCDeTh2fHDs7P1sJV0VIAtzbySJvUXbFcNVhhIAKM3d7cgv
         IX3SYu7EZvMn7l5mN8B+Cm5NU1pq7WvzKT/qNPp+0NvI3NuBu8RkOnOqjuqVot1ywK
         2tuUET68qqBpyEjJXgFaNDCxx9+q9Hv0Wo8CK0A8=
Date:   Mon, 31 Aug 2020 12:50:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, axboe@kernel.dk,
        hirofumi@mail.parknet.co.jp
Subject:  [alternative-merged]
 fat-avoid-oops-when-bdi-io_pages==0.patch removed from -mm tree
Message-ID: <20200831195029.T63Ay%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fat: avoid oops when bdi->io_pages==0
has been removed from the -mm tree.  Its filename was
     fat-avoid-oops-when-bdi-io_pages==0.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: avoid oops when bdi->io_pages==0

On one system, there was bdi->io_pages==0.  This seems to be the bug of a
driver somewhere, which perhaps failed to initialize io_pages.  We should
fix it though - it is better to avoid the divide-by-zero Oops.

So add a check for this.

Link: http://lkml.kernel.org/r/87ft85osn6.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>		[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/fatent.c~fat-avoid-oops-when-bdi-io_pages==0
+++ a/fs/fat/fatent.c
@@ -660,7 +660,7 @@ static void fat_ra_init(struct super_blo
 	if (fatent->entry >= ent_limit)
 		return;
 
-	if (ra_pages > sb->s_bdi->io_pages)
+	if (sb->s_bdi->io_pages && ra_pages > sb->s_bdi->io_pages)
 		ra_pages = rounddown(ra_pages, sb->s_bdi->io_pages);
 	reada_blocks = ra_pages << (PAGE_SHIFT - sb->s_blocksize_bits + 1);
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are


