Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1CF26BE5C
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgIPHmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgIPHmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:42:36 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CA5C06174A
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 00:42:34 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d4so1752069wmd.5
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 00:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ot6iZWd98YQr5mHaX8FXKQBw+IpUt9BsD4MskvvQqpo=;
        b=BJLaewkh1jJeIx94d5rS5o5OhiIfCBOn/m+CGOnQ3cN9D60IaKLC5G0C2QG+DU5jNq
         V1NdXeQKtmKS+bpl3GQfhqSH4nBVCtQjRuEmMA1r1vhnANHhawnanHGqicGnxufKJJF9
         5vyA6Iv7lx2D07L4+9YoIV1Zgk+GzL0p7995w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ot6iZWd98YQr5mHaX8FXKQBw+IpUt9BsD4MskvvQqpo=;
        b=diJJ3mE+EJ1BXKebOpqQUv2VicY8NFIwEGK89jNXmh3gEIqteVcnZ1kaYdtsLqRG3N
         +lwnYDIF1WMPQCgkYo3dfpLX4aZNs7WjvW0BsgX+5dVWSMmxXQo4UNzP/WKixopc70Wd
         3rwpopPOfraf83hgffDUQ8e35d6AidVJwlp5TMET05kYdA86smaJ2nH9TzHmjpv+yPH4
         a6bDMOuLtRt4rhtggWuMtEXxUYpfom0uq0r+dMSFoElvuHa2xypizGZ3oMUep2F3xxP4
         m6LjVTPJ991qS45G2awle08sJO75aCEwzj5LdA3TfTjYE2AaapOvC77LokV3bWzFkzwH
         Y9BQ==
X-Gm-Message-State: AOAM53352RviV+7mJxlb1zcnuQz4pqpajy29txfRXPBwUwVUMGDq/I9w
        3ncCvsRZcOXyOPNfcGh//moWaw==
X-Google-Smtp-Source: ABdhPJz3yMmR1XwOGajN+KW42rvNn/OWzNC/FWXYl3XGMATka4cMHZSootWZ6ul86yXqmajpNgIDFA==
X-Received: by 2002:a7b:c8c9:: with SMTP id f9mr3317002wml.67.1600242153009;
        Wed, 16 Sep 2020 00:42:33 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id y207sm4011619wmc.17.2020.09.16.00.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 00:42:32 -0700 (PDT)
Date:   Wed, 16 Sep 2020 09:42:30 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj.dadhania@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH 3/3] drm/i915/gem: Serialise debugfs
 i915_gem_objects with ctx->mutex
Message-ID: <20200916074230.GS438822@phenom.ffwll.local>
References: <20200723172119.17649-1-chris@chris-wilson.co.uk>
 <20200723172119.17649-3-chris@chris-wilson.co.uk>
 <5e7f2c00-c72e-46ff-defe-404b5a847a02@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7f2c00-c72e-46ff-defe-404b5a847a02@linux.intel.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 05:45:09PM +0100, Tvrtko Ursulin wrote:
> 
> On 23/07/2020 18:21, Chris Wilson wrote:
> > Since the debugfs may peek into the GEM contexts as the corresponding
> > client/fd is being closed, we may try and follow a dangling pointer.
> > However, the context closure itself is serialised with the ctx->mutex,
> > so if we hold that mutex as we inspect the state coupled in the context,
> > we know the pointers within the context are stable and will remain valid
> > as we inspect their tables.
> > 
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: CQ Tang <cq.tang@intel.com>
> > Cc: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >   drivers/gpu/drm/i915/i915_debugfs.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> > index 784219962193..ea469168cd44 100644
> > --- a/drivers/gpu/drm/i915/i915_debugfs.c
> > +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> > @@ -326,6 +326,7 @@ static void print_context_stats(struct seq_file *m,
> >   		}
> >   		i915_gem_context_unlock_engines(ctx);
> > +		mutex_lock(&ctx->mutex);
> >   		if (!IS_ERR_OR_NULL(ctx->file_priv)) {
> >   			struct file_stats stats = {
> >   				.vm = rcu_access_pointer(ctx->vm),
> > @@ -346,6 +347,7 @@ static void print_context_stats(struct seq_file *m,
> >   			print_file_stats(m, name, stats);
> >   		}
> > +		mutex_unlock(&ctx->mutex);
> >   		spin_lock(&i915->gem.contexts.lock);
> >   		list_safe_reset_next(ctx, cn, link);
> > 
> 
> Hm this apparently never got it's r-b and so got re-discovered in the field.
> +Nikunj
> 
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

I'm not super thrilled about patch 1 in this, for debugfs imo better to
wrangle this in the driver. And without patch 1 and 2 this wont fix a
whole lot.
-Daniel


> 
> Regards,
> 
> Tvrtko
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
