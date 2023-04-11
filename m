Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307696DDC7E
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDKNos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDKNor (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:44:47 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DF1C4
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:44:46 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2ef70620b9dso629686f8f.1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1681220684;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fp4rlXw79VcdA2AOoSPpOfYMZ9IUxLVJ3GocVp0+rN4=;
        b=M9knvb6pdlQ3GyWNetTLlteC0E2mKH0SdNXMypNKBJFlpJlMUu/DAbcHTr3bPsR5/j
         SYTEq1F7tMMx5SHTYY5XlnULPEZTieVTqnT8C0O3s0CkL5VdHz5t4JArJWpMaQkA5Fn0
         XzQAO5LxvhoZrBJ0SJWrPvOpZEdfUbU/abbRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681220684;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp4rlXw79VcdA2AOoSPpOfYMZ9IUxLVJ3GocVp0+rN4=;
        b=vEc/j4W4HNIE9jyHyNXExqpNAg0MtC0ADSmv5EZndwmdhpj8x9PhcyHL3rJ8BdZzUd
         tsMIlPd4z6KLQQZwQwxz6Ir8ZHWI5XVtdUUWU44Q6gg3x6zQ4TpDKM/R5iMzAX1FCZcg
         MVrV4QNID1n4UNVX8WGMhglMOMHjmHv+a5uHT9nDhr00bePy2bqk1/Vu4U5VzTHLpQqb
         w9Kj0FcenOR0rm3gsiR0v3gGl+ATOk4n+l0MrQCJi9lOXXJjG2audg5pl7WtJ1P4LGEA
         DKy7iMWP6mMe2o0IpgkyyNpp74tOo90lv08z/UCKI9N1fkxoZf4Kq8E5PVyiCAdGTZ8Q
         OgbA==
X-Gm-Message-State: AAQBX9d2UIyE3ALVtvCpA/fApfKPQWZa8fBAk0EcUF3qa1jsDzNWCVHx
        SAVIm8ggu5RmphNN/Yy7DV5KOhDbXhkwW5nVT7U=
X-Google-Smtp-Source: AKy350aG4k+mNBiF8l8fXL2dxJrJEyAlXU5HH05sc8I796zTIROU200GENXBJcM9/TJ/mqG0FF1ycQ==
X-Received: by 2002:a5d:54c9:0:b0:2e4:c9ac:c492 with SMTP id x9-20020a5d54c9000000b002e4c9acc492mr6788945wrv.1.1681220684488;
        Tue, 11 Apr 2023 06:44:44 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id c14-20020a5d4cce000000b002f2782978d8sm4178312wrt.20.2023.04.11.06.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:44:44 -0700 (PDT)
Date:   Tue, 11 Apr 2023 15:44:41 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>, shlomo@fastmail.com,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-fbdev@vger.kernel.org,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Shigeru Yoshida <syoshida@redhat.com>
Subject: Re: [PATCH] fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace
Message-ID: <ZDVkSaskEvwix8Bz@phenom.ffwll.local>
References: <20230404193934.472457-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230404193934.472457-1-daniel.vetter@ffwll.ch>
X-Operating-System: Linux phenom 6.1.0-7-amd64 
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 09:39:34PM +0200, Daniel Vetter wrote:
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
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: shlomo@fastmail.com
> Cc: Michel Dänzer <michel@daenzer.net>
> Cc: Noralf Trønnes <noralf@tronnes.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.7+
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Nathan Chancellor <natechancellor@gmail.com>
> Cc: Qiujun Huang <hqjagain@gmail.com>
> Cc: Peter Rosin <peda@axentia.se>
> Cc: linux-fbdev@vger.kernel.org
> Cc: Helge Deller <deller@gmx.de>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Shigeru Yoshida <syoshida@redhat.com>

An Ack on this (or a better idea) would be great, so I can stuff it into
-fixes.

Thanks, Daniel

> ---
>  drivers/video/fbdev/core/fbmem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
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
>  		lock_fb_info(info);
>  		ret = fbcon_modechange_possible(info, &var);
> -- 
> 2.40.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
