Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680BF69A3C7
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 03:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBQCMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 21:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjBQCM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 21:12:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F603D935;
        Thu, 16 Feb 2023 18:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6FFBB829D3;
        Fri, 17 Feb 2023 02:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430D6C433D2;
        Fri, 17 Feb 2023 02:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676599946;
        bh=1P9crmbGj0TdJO2X/bkwAqkQTm8MounZ6I9m9iGx8jQ=;
        h=Date:To:From:Subject:From;
        b=qwvtsjEGtRAU+dYafQXUQjHtjzQDherZVslyvGJBCxLplovEcgu0DEa8hIfpnrQcX
         pLOvF3+ZbPsfpowN7FwPQxSLmpDPazTQfOf1WBG9oi0BZYZhFRFSl/3nDjqaoilS4y
         TUh3EhjCFacYD1oUY4C3NFleDqn6HgEE6YuiMur4=
Date:   Thu, 16 Feb 2023 18:12:25 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, qian@ddn.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-fix-page-end-in-filemap_get_read_batch.patch removed from -mm tree
Message-Id: <20230217021226.430D6C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/filemap: fix page end in filemap_get_read_batch
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-page-end-in-filemap_get_read_batch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qian Yingjin <qian@ddn.com>
Subject: mm/filemap: fix page end in filemap_get_read_batch
Date: Wed, 8 Feb 2023 10:24:00 +0800

I was running traces of the read code against an RAID storage system to
understand why read requests were being misaligned against the underlying
RAID strips.  I found that the page end offset calculation in
filemap_get_read_batch() was off by one.

When a read is submitted with end offset 1048575, then it calculates the
end page for read of 256 when it should be 255.  "last_index" is the index
of the page beyond the end of the read and it should be skipped when get a
batch of pages for read in @filemap_get_read_batch().

The below simple patch fixes the problem.  This code was introduced in
kernel 5.12.

Link: https://lkml.kernel.org/r/20230208022400.28962-1-coolqyj@163.com
Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
Signed-off-by: Qian Yingjin <qian@ddn.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/filemap.c~mm-filemap-fix-page-end-in-filemap_get_read_batch
+++ a/mm/filemap.c
@@ -2588,18 +2588,19 @@ static int filemap_get_pages(struct kioc
 	struct folio *folio;
 	int err = 0;
 
+	/* "last_index" is the index of the page beyond the end of the read */
 	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
 retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	filemap_get_read_batch(mapping, index, last_index, fbatch);
+	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	if (!folio_batch_count(fbatch)) {
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		page_cache_sync_readahead(mapping, ra, filp, index,
 				last_index - index);
-		filemap_get_read_batch(mapping, index, last_index, fbatch);
+		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	}
 	if (!folio_batch_count(fbatch)) {
 		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
_

Patches currently in -mm which might be from qian@ddn.com are


