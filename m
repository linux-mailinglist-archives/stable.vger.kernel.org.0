Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181056A7236
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 18:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCARi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 12:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCARi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 12:38:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB762367D
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 09:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=JZmPs80V5aFX6mw5aITc0LL2zwcfx8nnrc7nCp16VbA=; b=sFKv11Q5xa9wP7UbTbhY89wNHI
        +VUFeuB0Nd9JtLHQBdUA+Tl18LvKX2s5bGu0QUR79MJ+zzwgmI7N7mpW0ilVN/c4TKQHOVVFI/IBY
        4YIt0+kY28YXL6Ok5P4N2PebViO0qvdAd44o5Sw3yQUyUZWR0Z9BYIxB0djvROypUqYHV8wu2rpxi
        O8t5t85oBHsfSojny0ftiwerrGaMwRvQJSG46KKBaA88yuF/1DZM7pANVjY8xotZB6ggN7bY6GXFP
        YJou7ZEm/SLD5rOcBDbEhAlUxj+rPoAIWNXvvtHzScbCdjyWsZ3JUdGPLZVtVgp0iiCHd+PrYwyPT
        ok+UPvJA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXQPD-001mL3-T3; Wed, 01 Mar 2023 17:38:19 +0000
Date:   Wed, 1 Mar 2023 17:38:19 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>, security@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] freevxfs: Fix kernel memory exposure with inline files
Message-ID: <Y/+Ni+kYeUWQokis@casper.infradead.org>
References: <20230301171007.420708-1-willy@infradead.org>
 <CAHk-=wi5b+-Hys_8V7asP13EY=YSA8MUv=DwP7WK7mKeNvpRFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wi5b+-Hys_8V7asP13EY=YSA8MUv=DwP7WK7mKeNvpRFw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 09:26:27AM -0800, Linus Torvalds wrote:
> On Wed, Mar 1, 2023 at 9:10 AM Matthew Wilcox (Oracle)
> <willy@infradead.org> wrote:
> >
> > +       memcpy_to_file_folio(folio, 0, vip->vii_immed.vi_immed, isize);
> 
> Well, this function doesn't exist upstream yet, much less in any
> stable kernels..

Oops, see other email.

> And while I'm on this subject: the "memcpy_from_file_folio()"
> interface is horrendously broken. For the highmem case, it shouldn't
> be an inline function, and it should loop over pages - instead of
> leaving the callers having to do that.
> 
> Of course, callers don't actually do that (since there are no callers
> - unless I'm again missing it due to some macro games with token
> concatenation), but I really wish it was fixed before any callers
> appear.

The first caller was pagecache_read() in fs/ext4/verity.c.  I
think that's waiting for next merge window.  It does make sense
in that context -- the caller genuinely wants to loop over multiple
folios because its read may cross folio boundaries, so it makes
sense.  It actually reduces how much calculation the caller does:

        while (count) {
-               size_t n = min_t(size_t, count,
-                                PAGE_SIZE - offset_in_page(pos));
-               struct page *page;
+               struct folio *folio;
+               size_t n;

-               page = read_mapping_page(inode->i_mapping, pos >> PAGE_SHIFT,
+               folio = read_mapping_folio(inode->i_mapping, pos >> PAGE_SHIFT,
                                         NULL);
-               if (IS_ERR(page))
-                       return PTR_ERR(page);
-
-               memcpy_from_page(buf, page, offset_in_page(pos), n);
+               if (IS_ERR(folio))
+                       return PTR_ERR(folio);

-               put_page(page);
+               n = memcpy_from_file_folio(buf, folio, pos, count);
+               folio_put(folio);

                buf += n;
                pos += n;

Are there other callers which only handle a single folio and really wish
that memcpy_from_file_folio() handled the loop internally?  Probably.
I don't have a good survey yet.
