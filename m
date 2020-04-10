Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E90D1A4735
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 16:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgDJOPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 10:15:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44448 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgDJOPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 10:15:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id n13so1021797pgp.11
        for <stable@vger.kernel.org>; Fri, 10 Apr 2020 07:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xO1FGU/icOILvFWOuncN4qsCUUWcHUB8OtOA1cu0N2s=;
        b=madjR8lVVZWyxrotIaHC0bT7FQ2An1oDP3ZXfBfiILzK4xThy0fM1zhiX7VVmdyK3H
         gNBIHZrdhbrCiJXzq/zYD2s1e9tE1x5v4YS8v2cjYSQuSblt0ydKI2Xw66nAFNHjm54d
         yBbwnbU8nzSx+vllURI3zBEkd7p+qY/pMhdmvsPI3tgyXw3UCxReqB2lwwX1fPObnVX3
         j1CS6wA7oCL9jjw3AGF0Rjd18AXgK5wKrjV+aJzaYE/oWlQUFtR4JBNyZoUvxDcAqUmW
         uaM+rIVwCbtNVpajzEwZEgDFIm+JCU46Cq29tsp+hV/IbymG9aazFmlGE+2pN1pQz3oF
         iKoA==
X-Gm-Message-State: AGi0PuYgHG0rI3hd+ap+sDRzVZ+I6bmfmvIlJXyPgWmj9ZLuSHNoB9X8
        KxRhjiBhc4cfqZkrHuUCXZo=
X-Google-Smtp-Source: APiQypJSCa9K9MnX8xss6uk3WdmwEdOYIYI5gQFTkBUq5NrSTxzecl4NUnAlt9445YegA/m/FHQj1Q==
X-Received: by 2002:a65:53cf:: with SMTP id z15mr4747258pgr.367.1586528112467;
        Fri, 10 Apr 2020 07:15:12 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id t126sm902648pfb.29.2020.04.10.07.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 07:15:11 -0700 (PDT)
Date:   Fri, 10 Apr 2020 07:15:08 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] drm/i915: Fix ref->mutex deadlock in
 i915_active_wait()
Message-ID: <20200410141508.GA2025@sultan-box.localdomain>
References: <20200407065210.GA263852@kroah.com>
 <20200407071809.3148-1-sultan@kerneltoast.com>
 <20200410090838.GD1691838@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410090838.GD1691838@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 10, 2020 at 11:08:38AM +0200, Greg KH wrote:
> On Tue, Apr 07, 2020 at 12:18:09AM -0700, Sultan Alsawaf wrote:
> > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > 
> > The following deadlock exists in i915_active_wait() due to a double lock
> > on ref->mutex (call chain listed in order from top to bottom):
> >  i915_active_wait();
> >  mutex_lock_interruptible(&ref->mutex); <-- ref->mutex first acquired
> >  i915_active_request_retire();
> >  node_retire();
> >  active_retire();
> >  mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING); <-- DEADLOCK
> > 
> > Fix the deadlock by skipping the second ref->mutex lock when
> > active_retire() is called through i915_active_request_retire().
> > 
> > Note that this bug only affects 5.4 and has since been fixed in 5.5.
> > Normally, a backport of the fix from 5.5 would be in order, but the
> > patch set that fixes this deadlock involves massive changes that are
> > neither feasible nor desirable for backporting [1][2][3]. Therefore,
> > this small patch was made to address the deadlock specifically for 5.4.
> > 
> > [1] 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
> > [2] 093b92287363 ("drm/i915: Split i915_active.mutex into an irq-safe spinlock for the rbtree")
> > [3] 750bde2fd4ff ("drm/i915: Serialise with remote retirement")
> > 
> > Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
> > Cc: <stable@vger.kernel.org> # 5.4.x
> > Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> > ---
> >  drivers/gpu/drm/i915/i915_active.c | 27 +++++++++++++++++++++++----
> >  drivers/gpu/drm/i915/i915_active.h |  4 ++--
> >  2 files changed, 25 insertions(+), 6 deletions(-)
> 
> Now queued up, thanks.
> 
> greg k-h

Hi Greg,

Thanks for queuing this! However, you queued the v1 version of the patch instead
of v2. Please pick the v2 version instead.

Thanks,
Sultan
