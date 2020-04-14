Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2BA1A800B
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403970AbgDNOnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:43:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42749 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403941AbgDNOnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:43:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id g6so6081794pgs.9;
        Tue, 14 Apr 2020 07:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ISpaCA7mjN5YjkHYISL3HSq+S++mjTHZ6Lu/DzWzgxg=;
        b=TIBdpUNc4hD0uk2v2NBi0PeszdnyJON+rnJHdFQYgr7JrMXnHxSIUDHPJEsI5+bkvp
         R9xbA1No7G+7LpEFf09bDylFQEBEXryTs3dLX4zC7cF2sU0K3pJr1Z6IONZj0F0zj117
         eyDvkJrc5O/1oH+nYUdEPJ2WFI2TISRfMhJIdPxWqUOlXgDNOUN7iMIMCU80XS34dWAO
         NcscPxY+EDhcCEt5EXB9W2PbEN4d+2kH6edPtktidRl+Uf9QHEDt8qEe1Md0wbxj/TLm
         Leekl/OsI3ILhn5e5R2agXIL0mThBAy6AAsQ6RsgBHCa+rddZnHeizT906kmgMI603Dm
         KqzA==
X-Gm-Message-State: AGi0PubPgpMjmatSIfg87sg+HzWp/Rx5hN2+JFPjeq+KFymRZ4FZE4fc
        zVw1McGY9DFuzhJo2odXV7Y=
X-Google-Smtp-Source: APiQypKYnkcJwA8lBILHDaTEYsu7MMvchjuIIOFNWKTQsueYRWsxR236WZye6IlT0+1XV9h4RXp4Tg==
X-Received: by 2002:a63:ec44:: with SMTP id r4mr21490047pgj.425.1586875395070;
        Tue, 14 Apr 2020 07:43:15 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id y123sm11056229pfb.13.2020.04.14.07.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:43:14 -0700 (PDT)
Date:   Tue, 14 Apr 2020 07:43:09 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] drm/i915: Synchronize active and retire callbacks
Message-ID: <20200414144309.GB2082@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain>
 <20200407064007.7599-1-sultan@kerneltoast.com>
 <20200414061312.GA90768@sultan-box.localdomain>
 <158685263618.16269.9317893477736764675@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158685263618.16269.9317893477736764675@build.alporthouse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 09:23:56AM +0100, Chris Wilson wrote:
> Quoting Sultan Alsawaf (2020-04-14 07:13:12)
> > Chris,
> > 
> > Could you please take a look at this? This really is quite an important fix.
> 
> It's crazy. See a266bf420060 for a patch that should be applied to v5.4
> -Chris

What? a266bf420060 was part of 5.4.0-rc7, so it's already in 5.4. And if you
read the commit message, you would see that the problem in question affects
Linus' tree.

You can break i915 in 5.6 by just adding a small delay:

diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 6ff803f397c4..3a7968effdfd 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -10,6 +10,7 @@
 #include "intel_engine.h"
 #include "intel_ring.h"
 #include "intel_timeline.h"
+#include <linux/delay.h>
 
 unsigned int intel_ring_update_space(struct intel_ring *ring)
 {
@@ -92,6 +93,9 @@ void intel_ring_unpin(struct intel_ring *ring)
 	else
 		i915_gem_object_unpin_map(vma->obj);
 
+	mdelay(1);
+	ring->vaddr = NULL;
+
 	i915_vma_make_purgeable(vma);
 	i915_vma_unpin(vma);
 }

This is how I reproduced the race in question. I can't even reach the greeter on
my laptop with this, because i915 dies before that.

Sultan
