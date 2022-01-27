Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908B049DC7E
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 09:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbiA0IZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 03:25:51 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:57940 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiA0IZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 03:25:50 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 97F941F782;
        Thu, 27 Jan 2022 08:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643271949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Q0FkSQmm1fWntRs1C5a+2X1IC7ibgX3XsHWMAzrK8A=;
        b=d29mOoQK93zcDc6AY8VZqcYav5jp45qVch2NDpZxg5up8oPsZtZz9iZd0+LwB8l7Bqv8TY
        YB9TQdlzSXwxRuhbKWYaZQZGGFNBcIf/hdxTgwq/hG0Wk0YdHZ/TTdHlrN79DatiOy5Rou
        fGkimGB+7UI2sAfmcjwFZyC7OfUzo6k=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5285CA3B81;
        Thu, 27 Jan 2022 08:25:49 +0000 (UTC)
Date:   Thu, 27 Jan 2022 09:25:48 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Message-ID: <YfJXDDeDwZuBxs13@dhcp22.suse.cz>
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <20220126185340.58f88e8e1b153b6650c83270@linux-foundation.org>
 <c658f8c5-a808-f2f1-2e1e-cfb68dd19d6a@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c658f8c5-a808-f2f1-2e1e-cfb68dd19d6a@colorfullife.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 27-01-22 06:59:50, Manfred Spraul wrote:
> Hi Andrew,
> 
> On 1/27/22 03:53, Andrew Morton wrote:
> > On Wed, 22 Dec 2021 20:48:28 +0100 Manfred Spraul <manfred@colorfullife.com> wrote:
> > 
> > > One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
> > > Since vfree() can sleep this is a bug.
> > > 
> > > Previously, the code path used kfree(), and kfree() is safe to be called
> > > while holding a spinlock.
> > > 
> > > Minghao proposed to fix this by updating find_alloc_undo().
> > > 
> > > Alternate proposal to fix this: Instead of changing find_alloc_undo(),
> > > change kvfree() so that the same rules as for kfree() apply:
> > > Having different rules for kfree() and kvfree() just asks for bugs.
> > > 
> > > Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.
> > I know we've been around this loop a bunch of times and deferring was
> > considered.   But I forget the conclusion.  IIRC, mhocko was involved?
> 
> I do not remember a mail from mhocko.

I do not remember either.

> 
> Shakeel proposed to use the approach from Chi.
> 
> Decision: https://marc.info/?l=linux-kernel&m=164132032717757&w=2

And I would agree with Shakeel and go with the original change to the
ipc code. That is trivial and without any other side effects like this
one. I bet nobody has evaluated what the undconditional deferred freeing
has. At least changelog doesn't really dive into that more than a very
vague statement that this will happen.

> With Reviewed-by:
> 
> https://marc.info/?l=linux-kernel&m=164132744522325&w=2
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -610,12 +610,12 @@ EXPORT_SYMBOL(kvmalloc_node);
> > >    * It is slightly more efficient to use kfree() or vfree() if you are certain
> > >    * that you know which one to use.
> > >    *
> > > - * Context: Either preemptible task context or not-NMI interrupt.
> > > + * Context: Any context except NMI interrupt.
> > >    */
> > >   void kvfree(const void *addr)
> > >   {
> > >   	if (is_vmalloc_addr(addr))
> > > -		vfree(addr);
> > > +		vfree_atomic(addr);
> > >   	else
> > >   		kfree(addr);
> > >   }
> 

-- 
Michal Hocko
SUSE Labs
