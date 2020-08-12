Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3527B24272D
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 11:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgHLJGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 05:06:31 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:47837 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgHLJGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 05:06:31 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 230163C0579;
        Wed, 12 Aug 2020 11:06:29 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AtrILPphwTim; Wed, 12 Aug 2020 11:06:24 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 2A1D53C009D;
        Wed, 12 Aug 2020 11:06:24 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.23) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 12 Aug
 2020 11:06:23 +0200
Date:   Wed, 12 Aug 2020 11:06:18 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH] mm: slub: fix conversion of freelist_corrupted()
Message-ID: <20200812090618.GA11872@lxhi-065.adit-jv.com>
References: <20200811124656.10308-1-erosca@de.adit-jv.com>
 <20200811134909.536004dcfc4c78204313dcd2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200811134909.536004dcfc4c78204313dcd2@linux-foundation.org>
X-Originating-IP: [10.72.94.23]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Andrew,

On Tue, Aug 11, 2020 at 01:49:09PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2020 14:46:56 +0200 Eugeniu Rosca <erosca@de.adit-jv.com> wrote:
> 
> > Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
> > deactivate_slab()") suffered an update when picked up from LKML [1].
> > 
> > Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
> > created a no-op statement. Fix it by sticking to the behavior intended
> > in the original patch [1]. Prefer the lowest-line-count solution.
> > 
> > [1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/
> > 
> > ...
> >
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -677,7 +677,6 @@ static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
> >  	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
> >  	    !check_valid_pointer(s, page, nextfree)) {
> >  		object_err(s, page, freelist, "Freechain corrupt");
> > -		freelist = NULL;
> >  		slab_fix(s, "Isolate corrupted freechain");
> >  		return true;
> >  	}
> > @@ -2184,8 +2183,10 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
> >  		 * 'freelist' is already corrupted.  So isolate all objects
> >  		 * starting at 'freelist'.
> >  		 */
> > -		if (freelist_corrupted(s, page, freelist, nextfree))
> > +		if (freelist_corrupted(s, page, freelist, nextfree)) {
> > +			freelist = NULL;
> >  			break;
> > +		}
> >  
> >  		do {
> >  			prior = page->freelist;
> 
> Looks right.
> 
> What are the runtime effects of this change?  In other words, what are
> the end user visible effects of the present defect?

Thank you for the prompt feedback.

The issue popped up as a result of static analysis and code review.
Therefore, I lack any specific runtime behavior example being fixed.
Nevertheless, I think this does not diminish the concern expressed in
the description of the patch.

-- 
Best regards,
Eugeniu Rosca
