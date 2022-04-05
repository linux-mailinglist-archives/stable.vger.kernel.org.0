Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1644B4F30BF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350268AbiDEJ4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiDEJQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:17 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC58D370C
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 02:01:54 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id b15so14087335edn.4
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 02:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ukU+t72pCQS0dxZ/jjpxMfkj3HHFvuWvhSfqxyZT7hc=;
        b=VOxf2rqldenyWuq4/GZclZ/AOLui/1JP+UPpYfrOiuiWjr6NzBTasGuPRk3bkifgiy
         u4crqoIM4IRJRcpgWVSFB9x87hU+hQmTTKJY/h7P6dCSPZMq3AXpUsCwOJOFyzTqrKrn
         RQ3RaB/jzS62Gja/Yv8MV9/kTxPeaCFO2O4qQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ukU+t72pCQS0dxZ/jjpxMfkj3HHFvuWvhSfqxyZT7hc=;
        b=1Ds7H2F98NhBtzxCuVIZ+H+PnYt1BNTzc1q5eWjUN9NaPl3EN5+p7ivWcdNP5AynV6
         NkfTVn53xQOkfqWSEOQN1oSGV2yC7vj6rDfnC8PZaiQOOO9TSaaIUhLV8enRlKjcyUrP
         0xt09/UWQ0MJGxUU9LITFM/VcFb2pOLJ3jKYUywbgI7um4TDo0wW0JERyr+TwIZSNfeb
         rWu2u9TG2rgEi3LeKExO8nqug2qL0Ndiy7Spfp4xayeijE3+A/70N+atAPiVy3cPWikk
         v/YTjEpa3Iis17XzPBjSUQ9tOUcueCMvfmUKWFhvd+uOsDXkhWd+8hRZljKFxs2ITf4i
         Q4Tg==
X-Gm-Message-State: AOAM53038h4OCqq62kSxHoeW5o7sB01pBA5kB+v4GsV6Gz6ZFTzUi+3o
        1x5Y+mqU1Eidw2NQM/+YqAySZA==
X-Google-Smtp-Source: ABdhPJweAwmJC1qCJmen7vN7PIx9RM/tjpi9M1OUjoduD5l3KnLGEhjsOx8iH4nVUNGmGoj+dJD/DQ==
X-Received: by 2002:a05:6402:5191:b0:41c:e08c:ae21 with SMTP id q17-20020a056402519100b0041ce08cae21mr2462737edd.268.1649149313035;
        Tue, 05 Apr 2022 02:01:53 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id pv26-20020a170907209a00b006e76737d880sm3242705ejb.44.2022.04.05.02.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 02:01:52 -0700 (PDT)
Date:   Tue, 5 Apr 2022 11:01:50 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, deller@gmx.de, sudipm.mukherjee@gmail.com,
        sam@ravnborg.org, javierm@redhat.com, zackr@vmware.com,
        hdegoede@redhat.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zheyu Ma <zheyuma97@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] fbdev: Fix unregistering of framebuffers without device
Message-ID: <YkwFfusqI2Nuu7Dn@phenom.ffwll.local>
References: <20220404194402.29974-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404194402.29974-1-tzimmermann@suse.de>
X-Operating-System: Linux phenom 5.10.0-8-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 09:44:02PM +0200, Thomas Zimmermann wrote:
> OF framebuffers do not have an underlying device in the Linux
> device hierarchy. Do a regular unregister call instead of hot
> unplugging such a non-existing device. Fixes a NULL dereference.
> An example error message on ppc64le is shown below.
> 
>   BUG: Kernel NULL pointer dereference on read at 0x00000060
>   Faulting instruction address: 0xc00000000080dfa4
>   Oops: Kernel access of bad area, sig: 11 [#1]
>   LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>   [...]
>   CPU: 2 PID: 139 Comm: systemd-udevd Not tainted 5.17.0-ae085d7f9365 #1
>   NIP:  c00000000080dfa4 LR: c00000000080df9c CTR: c000000000797430
>   REGS: c000000004132fe0 TRAP: 0300   Not tainted  (5.17.0-ae085d7f9365)
>   MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 28228282  XER: 20000000
>   CFAR: c00000000000c80c DAR: 0000000000000060 DSISR: 40000000 IRQMASK: 0
>   GPR00: c00000000080df9c c000000004133280 c00000000169d200 0000000000000029
>   GPR04: 00000000ffffefff c000000004132f90 c000000004132f88 0000000000000000
>   GPR08: c0000000015658f8 c0000000015cd200 c0000000014f57d0 0000000048228283
>   GPR12: 0000000000000000 c00000003fffe300 0000000020000000 0000000000000000
>   GPR16: 0000000000000000 0000000113fc4a40 0000000000000005 0000000113fcfb80
>   GPR20: 000001000f7283b0 0000000000000000 c000000000e4a588 c000000000e4a5b0
>   GPR24: 0000000000000001 00000000000a0000 c008000000db0168 c0000000021f6ec0
>   GPR28: c0000000016d65a8 c000000004b36460 0000000000000000 c0000000016d64b0
>   NIP [c00000000080dfa4] do_remove_conflicting_framebuffers+0x184/0x1d0
>   [c000000004133280] [c00000000080df9c] do_remove_conflicting_framebuffers+0x17c/0x1d0 (unreliable)
>   [c000000004133350] [c00000000080e4d0] remove_conflicting_framebuffers+0x60/0x150
>   [c0000000041333a0] [c00000000080e6f4] remove_conflicting_pci_framebuffers+0x134/0x1b0
>   [c000000004133450] [c008000000e70438] drm_aperture_remove_conflicting_pci_framebuffers+0x90/0x100 [drm]
>   [c000000004133490] [c008000000da0ce4] bochs_pci_probe+0x6c/0xa64 [bochs]
>   [...]
>   [c000000004133db0] [c00000000002aaa0] system_call_exception+0x170/0x2d0
>   [c000000004133e10] [c00000000000c3cc] system_call_common+0xec/0x250
> 
> The bug [1] was introduced by commit 27599aacbaef ("fbdev: Hot-unplug
> firmware fb devices on forced removal"). Most firmware framebuffers
> have an underlying platform device, which can be hot-unplugged
> before loading the native graphics driver. OF framebuffers do not
> (yet) have that device. Fix the code by unregistering the framebuffer
> as before without a hot unplug.
> 
> Tested with 5.17 on qemu ppc64le emulation.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 27599aacbaef ("fbdev: Hot-unplug firmware fb devices on forced removal")
> Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Cc: Zack Rusin <zackr@vmware.com>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: stable@vger.kernel.org # v5.11+
> Cc: Helge Deller <deller@gmx.de>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Zheyu Ma <zheyuma97@gmail.com>
> Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-fbdev@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Link: https://lore.kernel.org/all/YkHXO6LGHAN0p1pq@debian/ # [1]
> ---
>  drivers/video/fbdev/core/fbmem.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
> index 34d6bb1bf82e..a6bb0e438216 100644
> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -1579,7 +1579,14 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
>  			 * If it's not a platform device, at least print a warning. A
>  			 * fix would add code to remove the device from the system.
>  			 */
> -			if (dev_is_platform(device)) {
> +			if (!device) {
> +				/* TODO: Represent each OF framebuffer as its own
> +				 * device in the device hierarchy. For now, offb
> +				 * doesn't have such a device, so unregister the
> +				 * framebuffer as before without warning.
> +				 */
> +				do_unregister_framebuffer(registered_fb[i]);

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Might be good to have a fb_info flag for offb and then check in
register_framebuffer that everyone else does have a device? Just to make
sure we don't have more surprises here ...
-Daniel


> +			} else if (dev_is_platform(device)) {
>  				registered_fb[i]->forced_out = true;
>  				platform_device_unregister(to_platform_device(device));
>  			} else {
> -- 
> 2.35.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
