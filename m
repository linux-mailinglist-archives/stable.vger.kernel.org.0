Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AD02A07B5
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgJ3OUD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 30 Oct 2020 10:20:03 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:53714 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725975AbgJ3OUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 10:20:03 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22845286-1500050 
        for multiple; Fri, 30 Oct 2020 14:19:46 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201022194256.30978-1-ville.syrjala@linux.intel.com>
References: <20201022194256.30978-1-ville.syrjala@linux.intel.com>
Subject: Re: [PATCH] drm/modes: Switch to 64bit maths to avoid integer overflow
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Date:   Fri, 30 Oct 2020 14:19:45 +0000
Message-ID: <160406758530.15070.9622609556730885347@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ville Syrjala (2020-10-22 20:42:56)
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> The new >8k CEA modes have dotclocks reaching 5.94 GHz, which
> means our clock*1000 will now overflow the 32bit unsigned
> integer. Switch to 64bit maths to avoid it.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
> An interesting question how many other place might suffer from similar
> overflows. I think i915 should be mostly OK. The one place I know we use
> Hz instead kHz is the hsw DPLL code, which I would prefer we also change
> to use kHz. The other concern is whether we have any potential overflows
> before we check this against the platform's max dotclock.
> 
> I do have this unreviewed igt series 
> https://patchwork.freedesktop.org/series/69531/ which extends the
> current testing with some other forms of invalid modes. Could probably
> extend that with a mode.clock=INT_MAX test to see if anything else might
> trip up.
> 
> No idea about other drivers.
> 
>  drivers/gpu/drm/drm_modes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> index 501b4fe55a3d..511cde5c7fa6 100644
> --- a/drivers/gpu/drm/drm_modes.c
> +++ b/drivers/gpu/drm/drm_modes.c
> @@ -762,7 +762,7 @@ int drm_mode_vrefresh(const struct drm_display_mode *mode)
>         if (mode->htotal == 0 || mode->vtotal == 0)
>                 return 0;
>  
> -       num = mode->clock * 1000;
> +       num = mode->clock;
>         den = mode->htotal * mode->vtotal;

You don't want to promote den to u64 while you are here? We are at
8kx4k, throw in dblscan and some vscan, and we could soon have wacky
refresh rates.
-Chris
