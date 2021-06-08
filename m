Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D216D3A0799
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 01:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhFHXNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 19:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFHXNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 19:13:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D57AC061787
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 16:11:07 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m7so3979790pfa.10
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 16:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CtnIG0I9WH5rJ/qkiBO8MTiub4f1BJwHmBXw1xc/PqU=;
        b=dxzowAxFXpK7aiWcWxbNfqXurQ1lkSAJANaUZhAo+/ACQvsmkdvn85Ksv9A80cNT4r
         cpVKsC7BJ+foyQTW7mhParj8XoFy4ytIPqr/unu215You+Ymrz7KEMlQHBfORJOgQZsr
         KcDkWQGZ7QTrNwnEHU9S8pzRLxrMsNHhU51OU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CtnIG0I9WH5rJ/qkiBO8MTiub4f1BJwHmBXw1xc/PqU=;
        b=cP3xgj3YZOyrzVIjwNGTxG1HsjoRISUF7YqYSCSP2Sw8mzDwi/1f+Vim/aKHEr7hhz
         zNq62trOvT0M1jArPy8Rql4ZafLkiYeNdmLTdRnRcvPMGZJu80WWLavOyPkPOfNsSzS6
         ULSc5IJnJp2uI+2/rMdiONR6P9T8J2P75xRd8Me+wxwT3zC3YklbQzzQan2Tn9WYqaJ9
         zH+KeqRrqISK2FtEeP8N1xGr9DWFqEc/AtbVbAg1/HkeVfFLY9EVZLUA7NTrw7XzMgYK
         Q7548kxq/DHWlNP6HaqTiycx4gaTpqrLew5jtWNirAV73Qhfp2VZPbX2nP+3/jFj88Tg
         68Vw==
X-Gm-Message-State: AOAM533yCHyCCOFsnqW410yNN+8InBC0LVA3s203n3Ui5SjqKAEhZsXR
        cKOPmcmnWjkE1z0oG2f0D0lgVw==
X-Google-Smtp-Source: ABdhPJwsH1ZT/91h9f3ez1aHPP3kcJQrsPqtXCwE2vACMsQ/QMIYOKVYw4mf/HzmIRBastKcADl4sA==
X-Received: by 2002:aa7:8392:0:b029:2db:4a7:d866 with SMTP id u18-20020aa783920000b02902db04a7d866mr2311154pfm.66.1623193866812;
        Tue, 08 Jun 2021 16:11:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r2sm3837786pfq.87.2021.06.08.16.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 16:11:06 -0700 (PDT)
Date:   Tue, 8 Jun 2021 16:11:05 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Marco Elver <elver@google.com>, "Lin, Zhenpeng" <zplin@psu.edu>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 3/3] mm/slub: Actually fix freelist pointer vs
 redzoning
Message-ID: <202106081608.A50EA64@keescook>
References: <20210608183955.280836-1-keescook@chromium.org>
 <20210608183955.280836-4-keescook@chromium.org>
 <20210608135633.167bd07cf8011a792a128976@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608135633.167bd07cf8011a792a128976@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 01:56:33PM -0700, Andrew Morton wrote:
> On Tue,  8 Jun 2021 11:39:55 -0700 Kees Cook <keescook@chromium.org> wrote:
> 
> > It turns out that SLUB redzoning ("slub_debug=Z") checks from
> > s->object_size rather than from s->inuse (which is normally bumped
> > to make room for the freelist pointer), so a cache created with an
> > object size less than 24 would have the freelist pointer written beyond
> > s->object_size, causing the redzone to be corrupted by the freelist
> > pointer. This was very visible with "slub_debug=ZF":
> > 
> > BUG test (Tainted: G    B            ): Right Redzone overwritten
> > -----------------------------------------------------------------------------
> > 
> > INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
> > INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
> > INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620
> > 
> > Redzone  (____ptrval____): bb bb bb bb bb bb bb bb               ........
> > Object   (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
> > Redzone  (____ptrval____): 40 1d e8 1a aa                        @....
> > Padding  (____ptrval____): 00 00 00 00 00 00 00 00               ........
> > 
> > Adjust the offset to stay within s->object_size.
> > 
> > (Note that no caches of in this size range are known to exist in the
> > kernel currently.)
> 
> We already have
> https://lkml.kernel.org/r/6746FEEA-FD69-4792-8DDA-C78F5FE7DA02@psu.edu.
> Is this patch better?

Yes, I believe so, since it reduces code and corrects the size checking
more directly (and more clearly demonstrates the redzone calculation
problem in the commit log).

-Kees

> 
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3689,7 +3689,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >  {
> >  	slab_flags_t flags = s->flags;
> >  	unsigned int size = s->object_size;
> > -	unsigned int freepointer_area;
> >  	unsigned int order;
> >  
> >  	/*
> > @@ -3698,13 +3697,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >  	 * the possible location of the free pointer.
> >  	 */
> >  	size = ALIGN(size, sizeof(void *));
> > -	/*
> > -	 * This is the area of the object where a freepointer can be
> > -	 * safely written. If redzoning adds more to the inuse size, we
> > -	 * can't use that portion for writing the freepointer, so
> > -	 * s->offset must be limited within this for the general case.
> > -	 */
> > -	freepointer_area = size;
> >  
> >  #ifdef CONFIG_SLUB_DEBUG
> >  	/*
> > @@ -3730,7 +3722,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >  
> >  	/*
> >  	 * With that we have determined the number of bytes in actual use
> > -	 * by the object. This is the potential offset to the free pointer.
> > +	 * by the object and redzoning.
> >  	 */
> >  	s->inuse = size;
> >  
> > @@ -3753,13 +3745,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >  		 */
> >  		s->offset = size;
> >  		size += sizeof(void *);
> > -	} else if (freepointer_area > sizeof(void *)) {
> > +	} else {
> >  		/*
> >  		 * Store freelist pointer near middle of object to keep
> >  		 * it away from the edges of the object to avoid small
> >  		 * sized over/underflows from neighboring allocations.
> >  		 */
> > -		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
> > +		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
> >  	}
> >  
> >  #ifdef CONFIG_SLUB_DEBUG
> > -- 
> > 2.25.1

-- 
Kees Cook
