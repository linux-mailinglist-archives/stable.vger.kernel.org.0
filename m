Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427611A4746
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 16:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgDJORm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 10:17:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37253 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgDJORm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 10:17:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id u65so1105668pfb.4
        for <stable@vger.kernel.org>; Fri, 10 Apr 2020 07:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=phSmRmK8df1FHnQ5vNeBAAQ75z9yd9I/uZBVXE2qr20=;
        b=JJ3cmeqC55Z864BmdE9QNPwjAEzPNTKJ3Kadgen4vwqWZXJdd2pv/sgrUGjhFI0fBE
         CE8FOu61KpzNji6jSItw9c5w7WdcwE8G9WonZfMuytvVp+oD5LalRvNfN9c4M+ZHIPNo
         Z5yo55CUqXQvCQcd8LS6URgh8qiuNlB3GvhojNYuMI3+vcbZFzOUDXH9olEnLiqh17tN
         LFMRPW68mbYEeRZUN4Rhs0AD7QnNXEW72MFt3Xn/0r6Va7asIfnxRYStsJ3S4Aa4Ph1O
         sPHIF9RY/FSEQRN35CwVdjNFop7hzJhUhQGTyneZvTdFyOLfQcKJCVbAZdcQEXem3lD5
         mQjA==
X-Gm-Message-State: AGi0PubDOSVYR2mlR9Jj8td9rux1/IrsJm8jqLN8PdyyUbNmj2ASsUAt
        MtvD9mAoROyr5WY4K7UCBBw=
X-Google-Smtp-Source: APiQypJeGWMtEkYgrzBPjdIl7sj2PdpafWKmiZDlFKA/qWp0FO3nWji0ifyG/uz4StCCWE0/jA2S/g==
X-Received: by 2002:a63:f403:: with SMTP id g3mr4880072pgi.47.1586528262067;
        Fri, 10 Apr 2020 07:17:42 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id s9sm1841879pjr.5.2020.04.10.07.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 07:17:41 -0700 (PDT)
Date:   Fri, 10 Apr 2020 07:17:38 -0700
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
Message-ID: <20200410141738.GB2025@sultan-box.localdomain>
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

I'm sorry, I meant the v3 [1]. Apologies for the confusion. The v3 was picked
into Ubuntu so that's what we're rolling with.

Thanks,
Sultan

[1] https://lore.kernel.org/stable/20200407203222.2493-1-sultan@kerneltoast.com
