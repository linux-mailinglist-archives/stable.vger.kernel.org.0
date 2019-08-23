Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32969AA76
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390622AbfHWIfc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 23 Aug 2019 04:35:32 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:49721 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391852AbfHWIfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 04:35:32 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 18236459-1500050 
        for multiple; Fri, 23 Aug 2019 09:35:24 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     "Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <073732E20AE4C540AE91DBC3F07D4460876D3410@SHSMSX107.ccr.corp.intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
References: <1566543451-13955-1-git-send-email-xiaolin.zhang@intel.com>
 <156654711627.27716.4474982727513548344@skylake-alporthouse-com>
 <073732E20AE4C540AE91DBC3F07D4460876D3410@SHSMSX107.ccr.corp.intel.com>
Message-ID: <156654932243.27716.13325423141754929364@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: to make vgpu ppgtt notificaiton as
 atomic operation
Date:   Fri, 23 Aug 2019 09:35:22 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Zhang, Xiaolin (2019-08-23 09:07:01)
> On 08/23/2019 03:58 PM, Chris Wilson wrote:
> > Quoting Xiaolin Zhang (2019-08-23 07:57:31)
> >> vgpu ppgtt notification was split into 2 steps, the first step is to
> >> update PVINFO's pdp register and then write PVINFO's g2v_notify register
> >> with action code to tirgger ppgtt notification to GVT side.
> >>
> >> currently these steps were not atomic operations due to no any protection,
> >> so it is easy to enter race condition state during the MTBF, stress and
> >> IGT test to cause GPU hang.
> >>
> >> the solution is to add a lock to make vgpu ppgtt notication as atomic
> >> operation.
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> >> ---
> >>  drivers/gpu/drm/i915/i915_drv.h     | 1 +
> >>  drivers/gpu/drm/i915/i915_gem_gtt.c | 4 ++++
> >>  drivers/gpu/drm/i915/i915_vgpu.c    | 1 +
> >>  3 files changed, 6 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> >> index eb31c16..32e17c4 100644
> >> --- a/drivers/gpu/drm/i915/i915_drv.h
> >> +++ b/drivers/gpu/drm/i915/i915_drv.h
> >> @@ -961,6 +961,7 @@ struct i915_frontbuffer_tracking {
> >>  };
> >>  
> >>  struct i915_virtual_gpu {
> >> +       struct mutex lock;
> >>         bool active;
> >>         u32 caps;
> >>  };
> >> diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
> >> index 2cd2dab..ff0b178 100644
> >> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> >> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> >> @@ -833,6 +833,8 @@ static int gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
> >>         enum vgt_g2v_type msg;
> >>         int i;
> >>  
> >> +       mutex_lock(&dev_priv->vgpu.lock);
> >> +
> >>         if (create)
> >>                 atomic_inc(px_used(ppgtt->pd)); /* never remove */
> >>         else
> >> @@ -860,6 +862,8 @@ static int gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
> >>  
> >>         I915_WRITE(vgtif_reg(g2v_notify), msg);
> >>  
> > How do you know the operation is complete and it is now safe to
> > overwrite the data regs?
> > -Chris
> >
> by design, the data reg value is copied out to use, so as long as the
> action and data is operated together, how long the operation is not a
> issue and  it is safe to overwrite the data regs with new action next time.

When and how quickly is it copied? Consider that it will be immediately
overwritten by the next packet. Does the vgpu mmio write cause the
calling CPU to be trapped?
-Chris
