Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6724169B8A0
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 09:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBRICu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 03:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBRICt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 03:02:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E115A4DE3E
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 00:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 956AEB82E8A
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 08:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53CCC4339B;
        Sat, 18 Feb 2023 08:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676707365;
        bh=J03DmW9CUJ7CobuSew49uvg1+Sv6derYpCSExpSoJbo=;
        h=Subject:To:Cc:From:Date:From;
        b=w111Rhp0EwI7O7Nim0Hri46e+RLRpvHINhoTsI6PJOx6hCgeeQf4yy6L5zoFcvosU
         3X10JcI07eOpL/uyIAI6LML0Af9ZHAhDpisbjRWMFwUIAR4WK/2izSsgnVDh+sGEKz
         6lLV0vQxrNDFiyQpqcQg3TwrvSnkGUBPAzvBEwdQ=
Subject: FAILED: patch "[PATCH] mm/filemap: fix page end in filemap_get_read_batch" failed to apply to 5.15-stable tree
To:     qian@ddn.com, akpm@linux-foundation.org, stable@vger.kernel.org,
        willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 09:02:42 +0100
Message-ID: <167670736248208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5956592ce337 ("mm/filemap: fix page end in filemap_get_read_batch")
25d6a23e8d28 ("filemap: Convert filemap_get_read_batch() to use a folio_batch")
d996fc7f615f ("filemap: Convert filemap_read() to use a folio")
65bca53b5f63 ("filemap: Convert filemap_get_pages to use folios")
a5d4ad098528 ("filemap: Convert filemap_create_page to folio")
9d427b4eb456 ("filemap: Convert filemap_read_page to take a folio")
bdb729329769 ("filemap: Convert filemap_get_read_batch to use folios")
512b7931ad05 ("Merge branch 'akpm' (patches from Andrew)")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5956592ce337330cdff0399a6f8b6a5aea397a8e Mon Sep 17 00:00:00 2001
From: Qian Yingjin <qian@ddn.com>
Date: Wed, 8 Feb 2023 10:24:00 +0800
Subject: [PATCH] mm/filemap: fix page end in filemap_get_read_batch

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

diff --git a/mm/filemap.c b/mm/filemap.c
index c4d4ace9cc70..0e20a8d6dd93 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2588,18 +2588,19 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
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

