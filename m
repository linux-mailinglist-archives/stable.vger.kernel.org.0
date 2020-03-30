Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8119812D
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgC3Q1i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Mar 2020 12:27:38 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:65280 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726085AbgC3Q1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 12:27:38 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20742597-1500050 
        for multiple; Mon, 30 Mar 2020 17:27:29 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200330033057.2629052-3-sultan@kerneltoast.com>
References: <20200330033057.2629052-1-sultan@kerneltoast.com> <20200330033057.2629052-3-sultan@kerneltoast.com>
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Sultan Alsawaf <sultan@kerneltoast.com>
To:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915/gt: Schedule request retirement when timeline idles
From:   Chris Wilson <chris@chris-wilson.co.uk>
Message-ID: <158558564835.3228.8789679707542626662@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Mon, 30 Mar 2020 17:27:28 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sultan Alsawaf (2020-03-30 04:30:57)
> +static void engine_retire(struct work_struct *work)
> +{
> +       struct intel_engine_cs *engine =
> +               container_of(work, typeof(*engine), retire_work);
> +       struct intel_timeline *tl = xchg(&engine->retire, NULL);
> +
> +       do {
> +               struct intel_timeline *next = xchg(&tl->retire, NULL);
> +
> +               /*
> +                * Our goal here is to retire _idle_ timelines as soon as
> +                * possible (as they are idle, we do not expect userspace
> +                * to be cleaning up anytime soon).
> +                *
> +                * If the timeline is currently locked, either it is being
> +                * retired elsewhere or about to be!
> +                */

iirc the backport requires the retirement to be wrapped in struct_mutex

mutex_lock(&engine->i915->drm.struct_mutex);

> +               if (mutex_trylock(&tl->mutex)) {
> +                       retire_requests(tl);
> +                       mutex_unlock(&tl->mutex);
> +               }

mutex_unlock(&engine->i915->drm.struct_mutex);

Now the question is whether that was for 5.3 or 5.4. I think 5.3 is
where the changes were more severe and where we switch to the 4.19
approach.

> +               intel_timeline_put(tl);
> +
> +               GEM_BUG_ON(!next);
> +               tl = ptr_mask_bits(next, 1);
> +       } while (tl);
> +}
