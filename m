Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01A710A588
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 21:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfKZUfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 15:35:43 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48637 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfKZUfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 15:35:42 -0500
X-Originating-IP: 78.194.159.98
Received: from gandi.net (unknown [78.194.159.98])
        (Authenticated sender: thibaut@sautereau.fr)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 2758A60004;
        Tue, 26 Nov 2019 20:35:39 +0000 (UTC)
Date:   Tue, 26 Nov 2019 21:35:38 +0100
From:   Thibaut Sautereau <thibaut@sautereau.fr>
To:     stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, cl@linux.com, glider@google.com,
        keescook@chromium.org, labbott@redhat.com,
        mm-commits@vger.kernel.org
Subject: Re: [merged]
 mm-slub-init_on_free=1-should-wipe-freelist-ptr-for-bulk-allocations.patch
 removed from -mm tree
Message-ID: <20191126203538.GA856@gandi.net>
References: <20191015181442.O6zEw6y50%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191015181442.O6zEw6y50%akpm@linux-foundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 11:14:42AM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/slub.c: init_on_free=1 should wipe freelist ptr for bulk allocations
> has been removed from the -mm tree.  Its filename was
>      mm-slub-init_on_free=1-should-wipe-freelist-ptr-for-bulk-allocations.patch
> 
> This patch was dropped because it was merged into mainline or a subsystem tree
> 
> ------------------------------------------------------
> From: Alexander Potapenko <glider@google.com>
> Subject: mm/slub.c: init_on_free=1 should wipe freelist ptr for bulk allocations
> 
> slab_alloc_node() already zeroed out the freelist pointer if init_on_free
> was on.  Thibaut Sautereau noticed that the same needs to be done for
> kmem_cache_alloc_bulk(), which performs the allocations separately.
> 
> kmem_cache_alloc_bulk() is currently used in two places in the kernel, so
> this change is unlikely to have a major performance impact.
> 
> SLAB doesn't require a similar change, as auto-initialization makes the
> allocator store the freelist pointers off-slab.
> 
> Link: http://lkml.kernel.org/r/20191007091605.30530-1-glider@google.com
> Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Reported-by: Thibaut Sautereau <thibaut@sautereau.fr>
> Reported-by: Kees Cook <keescook@chromium.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/slub.c |   22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> --- a/mm/slub.c~mm-slub-init_on_free=1-should-wipe-freelist-ptr-for-bulk-allocations
> +++ a/mm/slub.c
> @@ -2672,6 +2672,17 @@ static void *__slab_alloc(struct kmem_ca
>  }
>  
>  /*
> + * If the object has been wiped upon free, make sure it's fully initialized by
> + * zeroing out freelist pointer.
> + */
> +static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> +						   void *obj)
> +{
> +	if (unlikely(slab_want_init_on_free(s)) && obj)
> +		memset((void *)((char *)obj + s->offset), 0, sizeof(void *));
> +}
> +
> +/*
>   * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
>   * have the fastpath folded into their functions. So no function call
>   * overhead for requests that can be satisfied on the fastpath.
> @@ -2759,12 +2770,8 @@ redo:
>  		prefetch_freepointer(s, next_object);
>  		stat(s, ALLOC_FASTPATH);
>  	}
> -	/*
> -	 * If the object has been wiped upon free, make sure it's fully
> -	 * initialized by zeroing out freelist pointer.
> -	 */
> -	if (unlikely(slab_want_init_on_free(s)) && object)
> -		memset(object + s->offset, 0, sizeof(void *));
> +
> +	maybe_wipe_obj_freeptr(s, object);
>  
>  	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
>  		memset(object, 0, s->object_size);
> @@ -3178,10 +3185,13 @@ int kmem_cache_alloc_bulk(struct kmem_ca
>  				goto error;
>  
>  			c = this_cpu_ptr(s->cpu_slab);
> +			maybe_wipe_obj_freeptr(s, p[i]);
> +
>  			continue; /* goto for-loop */
>  		}
>  		c->freelist = get_freepointer(s, object);
>  		p[i] = object;
> +		maybe_wipe_obj_freeptr(s, p[i]);
>  	}
>  	c->tid = next_tid(c->tid);
>  	local_irq_enable();
> _

Can this be backported to stable 5.3 please? It's commit 0f181f9fbea8
upstream. Thanks!

-- 
Thibaut Sautereau
