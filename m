Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59947642121
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 02:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiLEBl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 20:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiLEBl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 20:41:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E8910FDB;
        Sun,  4 Dec 2022 17:41:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B8660F21;
        Mon,  5 Dec 2022 01:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11144C433D7;
        Mon,  5 Dec 2022 01:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670204515;
        bh=pVEtoNB3nEJ9xracHQkOSfDu1vYY/E6hcJ7XPkUIit4=;
        h=Date:To:From:Subject:From;
        b=urBAoY58shUNLCSXXza8AiyCfDz/+vslngGznsHE3NFkK49FkYdOxS57TR+x7TzY7
         eCCwwakUKSKWvneWazR62LE2S4g84LV2QPc4SJpnS4zshFxnxIXuNGoNisoGhfDx0H
         92KLWyO8XlLIV74IfaIl8Pf46mIYp/jvlN+dJY8E=
Date:   Sun, 04 Dec 2022 17:41:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, stable@vger.kernel.org, kernel@hev.cc,
        chenhuacai@loongson.cn, chenguoqic@163.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-data-loss-from-failed-fallocate.patch added to mm-hotfixes-unstable branch
Message-Id: <20221205014155.11144C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tmpfs: fix data loss from failed fallocate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tmpfs-fix-data-loss-from-failed-fallocate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-data-loss-from-failed-fallocate.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

tmpfs-fix-data-loss-from-failed-fallocate.patch

