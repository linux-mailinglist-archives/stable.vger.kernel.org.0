Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1566C4C1A0A
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiBWRot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243436AbiBWRos (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:44:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C369741331;
        Wed, 23 Feb 2022 09:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 608D6612B5;
        Wed, 23 Feb 2022 17:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B843C340EF;
        Wed, 23 Feb 2022 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645638258;
        bh=ieSfUD0+w+fPqm2Dn3xrJaap6YZ7Coy/YY/N9ES6v70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAQR+4JUavxhFq+hS9+sZQ+fTnx8cWxy+hJe3MeOmKcAh1s0T0hBHHTxloDSCvmL8
         MaegYED3lXb+3C0pzTUwT4XHQOrbqWAZCGXxf1kipuxtGej65WVPC3LQpMmH3tE2Db
         m2VDBXTn6Z1ATw5C0zDk5YPyPYNT5rPxre2wC/4g=
Date:   Wed, 23 Feb 2022 18:44:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com,
        Song Liu <songliubraving@fb.com>, Adam Majer <amajer@suse.com>,
        Dirk Mueller <dmueller@suse.com>, Takashi Iwai <tiwai@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/filemap: Fix handling of THPs in
 generic_file_buffered_read()
Message-ID: <YhZycDfxDo2K9Db+@kroah.com>
References: <20220223155918.927140-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223155918.927140-1-willy@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 03:59:18PM +0000, Matthew Wilcox (Oracle) wrote:
> When a THP is present in the page cache, we can return it several times,
> leading to userspace seeing the same data repeatedly if doing a read()
> that crosses a 64-page boundary.  This is probably not a security issue
> (since the data all comes from the same file), but it can be interpreted
> as a transient data corruption issue.  Fortunately, it is very rare as
> it can only occur when CONFIG_READ_ONLY_THP_FOR_FS is enabled, and it can
> only happen to executables.  We don't often call read() on executables.
> 
> This bug is fixed differently in v5.17 by commit 6b24ca4a1a8d
> ("mm: Use multi-index entries in the page cache").  That commit is
> unsuitable for backporting, so fix this in the clearest way.  It
> sacrifices a little performance for clarity, but this should never
> be a performance path in these kernel versions.
> 
> Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
> Cc: stable@vger.kernel.org # v5.15, v5.16
> Link: https://lore.kernel.org/r/df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz/
> Analyzed-by: Adam Majer <amajer@suse.com>
> Analyzed-by: Dirk Mueller <dmueller@suse.com>
> Bisected-by: Takashi Iwai <tiwai@suse.de>
> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/filemap.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 82a17c35eb96..1293c3409e42 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2354,8 +2354,12 @@ static void filemap_get_read_batch(struct address_space *mapping,
>  			break;
>  		if (PageReadahead(head))
>  			break;
> -		xas.xa_index = head->index + thp_nr_pages(head) - 1;
> -		xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
> +		if (PageHead(head)) {
> +			xas_set(&xas, head->index + thp_nr_pages(head));
> +			/* Handle wrap correctly */
> +			if (xas.xa_index - 1 >= max)
> +				break;
> +		}
>  		continue;
>  put_page:
>  		put_page(head);
> -- 
> 2.34.1
> 

Now queued up, thanks!

greg k-h
