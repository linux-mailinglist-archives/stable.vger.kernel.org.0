Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6432445E9
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 09:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgHNHq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 03:46:58 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:34191 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgHNHq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 03:46:58 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 1802E3C04C1;
        Fri, 14 Aug 2020 09:46:56 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TMQkkEkhmfli; Fri, 14 Aug 2020 09:46:50 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 764EA3C009D;
        Fri, 14 Aug 2020 09:46:50 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.32) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 14 Aug
 2020 09:46:49 +0200
Date:   Fri, 14 Aug 2020 09:46:44 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <stable@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH] mm: slub: fix conversion of freelist_corrupted()
Message-ID: <20200814074644.GA7943@lxhi-065.adit-jv.com>
References: <20200811124656.10308-1-erosca@de.adit-jv.com>
 <f93a9f06-8608-6f28-27c0-b17f86dca55b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f93a9f06-8608-6f28-27c0-b17f86dca55b@oracle.com>
X-Originating-IP: [10.72.94.32]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dongli,

On Thu, Aug 13, 2020 at 11:57:51PM -0700, Dongli Zhang wrote:
> On 8/11/20 5:46 AM, Eugeniu Rosca wrote:
> > Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
> > deactivate_slab()") suffered an update when picked up from LKML [1].
> > 
> > Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
> > created a no-op statement. Fix it by sticking to the behavior intended
> > in the original patch [1]. Prefer the lowest-line-count solution.
> > 
> > [1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/
> > 
> > Fixes: 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in deactivate_slab()")
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Dongli Zhang <dongli.zhang@oracle.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > ---
> >  mm/slub.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 68c02b2eecd9..9a3e963b02a3 100644
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
> 
> This is good to me.
> 
> However, this would confuse people when CONFIG_SLUB_DEBUG is not defined.
> 
> While reading the source code, people may be curious why to reset freelist when
> CONFIG_SLUB_DEBUG is even not defined.

This is a fair point. To address it, the `freelist = NULL` assignment
should be then moved into the body of freelist_corrupted(). If no
concerns on that, I will soon push a v2 implementing this proposal.

-- 
Best regards,
Eugeniu Rosca
