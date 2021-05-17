Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4CA382ABE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhEQLTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbhEQLTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 07:19:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BACCC061573;
        Mon, 17 May 2021 04:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jazNxV8D/7woDhWY9AkuzXWH5FjzFOrSgXVg3JXgTV8=; b=LlIkC4k+DL/6oGATReVm9MaK7X
        9KxaYfSaHi6rAsbF8Tk2uGAlVwWRyS+bOvAYKjkIUl9zK2/Lf+w1MWjCdNe34uQthJKbZGmfVSqR1
        rtClLQjdUCPlbERjYMEJq3sUah2HT+3ETF9eK6cn6zuPFRvIfpjGASwhtmN/hsHJwCiR4HR1KhXYn
        vXqsC6uBn9gDLeGPXpagCE26yOPzSlrapc1AwVy5avg3yOUaS5JvzkV6MQ/SOXy6P4Qfh2XZJihUU
        0TMhSLH64gTvBgWDu0GMJ/mZT2NE7QFMHET7MyK1QXJ9LzkDUq9G3gS4C0ZWIg9dpmilGu19X64nm
        O6HuvzRw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1libFc-00CqY5-CF; Mon, 17 May 2021 11:17:52 +0000
Date:   Mon, 17 May 2021 12:17:32 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Jan Stancek <jstancek@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5.4] iomap: fix sub-page uptodate handling
Message-ID: <YKJQzJESWb+FZE+N@casper.infradead.org>
References: <20210516150328.2881778-1-willy@infradead.org>
 <YKIeYkw1YjkT4hth@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKIeYkw1YjkT4hth@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 09:42:26AM +0200, Greg KH wrote:
> On Sun, May 16, 2021 at 04:03:28PM +0100, Matthew Wilcox (Oracle) wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > commit 1cea335d1db1ce6ab71b3d2f94a807112b738a0f upstream
> > 
> > bio completions can race when a page spans more than one file system
> > block.  Add a spinlock to synchronize marking the page uptodate.
> > 
> > Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
> > Reported-by: Jan Stancek <jstancek@redhat.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/iomap/buffered-io.c | 34 ++++++++++++++++++++++++----------
> >  include/linux/iomap.h  |  1 +
> >  2 files changed, 25 insertions(+), 10 deletions(-)
> 
> No s-o-b from you as you did the backport?  :(

My mistake.  I don't do stable backports of other people's patches very
often.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> Anyway, what about a 4.19.y version?

I'll look into it and see what I can do.
