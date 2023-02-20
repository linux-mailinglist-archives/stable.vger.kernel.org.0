Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7D69CEA9
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjBTOBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjBTOBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6781E9F6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CE4460EAB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B14CC433D2;
        Mon, 20 Feb 2023 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901655;
        bh=70nt5YXnsnuF/TiI57JzukWJyKEX4DkcMGU4gnlvgsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2oBlI1w9tZv4AJHLpxh+CI0vCIq/msKqzqespVeAoMCaKzE9hIGEr13G43cCgLkjS
         4fjJw90YVPU69hErU1fH92kLsnaGjTaeP55/1LCGILb+HCiDgLzHW37UL+egnv8QqV
         gnZn9aM7DQK/WMojMDV+QoYuR9PjVcgO9IxM+KRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qian Yingjin <qian@ddn.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 070/118] mm/filemap: fix page end in filemap_get_read_batch
Date:   Mon, 20 Feb 2023 14:36:26 +0100
Message-Id: <20230220133603.227781589@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Yingjin <qian@ddn.com>

commit 5956592ce337330cdff0399a6f8b6a5aea397a8e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2569,18 +2569,19 @@ static int filemap_get_pages(struct kioc
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


