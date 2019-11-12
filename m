Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16518F8B65
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 10:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfKLJJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 04:09:19 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39818 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLJJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 04:09:19 -0500
Received: by mail-ot1-f65.google.com with SMTP id z9so536884otq.6
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 01:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHPKlhKO7XCkjzMpQFqzFclixAEBxx1FP1Cib9aUIt0=;
        b=dIMZSpm21n4Lvj7LNSVE3iXH8GIQCXuc3mlVLSXlQsySgf7fipjpWs11JR1/RPRcI9
         N/Ip5mFgfWkRU+kPigYweaN9SrtcqiGMLihWrALL4n4IKxnX0Ct+UuZV1ML5Xg6T3wwf
         5jcjaq2dc6AUDFu+sgoabnCxikipL9632C0Y8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHPKlhKO7XCkjzMpQFqzFclixAEBxx1FP1Cib9aUIt0=;
        b=AGD12lNiUiQilQYURzBxRJIWSr+CW9JBujSdtu0UMrMsK+sxzcpzpuyUclP8E4jPV+
         ymeZpK6cxHflgpEYoJBba8XAOgsOk3Byz0HuAtHlfvG40LgEMJvlh02eKGCXnwEAgniI
         y2LMctYmR5pfscYFYjkr5fEZ4tdkj3sQ5QI76hdv+LSIp2Ri0VZSTbs1LLj+nOzb5nYs
         TeEQaup9h7WApsGcTMkhpHlqsaWLR3IloY7eFwxN1EermnJ+df6USBRdoSmB71qNCvaX
         mKYDmSnnD2KR9n55QsVJEPGyZhYkouPwARvc0cG/b+pbhp+BGg46NzBGexJIrNb9n8D8
         Ptyg==
X-Gm-Message-State: APjAAAU++IR9C0+TSBPlDa+INc4pSLayEib+HG4Tb6wnK5dSh1myW/vD
        RBidk3CvU1HwHGPvjyHJzQ0OsfMcT+c7CAB2N3kqoA==
X-Google-Smtp-Source: APXvYqxWSUfmQNdvctBvqvm85EKWYdHBsiXYTCfi0ftmMPCvgtA2sF1Cv5gyecUpE0AbnZ8p5aLaaGfCRxKiYiPvMQo=
X-Received: by 2002:a9d:6649:: with SMTP id q9mr8533283otm.106.1573549758145;
 Tue, 12 Nov 2019 01:09:18 -0800 (PST)
MIME-Version: 1.0
References: <20190718145407.21352-1-chris@chris-wilson.co.uk> <20190718145407.21352-4-chris@chris-wilson.co.uk>
In-Reply-To: <20190718145407.21352-4-chris@chris-wilson.co.uk>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 12 Nov 2019 10:09:06 +0100
Message-ID: <CAKMK7uEgFS8FAatJBzsEid72sy2_h8x2WsyhsZuyyfaoD1Lg0Q@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 4/4] drm/i915: Flush stale cachelines on set-cache-level
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Francisco Jerez <currojerez@riseup.net>
Cc:     intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 4:54 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Ensure that we flush any cache dirt out to main memory before the user
> changes the cache-level as they may elect to bypass the cache (even after
> declaring their access cache-coherent) via use of unprivileged MOCS.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_domain.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> index 2e3ce2a69653..5d41e769a428 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> @@ -277,6 +277,11 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
>
>         list_for_each_entry(vma, &obj->vma.list, obj_link)
>                 vma->node.color = cache_level;
> +
> +       /* Flush any previous cache dirt in case of cache bypass */
> +       if (obj->cache_dirty & ~obj->cache_coherent)
> +               i915_gem_clflush_object(obj, I915_CLFLUSH_SYNC);

I think writing out the bit logic instead of implicitly relying on the
#defines would be much better, i.e. && !(cache_coherent &
COHERENT_FOR_READ). Plus I think we only need to set cache_dirty =
true if we don't flush here already, to avoid double flushing?
-Daniel

> +
>         i915_gem_object_set_cache_coherency(obj, cache_level);
>         obj->cache_dirty = true; /* Always invalidate stale cachelines */
>
> --
> 2.22.0
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
