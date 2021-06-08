Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833F23A0562
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 22:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhFHU62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 16:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhFHU62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 16:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7782F61183;
        Tue,  8 Jun 2021 20:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623185794;
        bh=OJGgtBm3q7tcqDwa9BJEaBavdukZSO3qBK6MijhoVOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MQXq/Hx3fjxqEhCexwtfrIC4TuKeq0UtnAQnOl5JKeaOWFHZ+zyWV4fTfIiaIlw4K
         SxaE7nlGyVrx0rFi9o1tWINlsPPixyQqqyXOZEM9yFm0rul6G3zhMr9fo6POaZlDJ4
         bUyXf6NboSgc8nM6iqvfiiqoaIlkxRjXPgzyf0jI=
Date:   Tue, 8 Jun 2021 13:56:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Marco Elver <elver@google.com>, "Lin, Zhenpeng" <zplin@psu.edu>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        "Lin, Zhenpeng" <zplin@psu.edu>
Subject: Re: [PATCH v4 3/3] mm/slub: Actually fix freelist pointer vs
 redzoning
Message-Id: <20210608135633.167bd07cf8011a792a128976@linux-foundation.org>
In-Reply-To: <20210608183955.280836-4-keescook@chromium.org>
References: <20210608183955.280836-1-keescook@chromium.org>
        <20210608183955.280836-4-keescook@chromium.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  8 Jun 2021 11:39:55 -0700 Kees Cook <keescook@chromium.org> wrote:

> It turns out that SLUB redzoning ("slub_debug=Z") checks from
> s->object_size rather than from s->inuse (which is normally bumped
> to make room for the freelist pointer), so a cache created with an
> object size less than 24 would have the freelist pointer written beyond
> s->object_size, causing the redzone to be corrupted by the freelist
> pointer. This was very visible with "slub_debug=ZF":
> 
> BUG test (Tainted: G    B            ): Right Redzone overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
> INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
> INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620
> 
> Redzone  (____ptrval____): bb bb bb bb bb bb bb bb               ........
> Object   (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
> Redzone  (____ptrval____): 40 1d e8 1a aa                        @....
> Padding  (____ptrval____): 00 00 00 00 00 00 00 00               ........
> 
> Adjust the offset to stay within s->object_size.
> 
> (Note that no caches of in this size range are known to exist in the
> kernel currently.)

We already have
https://lkml.kernel.org/r/6746FEEA-FD69-4792-8DDA-C78F5FE7DA02@psu.edu.
Is this patch better?

> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3689,7 +3689,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  {
>  	slab_flags_t flags = s->flags;
>  	unsigned int size = s->object_size;
> -	unsigned int freepointer_area;
>  	unsigned int order;
>  
>  	/*
> @@ -3698,13 +3697,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  	 * the possible location of the free pointer.
>  	 */
>  	size = ALIGN(size, sizeof(void *));
> -	/*
> -	 * This is the area of the object where a freepointer can be
> -	 * safely written. If redzoning adds more to the inuse size, we
> -	 * can't use that portion for writing the freepointer, so
> -	 * s->offset must be limited within this for the general case.
> -	 */
> -	freepointer_area = size;
>  
>  #ifdef CONFIG_SLUB_DEBUG
>  	/*
> @@ -3730,7 +3722,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  
>  	/*
>  	 * With that we have determined the number of bytes in actual use
> -	 * by the object. This is the potential offset to the free pointer.
> +	 * by the object and redzoning.
>  	 */
>  	s->inuse = size;
>  
> @@ -3753,13 +3745,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  		 */
>  		s->offset = size;
>  		size += sizeof(void *);
> -	} else if (freepointer_area > sizeof(void *)) {
> +	} else {
>  		/*
>  		 * Store freelist pointer near middle of object to keep
>  		 * it away from the edges of the object to avoid small
>  		 * sized over/underflows from neighboring allocations.
>  		 */
> -		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
> +		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
>  	}
>  
>  #ifdef CONFIG_SLUB_DEBUG
> -- 
> 2.25.1
