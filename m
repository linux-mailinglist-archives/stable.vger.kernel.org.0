Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10614980F7
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 19:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfHUREd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 21 Aug 2019 13:04:33 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:63572 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726828AbfHUREd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 13:04:33 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 18217451-1500050 
        for multiple; Wed, 21 Aug 2019 18:04:30 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Xiong Zhang <xiong.y.zhang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190821033556.GA11927@zhen-hp.sh.intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
References: <1566279978-9659-1-git-send-email-xiong.y.zhang@intel.com>
 <20190821033556.GA11927@zhen-hp.sh.intel.com>
Message-ID: <156640706795.20466.7242407780817145904@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Don't deballoon unused ggtt
 drm_mm_node in linux guest
Date:   Wed, 21 Aug 2019 18:04:27 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Zhenyu Wang (2019-08-21 04:35:56)
> On 2019.08.20 13:46:17 +0800, Xiong Zhang wrote:
> > The following call trace may exist in linux guest dmesg when guest i915
> > driver is unloaded.
> > [   90.776610] [drm:vgt_deballoon_space.isra.0 [i915]] deballoon space: range [0x0 - 0x0] 0 KiB.
> > [   90.776621] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c0
> > [   90.776691] IP: drm_mm_remove_node+0x4d/0x320 [drm]
> > [   90.776718] PGD 800000012c7d0067 P4D 800000012c7d0067 PUD 138e4c067 PMD 0
> > [   90.777091] task: ffff9adab60f2f00 task.stack: ffffaf39c0fe0000
> > [   90.777142] RIP: 0010:drm_mm_remove_node+0x4d/0x320 [drm]
> > [   90.777573] Call Trace:
> > [   90.777653]  intel_vgt_deballoon+0x4c/0x60 [i915]
> > [   90.777729]  i915_ggtt_cleanup_hw+0x121/0x190 [i915]
> > [   90.777792]  i915_driver_unload+0x145/0x180 [i915]
> > [   90.777856]  i915_pci_remove+0x15/0x20 [i915]
> > [   90.777890]  pci_device_remove+0x3b/0xc0
> > [   90.777916]  device_release_driver_internal+0x157/0x220
> > [   90.777945]  driver_detach+0x39/0x70
> > [   90.777967]  bus_remove_driver+0x51/0xd0
> > [   90.777990]  pci_unregister_driver+0x23/0x90
> > [   90.778019]  SyS_delete_module+0x1da/0x240
> > [   90.778045]  entry_SYSCALL_64_fastpath+0x24/0x87
> > [   90.778072] RIP: 0033:0x7f34312af067
> > [   90.778092] RSP: 002b:00007ffdea3da0d8 EFLAGS: 00000206
> > [   90.778297] RIP: drm_mm_remove_node+0x4d/0x320 [drm] RSP: ffffaf39c0fe3dc0
> > [   90.778344] ---[ end trace f4b1bc8305fc59dd ]---
> > 
> > Four drm_mm_node are used to reserve guest ggtt space, but some of them
> > may be skipped and not initialised due to space constraints in
> > intel_vgt_balloon(). If drm_mm_remove_node() is called with
> > uninitialized drm_mm_node, the above call trace occurs.
> > 
> > This patch check drm_mm_node's validity before calling
> > drm_mm_remove_node().
> > 
> > Fixes: ff8f797557c7("drm/i915: return the correct usable aperture size under gvt environment")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> > ---
> >  drivers/gpu/drm/i915/i915_vgpu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_vgpu.c b/drivers/gpu/drm/i915/i915_vgpu.c
> > index bf2b837..d2fd66f 100644
> > --- a/drivers/gpu/drm/i915/i915_vgpu.c
> > +++ b/drivers/gpu/drm/i915/i915_vgpu.c
> > @@ -119,6 +119,9 @@ static struct _balloon_info_ bl_info;
> >  static void vgt_deballoon_space(struct i915_ggtt *ggtt,
> >                               struct drm_mm_node *node)
> >  {
> > +     if (!node->allocated)
> > +             return;
> > +
> >       DRM_DEBUG_DRIVER("deballoon space: range [0x%llx - 0x%llx] %llu KiB.\n",
> >                        node->start,
> >                        node->start + node->size,
> 
> Searching shows this is pretty old one and also with r-b from Chris,
> but be ignored that nobody picked this up..
> 
> I think I hit this once too and tried to fix it another way,
> but this looks simpler to me.
> 
> Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>

Better late than never, I guess. Thanks for the patch and checking it
over, pushed.
-Chris
