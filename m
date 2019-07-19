Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BE56D969
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfGSDnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGSDnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:43:22 -0400
Received: from localhost (p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp [153.156.43.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C959F2184E;
        Fri, 19 Jul 2019 03:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563507801;
        bh=HrhZEcSQN51KrMKglwqRrsI7E3xr0hfIM76XucbZx14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ONSgg6eG0qjUubfHx/upW/n7ZzF0rISIrx3M1JZezpE4qOCH/Lf0l4vUANH5zTV3j
         H6KAhSFBU/qvFzAJbfVnIEgME7//1ByAI1I8+SiwNAKmx+FmrLmO8pPulV3xNHJvUy
         Cezf9XIDjEsLNGSrrF/1dS85E8+n7shWLJfyruHU=
Date:   Fri, 19 Jul 2019 12:43:18 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Liu Bo <bo.liu@linux.alibaba.com>, stable <stable@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        Peng Tao <tao.peng@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] mm: fix livelock caused by iterating multi order entry
Message-ID: <20190719034318.GA7886@kroah.com>
References: <1563495160-25647-1-git-send-email-bo.liu@linux.alibaba.com>
 <CAPcyv4jR3vscppooTFBEU=Kp4CNVfthNNz1pV6jxwyg2bmdBjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jR3vscppooTFBEU=Kp4CNVfthNNz1pV6jxwyg2bmdBjg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 07:53:42PM -0700, Dan Williams wrote:
> [ add Sasha for -stable advice ]
> 
> On Thu, Jul 18, 2019 at 5:13 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
> >
> > The livelock can be triggerred in the following pattern,
> >
> >         while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
> >                                 min(end - index, (pgoff_t)PAGEVEC_SIZE),
> >                                 indices)) {
> >                 ...
> >                 for (i = 0; i < pagevec_count(&pvec); i++) {
> >                         index = indices[i];
> >                         ...
> >                 }
> >                 index++; /* BUG */
> >         }
> >
> > multi order exceptional entry is not specially considered in
> > invalidate_inode_pages2_range() and it ended up with a livelock because
> > both index 0 and index 1 finds the same pmd, but this pmd is binded to
> > index 0, so index is set to 0 again.
> >
> > This introduces a helper to take the pmd entry's length into account when
> > deciding the next index.
> >
> > Note that there're other users of the above pattern which doesn't need to
> > fix,
> >
> > - dax_layout_busy_page
> > It's been fixed in commit d7782145e1ad
> > ("filesystem-dax: Fix dax_layout_busy_page() livelock")
> >
> > - truncate_inode_pages_range
> > This won't loop forever since the exceptional entries are immediately
> > removed from radix tree after the search.
> >
> > Fixes: 642261a ("dax: add struct iomap based DAX PMD support")
> > Cc: <stable@vger.kernel.org> since 4.9 to 4.19
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >
> > The problem is gone after commit f280bf092d48 ("page cache: Convert
> > find_get_entries to XArray"), but since xarray seems too new to backport
> > to 4.19, I made this fix based on radix tree implementation.
> 
> I think in this situation, since mainline does not need this change
> and the bug has been buried under a major refactoring, is to send a
> backport directly against the v4.19 kernel. Include notes about how it
> replaces the fix that was inadvertently contained in f280bf092d48
> ("page cache: Convert find_get_entries to XArray"). Do you have a test
> case that you can include in the changelog?

Yes, I need a _TON_ of documentation, and signed off by from all of the
developers involved in this part of the kernel, before I can take this
not-in-mainline patch.

thanks,

greg k-h
