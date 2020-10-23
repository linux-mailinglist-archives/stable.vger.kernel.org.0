Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A656829765B
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 20:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465926AbgJWSEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 14:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S465549AbgJWSEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 14:04:35 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9785C0613CE
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 11:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=sSHscReIOky4s2YqhdJExEQEr3QLb6PUad1azvWlF30=; b=bmsxUUxca14wmg+tWuc9J1Um54
        mwroxkG794AcVyl8IP7HQsnwrASV2FxLYnIfozn/D8XrX/Mo+fexew4sRMCVCOnkMdWZkjtcgEDjX
        REIeoGHTnPvZ1jCNCHVxphOPMLqGWJ4WXE2e6sRjXih7ax+g+bRCkDRpBAZgG9FzszKFIb6ejmT5i
        N9zLluyc760N2toNQTl5e2otI6XmQORpnxTNE/HcSLj+sD5Xqh6hjvdtr13zzC+iHhh5FmIaoJ6wc
        r+JuKK4IQruoWQ1HN+oDW0Lcy2j+AjJdTPwcXmJAKrdMjUuhoT7npBSLr6TuWbu6zZqIKEehPkxnv
        8rNvuoAQ==;
Received: from [2601:1c0:6280:3f0::507c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kW1QW-0005sn-H0; Fri, 23 Oct 2020 18:04:32 +0000
Subject: Re: [PATCH] drm/modes: Switch to 64bit maths to avoid integer
 overflow
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <20201022194256.30978-1-ville.syrjala@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a9b837f9-1293-b513-230a-5aa7385e2a3f@infradead.org>
Date:   Fri, 23 Oct 2020 11:04:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201022194256.30978-1-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/22/20 12:42 PM, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> The new >8k CEA modes have dotclocks reaching 5.94 GHz, which
> means our clock*1000 will now overflow the 32bit unsigned
> integer. Switch to 64bit maths to avoid it.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

This cures the problem that I reported. Thanks.

Tested-by: Randy Dunlap <rdunlap@infradead.org>

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
>  	if (mode->htotal == 0 || mode->vtotal == 0)
>  		return 0;
>  
> -	num = mode->clock * 1000;
> +	num = mode->clock;
>  	den = mode->htotal * mode->vtotal;
>  
>  	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
> @@ -772,7 +772,7 @@ int drm_mode_vrefresh(const struct drm_display_mode *mode)
>  	if (mode->vscan > 1)
>  		den *= mode->vscan;
>  
> -	return DIV_ROUND_CLOSEST(num, den);
> +	return DIV_ROUND_CLOSEST_ULL(mul_u32_u32(num, 1000), den);
>  }
>  EXPORT_SYMBOL(drm_mode_vrefresh);
>  
> 


-- 
~Randy
