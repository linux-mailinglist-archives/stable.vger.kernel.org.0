Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C749B1B0437
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 10:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDTIVt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Apr 2020 04:21:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:18884 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgDTIVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 04:21:49 -0400
IronPort-SDR: ZCSVViqtBsoAZLANHkyf7ooVzcAjk4CQF7s5Ib/D1uBJRZOxBn+KTVXyw1+S77SfaMCdDx0zvC
 7NKnbPGoaALA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 01:21:48 -0700
IronPort-SDR: VftcpKwtEeA3P5jAsD0qeY0JUB3b0ewMhuRIXm8KrqnlVNM9jTn3h1VsNeDUl2x/j132iy1XLW
 c5WLlUsKUUCA==
X-IronPort-AV: E=Sophos;i="5.72,406,1580803200"; 
   d="scan'208";a="429041855"
Received: from jlahtine-desk.ger.corp.intel.com (HELO localhost) ([10.252.46.49])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 01:21:45 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200420052419.GA40250@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain> <20200407064007.7599-1-sultan@kerneltoast.com> <20200414061312.GA90768@sultan-box.localdomain> <158685263618.16269.9317893477736764675@build.alporthouse.com> <20200414144309.GB2082@sultan-box.localdomain> <20200420052419.GA40250@sultan-box.localdomain>
Subject: Re: [PATCH v4] drm/i915: Synchronize active and retire callbacks
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Sultan Alsawaf <sultan@kerneltoast.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Date:   Mon, 20 Apr 2020 11:21:42 +0300
Message-ID: <158737090265.8380.6644489879531344891@jlahtine-desk.ger.corp.intel.com>
User-Agent: alot/0.8.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sultan Alsawaf (2020-04-20 08:24:19)
> Chris,
> 
> Could you please look at this in earnest? This is a real bug that crashes my
> laptop without any kind of provocation. It is undeniably a bug in i915, and I've
> clearly described it in my patch. If you dont like the patch, I'm open to any
> suggestions you have for an alternative solution. My goal here is to make i915
> better, but it's difficult when communication only goes one way.

Hi Sultan,

The patch Chris pointed out was not part of 5.4 release. The commit
message describes that it fixes the functions to be tolerant to
running simultaneously. In doing that zeroing of ring->vaddr is
removed so the test to do mdelay(1) and "ring->vaddr = NULL;" is
not correct.

I think you might have used the wrong git command for checking the
patch history:

$ git describe a266bf420060
v5.4-rc7-1996-ga266bf420060 # after -rc7 tag

$ git describe --contains a266bf420060
v5.6-rc1~34^2~21^2~326 # included in v5.6-rc1

And git log to double check:

$ git log --format=oneline kernel.org/stable/linux-5.4.y --grep="drm/i915/gt: Make intel_ring_unpin() safe for concurrent pint"
$ git log --format=oneline kernel.org/stable/linux-5.5.y --grep="drm/i915/gt: Make intel_ring_unpin() safe for concurrent pint"
0725d9a31869e6c80630e99da366ede2848295cc drm/i915/gt: Make intel_ring_unpin() safe for concurrent pint
$ git log --format=oneline kernel.org/stable/linux-5.6.y --grep="drm/i915/gt: Make intel_ring_unpin() safe for concurrent pint"
a754012b9f2323a5d640da7eb7b095ac3b8cd012 drm/i915/execlists: Leave resetting ring to intel_ring
0725d9a31869e6c80630e99da366ede2848295cc drm/i915/gt: Make intel_ring_unpin() safe for concurrent pint
a266bf42006004306dd48a9082c35dfbff153307 drm/i915/gt: Make intel_ring_unpin() safe for concurrent pint

So it seems that the patch got pulled into v5.6 and has been backported
to v5.5 but not v5.4.

Could you try applying the patch to 5.4 and seeing if the problem
persists?

Regards, Joonas
