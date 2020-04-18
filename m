Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17541AEBD4
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgDRKa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 06:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgDRKa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 06:30:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 731B821D79;
        Sat, 18 Apr 2020 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587205825;
        bh=C6/sEpG/uEMZxVgCoKuNJdQO4jMJV0m3Mqan9Va5s1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i0JsSAwZAWpQQZ4pga2hR9KRTRYAtoV93keiHJpK7ajIn6mIgOL2jBdcoRAsmq+1x
         HYWozPPEyrWFursruqm7FRKF7U8DlGf9yTjGQ/4LK9bWnPxV3WnIn752Ku0oJXNWOJ
         BfvUBQcWwYichxUvKgGJgFOliQc1Jk2CqEkbBvvk=
Date:   Sat, 18 Apr 2020 12:30:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] drm/i915/gt: Schedule request retirement when
 timeline idles
Message-ID: <20200418103023.GB2816412@kroah.com>
References: <20200413152344.GA2300@sultan-box.localdomain>
 <20200413152930.2930-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413152930.2930-1-sultan@kerneltoast.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 08:29:30AM -0700, Sultan Alsawaf wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> commit 4f88f8747fa43c97c3b3712d8d87295ea757cc51 upstream.
> 
> The major drawback of commit 7e34f4e4aad3 ("drm/i915/gen8+: Add RC6 CTX
> corruption WA") is that it disables RC6 while Skylake (and friends) is
> active, and we do not consider the GPU idle until all outstanding
> requests have been retired and the engine switched over to the kernel
> context. If userspace is idle, this task falls onto our background idle
> worker, which only runs roughly once a second, meaning that userspace has
> to have been idle for a couple of seconds before we enable RC6 again.
> Naturally, this causes us to consume considerably more energy than
> before as powersaving is effectively disabled while a display server
> (here's looking at you Xorg) is running.
> 
> As execlists will get a completion event as each context is completed,
> we can use this interrupt to queue a retire worker bound to this engine
> to cleanup idle timelines. We will then immediately notice the idle
> engine (without userspace intervention or the aid of the background
> retire worker) and start parking the GPU. Thus during light workloads,
> we will do much more work to idle the GPU faster...  Hopefully with
> commensurate power saving!
> 
> v2: Watch context completions and only look at those local to the engine
> when retiring to reduce the amount of excess work we perform.
> 
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112315
> References: 7e34f4e4aad3 ("drm/i915/gen8+: Add RC6 CTX corruption WA")
> References: 2248a28384fe ("drm/i915/gen8+: Add RC6 CTX corruption WA")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20191125105858.1718307-3-chris@chris-wilson.co.uk
> [Sultan: for the backport to 5.4, struct_mutex needs to be held while
>  retiring so that retirement doesn't race with vma destruction.]
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> ---
>  drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  2 +
>  drivers/gpu/drm/i915/gt/intel_engine_types.h  |  8 ++
>  drivers/gpu/drm/i915/gt/intel_lrc.c           |  8 ++
>  drivers/gpu/drm/i915/gt/intel_timeline.c      |  1 +
>  .../gpu/drm/i915/gt/intel_timeline_types.h    |  3 +
>  drivers/gpu/drm/i915/i915_request.c           | 75 +++++++++++++++++++
>  drivers/gpu/drm/i915/i915_request.h           |  4 +
>  7 files changed, 101 insertions(+)

Why are you not cc:ing all of the relevant people on these patches?
That's not ok, I'm just going to drop all of these requests until that
happens, and I get an ack from the developers/maintainers involved.

thanks,

greg k-h
