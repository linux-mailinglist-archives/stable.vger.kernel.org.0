Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B3A6CA901
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbjC0Pai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjC0Pag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC433A80;
        Mon, 27 Mar 2023 08:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B19AD6132A;
        Mon, 27 Mar 2023 15:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6F5C433D2;
        Mon, 27 Mar 2023 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679931035;
        bh=JHargJmoV2rpLqiVYrLlfoessqmQMDUkG266orZF8xo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3j9dFtzDxvAAtciOQtbBmZjKSjWKnOTy+3e4aHO6Fmezj0zAi2fcTv9TLgM8lNy2
         qkt6NeYsF/zz5nxm1yLa+7aHfSMN9xg9tfOYl2bRP6/mtQU/oBTze8t8pDsxylTU2o
         ibYGcJaZ5s4TCXDHu2fyK3jo/5YQZ3hMsDDplKqI1TVq4v2R2KYeNdjIP0wcekub5D
         mG7XeAFqxJQXa3GWSC2PHfAlwHMhyoIBWGrhKtyZcA4JQ1eqvRzfPsbG3Eph2N0960
         Iwo+afIagZqqjn7OBpArjS2WzGKaYdY901NYtIAWSFJUNRpbvY0cqgdq/b3Go0Lefa
         wmYIq5aY82yvg==
Date:   Mon, 27 Mar 2023 08:30:33 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        willy@infradead.org
Subject: Re: [f2fs-dev] [PATCH] f2fs: get out of a repeat loop when getting a
 locked data page
Message-ID: <ZCG2mfviZfY1dqb4@google.com>
References: <20230323213919.1876157-1-jaegeuk@kernel.org>
 <8aea02b0-86f9-539a-02e9-27b381e68b66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aea02b0-86f9-539a-02e9-27b381e68b66@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/26, Chao Yu wrote:
> On 2023/3/24 5:39, Jaegeuk Kim wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=216050
> > 
> > Somehow we're getting a page which has a different mapping.
> > Let's avoid the infinite loop.
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >   fs/f2fs/data.c | 8 ++------
> >   1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index bf51e6e4eb64..80702c93e885 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
> >   {
> >   	struct address_space *mapping = inode->i_mapping;
> >   	struct page *page;
> > -repeat:
> > +
> >   	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
> >   	if (IS_ERR(page))
> >   		return page;
> >   	/* wait for read completion */
> >   	lock_page(page);
> > -	if (unlikely(page->mapping != mapping)) {
> 
> How about using such logic only for move_data_page() to limit affect for
> other paths?

Why move_data_page() only? If this happens, we'll fall into a loop in anywhere?

> 
> Jaegeuk, any thoughts about why mapping is mismatch in between page's one and
> inode->i_mapping?

> 
> After several times code review, I didn't get any clue about why f2fs always
> get the different mapping in a loop.

I couldn't find the path to happen this. So weird. Please check the history in the
bug.

> 
> Maybe we can loop MM guys to check whether below folio_file_page() may return
> page which has different mapping?

Matthew may have some idea on this?

> 
> struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
> 		int fgp_flags, gfp_t gfp)
> {
> 	struct folio *folio;
> 
> 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
> 	if (IS_ERR(folio))
> 		return NULL;
> 	return folio_file_page(folio, index);
> }
> 
> Thanks,
> 
> > -		f2fs_put_page(page, 1);
> > -		goto repeat;
> > -	}
> > -	if (unlikely(!PageUptodate(page))) {
> > +	if (unlikely(page->mapping != mapping || !PageUptodate(page))) {
> >   		f2fs_put_page(page, 1);
> >   		return ERR_PTR(-EIO);
> >   	}
