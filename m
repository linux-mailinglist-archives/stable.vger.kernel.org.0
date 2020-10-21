Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62034294D7C
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 15:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409713AbgJUN1C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 21 Oct 2020 09:27:02 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:63962 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409707AbgJUN1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 09:27:02 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22765843-1500050 
        for multiple; Wed, 21 Oct 2020 14:26:51 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201021131443.25616-1-ville.syrjala@linux.intel.com>
References: <20201021131443.25616-1-ville.syrjala@linux.intel.com>
Subject: Re: [PATCH 1/5] drm/i915: Restore ILK-M RPS support
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Wed, 21 Oct 2020 14:26:49 +0100
Message-ID: <160328680949.24927.6953743823876644711@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ville Syrjala (2020-10-21 14:14:39)
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Restore RPS for ILK-M. We lost it when an extra HAS_RPS()
> check appeared in intel_rps_enable().
> 
> Unfortunaltey this just makes the performance worse on my
> ILK because intel_ips insists on limiting the GPU freq to
> the minimum. If we don't do the RPS init then intel_ips will
> not limit the frequency for whatever reason. Either it can't
> get at some required information and thus makes wrong decisions,
> or we mess up some weights/etc. and cause it to make the wrong
> decisions when RPS init has been done, or the entire thing is
> just wrong. Would require a bunch of reverse engineering to
> figure out what's going on.
> 
> Cc: stable@vger.kernel.org
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Fixes: 9c878557b1eb ("drm/i915/gt: Use the RPM config register to determine clk frequencies")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/i915_pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
> index 27964ac0638a..1fe390727d80 100644
> --- a/drivers/gpu/drm/i915/i915_pci.c
> +++ b/drivers/gpu/drm/i915/i915_pci.c
> @@ -389,6 +389,7 @@ static const struct intel_device_info ilk_m_info = {
>         GEN5_FEATURES,
>         PLATFORM(INTEL_IRONLAKE),
>         .is_mobile = 1,
> +       .has_rps = true,

Oops.

Too bad we have to fight with ips, but presumably it makes some
workloads better, and more importantly restores our previous behaviour.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
