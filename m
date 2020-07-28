Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523CA230CDE
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 17:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbgG1PAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 11:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbgG1PAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 11:00:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47BF3206D8;
        Tue, 28 Jul 2020 15:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595948453;
        bh=frxB2QXihnX0bS03Xc1I0P6xwq48DECVyTC63uP/ctM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kjc1NjTB8mTa19UGapHTh6qmux0UixS44sD8UjmAXe+/c2jxnunFjlZWvrL9fK4h9
         Gt3SlRxefMTqGCYw4JIh6RTMQ0MGLKLGxPKyYBTjVj1Gd4ovftrw+hlJQz9bCP/WnW
         y/4tr2Mpq6ISoqGqYaRDApHAC/R/yERivGbwlOC8=
Date:   Tue, 28 Jul 2020 17:00:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [External] [PATCH 4.19 76/86] mm: memcg/slab: fix memory leak at
 non-root kmem_cache destroy
Message-ID: <20200728150047.GC3537020@kroah.com>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134918.205538211@linuxfoundation.org>
 <CAMZfGtWVtGeMfu=04LiNVcLrBpmexUryHjy-dujo77CpJhcwGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtWVtGeMfu=04LiNVcLrBpmexUryHjy-dujo77CpJhcwGg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 28, 2020 at 08:56:41PM +0800, Muchun Song wrote:
> On Mon, Jul 27, 2020 at 10:12 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Muchun Song <songmuchun@bytedance.com>
> >
> > commit d38a2b7a9c939e6d7329ab92b96559ccebf7b135 upstream.
> >
> > If the kmem_cache refcount is greater than one, we should not mark the
> > root kmem_cache as dying.  If we mark the root kmem_cache dying
> > incorrectly, the non-root kmem_cache can never be destroyed.  It
> > resulted in memory leak when memcg was destroyed.  We can use the
> > following steps to reproduce.
> >
> >   1) Use kmem_cache_create() to create a new kmem_cache named A.
> >   2) Coincidentally, the kmem_cache A is an alias for kmem_cache B,
> >      so the refcount of B is just increased.
> >   3) Use kmem_cache_destroy() to destroy the kmem_cache A, just
> >      decrease the B's refcount but mark the B as dying.
> >   4) Create a new memory cgroup and alloc memory from the kmem_cache
> >      B. It leads to create a non-root kmem_cache for allocating memory.
> >   5) When destroy the memory cgroup created in the step 4), the
> >      non-root kmem_cache can never be destroyed.
> >
> > If we repeat steps 4) and 5), this will cause a lot of memory leak.  So
> > only when refcount reach zero, we mark the root kmem_cache as dying.
> >
> > Fixes: 92ee383f6daa ("mm: fix race between kmem_cache destroy, create and deactivate")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > Acked-by: Roman Gushchin <guro@fb.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Cc: <stable@vger.kernel.org>
> > Link: http://lkml.kernel.org/r/20200716165103.83462-1-songmuchun@bytedance.com
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  mm/slab_common.c |   35 ++++++++++++++++++++++++++++-------
> >  1 file changed, 28 insertions(+), 7 deletions(-)
> >
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -310,6 +310,14 @@ int slab_unmergeable(struct kmem_cache *
> >         if (s->refcount < 0)
> >                 return 1;
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> > +       /*
> > +        * Skip the dying kmem_cache.
> > +        */
> > +       if (s->memcg_params.dying)
> > +               return 1;
> > +#endif
> > +
> >         return 0;
> >  }
> >
> > @@ -832,12 +840,15 @@ static int shutdown_memcg_caches(struct
> >         return 0;
> >  }
> >
> > -static void flush_memcg_workqueue(struct kmem_cache *s)
> > +static void memcg_set_kmem_cache_dying(struct kmem_cache *s)
> >  {
> >         mutex_lock(&slab_mutex);
> >         s->memcg_params.dying = true;
> >         mutex_unlock(&slab_mutex);
> 
> We should remove mutex_lock/unlock(&slab_mutex) here, because
> we already hold the slab_mutex from kmem_cache_destroy().

Good catch.  I'll go make this change and push out a -rc2.

thanks,

greg k-h
