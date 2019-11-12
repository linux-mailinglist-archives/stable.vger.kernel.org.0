Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9C0F8F4C
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 13:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKLMIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 07:08:51 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37804 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKLMIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 07:08:51 -0500
Received: by mail-ot1-f67.google.com with SMTP id d5so14089504otp.4
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 04:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OUN6Grlj3r+JUTZHCXOHHAU/NbGv44gvlcRy+k3pSHk=;
        b=RmGR38IYKbiIxal/+Dz6A8YenRRTKIyPoln3q+lhgdFr1ekEQuJcVQ9k3bSQOFkuQf
         oAFc66FTa57xnu/Cs4i2MZeh5uaoJ9fzH60cQTeWuRXyF6B1mJOG+bu6f2lZm4gbkUkA
         uoFAyKBMLxKQI9J7MTMhIzv7Gl0vtAK54eLe0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUN6Grlj3r+JUTZHCXOHHAU/NbGv44gvlcRy+k3pSHk=;
        b=RMcECLnAynPKYRLtPrAUjrW4aRiYp1+VXKJbKN4+SMZM7ygVFk9hZrxsWQjeIMj3Cq
         6jsDPfVCZzbOJWXkXMXMpGqWRTkP1VSMAPNmNiKpFUk3DLQkKWW1JsgCX0z3BbvR6Zln
         VLWijJBuZPmmtcIKFDdqFSLZPYIPboH+dnb86W+vFjeGVyUfYZBTTHM0a0jXgC1PDh46
         4KidwNgVQ+YMIY/0cVWMg79IBrpUuHjk+Z2WxbNAFZf7pR9v67k9oeRjVXO+zeRhJy3I
         udMO2qrFP0Faw0TzZcyKoIbLjmv/j9Dfp1G0uVvKsIBnwe/uhGtefj/gwxj+U9/7Svbb
         UHMg==
X-Gm-Message-State: APjAAAU9BOp8IlZkg6WofpCJV4eCKlhtgE/w8Hy6RMOUIM00CEz9LFVh
        abIoTMZ0SiJrtPytHl3dRDelE/lD5JVNZlRskm3qqg==
X-Google-Smtp-Source: APXvYqzEF3E6/uOIEbhv+KGFTcI55Is+WI6005Nr+Xu5QQ5Gr3PG7l8SkEl8TPYqY8kwEVbh9tflH7XeGvXTGu2QDzw=
X-Received: by 2002:a05:6830:1649:: with SMTP id h9mr26387549otr.281.1573560529975;
 Tue, 12 Nov 2019 04:08:49 -0800 (PST)
MIME-Version: 1.0
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
 <20190718145407.21352-4-chris@chris-wilson.co.uk> <CAKMK7uEgFS8FAatJBzsEid72sy2_h8x2WsyhsZuyyfaoD1Lg0Q@mail.gmail.com>
 <157355174344.9322.13853897964725973571@skylake-alporthouse-com> <CAKMK7uE8fjc3OXhAnESs-w=fqPhmJUUFOF_n_bKETFaQiQw+GA@mail.gmail.com>
In-Reply-To: <CAKMK7uE8fjc3OXhAnESs-w=fqPhmJUUFOF_n_bKETFaQiQw+GA@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 12 Nov 2019 13:08:38 +0100
Message-ID: <CAKMK7uHwoff5+GHEfswsvgCzSAAnZgtYu0hE_JQU9_86PeTN4Q@mail.gmail.com>
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

On Tue, Nov 12, 2019 at 11:57 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Tue, Nov 12, 2019 at 10:43 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > Quoting Daniel Vetter (2019-11-12 09:09:06)
> > > On Thu, Jul 18, 2019 at 4:54 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > > >
> > > > Ensure that we flush any cache dirt out to main memory before the user
> > > > changes the cache-level as they may elect to bypass the cache (even after
> > > > declaring their access cache-coherent) via use of unprivileged MOCS.
> > > >
> > > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  drivers/gpu/drm/i915/gem/i915_gem_domain.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > > > index 2e3ce2a69653..5d41e769a428 100644
> > > > --- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > > > +++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > > > @@ -277,6 +277,11 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
> > > >
> > > >         list_for_each_entry(vma, &obj->vma.list, obj_link)
> > > >                 vma->node.color = cache_level;
> > > > +
> > > > +       /* Flush any previous cache dirt in case of cache bypass */
> > > > +       if (obj->cache_dirty & ~obj->cache_coherent)
> > > > +               i915_gem_clflush_object(obj, I915_CLFLUSH_SYNC);
> > >
> > > I think writing out the bit logic instead of implicitly relying on the
> > > #defines would be much better, i.e. && !(cache_coherent &
> > > COHERENT_FOR_READ). Plus I think we only need to set cache_dirty =
> > > true if we don't flush here already, to avoid double flushing?
> >
> > No. The mask is being updated, so you need to flush before you lose
> > track. The cache is then cleared of the dirty bit so won't be flushed
> > again until dirty and no longer coherent. We need to flag that the page
> > is no longer coherent at the end of its lifetime (passing back to the
> > system) to force the flush then.
>
> Hm I think I overlooked that we only clear cache_dirty in
> i915_gem_clflush_object when it's a coherent mode.

Hm, the clear/blt code recently merged doesn't preserve the
->cache_dirty setting for this case, unlike clfush_object. Do we have
a bug there?

> I also spotted more cases for (obj->cache_dirty
> &~obj->cache_coherent), so that obscure/fragile pattern is
> pre-existing :-/ One of them also checks outside of the object lock,
> which I think is how these states are supposed to be protected. Smells
> a bit fishy still, would be good to make a bit clearer.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
