Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6B467C1FD
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbjAZAvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 19:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbjAZAvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 19:51:33 -0500
Received: from sonata.ens-lyon.org (domu-toccata.ens-lyon.fr [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7391FFF14;
        Wed, 25 Jan 2023 16:51:32 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id 43C6D20153;
        Thu, 26 Jan 2023 01:51:31 +0100 (CET)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Okn7r1ewCpFJ; Thu, 26 Jan 2023 01:51:31 +0100 (CET)
Received: from begin (adijon-658-1-86-31.w86-204.abo.wanadoo.fr [86.204.233.31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id 0F8EC20145;
        Thu, 26 Jan 2023 01:51:31 +0100 (CET)
Received: from samy by begin with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1pKqUE-00HVSI-2C;
        Thu, 26 Jan 2023 01:51:30 +0100
Date:   Thu, 26 Jan 2023 01:51:30 +0100
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Subject: Re: [PATCH] fbcon: Check font dimension limits
Message-ID: <20230126005130.t4krica4lfv3p6sc@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        Helge Deller <deller@gmx.de>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
References: <20230126004911.869923511@ens-lyon.org>
 <20230126004921.616264824@ens-lyon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126004921.616264824@ens-lyon.org>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(FYI, the UB was already a problem before my big-font patch submission,
the checks I add here are already making sense in previous versions
anyway)

Samuel Thibault, le jeu. 26 janv. 2023 01:49:12 +0100, a ecrit:
> blit_x and blit_y are uint32_t, so fbcon currently cannot support fonts
> larger than 32x32.
> 
> The 32x32 case also needs shifting an unsigned int, to properly set bit
> 31, otherwise we get "UBSAN: shift-out-of-bounds in fbcon_set_font",
> as reported on
> 
> http://lore.kernel.org/all/IA1PR07MB98308653E259A6F2CE94A4AFABCE9@IA1PR07MB9830.namprd07.prod.outlook.com
> Kernel Branch: 6.2.0-rc5-next-20230124
> Kernel config: https://drive.google.com/file/d/1F-LszDAizEEH0ZX0HcSR06v5q8FPl2Uv/view?usp=sharing
> Reproducer: https://drive.google.com/file/d/1mP1jcLBY7vWCNM60OMf-ogw-urQRjNrm/view?usp=sharing
> 
> Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
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
>  		return -EINVAL;
>  
>  	/* Make sure driver can handle the font length */
> 
> 
