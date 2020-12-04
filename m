Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C252CF0B0
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgLDP03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDP02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 10:26:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A1AC0613D1
        for <stable@vger.kernel.org>; Fri,  4 Dec 2020 07:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pHXKG6Haj3UJYJ0/Ctjg52HvNhgZPX5snB6HaKckAMw=; b=hPy86toiiQGS2Z1v7egHTV//zO
        N30rsVcZ2fSvK/3BRUCqDf4XYJlBb9PpoEXS6jXqU0adjw1IcgTYdX1IjbfcHItfsmXosbMpK1wf6
        o0N98TWl9C4c0ep+XzdGz16sm0Y741/479IMkluzixx+AnzI1rx5WnXgqvo31kR9InV6bctjJ3N+e
        MQa/7VcBwVmVSy/sojbK3TGooT+xfmUZPg3qNBAckZpdx6s+UboFGZmunu/l/CgdUad/1I0CDG60k
        qGsBCSs3+yYyoIQlEXpSWEGIT3xnFohUSySC/HkaClk4SiNN17aEXiP7+sXPLMFn4UuK6fiaSatHv
        UYesnYrA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klCxj-0004a8-KI; Fri, 04 Dec 2020 15:25:35 +0000
Date:   Fri, 4 Dec 2020 15:25:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     David Hildenbrand <david@redhat.com>,
        Liu Zixian <liuzixian4@huawei.com>, akpm@linux-foundation.org,
        linmiaohe@huawei.com, louhongxiang@huawei.com, linux-mm@kvack.org,
        hushiyuan@huawei.com, stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2] fix mmap return value when vma is merged after
 call_mmap()
Message-ID: <20201204152535.GP11935@casper.infradead.org>
References: <20201203085350.22624-1-liuzixian4@huawei.com>
 <d59e9e5a-1d6e-e7dc-21ec-17777fe9f7a2@redhat.com>
 <20201204151028.GZ5487@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204151028.GZ5487@ziepe.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 11:10:28AM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 04, 2020 at 03:11:54PM +0100, David Hildenbrand wrote:
> > On 03.12.20 09:53, Liu Zixian wrote:
> > > On success, mmap should return the begin address of newly mapped area,
> > > but patch "mm: mmap: merge vma after call_mmap() if possible"
> > > set vm_start of newly merged vma to return value addr.
> > > Users of mmap will get wrong address if vma is merged after call_mmap().
> > > We fix this by moving the assignment to addr before merging vma.
> > > 
> > > Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
> > > Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
> > > v2:
> > > We want to do "addr = vma->vm_start;" unconditionally,
> > > so move assignment to addr before if(unlikely) block.
> > >  mm/mmap.c | 26 ++++++++++++--------------
> > >  1 file changed, 12 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index d91ecb00d38c..5c8b4485860d 100644
> > > +++ b/mm/mmap.c
> > > @@ -1808,6 +1808,17 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
> > >  		if (error)
> > >  			goto unmap_and_free_vma;
> > >  
> > > +		/* Can addr have changed??
> > > +		 *
> > > +		 * Answer: Yes, several device drivers can do it in their
> > > +		 *         f_op->mmap method. -DaveM
> > > +		 * Bug: If addr is changed, prev, rb_link, rb_parent should
> > > +		 *      be updated for vma_link()
> > > +		 */
> > 
> > 
> > Why do we tolerate device drivers doing such stuff at all?
> > WARN_ON_ONCE() is just as good as BUG_ON() in many environments. If we
> > support it, then no warning. If we don't support it, then why tolerate it?
> 
> The commit that introduced this seemed pretty clear it is to catch
> possibly wrong drivers. I suppose the idea was to give a migration
> time where things would "work" and drivers could be fixed. Since it
> has now been 8 years it should be either dropped or turned into:
> 
>  /* Drivers are not permitted to change vm_start */
>  if (WARN_ON(addr != vma->vm_start)) {
>      err = EINVAL
>      goto unmap_and_free_vma
>  }

This commit makes no sense.  I know it's eight years old, so maybe the
device driver which did this has long been removed from the tree, but
davem's comment was (iirc) related to a device driver for a graphics
card that would 256MB-align the user address.  Another possibility is
that userspace always asks for a 256MB-aligned address these days.

I don't understand why prev/rb_link/rb_parent would need to be changed
in this case.  It's going to be inserted at the exact same location in
the rbtree, just at a slightly shifted address.
