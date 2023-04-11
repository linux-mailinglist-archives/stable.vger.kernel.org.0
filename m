Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AFC6DDD32
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjDKOER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjDKOEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:04:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5876D19AF
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681221811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CIGXauWS2Wr91Jq5IW+UgW4CSynzPp3COFUoOkdMkhA=;
        b=hGAyKxigSBqDb9ZMDE0p2/U96hIOcACTGoxjaG43WoX+P6sngkoOawjDg+kLkfoWF9Kxmd
        XJzkTrekM1B8ROTIVER5MX5xVzTMMNgeKgMF0CBHA1LE171ysCgtI7a7zhzgKloInsXyEU
        +gO3FdXP4Gf9lkoTbU8vnBISSXp6xqk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-h_bJMoQDNBO9QyMyIBow4A-1; Tue, 11 Apr 2023 10:03:29 -0400
X-MC-Unique: h_bJMoQDNBO9QyMyIBow4A-1
Received: by mail-wr1-f72.google.com with SMTP id h10-20020adfa4ca000000b002efb157f477so1347207wrb.15
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681221808;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CIGXauWS2Wr91Jq5IW+UgW4CSynzPp3COFUoOkdMkhA=;
        b=1R/JEnlPusJdy+3z2UH4Wmg9joqjnVP50GGeBv/sjCOsWGRsLyoTgC/GlUPa5/f7rk
         9O8Af7ZhPgVNY+Y+76HuztIU9T/X0XHaNrypg9w0vxW4bJqgBoxSAM/14s1LHhPkTxwy
         56ugcjNnjF/v6zZgDiN/E7qQM32DJU3NXwjro2NqvifVJ3tjzDVCvNRrRbASLHgW7yvl
         4e2CDk7S0fBwFzSaccQHZC1jXx0a6oyJkkY5UmKEWxEaRSWgn5XYq+DI+rKr3Qyz8ttQ
         21OP16qKhWzkSciAIDWT0tNlHGoudmQwQvex9E6MWtWNUNQBEs3ZJhrcjTiwMufaLYHR
         7hqw==
X-Gm-Message-State: AAQBX9fE24YNNvAVwAeLYaak6mFPp/i2c4PbNnEp8dkJ3TVTGshh+yTA
        +ABtjLtZR8dMfwQhWgYT69ZgUWGPt3bUj1vKSzLq+yIWjDKj1Aux8FRcxn5QHz9GpSy5hV4iZT7
        Ya1wvptMNaFfzI10O
X-Received: by 2002:a05:600c:246:b0:3ef:62c6:9930 with SMTP id 6-20020a05600c024600b003ef62c69930mr2272898wmj.3.1681221808152;
        Tue, 11 Apr 2023 07:03:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350aKiEZG2/eTE3qgJobPobJFBtpp/GDgmMcutPCUe6o6pFTDe6EfUfpz+ooaKEyqriEN7AUpYw==
X-Received: by 2002:a05:600c:246:b0:3ef:62c6:9930 with SMTP id 6-20020a05600c024600b003ef62c69930mr2272867wmj.3.1681221807826;
        Tue, 11 Apr 2023 07:03:27 -0700 (PDT)
Received: from localhost (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003ee443bf0c7sm20919284wms.16.2023.04.11.07.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 07:03:27 -0700 (PDT)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     linux-fbdev@vger.kernel.org, Shigeru Yoshida <syoshida@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>, Helge Deller <deller@gmx.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
        shlomo@fastmail.com, Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org,
        Noralf =?utf-8?Q?Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Peter Rosin <peda@axentia.se>,
        Qiujun Huang <hqjagain@gmail.com>
Subject: Re: [PATCH] fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace
In-Reply-To: <20230404193934.472457-1-daniel.vetter@ffwll.ch>
References: <20230404193934.472457-1-daniel.vetter@ffwll.ch>
Date:   Tue, 11 Apr 2023 16:03:24 +0200
Message-ID: <874jpmtt1v.fsf@minerva.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Daniel Vetter <daniel.vetter@ffwll.ch> writes:

> This is an oversight from dc5bdb68b5b3 ("drm/fb-helper: Fix vt
> restore") - I failed to realize that nasty userspace could set this.
>
> It's not pretty to mix up kernel-internal and userspace uapi flags
> like this, but since the entire fb_var_screeninfo structure is uapi
> we'd need to either add a new parameter to the ->fb_set_par callback
> and fb_set_par() function, which has a _lot_ of users. Or some other
> fairly ugly side-channel int fb_info. Neither is a pretty prospect.
>
> Instead just correct the issue at hand by filtering out this
> kernel-internal flag in the ioctl handling code.
>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Fixes: dc5bdb68b5b3 ("drm/fb-helper: Fix vt restore")

[..]

> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
> index 875541ff185b..3fd95a79e4c3 100644
> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -1116,6 +1116,8 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  	case FBIOPUT_VSCREENINFO:
>  		if (copy_from_user(&var, argp, sizeof(var)))
>  			return -EFAULT;
> +		/* only for kernel-internal use */
> +		var.activate &= ~FB_ACTIVATE_KD_TEXT;
>  		console_lock();

I don't have a better idea on how to fix this and as you said the whole
struct fb_var_screeninfo is an uAPI anyways...

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

