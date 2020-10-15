Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223B928EB64
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 05:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgJODIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 23:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgJODIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 23:08:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BF8C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:08:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o7so842158pgv.6
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XKOhTjKsO0EE4YV4BAqrsCKoLcqTC+6y91gTBtyDfzc=;
        b=OhI20NXp3bRpI+D+HvzZmUsVj2SG0BLogQBtTOgVmB1IGwBBmPo3+zIkQTcfXvrE3c
         hz1n94A+Dx1w4X8g5XZQW9pRLZWXr3jnJD7godSQvrnAHtHW5GXWABb2zL0O45l4rCcg
         gEk2IzRuI5wzPIRE/dmbuaGMl9dDRq0KVdEmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XKOhTjKsO0EE4YV4BAqrsCKoLcqTC+6y91gTBtyDfzc=;
        b=VZkD2y/tX2yXLJgZdl190/z9EHUUk6IuK+Kr4JhdwPbc+GHPZjNIHU10ugcmPpdPoq
         oclE8wJXrcsNi7kJYQVA1pr2m4T7kVlrDFWyIp4B2P7cqbSACBx/rGP2LTjaUwgzGw8E
         t6m+r5Xo8AvIfTORSSjXS6L8LCKbTRmWbzTynPwBZmxKdZ0CNv+4QqZNB2yuAdgOXt2E
         EDBN0SmZya9EnObB56HzfgZUNaC6x8KWKGFTZbdB30To5xv1cHrSty0ZN69FARJwLD0l
         pctPe72rBdkRs8wAh9YyrRt3qnZswdoKeRN3hP0gJbAKhcwRzKDi6oMGqeCnNXQEBTP7
         qRPQ==
X-Gm-Message-State: AOAM532YPl0KlSTq+unGLf1ZRn1IeHuafiZT/nOeSd7aVlW7M3wGvIux
        OZ7QB3IX6s4iWtYO3B3AkkD+3A==
X-Google-Smtp-Source: ABdhPJym5UDdpMgKQQWmMZLVVyeSA1V2DiZOaQb1m5XeGgB5IjoBb5DxMYDHlklwpsc9fEsDssLb4g==
X-Received: by 2002:a62:8c55:0:b029:152:b326:9558 with SMTP id m82-20020a628c550000b0290152b3269558mr2082303pfd.72.1602731329686;
        Wed, 14 Oct 2020 20:08:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k8sm1036546pgi.39.2020.10.14.20.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 20:08:48 -0700 (PDT)
Date:   Wed, 14 Oct 2020 20:08:47 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Actually fix freelist pointer vs redzoning
Message-ID: <202010142006.BD734954@keescook>
References: <20201008233443.3335464-1-keescook@chromium.org>
 <d712c80b-873f-0007-2300-dca8056ac6fd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d712c80b-873f-0007-2300-dca8056ac6fd@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 10:36:01PM -0400, Waiman Long wrote:
> On 10/8/20 7:34 PM, Kees Cook wrote:
> > It turns out that SLUB redzoning ("slub_debug=Z") checks from
> > s->object_size rather than from s->inuse (which is normally bumped to
> > make room for the freelist pointer), so a cache created with an object
> > size less than 24 would have their freelist pointer written beyond
> > s->object_size, causing the redzone to corrupt the freelist pointer.
> > This was very visible with "slub_debug=ZF":
> > 
> > BUG test (Tainted: G    B            ): Redzone overwritten
> > -----------------------------------------------------------------------------
> > 
> > INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
> > INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
> > INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620
> > 
> > Redzone (____ptrval____): bb bb bb bb bb bb bb bb               ........
> > Object  (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
> > Redzone (____ptrval____): 40 1d e8 1a aa                        @....
> > Padding (____ptrval____): 00 00 00 00 00 00 00 00               ........
> > 
> > Adjust the offset to stay within s->object_size.
> > 
> > (Note that there appear to be no such small-sized caches in the kernel
> > currently.)
> > 
> > Reported-by: Marco Elver <elver@google.com>
> > Link: https://lore.kernel.org/linux-mm/20200807160627.GA1420741@elver.google.com/
> > Fixes: 89b83f282d8b (slub: avoid redzone when choosing freepointer location)
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >   mm/slub.c | 17 +++++------------
> >   1 file changed, 5 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 68c02b2eecd9..979f5da26992 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3641,7 +3641,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >   {
> >   	slab_flags_t flags = s->flags;
> >   	unsigned int size = s->object_size;
> > -	unsigned int freepointer_area;
> >   	unsigned int order;
> >   	/*
> > @@ -3650,13 +3649,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >   	 * the possible location of the free pointer.
> >   	 */
> >   	size = ALIGN(size, sizeof(void *));
> > -	/*
> > -	 * This is the area of the object where a freepointer can be
> > -	 * safely written. If redzoning adds more to the inuse size, we
> > -	 * can't use that portion for writing the freepointer, so
> > -	 * s->offset must be limited within this for the general case.
> > -	 */
> > -	freepointer_area = size;
> >   #ifdef CONFIG_SLUB_DEBUG
> >   	/*
> > @@ -3682,7 +3674,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >   	/*
> >   	 * With that we have determined the number of bytes in actual use
> > -	 * by the object. This is the potential offset to the free pointer.
> > +	 * by the object and redzoning.
> >   	 */
> >   	s->inuse = size;
> > @@ -3694,7 +3686,8 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >   		 * kmem_cache_free.
> >   		 *
> >   		 * This is the case if we do RCU, have a constructor or
> > -		 * destructor or are poisoning the objects.
> > +		 * destructor, are poisoning the objects, or are
> > +		 * redzoning an object smaller than sizeof(void *).
> >   		 *
> >   		 * The assumption that s->offset >= s->inuse means free
> >   		 * pointer is outside of the object is used in the
> 
> There is no check to go into this if condition to put free pointer after
> object when redzoning an object smaller than sizeof(void *). In that sense,
> the additional comment isn't correct.

Right -- part of this is why I did my v2 series[1], where I failed to find
where that had been enforced, and explicitly added it[2]. If no one
objects, I could fold that check into this fix, just for robustness.
cache creation is not fast-path, and the size test is a trivial check.

> Should we add that check even though we don't have slab objects with such a
> small size in the kernel?

I'd like to... I will spin a v3.

Thanks!

[1] https://lore.kernel.org/lkml/20201009195411.4018141-1-keescook@chromium.org/
[2] https://lore.kernel.org/lkml/20201009195411.4018141-3-keescook@chromium.org/

-- 
Kees Cook
