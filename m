Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0CF339627
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 19:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhCLSUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 13:20:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhCLSTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 13:19:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06F1364F50;
        Fri, 12 Mar 2021 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615573187;
        bh=Mu2QXZw/IUt0vZST8Y6WsQtqP6lFH4zwRSftj/m4ZGg=;
        h=Date:From:To:Subject:From;
        b=Y1OWyEPqDG3qsyVsxCU+RfO+5SBTWYpENly0zgn3pSUu1iMBgpgrt0shLrX6Ohpwf
         Fm3rsPu+v63VeHaNSoy+meOf/kRPgtf67imSEXZS509hNXyTh7irKrhFVY1wrQUcz7
         OmHzDyB3tun/EnfDO3CNVGgYhsR8XzlPK5d1npC8=
Date:   Fri, 12 Mar 2021 10:19:46 -0800
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject:  + zram-fix-return-value-on-writeback_store.patch added to
 -mm tree
Message-ID: <20210312181946.Q9ab9GicR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: zram: fix return value on writeback_store
has been added to the -mm tree.  Its filename is
     zram-fix-return-value-on-writeback_store.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-fix-return-value-on-writeback_store.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-return-value-on-writeback_store.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: fix return value on writeback_store

writeback_store's return value is overwritten by submit_bio_wait's return
value.  Thus, writeback_store will return zero since there was no IO
error.  In the end, write syscall from userspace will see the zero as
return value, which could make the process stall to keep trying the write
until it will succeed.

Link: https://lkml.kernel.org/r/20210312173949.2197662-1-minchan@kernel.org
Fixes: 3b82a051c101("drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-return-value-on-writeback_store
+++ a/drivers/block/zram/zram_drv.c
@@ -627,7 +627,7 @@ static ssize_t writeback_store(struct de
 	struct bio_vec bio_vec;
 	struct page *page;
 	ssize_t ret = len;
-	int mode;
+	int mode, err;
 	unsigned long blk_idx = 0;
 
 	if (sysfs_streq(buf, "idle"))
@@ -728,12 +728,17 @@ static ssize_t writeback_store(struct de
 		 * XXX: A single page IO would be inefficient for write
 		 * but it would be not bad as starter.
 		 */
-		ret = submit_bio_wait(&bio);
-		if (ret) {
+		err = submit_bio_wait(&bio);
+		if (err) {
 			zram_slot_lock(zram, index);
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
+			/*
+			 * Return last IO error unless every IO were
+			 * not suceeded.
+			 */
+			ret = err;
 			continue;
 		}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-return-value-on-writeback_store.patch
zram-fix-broken-page-writeback.patch
mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-page_alloc-dump-migrate-failed-pages.patch
mm-vmstat-add-cma-statistics.patch
mm-cma-support-sysfs.patch

