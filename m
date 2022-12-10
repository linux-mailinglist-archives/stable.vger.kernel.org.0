Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8DA648C8E
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 03:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLJCmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 21:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLJCl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 21:41:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1FC79C83;
        Fri,  9 Dec 2022 18:41:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DDF6623D5;
        Sat, 10 Dec 2022 02:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0162DC433EF;
        Sat, 10 Dec 2022 02:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670640116;
        bh=MnNnpbDc60oGThknKn8tFqyUgyumrCLe0lY4t4SomaU=;
        h=Date:To:From:Subject:From;
        b=JQL68w5e1c1Q7e1PxdpvDLS7Th/K9Yh1TME3sPRAbXQ6jkiuje5ea9fMBWOrQI4vX
         xP6scuIznGkt9KsI8Yvd9PAfditKPfPnwm3jPRdoZ5NSInmgq7jmWZXvYkJ4NQvlA0
         hQoH9XgN50ZEw08x413JqBk6/8+3PLixOKyhbmWY=
Date:   Fri, 09 Dec 2022 18:41:55 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, stable@vger.kernel.org, kernel@hev.cc,
        chenhuacai@loongson.cn, chenguoqic@163.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tmpfs-fix-data-loss-from-failed-fallocate.patch removed from -mm tree
Message-Id: <20221210024156.0162DC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: tmpfs: fix data loss from failed fallocate
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-data-loss-from-failed-fallocate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: fix data loss from failed fallocate
Date: Sun, 4 Dec 2022 16:51:50 -0800 (PST)

Fix tmpfs data loss when the fallocate system call is interrupted by a
signal, or fails for some other reason.  The partial folio handling in
shmem_undo_range() forgot to consider this unfalloc case, and was liable
to erase or truncate out data which had already been committed earlier.

It turns out that none of the partial folio handling there is appropriate
for the unfalloc case, which just wants to proceed to removal of whole
folios: which find_get_entries() provides, even when partially covered.

Original patch by Rui Wang.

Link: https://lore.kernel.org/linux-mm/33b85d82.7764.1842e9ab207.Coremail.chenguoqic@163.com/
Link: https://lkml.kernel.org/r/a5dac112-cf4b-7af-a33-f386e347fd38@google.com
Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Guoqi Chen <chenguoqic@163.com>
  Link: https://lore.kernel.org/all/20221101032248.819360-1-kernel@hev.cc/
Cc: Rui Wang <kernel@hev.cc>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/shmem.c~tmpfs-fix-data-loss-from-failed-fallocate
+++ a/mm/shmem.c
@@ -948,6 +948,15 @@ static void shmem_undo_range(struct inod
 		index++;
 	}
 
+	/*
+	 * When undoing a failed fallocate, we want none of the partial folio
+	 * zeroing and splitting below, but shall want to truncate the whole
+	 * folio when !uptodate indicates that it was added by this fallocate,
+	 * even when [lstart, lend] covers only a part of the folio.
+	 */
+	if (unfalloc)
+		goto whole_folios;
+
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
 	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
 	if (folio) {
@@ -973,6 +982,8 @@ static void shmem_undo_range(struct inod
 		folio_put(folio);
 	}
 
+whole_folios:
+
 	index = start;
 	while (index < end) {
 		cond_resched();
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcg-fix-swapcached-stat-accounting.patch
mmthprmap-fix-races-between-updates-of-subpages_mapcount.patch

