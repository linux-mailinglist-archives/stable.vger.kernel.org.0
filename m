Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CC18046E
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 06:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfHCEst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 00:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHCEst (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 00:48:49 -0400
Received: from X1 (unknown [76.191.170.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B53B2166E;
        Sat,  3 Aug 2019 04:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564807728;
        bh=q0zGOh8sv4iCZgF1t9ZkFXRLYGxTCmf3f38lEFEt00c=;
        h=Date:From:To:Subject:From;
        b=E2oXE8sEgI7HSJ2ZHFBpnTfpcI+QgM/EQIITHjz+ChEdbIMPiAdA0O1yrR6HJp9Jp
         Gezm6HGdRqVrOP2exfetj5dmtTNJun0mUmijE/ATRJGsofHMA9k1gmahDXl778KZfJ
         MC+yLU4vzbT21AN9femUbyVjjujSqtLZZ7snBQQI=
Date:   Fri, 02 Aug 2019 21:48:47 -0700
From:   akpm@linux-foundation.org
To:     stable@vger.kernel.org, mgorman@techsingularity.net, jack@suse.cz,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 05/17] mm: migrate: fix reference check race between
 __find_get_block() and migration
Message-ID: <20190803044847.jzxsm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
