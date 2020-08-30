Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DB825707F
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 22:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgH3Uad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 16:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgH3Uab (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 16:30:31 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C61A20757;
        Sun, 30 Aug 2020 20:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598819430;
        bh=dLXp4UiQ8o25W0JNBTeH+xyz1kltRrGPv0bnrfI1CJo=;
        h=Date:From:To:Subject:From;
        b=sobJ5/zqyioSH8t6oxKvHCQZZSrfZbHcvzS2Ll0e/Si67CRVRwEgO2irvyFHgGLz1
         fBdSsNOZKZEYisvVOKaRg42VKbJTk/cErHzegGmQcsFjrv2/LjxwknjaV4OsO9+Suf
         aQ1TJeG49liGSjRb+l4SxGE8MEr4OCGocVoDPbmA=
Date:   Sun, 30 Aug 2020 13:30:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, axboe@kernel.dk,
        hirofumi@mail.parknet.co.jp
Subject:  + fat-avoid-oops-when-bdi-io_pages==0.patch added to -mm
 tree
Message-ID: <20200830203029.pwefu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fat: avoid oops when bdi->io_pages==0
has been added to the -mm tree.  Its filename is
     fat-avoid-oops-when-bdi-io_pages==0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-avoid-oops-when-bdi-io_pages%3D%3D0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-avoid-oops-when-bdi-io_pages%3D%3D0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fat-avoid-oops-when-bdi-io_pages==0.patch

