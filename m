Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606DC788FE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 11:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfG2J6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 05:58:06 -0400
Received: from foss.arm.com ([217.140.110.172]:41110 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfG2J6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 05:58:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E0A715AB;
        Mon, 29 Jul 2019 02:58:05 -0700 (PDT)
Received: from e110455-lin.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EF7C3F694;
        Mon, 29 Jul 2019 02:58:05 -0700 (PDT)
Received: by e110455-lin.cambridge.arm.com (Postfix, from userid 1000)
        id F23AF68240B; Mon, 29 Jul 2019 10:58:03 +0100 (BST)
Date:   Mon, 29 Jul 2019 10:58:03 +0100
From:   Liviu Dudau <Liviu.Dudau@arm.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     airlied@linux.ie, daniel@ffwll.ch, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: mali-dp: Mark expected switch fall-through
Message-ID: <20190729095803.hd7ehqjc4zlqztv3@e110455-lin.cambridge.arm.com>
References: <20190726112741.19360-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190726112741.19360-1-anders.roxell@linaro.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Anders,

On Fri, Jul 26, 2019 at 01:27:41PM +0200, Anders Roxell wrote:
> When fall-through warnings was enabled by default, commit d93512ef0f0e
> ("Makefile: Globally enable fall-through warning"), the following
> warnings was starting to show up:
> 
> ../drivers/gpu/drm/arm/malidp_hw.c: In function ‘malidp_format_get_bpp’:
> ../drivers/gpu/drm/arm/malidp_hw.c:387:8: warning: this statement may fall
>  through [-Wimplicit-fallthrough=]
>     bpp = 30;
>     ~~~~^~~~
> ../drivers/gpu/drm/arm/malidp_hw.c:388:3: note: here
>    case DRM_FORMAT_YUV420_10BIT:
>    ^~~~
> ../drivers/gpu/drm/arm/malidp_hw.c: In function ‘malidp_se_irq’:
> ../drivers/gpu/drm/arm/malidp_hw.c:1311:4: warning: this statement may fall
>  through [-Wimplicit-fallthrough=]
>     drm_writeback_signal_completion(&malidp->mw_connector, 0);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/gpu/drm/arm/malidp_hw.c:1313:3: note: here
>    case MW_START:
>    ^~~~
> 
> Rework to add a 'break;' in a case that didn't have it so that
> the compiler doesn't warn about fall-through.
> 
> Cc: stable@vger.kernel.org # v4.9+
> Fixes: b8207562abdd ("drm/arm/malidp: Specified the rotation memory requirements for AFBC YUV formats")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Running the patch through scripts/get_maintainer.pl would've also given you the
emails for the mali-dp maintainers to reach directly and have a faster response
time, but I guess you were trying to see if we check the dri-devel mailing list.

Thanks for the patch!

Acked-by: Liviu Dudau <liviu.dudau@arm.com>

Best regards,
Liviu

> ---
>  drivers/gpu/drm/arm/malidp_hw.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
> index 50af399d7f6f..dc5fff9af338 100644
> --- a/drivers/gpu/drm/arm/malidp_hw.c
> +++ b/drivers/gpu/drm/arm/malidp_hw.c
> @@ -385,6 +385,7 @@ int malidp_format_get_bpp(u32 fmt)
>  		switch (fmt) {
>  		case DRM_FORMAT_VUY101010:
>  			bpp = 30;
> +			break;
>  		case DRM_FORMAT_YUV420_10BIT:
>  			bpp = 15;
>  			break;
> @@ -1309,7 +1310,7 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
>  			break;
>  		case MW_RESTART:
>  			drm_writeback_signal_completion(&malidp->mw_connector, 0);
> -			/* fall through to a new start */

It's a shame that the compiler throws a warning here, it would've been really
useful to keep the hint that going back to a new start is intentional without
having to type another comment.

> +			/* fall through */
>  		case MW_START:
>  			/* writeback started, need to emulate one-shot mode */
>  			hw->disable_memwrite(hwdev);
> -- 
> 2.20.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯
