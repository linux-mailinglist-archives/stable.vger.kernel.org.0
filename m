Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE9E6D8DEF
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 05:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbjDFDSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 23:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbjDFDSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 23:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96175273D;
        Wed,  5 Apr 2023 20:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 244C962D37;
        Thu,  6 Apr 2023 03:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9A4C433D2;
        Thu,  6 Apr 2023 03:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680751115;
        bh=gAmdsJOvAvFD8Pw7Hham6hOYozB50NHRKYgiFOuCPfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l2e0pGTXGAtAPzTTnr66THH9X6WCwGZ71B0GcYDBdAK4iVE/qpW+Vtje9oULjo760
         C5fztSxMeSDI8CzgyFHNRkyg+a9kC4Vi1DovQ8vNEuX7+ys99emvilPhFqCwpIXBVh
         DgYJ2pRns+U1kFi23a6LQ/OXgp8PZIkOxQWq6caHPxMRZXHyj1fyNDJMWCNDkYy/gn
         QvLv1yhW7zZCo+kogFEvq8IMXBGO83iezovNVY7TPMBKwEqpIoC2KSqzt0G52Ap8an
         hjRuZy5m5WDR5mPWwI3m6GSLA0PtdDWeVORjmyhT1++sCVH3cvM7bQTu07dKxho6dk
         GIgXlbYEmhXTg==
Date:   Wed, 5 Apr 2023 20:18:33 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH] f2fs: get out of a repeat loop when getting a
 locked data page
Message-ID: <ZC46Ccm8xTT4OlE3@google.com>
References: <20230323213919.1876157-1-jaegeuk@kernel.org>
 <8aea02b0-86f9-539a-02e9-27b381e68b66@kernel.org>
 <ZCG2mfviZfY1dqb4@google.com>
 <ZCHCykI/BLcfDzt7@casper.infradead.org>
 <ZC2kSfNUXKK4PfpM@google.com>
 <9dc4ba32-5be5-26d8-5dd2-9bd48d6b0af4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dc4ba32-5be5-26d8-5dd2-9bd48d6b0af4@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/06, Chao Yu wrote:
> On 2023/4/6 0:39, Jaegeuk Kim wrote:
> > On 03/27, Matthew Wilcox wrote:
> > > On Mon, Mar 27, 2023 at 08:30:33AM -0700, Jaegeuk Kim wrote:
> > > > On 03/26, Chao Yu wrote:
> > > > > On 2023/3/24 5:39, Jaegeuk Kim wrote:
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=216050
> > > > > > 
> > > > > > Somehow we're getting a page which has a different mapping.
> > > > > > Let's avoid the infinite loop.
> > > > > > 
> > > > > > Cc: <stable@vger.kernel.org>
> > > > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > > ---
> > > > > >    fs/f2fs/data.c | 8 ++------
> > > > > >    1 file changed, 2 insertions(+), 6 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > > > > > index bf51e6e4eb64..80702c93e885 100644
> > > > > > --- a/fs/f2fs/data.c
> > > > > > +++ b/fs/f2fs/data.c
> > > > > > @@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
> > > > > >    {
> > > > > >    	struct address_space *mapping = inode->i_mapping;
> > > > > >    	struct page *page;
> > > > > > -repeat:
> > > > > > +
> > > > > >    	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
> > > > > >    	if (IS_ERR(page))
> > > > > >    		return page;
> > > > > >    	/* wait for read completion */
> > > > > >    	lock_page(page);
> > > > > > -	if (unlikely(page->mapping != mapping)) {
> > > > > 
> > > > > How about using such logic only for move_data_page() to limit affect for
> > > > > other paths?
> > > > 
> > > > Why move_data_page() only? If this happens, we'll fall into a loop in anywhere?
> > > > 
> > > > > 
> > > > > Jaegeuk, any thoughts about why mapping is mismatch in between page's one and
> > > > > inode->i_mapping?
> > > > 
> > > > > 
> > > > > After several times code review, I didn't get any clue about why f2fs always
> > > > > get the different mapping in a loop.
> > > > 
> > > > I couldn't find the path to happen this. So weird. Please check the history in the
> > > > bug.
> > > > 
> > > > > 
> > > > > Maybe we can loop MM guys to check whether below folio_file_page() may return
> > > > > page which has different mapping?
> > > > 
> > > > Matthew may have some idea on this?
> > > 
> > > There's a lot of comments in the bug ... hard to come into this one
> > > cold.
> > > 
> > > I did notice this one (#119):
> > > : Interestingly, ref count is 514, which looks suspiciously as a binary
> > > : flag 1000000010. Is it possible that during 5.17/5.18 implementation
> > > : of a "pin", somehow binary flag was written to ref count, or something
> > > : like '1 << ...' happens?
> > > 
> > > That indicates to me that somehow you've got hold of a THP that is in
> > > the page cache.  Probably shmem/tmpfs.  That indicate to me a refcount
> > > problem that looks something like this:
> > > 
> > > f2fs allocates a page
> > > f2fs adds the page to the page cache
> > > f2fs puts the reference to the page without removing it from the
> > > page cache (how?)
> > 
> > Is it somewhat related to setting a bit in private field?
> 
> IIUC, it looks the page reference is added/removed as pair.
> 
> > 
> > When we migrate the blocks, we do:
> > 1) get_lock_page()
> 
> - f2fs_grab_cache_page
>  - pagecache_get_page
>   - __filemap_get_folio
>    - no_page  -> filemap_alloc_folio  page_ref = 1 (referenced by caller)
>     - filemap_add_folio page_ref = 2 (referenced by radix tree)
> 
> > 2) submit read
> > 3) lock_page()
> > 3) set_page_dirty()
> > 4) set_page_private_gcing(page)
> 
> page_ref = 3 (reference by private data)
> 
> > 
> > --- in fs/f2fs/f2fs.h
> > 1409 #define PAGE_PRIVATE_SET_FUNC(name, flagname) \
> > 1410 static inline void set_page_private_##name(struct page *page) \
> > 1411 { \
> > 1412         if (!PagePrivate(page)) { \
> > 1413                 get_page(page); \
> > 1414                 SetPagePrivate(page); \
> > 1415                 set_page_private(page, 0); \
> > 1416         } \
> > 1417         set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
> > 1418         set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
> > 1419 }
> > 
> > 
> > 5) set_page_writebac()
> > 6) submit write
> > 7) unlock_page()
> > 8) put_page(page)
> 
> page_ref = 2 (ref by caller was removed)
> 
> > 
> > Later, f2fs_invalidate_folio will do put_page again by:
> > clear_page_private_gcing(&folio->page);
> 
> page_ref = 1 (ref by private was removed, and the last left ref is hold by radix tree)
> 
> > 
> > --- in fs/f2fs/f2fs.h
> > 1421 #define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
> > 1422 static inline void clear_page_private_##name(struct page *page) \
> > 1423 { \
> > 1424         clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
> > 1425         if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) { \
> > 1426                 set_page_private(page, 0); \
> > 1427                 if (PagePrivate(page)) { \
> > 1428                         ClearPagePrivate(page); \
> 
> Since PagePrivate was cleared, so folio_detach_private in
> f2fs_invalidate_folio()/f2fs_release_folio will just skip drop reference.
> 
> static inline void *folio_detach_private(struct folio *folio)
> {
> 	void *data = folio_get_private(folio);
> 
> 	if (!folio_test_private(folio))
> 		return NULL;
> 	folio_clear_private(folio);
> 	folio->private = NULL;
> 	folio_put(folio);
> 
> 	return data;
> }
> 
> Or am I missing something?

Ah, I missed folio_test_private() tho, can we really expect get_page(),
SetPagePrivate(), and set_page_private() is in pair with folio_detach_private()?
I feel attach/detach_page_private would look better?

> 
> Thanks,
> 
> > 1429                         put_page(page); \
> > 1430                 }\
> > 1431         } \
> > 1432 }
> > 
> > > page is now free, gets reallocated into a THP
> > > lookup from the f2fs file finds the new THP
> > > things explode messily
> > > 
> > > Checking page->mapping is going to avoid the messy explosion, but
> > > you'll still have a page in the page cache which doesn't actually
> > > belong to you, and that's going to lead to subtle data corruption.
> > > 
> > > This should be caught by page_expected_state(), called from
> > > free_page_is_bad(), called from free_pages_prepare().  Do your testers
> > > have CONFIG_DEBUG_VM enabled?  That might give you a fighting chance at
> > > finding the last place which called put_page().  It won't necessarily be
> > > the _wrong_ place to call put_page() (that may have happened earlier),
> > > but it may give you a clue.
> > > 
> > > > > 
> > > > > struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
> > > > > 		int fgp_flags, gfp_t gfp)
> > > > > {
> > > > > 	struct folio *folio;
> > > > > 
> > > > > 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
> > > > > 	if (IS_ERR(folio))
> > > > > 		return NULL;
> > > > > 	return folio_file_page(folio, index);
> > > > > }
> > > > > 
> > > > > Thanks,
> > > > > 
> > > > > > -		f2fs_put_page(page, 1);
> > > > > > -		goto repeat;
> > > > > > -	}
> > > > > > -	if (unlikely(!PageUptodate(page))) {
> > > > > > +	if (unlikely(page->mapping != mapping || !PageUptodate(page))) {
> > > > > >    		f2fs_put_page(page, 1);
> > > > > >    		return ERR_PTR(-EIO);
> > > > > >    	}
