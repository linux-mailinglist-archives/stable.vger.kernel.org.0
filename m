Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9667067C693
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 10:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjAZJDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 04:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbjAZJDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 04:03:04 -0500
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4707240BFC;
        Thu, 26 Jan 2023 01:02:59 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id ss4so3240702ejb.11;
        Thu, 26 Jan 2023 01:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zpTA8PogrXlsIUarI4aY2hvRwCUuO/PnjHEhsl7Xlq8=;
        b=i1r2T5tgBVD1TtXB2M8jXOV3bz0vQ5X/UWHAds/QfAQj5H/0NAijHjnFXLFr4fj7kP
         6lS32m/cp7RiMUEpEShs1qvATSsIKcZzbSK0KU73LbchxSgu11MiC7TiGLDPavpUac5b
         1Y/R++JXyRrdD/ydzJsHV4ODJcmOb2yr7pQB2fvCqVdj04KAh+DSU8Ibbw6K789dQItL
         aSPPOThErHfaGXRnhP3T7Co63qDSeU03KWKmH3kJ8PD+2v9E3Xc4GvBXybPSgZKhc2pG
         HHK5uYuGegy6fJ4f/JjG0rJ1NhJUDW3Ln2i4mH1Uc2ao6Vd4hXuZsJVUmJLoGdymCJOw
         WKiA==
X-Gm-Message-State: AFqh2kp79WoOC8c1+ftkVudNRugqTZJF+EXM9yMOYI5EDXqESb9+xHN9
        yITErRMERyLbAi01F4xQFi4=
X-Google-Smtp-Source: AMrXdXvZTr1bl/my1N+x4SHitbZ1MhWds08SNNOyDBFXgOff3S0BXuCoVCAZAMhJfKWBuQ1dj1pmtg==
X-Received: by 2002:a17:907:2135:b0:86f:fe8a:be with SMTP id qo21-20020a170907213500b0086ffe8a00bemr35892174ejb.4.1674723777426;
        Thu, 26 Jan 2023 01:02:57 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id a15-20020a170906244f00b00877de2def77sm294393ejb.31.2023.01.26.01.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 01:02:56 -0800 (PST)
Message-ID: <3bcd9911-5fdd-2a1a-0a76-55e1b8f7642a@kernel.org>
Date:   Thu, 26 Jan 2023 10:02:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] fbcon: Check font dimension limits
Content-Language: en-US
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
References: <20230126004911.869923511@ens-lyon.org>
 <20230126004921.616264824@ens-lyon.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230126004921.616264824@ens-lyon.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26. 01. 23, 1:49, Samuel Thibault wrote:
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
>   	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
>   		return -EINVAL;
>   
> +	if (font->width > 32 || font->height > 32)
> +		return -EINVAL;
> +
>   	/* Make sure drawing engine can handle the font */
> -	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
> -	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
> +	if (!(info->pixmap.blit_x & (1U << (font->width - 1))) ||
> +	    !(info->pixmap.blit_y & (1U << (font->height - 1))))

So use BIT() properly then? That should be used in all these shifts 
anyway. Exactly to avoid UB.

thanks,
-- 
js
suse labs

