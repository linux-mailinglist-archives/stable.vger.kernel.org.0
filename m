Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EB66CAA79
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 18:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjC0QWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 12:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjC0QWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 12:22:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D311B1703;
        Mon, 27 Mar 2023 09:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5gk+dREm5bLSsqD3YSf3yyJg/yMmvA9kxHAGuA6QyKw=; b=tbNGl/HFxlKsfgEwkgvNpIQn1V
        EdFym+Rjoi4yvX/tWDfz8RvIXF9lhk1mHVi+3eFpp7xfuz2NYmQBhx2Z5xIkl/XI4rtizrcOh5466
        iN0epzVbsqEQaqiskLE4Ug2xJgG+h43clnv8CDF/ky7GbSnm6EtS2+P5oAuGwZFjZFKuJMLNC7fwP
        v7/LVa4xzJSmuP5A8LfURjrU5rU9F7nHAzjJrB6xCpFrq+NTNqckBPoVcfSaLSq5eKvTm8wnM88AP
        LlTAZN9+V2xZRHD03aJoBvsD/bHdkQMoqOyfrCX5G1CGvM8FSDu4aE6t2Lt1+DA7wghy4HTX71opC
        LjtvfiNw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pgpcA-007Y5s-B2; Mon, 27 Mar 2023 16:22:34 +0000
Date:   Mon, 27 Mar 2023 17:22:34 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Chao Yu <chao@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH] f2fs: get out of a repeat loop when getting a
 locked data page
Message-ID: <ZCHCykI/BLcfDzt7@casper.infradead.org>
References: <20230323213919.1876157-1-jaegeuk@kernel.org>
 <8aea02b0-86f9-539a-02e9-27b381e68b66@kernel.org>
 <ZCG2mfviZfY1dqb4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCG2mfviZfY1dqb4@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 27, 2023 at 08:30:33AM -0700, Jaegeuk Kim wrote:
> On 03/26, Chao Yu wrote:
> > On 2023/3/24 5:39, Jaegeuk Kim wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=216050
> > > 
> > > Somehow we're getting a page which has a different mapping.
> > > Let's avoid the infinite loop.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >   fs/f2fs/data.c | 8 ++------
> > >   1 file changed, 2 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > > index bf51e6e4eb64..80702c93e885 100644
> > > --- a/fs/f2fs/data.c
> > > +++ b/fs/f2fs/data.c
> > > @@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
> > >   {
> > >   	struct address_space *mapping = inode->i_mapping;
> > >   	struct page *page;
> > > -repeat:
> > > +
> > >   	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
> > >   	if (IS_ERR(page))
> > >   		return page;
> > >   	/* wait for read completion */
> > >   	lock_page(page);
> > > -	if (unlikely(page->mapping != mapping)) {
> > 
> > How about using such logic only for move_data_page() to limit affect for
> > other paths?
> 
> Why move_data_page() only? If this happens, we'll fall into a loop in anywhere?
> 
> > 
> > Jaegeuk, any thoughts about why mapping is mismatch in between page's one and
> > inode->i_mapping?
> 
> > 
> > After several times code review, I didn't get any clue about why f2fs always
> > get the different mapping in a loop.
> 
> I couldn't find the path to happen this. So weird. Please check the history in the
> bug.
> 
> > 
> > Maybe we can loop MM guys to check whether below folio_file_page() may return
> > page which has different mapping?
> 
> Matthew may have some idea on this?

There's a lot of comments in the bug ... hard to come into this one
cold.

I did notice this one (#119):
: Interestingly, ref count is 514, which looks suspiciously as a binary
: flag 1000000010. Is it possible that during 5.17/5.18 implementation
: of a "pin", somehow binary flag was written to ref count, or something
: like '1 << ...' happens?

That indicates to me that somehow you've got hold of a THP that is in
the page cache.  Probably shmem/tmpfs.  That indicate to me a refcount
problem that looks something like this:

f2fs allocates a page
f2fs adds the page to the page cache
f2fs puts the reference to the page without removing it from the
page cache (how?)
page is now free, gets reallocated into a THP
lookup from the f2fs file finds the new THP
things explode messily

Checking page->mapping is going to avoid the messy explosion, but
you'll still have a page in the page cache which doesn't actually
belong to you, and that's going to lead to subtle data corruption.

This should be caught by page_expected_state(), called from
free_page_is_bad(), called from free_pages_prepare().  Do your testers
have CONFIG_DEBUG_VM enabled?  That might give you a fighting chance at
finding the last place which called put_page().  It won't necessarily be
the _wrong_ place to call put_page() (that may have happened earlier),
but it may give you a clue.

> > 
> > struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
> > 		int fgp_flags, gfp_t gfp)
> > {
> > 	struct folio *folio;
> > 
> > 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
> > 	if (IS_ERR(folio))
> > 		return NULL;
> > 	return folio_file_page(folio, index);
> > }
> > 
> > Thanks,
> > 
> > > -		f2fs_put_page(page, 1);
> > > -		goto repeat;
> > > -	}
> > > -	if (unlikely(!PageUptodate(page))) {
> > > +	if (unlikely(page->mapping != mapping || !PageUptodate(page))) {
> > >   		f2fs_put_page(page, 1);
> > >   		return ERR_PTR(-EIO);
> > >   	}
