Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3A5EF000
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 10:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiI2IHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 04:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiI2IHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 04:07:12 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEF17A756
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 01:07:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so5203113pjq.3
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 01:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=0Jfzl2sNnfhcmOJ2w1p67/kZD3Vw/dvkwuexZ9m31YM=;
        b=P87hvSDDuEWClVP5xzHvYmmh4LTLu551xTpJzaPDMe4LieY8KERFX8Ujs8zWUvrz98
         sKa5I87UXH+5n827rMS1kwkkgnMtwMX/RACxh9QuHtK3d4B6XF1aJXV+2XA1AmWLsvh/
         S+WtRHcrRei+OaTUo91sWFJpZtpfNO/ld1FhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0Jfzl2sNnfhcmOJ2w1p67/kZD3Vw/dvkwuexZ9m31YM=;
        b=dFtfcMxJHD4d4tcGpt4Bx+5ssnDrAmFGYejj5RIx+43clqoGfuibvZOfm+ZZjXs3X+
         N90rsBSl2u1Pg0mr/pjrqijk6YmsX0qnWR/HUBOoXfoAHk8Y0mR4uZ6n1udZGZgu8a1J
         CcaA47a1HhpxBgDUPh6qLWNm2Btd84vFtz42C75ZtR0G8tUN/4/7aD8GZVIFr2AydbKv
         2rNnkepo7YN3I22fjf2KIj1swLDzmMY1oHsa1cSbstyzgQ2NVYeDRMUpktwI40+Xm9dW
         AHbIy4AJK4qKz20J5N+nWhFQH8Wt6L4puhveQIyJIXDVPSFcynNFSj8UARews77jof3v
         jF3Q==
X-Gm-Message-State: ACrzQf3NlvQ6WZtWTC7bfNkTPkvdASsJHQOY5V9uNWOMT9DCtZh6P5hb
        XwYwJaUueD7UKMfKZR9/Jkhh5Q==
X-Google-Smtp-Source: AMsMyM4+Mj2J8XHAWgYmKThY6/GgJaz8N5uLUtVAjrhrE54ehACWk51RbxkUw262Lb+XCP8GD1+8FQ==
X-Received: by 2002:a17:90b:4b09:b0:202:ad77:9ee1 with SMTP id lx9-20020a17090b4b0900b00202ad779ee1mr2469916pjb.10.1664438829765;
        Thu, 29 Sep 2022 01:07:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902654400b00176b84eb29asm5185479pln.301.2022.09.29.01.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 01:07:09 -0700 (PDT)
Date:   Thu, 29 Sep 2022 01:07:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: Fix argument to sizeof() in
 uvc_register_video()
Message-ID: <202209290106.E6EFD95D4@keescook>
References: <20220928201921.3152163-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220928201921.3152163-1-nathan@kernel.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 28, 2022 at 01:19:21PM -0700, Nathan Chancellor wrote:
> When building s390 allmodconfig after commit 9b91a6523078 ("usb: gadget:
> uvc: increase worker prio to WQ_HIGHPRI"), the following error occurs:
> 
>   In file included from ../include/linux/string.h:253,
>                    from ../include/linux/bitmap.h:11,
>                    from ../include/linux/cpumask.h:12,
>                    from ../include/linux/smp.h:13,
>                    from ../include/linux/lockdep.h:14,
>                    from ../include/linux/rcupdate.h:29,
>                    from ../include/linux/rculist.h:11,
>                    from ../include/linux/pid.h:5,
>                    from ../include/linux/sched.h:14,
>                    from ../include/linux/ratelimit.h:6,
>                    from ../include/linux/dev_printk.h:16,
>                    from ../include/linux/device.h:15,
>                    from ../drivers/usb/gadget/function/f_uvc.c:9:
>   In function ‘fortify_memset_chk’,
>       inlined from ‘uvc_register_video’ at ../drivers/usb/gadget/function/f_uvc.c:424:2:
>   ../include/linux/fortify-string.h:301:25: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>     301 |                         __write_overflow_field(p_size_field, size);
>         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This points to the memset() in uvc_register_video(). It is clear that
> the argument to sizeof() is incorrect, as uvc->vdev (a 'struct
> video_device') is being zeroed out but the size of uvc->video (a 'struct
> uvc_video') is being used as the third arugment to memset().
> 
> pahole shows that prior to commit 9b91a6523078 ("usb: gadget: uvc:
> increase worker prio to WQ_HIGHPRI"), 'struct video_device' and
> 'struct ucv_video' had the same size, meaning that the argument to
> sizeof() is incorrect semantically but there is no visible issue:
> 
>   $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
>   video_device    1400    4
>   uvc_video       1400    3
> 
> After that change, uvc_video becomes slightly larger, meaning that the
> memset() will overwrite by 8 bytes:
> 
>   $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
>   video_device    1400    4
>   uvc_video       1408    3
> 
> Fix the arugment to sizeof() so that there is no overwrite.
> 
> Cc: stable@vger.kernel.org
> Fixes: e4ce9ed835bc ("usb: gadget: uvc: ensure the vdev is unset")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for tracking that down!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
