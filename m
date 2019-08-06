Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C09A83A05
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfHFUHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfHFUHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:07:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95CA520717;
        Tue,  6 Aug 2019 20:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565122040;
        bh=COPip/2bC2geRzZ/cL3zjFPJP5ZNb8VQEm3ZBw14snI=;
        h=Date:From:To:Subject:From;
        b=q5d/h+LbtlcOTU/AYfiSIJ27PzeVrgMZy1wE2F5wtv52/zHwEZtoAShIjLgbcXeLx
         XahV42LOImc3xXEw3cZo/xZ30m6PrAUN0ow9QKS4CHZ+wI1nolpoJmyTGHiOYZJlqe
         kSUI/dvV5nIdDrRPoCmzNrdZ7QkM21DRLsf9uqQg=
Date:   Tue, 06 Aug 2019 13:07:20 -0700
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-migrate-fix-reference-check-race-between-=5F=5Ffind=5Fg?=
 =?US-ASCII?Q?et=5Fblock-and-migration.patch?= removed from -mm tree
Message-ID: <20190806200720.XJyuEp2iu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix reference check race between __find_get_block() and migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-reference-check-race-between-__find_get_block-and-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -767,12 +767,12 @@ recheck_buffers:
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
@@ -805,6 +805,8 @@ recheck_buffers:
 
 	rc = MIGRATEPAGE_SUCCESS;
 unlock_buffers:
+	if (check_refs)
+		spin_unlock(&mapping->private_lock);
 	bh = head;
 	do {
 		unlock_buffer(bh);
_

Patches currently in -mm which might be from jack@suse.cz are


