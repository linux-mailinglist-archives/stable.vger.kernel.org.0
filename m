Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF514C1572
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 15:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiBWOdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 09:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiBWOdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 09:33:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B72FB23A7;
        Wed, 23 Feb 2022 06:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DSsaUYTnIRiB2PzfiQOl8KPGCRZn4AtjbzhZ9aqhhS4=; b=IQXhNyh1bKgWXPOCghk7P8JhIZ
        Mmd6lvW0zsac2ttbddPyjChwCJi0fwY11aiclzI7Hw4eOXo941yYLwzZ4l0DN2fScjO5sXGiFzUN3
        iU3RobPREFLg/76kC/9ItXvzISIgAyscJP3J4kTWyBY33FNOuXdUI0J0ZWz4nI43BMNnJ0hq1/FMi
        /8l+lnWfO+OiYGNlKu1HF0CnrDgh2FOMzMcamPw8jR4k0I25IYdRd1RVpGBHoCh1YA64BuuwwxOrB
        wQi70Q48ot93pNp5hAkHX5SSswz6mpay0u2xuCbhLiDX5xT252IvieyYolC40c5bVgwikxh0cxx3s
        62tuPSSg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMshj-003pS2-ML; Wed, 23 Feb 2022 14:33:19 +0000
Date:   Wed, 23 Feb 2022 14:33:19 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, patches@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: read() data corruption with CONFIG_READ_ONLY_THP_FOR_FS=y
Message-ID: <YhZFr+kXIJFgiMaf@casper.infradead.org>
References: <df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 02:54:43PM +0100, Vlastimil Babka wrote:
> we have found a bug involving CONFIG_READ_ONLY_THP_FOR_FS=y, introduced in
> 5.12 by cbd59c48ae2b ("mm/filemap: use head pages in
> generic_file_buffered_read")
> and apparently fixed in 5.17-rc1 by 6b24ca4a1a8d ("mm: Use multi-index
> entries in the page cache")
> The latter commit is part of folio rework so likely not stable material, so
> it would be nice to have a small fix for e.g. 5.15 LTS. Preferably from
> someone who understands xarray :)

[...]

> I've hacked some printk on top 5.16 (attached debug.patch)
> which gives this output:
> 
> i=0 page=ffffea0004340000 page_offset=0 uoff=0 bytes=2097152
> i=1 page=ffffea0004340000 page_offset=0 uoff=0 bytes=2097152
> i=2 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
> i=3 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
> i=4 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
> i=5 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
> i=6 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
> i=7 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
> i=8 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
> i=9 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
> i=10 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
> i=11 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
> i=12 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
> i=13 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
> i=14 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
> 
> It seems filemap_get_read_batch() should be returning pages ffffea0004340000
> and ffffea0004470000 consecutively in the pvec, but returns the first one 8
> times, so it's read twice and then the rest is just skipped over as it's
> beyond the requested read size.
> 
> I suspect these lines:
>   xas.xa_index = head->index + thp_nr_pages(head) - 1;
>   xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
> 
> commit 6b24ca4a1a8d changes those to xas_advance() (introduced one patch
> earlier), so some self-contained fix should be possible for prior kernels?
> But I don't understand xarray well enough.

I figured it out!

In v5.15 (indeed, everything before commit 6b24ca4a1a8d), an order-9
page is stored in 512 consecutive slots.  The XArray stores 64 entries
per level.  So what happens is we start looking at index 0 and we walk
down to the bottom of the tree and find the THP at index 0.

                xas.xa_index = head->index + thp_nr_pages(head) - 1;
                xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;

So we've advanced xas.xa_index to 511, but advanced xas.xa_offset to 63.
Then we call xas_next() which calls __xas_next(), which moves us along to
array index 64 while we think we're looking at index 512.

We could make __xas_next() more resistant to this kind of abuse (by
extracting the correct offset in the parent node from xa_index), but
as you say, we're looking for a small fix for LTS.  I suggest this
will probably do the right thing:

+++ b/mm/filemap.c
@@ -2354,8 +2354,7 @@ static void filemap_get_read_batch(struct address_space *mapping,
                        break;
                if (PageReadahead(head))
                        break;
-               xas.xa_index = head->index + thp_nr_pages(head) - 1;
-               xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
+               xas_set(&xas, head->index + thp_nr_pages(head) - 1);
                continue;
 put_page:
                put_page(head);

but I'll start trying the reproducer now.

