Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278FC65D5D6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjADOhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbjADOgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:36:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0760DF2;
        Wed,  4 Jan 2023 06:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QHnWJx9+mbeV4moLLlTd7s3x2Qm+/U2GwtkrSTjYFc8=; b=pKnH/xHwYTX6XoSUdXv9a6E/Ij
        EBvp1gIUuvItVhLsQKvmww8drzlnWjXinjwcvmvaMV2NueVgvzP1CgxyF3N6iMFS2y1GomMiIdhaG
        +1fjY8S5RFv0FBH6Wcry0ftUUwi+tOxK9QUgLiQkW+yxvoWkMxTf9+75ohLUsvzzxx3TaUjifoJAG
        swsIHn4wjvMEADFQyNTqhN3rXqhvSp4YShrmjfvPmL0GBfjKi+xfNlhBXKoJfJSf1NpdWo0qszY5W
        kEuDHIWq/aFccixteNgJczXMNdpRxZVuux4BU8KoqAYQ9t4hbynJxdVwswrTPcohmoyWXiD0Vxy0L
        XXHKOpAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pD4sT-00F7WX-PC; Wed, 04 Jan 2023 14:36:25 +0000
Date:   Wed, 4 Jan 2023 14:36:25 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     coolqyj@163.com
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, qian@ddn.com
Subject: Re: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
Message-ID: <Y7WO6YJvBQ1t1AuR@casper.infradead.org>
References: <20230104032124.72483-1-coolqyj@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104032124.72483-1-coolqyj@163.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 11:21:24AM +0800, coolqyj@163.com wrote:
> From: Qian Yingjin <qian@ddn.com>
> 
> I was running traces of the read code against an RAID storage
> system to understand why read requests were being misaligned
> against the underlying RAID strips. I found that the page end
> offset calculation in filemap_get_read_batch() was off by one.
> 
> When a read is submitted with end offset 1048575, then it
> calculates the end page for read of 256 when it should be 255.
> "last_index" is the index of the page beyond the end of the read
> and it should be skipped when get a batch of pages for read in
> @filemap_get_read_batch().
> 
> The below simple patch fixes the problem. This code was introduced
> in kernel 5.12.

Thanks for diagnosing & sending a patch.  However, I'd really prefer
to work in terms of 'max' instead of 'last_index' in that function.
Would this work for you?

+++ b/mm/filemap.c
@@ -2595,13 +2595,13 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
        if (fatal_signal_pending(current))
                return -EINTR;

-       filemap_get_read_batch(mapping, index, last_index, fbatch);
+       filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
        if (!folio_batch_count(fbatch)) {
                if (iocb->ki_flags & IOCB_NOIO)
                        return -EAGAIN;
                page_cache_sync_readahead(mapping, ra, filp, index,
                                last_index - index);
-               filemap_get_read_batch(mapping, index, last_index, fbatch);
+               filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
        }
        if (!folio_batch_count(fbatch)) {
                if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))

