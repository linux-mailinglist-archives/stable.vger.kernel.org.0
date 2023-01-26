Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1906A67C4FE
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 08:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbjAZHnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 02:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjAZHnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 02:43:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599BF1BAEB;
        Wed, 25 Jan 2023 23:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA91B61755;
        Thu, 26 Jan 2023 07:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054B8C433EF;
        Thu, 26 Jan 2023 07:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674718985;
        bh=qLBAZG/gbjpAF8cRofsMaVMSoAZk99jH0vp77Yjg1EQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCVJ9OZWp+IbuYSxY4Rhn4YdBs9okdhqwDqtpOVy68+MBd+rq1Ubx7+xi1unGSH32
         5g4HSticgDfxZovx6bVoysxu6rzPSUFHNBgRONw3LjBp88gaW7vco2RyJD0AJp5+6T
         2urMSXVL/wHFwqqo8juti32pvP4KMRGktnoitvv4=
Date:   Thu, 26 Jan 2023 08:43:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@knights.ucf.edu>
Subject: Re: [PATCH] fbcon: Check font dimension limits
Message-ID: <Y9IvBoAbmh27xl4B@kroah.com>
References: <20230126004911.869923511@ens-lyon.org>
 <20230126004921.616264824@ens-lyon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126004921.616264824@ens-lyon.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 01:49:12AM +0100, Samuel Thibault wrote:
> blit_x and blit_y are uint32_t, so fbcon currently cannot support fonts
> larger than 32x32.

"u32" you mean, right?

> The 32x32 case also needs shifting an unsigned int, to properly set bit
> 31, otherwise we get "UBSAN: shift-out-of-bounds in fbcon_set_font",
> as reported on
> 
> http://lore.kernel.org/all/IA1PR07MB98308653E259A6F2CE94A4AFABCE9@IA1PR07MB9830.namprd07.prod.outlook.com

Odd blank line?


> Kernel Branch: 6.2.0-rc5-next-20230124
> Kernel config: https://drive.google.com/file/d/1F-LszDAizEEH0ZX0HcSR06v5q8FPl2Uv/view?usp=sharing
> Reproducer: https://drive.google.com/file/d/1mP1jcLBY7vWCNM60OMf-ogw-urQRjNrm/view?usp=sharing

What are all of these lines for?

> 
> Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

What commit id does this fix?  Should it go to stable kernels?

> 
> Index: linux-6.0/drivers/video/fbdev/core/fbcon.c
> ===================================================================
> --- linux-6.0.orig/drivers/video/fbdev/core/fbcon.c
> +++ linux-6.0/drivers/video/fbdev/core/fbcon.c
> @@ -2489,9 +2489,12 @@ static int fbcon_set_font(struct vc_data
>  	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
>  		return -EINVAL;
>  
> +	if (font->width > 32 || font->height > 32)
> +		return -EINVAL;
> +
>  	/* Make sure drawing engine can handle the font */
> -	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
> -	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
> +	if (!(info->pixmap.blit_x & (1U << (font->width - 1))) ||
> +	    !(info->pixmap.blit_y & (1U << (font->height - 1))))

Are you sure this is still needed with the above check added?  If so,
why?  What is the difference in the compiled code?

thanks,

greg k-h
