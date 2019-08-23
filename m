Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007139B769
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 21:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392124AbfHWTxi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 23 Aug 2019 15:53:38 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:57675 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392123AbfHWTxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 15:53:37 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 18244603-1500050 
        for multiple; Fri, 23 Aug 2019 20:53:34 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Lyude Paul <lyude@redhat.com>, intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190822203127.24648-1-lyude@redhat.com>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20190822203127.24648-1-lyude@redhat.com>
Message-ID: <156659001202.4019.17272565895689332680@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH v2 1/2] drm/i915: Call dma_set_max_seg_size() in
 i915_ggtt_probe_hw()
Date:   Fri, 23 Aug 2019 20:53:32 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Lyude Paul (2019-08-22 21:31:26)
> Currently, we don't call dma_set_max_seg_size() for i915 because we
> intentionally do not limit the segment length that the device supports.
> However, this results in a warning being emitted if we try to map
> anything larger than SZ_64K on a kernel with CONFIG_DMA_API_DEBUG_SG
> enabled:
> 
> [    7.751926] DMA-API: i915 0000:00:02.0: mapping sg segment longer
> than device claims to support [len=98304] [max=65536]
> [    7.751934] WARNING: CPU: 5 PID: 474 at kernel/dma/debug.c:1220
> debug_dma_map_sg+0x20f/0x340
> 
> This was originally brought up on
> https://bugs.freedesktop.org/show_bug.cgi?id=108517 , and the consensus
> there was it wasn't really useful to set a limit (and that dma-debug
> isn't really all that useful for i915 in the first place). Unfortunately
> though, CONFIG_DMA_API_DEBUG_SG is enabled in the debug configs for
> various distro kernels. Since a WARN_ON() will disable automatic problem
> reporting (and cause any CI with said option enabled to start
> complaining), we really should just fix the problem.
> 
> Note that as me and Chris Wilson discussed, the other solution for this
> would be to make DMA-API not make such assumptions when a driver hasn't
> explicitly set a maximum segment size. But, taking a look at the commit
> which originally introduced this behavior, commit 78c47830a5cb
> ("dma-debug: check scatterlist segments"), there is an explicit mention
> of this assumption and how it applies to devices with no segment size:
> 
>         Conversely, devices which are less limited than the rather
>         conservative defaults, or indeed have no limitations at all
>         (e.g. GPUs with their own internal MMU), should be encouraged to
>         set appropriate dma_parms, as they may get more efficient DMA
>         mapping performance out of it.
> 
> So unless there's any concerns (I'm open to discussion!), let's just
> follow suite and call dma_set_max_seg_size() with UINT_MAX as our limit
> to silence any warnings.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v4.18+
> ---
>  drivers/gpu/drm/i915/i915_gem_gtt.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
> index 0b81e0b64393..a1475039d182 100644
> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> @@ -3152,6 +3152,11 @@ static int ggtt_probe_hw(struct i915_ggtt *ggtt, struct intel_gt *gt)
>         if (ret)
>                 return ret;
>  
> +       /* We don't have a max segment size, so set it to the max so sg's
> +        * debugging layer doesn't complain
> +        */
> +       dma_set_max_seg_size(ggtt->vm.dma, UINT_MAX);

The rest of the dma setup is in i915_driver_hw_probe, so I would put it
there just after dma_set_coherent_mask() (maybe one day even being brave
enough to pull out those to their own function).

I think I've made my point about the futility of dma-debug and you've
made yours about the simplicity of the patch to shut it up, so move it
across and
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
