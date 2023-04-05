Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDCC6D7753
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 10:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbjDEIus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 04:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbjDEIud (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 04:50:33 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D8F3C3E
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 01:50:30 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4PryyC05jKz9sd0;
        Wed,  5 Apr 2023 10:50:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1680684627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JoMcQjaWRTFJAZlTMPW2CqATVYYxvDWYRqZtrHR7FM=;
        b=CNfGQoM5HmhSLG8MpAhKqf6chfhxkuJLEFSFMr8Ltr5xSari8NB4GMztJFMnPUBuWipj5J
        dfhVXfuWoY3kHmsW4pEiLnJ3kfOv2OfbMBCiBEKCKev5ofIXg3SQDG1G0bZYuNPN9dAzfR
        E2fViaA3MlomCBaCpRL3jgOXEpBHT9bGXwloKdGc9KmzopqOykUhXcrMHUAij6IRbxTQ5W
        a5R+gFTInDhc2IF+b4s+S1WWYIvwoS8t9Q+/uDNhuYs0zDpvebO9rbgAMjM8hd4D/Hme+i
        nQp9pMW080SjjxmmaDOp9ZAMjlRTieQds/Wdlv27ySn5jIR16+payT3K2EpkhQ==
Message-ID: <03a575e1-b4ed-7bd6-b68a-0583d76803ff@mailbox.org>
Date:   Wed, 5 Apr 2023 10:50:24 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
Content-Language: en-CA
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@mailbox.org>
In-Reply-To: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: mzxrw78thnopc4sgrgqtw97dq6x1qahi
X-MBO-RS-ID: 94d8a51d1212d5b7798
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/4/23 14:36, Daniel Vetter wrote:
> There's a few reasons the kernel should not spam dmesg on bad
> userspace ioctl input:
> - at warning level it results in CI false positives
> - it allows userspace to drown dmesg output, potentially hiding real
>   issues.
> 
> None of the other generic EINVAL checks report in the
> FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.
> 
> I guess the intent of the patch which introduced this warning was that
> the drivers ->fb_check_var routine should fail in that case. Reality
> is that there's too many fbdev drivers and not enough people
> maintaining them by far, and so over the past few years we've simply
> handled all these validation gaps by tighning the checks in the core,
> because that's realistically really all that will ever happen.
> 
> Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
> Fixes: 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
> Cc: Helge Deller <deller@gmx.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@vger.kernel.org # v5.4+
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/video/fbdev/core/fbmem.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
> index 875541ff185b..9757f4bcdf57 100644
> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -1021,10 +1021,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
>  	/* verify that virtual resolution >= physical resolution */
>  	if (var->xres_virtual < var->xres ||
>  	    var->yres_virtual < var->yres) {
> -		pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
> -			info->fix.id,
> -			var->xres_virtual, var->yres_virtual,
> -			var->xres, var->yres);
>  		return -EINVAL;
>  	}
>  

Make it pr_warn_once? 99.9...% of the benefit, without spam.


-- 
Earthling Michel Dänzer            |                  https://redhat.com
Libre software enthusiast          |         Mesa and Xwayland developer

