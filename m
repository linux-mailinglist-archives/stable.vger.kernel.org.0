Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289D081CDD
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfHENYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731039AbfHENYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB172173C;
        Mon,  5 Aug 2019 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011473;
        bh=cSXLFjvwyHw2gAGDjH+6VhM4Ml2vsJ43WmdVDFlFgTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVfeUnkHk0kt9LyC7ifSHazZQK9okQRRsUXjvLRi4dHKcP1sYqs7cXOD9sLY83fcT
         B+04J9iiiOnUIUbQmWlJtKhwrAcobSIizMfUn3Pu+qi32OEKrGXYxsN8LftlYLcFUW
         TtNWgKLkdHe1vMJMruW0jvw0P6slf3bVe8Nfi4UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 101/131] mm: migrate: fix reference check race between __find_get_block() and migration
Date:   Mon,  5 Aug 2019 15:03:08 +0200
Message-Id: <20190805124958.718102251@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit ebdf4de5642fb6580b0763158b6b4b791c4d6a4d upstream.

buffer_migrate_page_norefs() can race with bh users in the following
way:

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
private_lock, it should be impossible for other references to be
acquired and updates to happen during the migration.

A user had reported data corruption issues on a distribution kernel with
a similar page migration implementation as mainline.  The data
corruption could not be reproduced with this patch applied.  A small
number of migration-intensive tests were run and no performance problems
were noted.

[mgorman@techsingularity.net: Changelog, removed tracing]
Link: http://lkml.kernel.org/r/20190718090238.GF24383@techsingularity.net
Fixes: 89cb0888ca14 "mm: migrate: provide buffer_migrate_page_norefs()"
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[5.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -771,12 +771,12 @@ recheck_buffers:
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
@@ -809,6 +809,8 @@ recheck_buffers:
 
 	rc = MIGRATEPAGE_SUCCESS;
 unlock_buffers:
+	if (check_refs)
+		spin_unlock(&mapping->private_lock);
 	bh = head;
 	do {
 		unlock_buffer(bh);


