Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48871A806B
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405210AbgDNOwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:52:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36796 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405206AbgDNOwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:52:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id n10so27166pff.3
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 07:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4WBdHUkYY7smG8N50aarxY/4v+FvQTuqufQXoC73mFQ=;
        b=cn0DIfjbaJePcV6EX1Gzht5z3FJbnybnV433bigLoe4SgtxuTk5CzpGzsrpn+2BUYF
         tGih9XguwwC5iCdgNgAEomKnxK43Vn7hCwGFZEompiv543KFo/PHgNdGHaHl1SOPLXZV
         hNEo7iqXezwts3sqY99MILrSs1TaolHZZOXOuZeNnmrpHx9cCy9zb9yj7+g2nuOz16n0
         w3E7JhLaSk7voso+rs7jfCcviNaUHHB5ny5+fdUa7F2K07iVt46A49F3isUDPMFkvKf7
         ykyhHHjbd95PcWn+a59L/evsQZ74JVGcdyPH1qJx2fMDa4xzyTG7/o6nQjOLODAB9HIF
         4Hbw==
X-Gm-Message-State: AGi0PubE6dXfTZuHzfVMYT1nTH4Zpo7VJoxjPtuBV3dOkee8mhuh58RN
        Bliq7wtqRm1W986DXoXcLOs=
X-Google-Smtp-Source: APiQypLsvkblz51WUZpaRhQYiOLEZSBo6rwtEWCpFLomKuFySQ2et7hfOCSdy26kKt9i4WSgUjZekA==
X-Received: by 2002:a63:2cce:: with SMTP id s197mr23209940pgs.184.1586875937101;
        Tue, 14 Apr 2020 07:52:17 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id i190sm9442055pfc.119.2020.04.14.07.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:52:16 -0700 (PDT)
Date:   Tue, 14 Apr 2020 07:52:13 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: Fix ref->mutex deadlock in
 i915_active_wait()
Message-ID: <20200414145213.GC2082@sultan-box.localdomain>
References: <20200407062622.6443-1-sultan@kerneltoast.com>
 <20200407062622.6443-2-sultan@kerneltoast.com>
 <158685200854.16269.9481176231557533815@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158685200854.16269.9481176231557533815@build.alporthouse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 09:13:28AM +0100, Chris Wilson wrote:
> Quoting Sultan Alsawaf (2020-04-07 07:26:22)
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
> > Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
> > Cc: <stable@vger.kernel.org> # 5.4.x
> > Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> Incorrect. 
> 
> You missed that it cannot retire from inside the wait due to the active
> reference held on the i915_active for the wait.
> 
> The only point it can enter retire from inside i915_active_wait() is via
> the terminal __active_retire() which releases the mutex in doing so.
> -Chris

The terminal __active_retire() and rbtree_postorder_for_each_entry_safe() loop
retire different objects, so this isn't true.

Sultan
