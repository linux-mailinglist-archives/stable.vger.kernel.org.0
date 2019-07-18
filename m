Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C013E6D5E6
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfGRUjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfGRUjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 16:39:31 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3501208C0;
        Thu, 18 Jul 2019 20:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563482370;
        bh=LAJamMS7YTxqf6JZA1ybMchEi9hfjyGvpn8qSiGoA9Q=;
        h=Date:From:To:Subject:From;
        b=zQZC9Pu06IqV1WsHpRHLl4UkdMeJpxDxXRB+Z5qDPHZ7MLUvF0A6fEhhHuhmQmnev
         nrrzUILvre3RRR6ibP0gY7KqJnv0GuO4CyRRFaRgjZu5lTbRNSnfNjjQcOe8vwSO6z
         ZVJ1zKCGM5+UiRGX75luf6k/q1xZYfE/84oHo8Ag=
Date:   Thu, 18 Jul 2019 13:39:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mgorman@techsingularity.net, jack@suse.cz
Subject:  +
 =?us-ascii?Q?mm-migrate-fix-reference-check-race-between-=5F=5Ffind=5Fg?=
 =?us-ascii?Q?et=5Fblock-and-migration.patch?= added to -mm tree
Message-ID: <20190718203930.x9y7j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix reference check race between __find_get_block() and migration
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-reference-check-race-between-__find_get_block-and-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-reference-check-race-between-__find_get_block-and-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-reference-check-race-between-__find_get_block-and-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: migrate: fix reference check race between __find_get_block() and migration

buffer_migrate_page_norefs() can race with bh users in the following way:

CPU1                                    CPU2
buffer_migrate_page_norefs()
  buffer_migrate_lock_buffers()
  checks bh refs
  spin_unlock(&mapping->private_lock)
                                        __find_get_block()
                                          spin_lock(&mapping->private_lock)
                                          grab bh ref
                                          spin_unlock(&mapping->private_lock)
  move page                               do bh work

This can result in various issues like lost updates to buffers (i.e. 
metadata corruption) or use after free issues for the old page.

This patch closes the race by holding mapping->private_lock while the
mapping is being moved to a new page.  Ordinarily, a reference can be
taken outside of the private_lock using the per-cpu BH LRU but the
references are checked and the LRU invalidated if necessary.  The
private_lock is held once the references are known so the buffer lookup
slow path will spin on the private_lock.  Between the page lock and
private_lock, it should be impossible for other references to be acquired
and updates to happen during the migration.

A user had reported data corruption issues on a distribution kernel with a
similar page migration implementation as mainline.  The data corruption
could not be reproduced with this patch applied.  A small number of
migration-intensive tests were run and no performance problems were noted.

[mgorman@techsingularity.net: Changelog, removed tracing]
Link: http://lkml.kernel.org/r/20190718090238.GF24383@techsingularity.net
Fixes: 89cb0888ca14 "mm: migrate: provide buffer_migrate_page_norefs()"
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[5.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-reference-check-race-between-__find_get_block-and-migration
+++ a/mm/migrate.c
@@ -768,12 +768,12 @@ recheck_buffers:
 			}
 			bh = bh->b_this_page;
 		} while (bh != head);
-		spin_unlock(&mapping->private_lock);
 		if (busy) {
 			if (invalidated) {
 				rc = -EAGAIN;
 				goto unlock_buffers;
 			}
+			spin_unlock(&mapping->private_lock);
 			invalidate_bh_lrus();
 			invalidated = true;
 			goto recheck_buffers;
@@ -806,6 +806,8 @@ recheck_buffers:
 
 	rc = MIGRATEPAGE_SUCCESS;
 unlock_buffers:
+	if (check_refs)
+		spin_unlock(&mapping->private_lock);
 	bh = head;
 	do {
 		unlock_buffer(bh);
_

Patches currently in -mm which might be from jack@suse.cz are

mm-migrate-fix-reference-check-race-between-__find_get_block-and-migration.patch

