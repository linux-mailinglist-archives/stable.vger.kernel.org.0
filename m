Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7415F1C794F
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 20:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgEFSX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 14:23:29 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:42578 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbgEFSX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 14:23:28 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 96C608050C;
        Wed,  6 May 2020 20:23:24 +0200 (CEST)
Date:   Wed, 6 May 2020 20:23:18 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rpurdie@rpsys.net, adaplas@pol.net, b.zolnierkie@samsung.com,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] video: fbdev: w100fb: Fix a potential double free.
Message-ID: <20200506182318.GA8712@ravnborg.org>
References: <20200506181902.193290-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506181902.193290-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=MOBOZvRl c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=kj9zAlcOel0A:10 a=-sM3sDvmAAAA:8 a=p1g2r8j9AAAA:8 a=hD80L64hAAAA:8
        a=VwQbUJbxAAAA:8 a=lUMsOl5nhcu_R7_EiuIA:9 a=CjuIK1q_8ugA:10
        a=LUHx1oGsa4U61Z4w8267:22 a=GEd6vGEn79KL1p3bDQhq:22
        a=AjGcO6oz07-iQ99wixmX:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christophe
On Wed, May 06, 2020 at 08:19:02PM +0200, Christophe JAILLET wrote:
> Some memory is vmalloc'ed in the 'w100fb_save_vidmem' function and freed in
> the 'w100fb_restore_vidmem' function. (these functions are called
> respectively from the 'suspend' and the 'resume' functions)
> 
> However, it is also freed in the 'remove' function.
> 
> In order to avoid a potential double free, set the corresponding pointer
> to NULL once freed in the 'w100fb_restore_vidmem' function.
> 
> Fixes: aac51f09d96a ("[PATCH] w100fb: Rewrite for platform independence")
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Antonino Daplas <adaplas@pol.net>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: <stable@vger.kernel.org> # v2.6.14+
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks for the quick v2.
Applied to drm-misc-next.

	Sam

> ---
> v2: - Add Cc: tags
>     - Reword the commit message to give the names of the functions that
>       allocate and free the memory. These functions are called from the
>       suspend and resume function.
> ---
>  drivers/video/fbdev/w100fb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/fbdev/w100fb.c b/drivers/video/fbdev/w100fb.c
> index 2d6e2738b792..d96ab28f8ce4 100644
> --- a/drivers/video/fbdev/w100fb.c
> +++ b/drivers/video/fbdev/w100fb.c
> @@ -588,6 +588,7 @@ static void w100fb_restore_vidmem(struct w100fb_par *par)
>  		memsize=par->mach->mem->size;
>  		memcpy_toio(remapped_fbuf + (W100_FB_BASE-MEM_WINDOW_BASE), par->saved_extmem, memsize);
>  		vfree(par->saved_extmem);
> +		par->saved_extmem = NULL;
>  	}
>  	if (par->saved_intmem) {
>  		memsize=MEM_INT_SIZE;
> @@ -596,6 +597,7 @@ static void w100fb_restore_vidmem(struct w100fb_par *par)
>  		else
>  			memcpy_toio(remapped_fbuf + (W100_FB_BASE-MEM_WINDOW_BASE), par->saved_intmem, memsize);
>  		vfree(par->saved_intmem);
> +		par->saved_intmem = NULL;
>  	}
>  }
>  
> -- 
> 2.25.1
