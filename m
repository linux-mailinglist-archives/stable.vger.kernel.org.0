Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E606E3A57E2
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhFMLG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhFMLGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:06:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647A4C061574;
        Sun, 13 Jun 2021 04:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KZ8cYln2EzEojSDa9+wdyMQQ0U1nvdCYdyEkFh22xj4=; b=pb0D0y77w1LmBzMXil6uk6EapM
        LAWre6HsHgyJWSLQh7ix03SyisfWCYBgioF0rn9zjZQQvewSkB2jMHi17ugakqOoFmfVK9HLsPt/X
        Pt8B7CA70y2h+BnecEMibC8mLdCrI+e6PGZDgvvtlo8rl8Tw9sngtH3mcHb9UF1jqq8HYtXasC6lT
        SKxo+tN6IWL4voPKsRI7K2G2dq6PCKL7/AJnugdt6glH/b3sj3m4239hYpAWn68hiKsu9hRXEbnOk
        FLKoULAfgituFixJmFdmZn7av7qnMNr9HILAGql64bR9m4aE5Tz4iGVPuR6z+dDejNG3yWQyAZ7rp
        PaZIGViA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsNuw-004Tha-W8; Sun, 13 Jun 2021 11:04:42 +0000
Date:   Sun, 13 Jun 2021 12:04:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        pfmeec@rit.edu, dhowells@redhat.com, idryomov@gmail.com,
        stable@vger.kernel.org, Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH v3] ceph: fix write_begin optimization when write is
 beyond EOF
Message-ID: <YMXmRo17oy8fDn2b@casper.infradead.org>
References: <YMS4TOw8txQQ7VGr@casper.infradead.org>
 <20210612183531.17074-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612183531.17074-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 12, 2021 at 02:35:31PM -0400, Jeff Layton wrote:
>  
> +/**
> + * prep_noread_page - prep a page for writing without reading first
> + * @page: page being prepared
> + * @pos: starting position for the write
> + * @len: length of write
> + *
> + * In some cases we don't need to read at all:
> + * - full page write
> + * - file is currently zero-length
> + * - write that lies in a page that is completely beyond EOF
> + * - write that covers the the page from start to EOF or beyond it
> + *
> + * If any of these criteria are met, then zero out the unwritten parts
> + * of the page and return true. Otherwise, return false.
> + */
> +static bool prep_noread_page(struct page *page, loff_t pos, unsigned int len)
> +{
> +	struct inode *inode = page->mapping->host;
> +	loff_t i_size = i_size_read(inode);
> +	pgoff_t index = pos / PAGE_SIZE;
> +	int pos_in_page = pos & ~PAGE_MASK;

Like the helper.  A couple of minor tweaks ...

	size_t offset = offset_in_page(pos);

> +	/* full page write */
> +	if (pos_in_page == 0 && len == PAGE_SIZE)
> +		goto zero_out;

At some point, we're going to need to pass the full len to
->write_begin, so that we can decide whether it's worth allocating
more than a single page.  Could you make 'len' here size_t, and
check for len >= PAGE_SIZE?

(with the current code, the offset of 0 is a redundant check, but
I'd rather see this future-proofed).

