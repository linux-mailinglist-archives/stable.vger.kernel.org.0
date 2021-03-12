Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364B233962A
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 19:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCLSUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 13:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhCLSTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 13:19:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00DE664F4C;
        Fri, 12 Mar 2021 18:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615573190;
        bh=fVzylv38Vko5rfqBiqn/c6c324Z3K8pyX3LuOhKaheo=;
        h=Date:From:To:Subject:From;
        b=1/QOCUvsHW3pF41QT/6qQmcK02HzypxME1ZaDj8TLw5JSmN0HaIJ054sMk5INCKDA
         myDYs4Ggdy/Uu6CNUmMKSXO6gZvNKBLrsIMCvt/WEwEWu3aGU16Yksl1EvCsqS19+h
         h0ZwM74t4XFzh0Kb3Wb5i/em6YiQSEvwZzT2wCvY=
Date:   Fri, 12 Mar 2021 10:19:49 -0800
From:   akpm@linux-foundation.org
To:     amosbianchi@google.com, joaodias@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject:  + zram-fix-broken-page-writeback.patch added to -mm tree
Message-ID: <20210312181949.6j8LtcfcU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: zram: fix broken page writeback
has been added to the -mm tree.  Its filename is
     zram-fix-broken-page-writeback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-fix-broken-page-writeback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-broken-page-writeback.patch

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
Subject: zram: fix broken page writeback

commit 0d8359620d9b ("zram: support page writeback") introduced two
problems.  It overwrites writeback_store's return value as kstrtol's
return value, which makes return value zero so user could see zero as
return value of write syscall even though it wrote data successfully.

It also breaks index value in the loop in that it doesn't increase the
index any longer.  It means it can write only first starting block index
so user couldn't write all idle pages in the zram so lose memory saving
chance.

This patch fixes those issues.

Link: https://lkml.kernel.org/r/20210312173949.2197662-2-minchan@kernel.org
Fixes: 0d8359620d9b("zram: support page writeback")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Amos Bianchi <amosbianchi@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-broken-page-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -638,8 +638,8 @@ static ssize_t writeback_store(struct de
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
 
-		ret = kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index);
-		if (ret || index >= nr_pages)
+		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index) ||
+				index >= nr_pages)
 			return -EINVAL;
 
 		nr_pages = 1;
@@ -663,7 +663,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	while (nr_pages--) {
+	for (; nr_pages != 0; index++, nr_pages--) {
 		struct bio_vec bvec;
 
 		bvec.bv_page = page;
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-return-value-on-writeback_store.patch
zram-fix-broken-page-writeback.patch
mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-page_alloc-dump-migrate-failed-pages.patch
mm-vmstat-add-cma-statistics.patch
mm-cma-support-sysfs.patch

