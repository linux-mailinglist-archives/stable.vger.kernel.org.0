Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710684C7EC5
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 00:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiB1XzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 18:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiB1XzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 18:55:08 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EAA135729
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 15:54:27 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g21so6220135pfj.11
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 15:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZoIjMvUL7SzOBwg//8DuZ5HAmugd/JLSwk0JeKnE4gI=;
        b=XLZRlj8v/bOfBnPN1XTZDp5pFeDuPzX/gLOHAziK0Rp0HdX17TS4xwpOMhJXCdbD+i
         Exvmptbl+fM/i15fKFFblN5PvHZU74mZECjuOgEL9V2mTw46+6fJVYAkhZI2f7yAUH4Y
         MecQaaMIRcZpS+Db670n85AI0u3RSD8n/xD/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZoIjMvUL7SzOBwg//8DuZ5HAmugd/JLSwk0JeKnE4gI=;
        b=Q/M0EmVfxjTmUL3ouwWFNqoIPKSoOzl3TYPBYi8kIjvU2E4KtxcO5vYnb1v0jWqPVS
         Vkllqx3O/dJXlqYPXygy4lt9WZHff9UnKrvAoONb0zkBjWKOjiAzwkqpILwv6cAdeJBc
         eSRYqvciXI3zQqE3SHYZW5eGehEjMPmvXNMfwmEjkvBgJnqTFgP0ZSh4WvVPiWrkMmn6
         wcWoeYPbJlAh3SVbmL9t26RJvGKY8f0Q/C/LKCX381GVh+W5+su/aGntR2aqMVYTRUuD
         ZKYvQP/BnKGTYsqm8BoSt/XtQ39EqN6OlWUMWpvgVE6U9h8ZYx+rEDLb9h2Kb0kKxNTv
         K4dA==
X-Gm-Message-State: AOAM532bUC/HgJI5t5oEVHESZjJ4GxWn4RE2Y2NU7KOg6DvUdSG9ar0g
        vIMkcQzHG6gvQbsPHON5O/0VQQ==
X-Google-Smtp-Source: ABdhPJwZflpqodYP0q6JFLbd74qZ9J/g0zWwTt91lu4CkMy3/Wym4LijBx/D0NSrovvHElQlit5Rtw==
X-Received: by 2002:a63:1a51:0:b0:34d:c269:566 with SMTP id a17-20020a631a51000000b0034dc2690566mr19118197pgm.305.1646092467330;
        Mon, 28 Feb 2022 15:54:27 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q10-20020a65524a000000b00372e458e87esm11050617pgp.67.2022.02.28.15.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 15:54:26 -0800 (PST)
Date:   Mon, 28 Feb 2022 15:54:26 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Marco Elver <elver@google.com>
Cc:     llvm@lists.linux.dev, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
Message-ID: <202202281516.19274C0@keescook>
References: <20220225221625.3531852-1-keescook@chromium.org>
 <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 12:24:51PM +0100, Marco Elver wrote:
> On Fri, 25 Feb 2022 at 23:16, Kees Cook <keescook@chromium.org> wrote:
> >
> > If ksize() is used on an allocation, the compiler cannot make any
> > assumptions about its size any more (as hinted by __alloc_size). Force
> > it to forget.
> > [...]
> > diff --git a/include/linux/slab.h b/include/linux/slab.h
> > index 37bde99b74af..a14f3bfa2f44 100644
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -182,8 +182,32 @@ int kmem_cache_shrink(struct kmem_cache *s);
> >  void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
> >  void kfree(const void *objp);
> >  void kfree_sensitive(const void *objp);
> > +
> > +/**
> > + * ksize - get the actual amount of memory allocated for a given object
> > + * @objp: Pointer to the object
> > + *
> > + * kmalloc may internally round up allocations and return more memory
> > + * than requested. ksize() can be used to determine the actual amount of
> > + * memory allocated. The caller may use this additional memory, even though
> > + * a smaller amount of memory was initially specified with the kmalloc call.
> > + * The caller must guarantee that objp points to a valid object previously
> > + * allocated with either kmalloc() or kmem_cache_alloc(). The object
> > + * must not be freed during the duration of the call.
> > + *
> > + * Return: size of the actual memory used by @objp in bytes
> > + */
> > +#define ksize(objp) ({                                                 \
> > +       /*                                                              \
> > +        * Getting the actual allocation size means the __alloc_size    \
> > +        * hints are no longer valid, and the compiler needs to         \
> > +        * forget about them.                                           \
> > +        */                                                             \
> > +       OPTIMIZER_HIDE_VAR(objp);                                       \
> > +       _ksize(objp);                                                   \
> > +})
> 
> So per that ClangBuiltLinux issue I'm gleaning that the __alloc_size
> annotations are actually causing the compiler to generate wrong code?

I would say "incompatible", but yes, the result in the same. The compiler
is doing exactly what we told it that it should do. Using __alloc_size
means it can assume (and enforce) the size of the allocation.

AFAICT, This became an issue due to:

	-fsanitize=bounds -fsanitize-undefined-trap-on-error

I would expect -Warray-bounds to warn about it, but since we don't have
-Warray-bounds enabled, this leads to a silent problem. (Note that I
and others been working very hard to get the code base well enough into
shape that we can enable -Warray-bounds.)

I have not, however, been able to reduce the issue to a minimal a test
case yet. This patch was proposed to see if Greg (or other Android folks)
could check it.

> Possibly due to the compiler thinking that the accesses must stay
> within some bound, and anything beyond that will be "undefined
> behaviour"? Clearly, per the slab APIs, in particular with the
> provision of ksize(), the compiler is wrong.

Right. __alloc_size vs ksize() is the problem.

> At first I thought this was only related to UBSAN bounds checking
> generating false positives, in which case a simple workaround as you
> present above would probably take care of most cases.
> 
> But if the real issue is the compiler suddenly doing more aggressive
> compiler optimizations because it thinks accesses beyond the object
> size (per __alloc_size) is UB, but UB can never happen, and thus does
> crazy things [1], I think the answer (at least with what we have right
> now) should be to find a different solution that is more reliable.
> 
> [1] https://lore.kernel.org/all/20220218131358.3032912-1-gregkh@linuxfoundation.org/

I think it's -fsanitize-undefined-trap-on-error causing the "problem".
It seems to be doing exactly what it was told to do. :)

But again, I haven't got a good example, so maybe there is _also_ a
miscompilation happening?

> Because who's to say that there's not some code that does:
> 
>    foo = kmalloc(...);
>    ...
>    bar = foo;
>    s = ksize(bar);
>    ... makes access address-dependent on 's' and 'foo' (but not 'bar') ...
> 
> This doesn't look like code anyone would write, but I fear with enough
> macro and inline function magic, it's not too unlikely.

Right ... I would _hope_ the s-based access would be on _bar_ only. :P

> I can see a few options:
> 
> 1. Dropping __alloc_size.

Right; that's the big-hammer solution (and is what Greg has already done
in [1] for the _particular_ case, but there may be others).

> 2. Somehow statically computing the size-class's size (kmalloc_index()
> might help here), removing __alloc_size from allocation functions and
> instead use some wrapper.

I want to do this for other reasons too, but yes, it looks a bit
finicky. And there are some plans to make this even MORE dynamic, but if
that happens, I think we could fall that condition back to "no
__alloc_size".

> 3. Teaching the compiler to drop *all* object sizes upon encountering a ksize().

size_t ksize(void *ptr) __just_kidding_about_the_alloc_size;

> So I think #1 is probably not what you want. #2 seems quite
> complicated, and in many cases likely too relaxed and would miss bugs,
> so also not ideal. #3 would be the most reliable, but
> OPTIMIZER_HIDE_VAR() doesn't cut it, and we need something stronger.
> The downside of #3 is that it might pessimize code generation, but
> given ksize() is used sparingly, might be ok.

Okay, so, using __alloc_size is currently very limited in scope, in the
sense that bounds checking against such an allocated pointer is only
within the resulting function (and inlining) bounds. This _has_ caught
flaws, though, so I remain interested in keeping it.

Using it within the same scope as with ksize(), however, is the
problem. Daniel suggests a reasonable solution here, which is "remove
ksize" (I'll call this #4), since what he points out is that the
users of ksize() follow a very specific pattern and don't benefit from
__alloc_size.

As I'd like to be expanding the scope of __alloc_size's effects even
more strong into runtime (via other users of the information like
__builtin_dynamic_object_size()), I think we need to either use the
patch I've proposed, make kmalloc have compile-time-visible buckets so
__alloc_size seems the "right" size, or remove ksize().

#4 seems maybe doable. Here's a slightly trimmed list:

arch/x86/kernel/cpu/microcode/amd.c:    memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
drivers/base/devres.c:  total_old_size = ksize(container_of(ptr, struct devres, data));
drivers/dma-buf/dma-resv.c:     list->shared_max = (ksize(list) - offsetof(typeof(*list), shared)) /
drivers/gpu/drm/drm_managed.c:  WARN_ON(dev + 1 > (struct drm_device *) (container + ksize(container)));
drivers/net/ethernet/intel/igb/igb_main.c:      } else if (size > ksize(q_vector)) {
drivers/net/ipa/gsi_trans.c:    pool->count = ksize(pool->base) / size;
drivers/net/wireless/intel/iwlwifi/mvm/scan.c:  memset(mvm->scan_cmd, 0, ksize(mvm->scan_cmd));
fs/btrfs/send.c:        p->buf_len = ksize(p->buf);
fs/coredump.c:  cn->size = ksize(corename);
include/linux/slab.h:size_t ksize(const void *objp);
kernel/bpf/verifier.c:  if (ksize(dst) < bytes) {
mm/mempool.c:           __check_element(pool, element, ksize(element));
mm/nommu.c:             return ksize(objp);
mm/slab_common.c:       ks = ksize(mem);
net/core/skbuff.c:      unsigned int size = frag_size ? : ksize(data);
net/core/skbuff.c:      osize = ksize(data);
net/core/skbuff.c:      size = SKB_WITH_OVERHEAD(ksize(data));
net/core/skbuff.c:      size = SKB_WITH_OVERHEAD(ksize(data));
net/core/skbuff.c:      size = SKB_WITH_OVERHEAD(ksize(data));
security/tomoyo/gc.c:   tomoyo_memory_used[TOMOYO_MEMORY_POLICY] -= ksize(ptr);
security/tomoyo/memory.c:               const size_t s = ksize(ptr);

I would really like to have #2, though, as I could use it for some
future kmalloc defenses that need compile-time sizing visibility.

-- 
Kees Cook
