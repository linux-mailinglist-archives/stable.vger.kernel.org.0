Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE01D198156
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgC3QfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 12:35:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42500 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbgC3QfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 12:35:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id h8so8900049pgs.9
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 09:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WQ+lNDSjrs6bHVHCI4B/2ehVc2E5l44ZeSm+HzaLnBY=;
        b=r2TdonHfcvO2WwleM/TEttBZl6mrZIx61HeONI9HLhEhexYxdMaxHizqyJAulLVvrz
         pSQVqRcO0USI2lngYfryWhek3SBK2rQsnBEM9Jz9Kr+fewR/wLkGKa8kFPGYI2YmDLGu
         L4bTeRscM2jgVSVx+PgCpPgIYrolSsQU3wECxNSmXvcrbtnjf7Q1Xq1o+2CnmFgxkS7C
         NGXF6a5hMhj+JSCds7kjLAUItgLoVgsf0MF96fqPT5yLed7Fm7mYJxnMrA+GT4MAOzqG
         6yXlhASaTMz8qjOhONZ2JUaZZjF+d8Gdqv/stRndkZOfNiogY3MAe+It1fJD8i8/ZS43
         K+6w==
X-Gm-Message-State: ANhLgQ3GkekDuPLIcmeqNrzap16Wpe1tKjM2C7Mt0V/L1GxLCLfxfdUF
        0vJY7DHn4zQ3xt98K2niM+c=
X-Google-Smtp-Source: ADFU+vuseSD4ITD2+tzP0HPXCYLaHGm07UOWO8gnV2AW+pTq5bV5b/FSxfnil9F78qzcA/6utFeH/Q==
X-Received: by 2002:a63:e607:: with SMTP id g7mr13324086pgh.303.1585586118171;
        Mon, 30 Mar 2020 09:35:18 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id o12sm30304pjt.16.2020.03.30.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:35:17 -0700 (PDT)
Date:   Mon, 30 Mar 2020 09:35:14 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: Re: [PATCH 2/2] drm/i915/gt: Schedule request retirement when
 timeline idles
Message-ID: <20200330163514.GA4184@sultan-box.localdomain>
References: <20200330033057.2629052-1-sultan@kerneltoast.com>
 <20200330033057.2629052-3-sultan@kerneltoast.com>
 <158558564835.3228.8789679707542626662@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158558564835.3228.8789679707542626662@build.alporthouse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 05:27:28PM +0100, Chris Wilson wrote:
> Quoting Sultan Alsawaf (2020-03-30 04:30:57)
> > +static void engine_retire(struct work_struct *work)
> > +{
> > +       struct intel_engine_cs *engine =
> > +               container_of(work, typeof(*engine), retire_work);
> > +       struct intel_timeline *tl = xchg(&engine->retire, NULL);
> > +
> > +       do {
> > +               struct intel_timeline *next = xchg(&tl->retire, NULL);
> > +
> > +               /*
> > +                * Our goal here is to retire _idle_ timelines as soon as
> > +                * possible (as they are idle, we do not expect userspace
> > +                * to be cleaning up anytime soon).
> > +                *
> > +                * If the timeline is currently locked, either it is being
> > +                * retired elsewhere or about to be!
> > +                */
> 
> iirc the backport requires the retirement to be wrapped in struct_mutex
> 
> mutex_lock(&engine->i915->drm.struct_mutex);
> 
> > +               if (mutex_trylock(&tl->mutex)) {
> > +                       retire_requests(tl);
> > +                       mutex_unlock(&tl->mutex);
> > +               }
> 
> mutex_unlock(&engine->i915->drm.struct_mutex);
> 
> Now the question is whether that was for 5.3 or 5.4. I think 5.3 is
> where the changes were more severe and where we switch to the 4.19
> approach.
> 
> > +               intel_timeline_put(tl);
> > +
> > +               GEM_BUG_ON(!next);
> > +               tl = ptr_mask_bits(next, 1);
> > +       } while (tl);
> > +}

In 5.4, the existing retirement instances don't hold
`&engine->i915->drm.struct_mutex`, however it is held in 5.3. So it looks like
this is fine as-is for 5.4.

Sultan
