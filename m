Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D03339BED
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhCMFIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232440AbhCMFIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 00:08:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B708564FA7;
        Sat, 13 Mar 2021 05:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612122;
        bh=Jp1b5qEapWDbCGjBEiqEpW0Pxh4Nci8/KiOnVdR/LAo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fZLsxydd0FjlsBjFS1AgOzYfYLu8Cwok6LaYuwVQOscLRS2BsZ6MVrVFbpUDWhJ+Q
         zrK+btgn7ObROCH1MyGhqjnpE6Jfi0eoPsZP5zgB6BFkQExWMs0G+sAk8fhLqixjN1
         gg6T3FAr0t+728Tx9relwCerGvlOKoqfXjE1vjUE=
Date:   Fri, 12 Mar 2021 21:08:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amosbianchi@google.com,
        joaodias@google.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 29/29] zram: fix broken page writeback
Message-ID: <20210313050841.HjY9UHuIF%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
