Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCF4F8D60
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 11:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbfKLK5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 05:57:21 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41354 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfKLK5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 05:57:20 -0500
Received: by mail-ot1-f68.google.com with SMTP id 94so13911544oty.8
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 02:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RbmZxFFZ7Nn450livDY2ON/taeh+9krVynuqhl80wy4=;
        b=SbOaHkL3kLOfobV1gHh5SKFiZoMQvl7AVIUHZ6P9j/nfOXdElrRFcB2taS6gSVUz1M
         5krhhBW6wQoyYWXVK9cambBFS7ErcbDF8XL7uNXmX80HPt01zDREDj7y+28dw02M4YpF
         13SZABV4GvydKoUfAKts8THd7pVLgCUBkLNjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RbmZxFFZ7Nn450livDY2ON/taeh+9krVynuqhl80wy4=;
        b=HZhRZnQwbYjvGnqAnAtH+A3KgP9Tv0K1VXZGx+Dh8Pg+RkJoLzp7KXXVYXs8pC9vWE
         sJwG8pOovAVlw/HBLJDNclKBxoPYjN+lx34Nbjj4EIVyNG95nD1Q/bkRQLDH5B/80bhH
         FyyWwZlLBUN0owUA2dZt5zBwY5OW/KgTxIUv9DVflZzDJ0sMW5afvw5+jTuoFDbVMgN/
         HWKAkwbSmBLGmlD8JvgeEYUWSHflBCOw459TydTn3JsasPx7ljb9QnqBOhsVemxmMq5S
         aBItgeU7NPB1w/RIX2Rz/DdvDDZEb6Ea86ftAucPOHAn7CExOtA9Y3fKclkeyc5oauwP
         1ooQ==
X-Gm-Message-State: APjAAAWUV6duu5l3v18hh4L1M4PtyhfFTLnQ2diHM4SFlOWfOAkayM/q
        sXziDqPHf89rlTQxkxMksx5MHN+DpLSNJ6WxLUukfw==
X-Google-Smtp-Source: APXvYqxZtkCDZzGY/0t9bL2y5WOpKPyHPq/MZSc2e04/FatRGcqTvFlPVxn99K2PeClhZav0kCRPg/qhwbDQNVlon64=
X-Received: by 2002:a05:6830:1649:: with SMTP id h9mr26137010otr.281.1573556239713;
 Tue, 12 Nov 2019 02:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
 <20190718145407.21352-4-chris@chris-wilson.co.uk> <CAKMK7uEgFS8FAatJBzsEid72sy2_h8x2WsyhsZuyyfaoD1Lg0Q@mail.gmail.com>
 <157355174344.9322.13853897964725973571@skylake-alporthouse-com>
In-Reply-To: <157355174344.9322.13853897964725973571@skylake-alporthouse-com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 12 Nov 2019 11:57:08 +0100
Message-ID: <CAKMK7uE8fjc3OXhAnESs-w=fqPhmJUUFOF_n_bKETFaQiQw+GA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 4/4] drm/i915: Flush stale cachelines on set-cache-level
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Francisco Jerez <currojerez@riseup.net>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 10:43 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Quoting Daniel Vetter (2019-11-12 09:09:06)
> > On Thu, Jul 18, 2019 at 4:54 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > >
> > > Ensure that we flush any cache dirt out to main memory before the user
> > > changes the cache-level as they may elect to bypass the cache (even after
> > > declaring their access cache-coherent) via use of unprivileged MOCS.
> > >
> > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/gpu/drm/i915/gem/i915_gem_domain.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > > index 2e3ce2a69653..5d41e769a428 100644
> > > --- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > > +++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > > @@ -277,6 +277,11 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
> > >
> > >         list_for_each_entry(vma, &obj->vma.list, obj_link)
> > >                 vma->node.color = cache_level;
> > > +
> > > +       /* Flush any previous cache dirt in case of cache bypass */
> > > +       if (obj->cache_dirty & ~obj->cache_coherent)
> > > +               i915_gem_clflush_object(obj, I915_CLFLUSH_SYNC);
> >
> > I think writing out the bit logic instead of implicitly relying on the
> > #defines would be much better, i.e. && !(cache_coherent &
> > COHERENT_FOR_READ). Plus I think we only need to set cache_dirty =
> > true if we don't flush here already, to avoid double flushing?
>
> No. The mask is being updated, so you need to flush before you lose
> track. The cache is then cleared of the dirty bit so won't be flushed
> again until dirty and no longer coherent. We need to flag that the page
> is no longer coherent at the end of its lifetime (passing back to the
> system) to force the flush then.

Hm I think I overlooked that we only clear cache_dirty in
i915_gem_clflush_object when it's a coherent mode.

I also spotted more cases for (obj->cache_dirty
&~obj->cache_coherent), so that obscure/fragile pattern is
pre-existing :-/ One of them also checks outside of the object lock,
which I think is how these states are supposed to be protected. Smells
a bit fishy still, would be good to make a bit clearer.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
