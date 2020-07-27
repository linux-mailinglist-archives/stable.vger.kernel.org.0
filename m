Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97E822EA2C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 12:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgG0Kks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgG0Kks (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 06:40:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5AFC061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 03:40:47 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t142so7884053wmt.4
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 03:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QAGkxy7zDHqwfq3HR6Ep0RxFMMTvIif5jJbN4T7u8T0=;
        b=CW/VPSXTsqGNsByyHKn5qQLkyJKMqZTfdy0I6FAc8bU6LUVU67IHuEJDrKqTj7FJJ2
         Nud4pYYKQSJevTynBSKaPkQ9Gyap8A/u5Bi+29WdBj/6ezoBguSPMrH5HIsWrlEwLQA6
         YR0aYMiWWjCQQfpyenXbDy0yobOQM6ifeARnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QAGkxy7zDHqwfq3HR6Ep0RxFMMTvIif5jJbN4T7u8T0=;
        b=CXGATbcFVxlVth4iUL7f+m550/wAetcRPkIuYFyd1teYRwUVAb9FcAOTe6Kh38nvqi
         Bw/dXDGG+/Re0+JvApcE6r2wBqPS0XePW9VS9h/qnUcrtTWpB8sxPytwZvWlp3uL7AI7
         Op7VHq/pczAZJhc/nYihLMTcfJmcLMcfWuiGWjgPUcL9u3XL+i7F/yJLziFXxsyZh1T7
         0LYfucQA2Bb3I2AQ7n6NgID+fwB3bgxZQilOuca+DV/nH4N+764FbQEy6n9fBFQViG4E
         ZNm4Tf90bUW70Su8zUd+ycgowrNjmZM536iJMVvdoLjA6fsbjzPOOrMCyc68UD2Hmfo6
         bcvA==
X-Gm-Message-State: AOAM530qJ9FoacNNv3Gr9yVIDkmKsLXutWLhvlq520/eoBUHXiMBnVRL
        LlRoviEpWYAs7OEoNFlk/G9Exw==
X-Google-Smtp-Source: ABdhPJw+X1md0G79Cgzmhg5XANVN1gR3Nxk/a+aOwWwjQ1jzk31BJ1RUZQgLagH67Ncu9SKX0MVyEA==
X-Received: by 2002:a7b:ce04:: with SMTP id m4mr19528565wmc.1.1595846446333;
        Mon, 27 Jul 2020 03:40:46 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id 111sm6228210wrc.53.2020.07.27.03.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 03:40:45 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:40:43 +0200
From:   daniel@ffwll.ch
Cc:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        kraxel@redhat.com, emil.l.velikov@gmail.com,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] drm/ast: Do full modeset if the primary plane's
 format changes
Message-ID: <20200727104043.GU6419@phenom.ffwll.local>
References: <20200727073707.21097-1-tzimmermann@suse.de>
 <20200727073707.21097-2-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727073707.21097-2-tzimmermann@suse.de>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 09:37:05AM +0200, Thomas Zimmermann wrote:
> The atomic modesetting code tried to distinguish format changes from
> full modesetting operations. In practice, this was buggy and the format
> registers were often updated even for simple pageflips.

Nah it's not buggy, it's intentional. Most hw can update formats in a flip
withouth having to shut down the hw to do so.


> Instead do a full modeset if the primary plane changes formats. It's
> just as rare as an actual mode change, so there will be no performance
> penalty.
> 
> The patch also replaces a reference to drm_crtc_state.allow_modeset with
> the correct call to drm_atomic_crtc_needs_modeset().
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 4961eb60f145 ("drm/ast: Enable atomic modesetting")
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  drivers/gpu/drm/ast/ast_mode.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
> index 154cd877d9d1..3680a000b812 100644
> --- a/drivers/gpu/drm/ast/ast_mode.c
> +++ b/drivers/gpu/drm/ast/ast_mode.c
> @@ -527,8 +527,8 @@ static const uint32_t ast_primary_plane_formats[] = {
>  static int ast_primary_plane_helper_atomic_check(struct drm_plane *plane,
>  						 struct drm_plane_state *state)
>  {
> -	struct drm_crtc_state *crtc_state;
> -	struct ast_crtc_state *ast_crtc_state;
> +	struct drm_crtc_state *crtc_state, *old_crtc_state;
> +	struct ast_crtc_state *ast_crtc_state, *old_ast_crtc_state;
>  	int ret;
>  
>  	if (!state->crtc)
> @@ -550,6 +550,15 @@ static int ast_primary_plane_helper_atomic_check(struct drm_plane *plane,
>  
>  	ast_crtc_state->format = state->fb->format;
>  
> +	old_crtc_state = drm_atomic_get_old_crtc_state(state->state, state->crtc);
> +	if (!old_crtc_state)
> +		return 0;
> +	old_ast_crtc_state = to_ast_crtc_state(old_crtc_state);
> +	if (!old_ast_crtc_state)

The above two if checks should never fail, I'd wrap them in a WARN_ON.

> +		return 0;
> +	if (ast_crtc_state->format != old_ast_crtc_state->format)
> +		crtc_state->mode_changed = true;
> +
>  	return 0;
>  }
>  
> @@ -775,18 +784,18 @@ static void ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
>  
>  	ast_state = to_ast_crtc_state(crtc->state);
>  
> -	format = ast_state->format;
> -	if (!format)
> +	if (!drm_atomic_crtc_needs_modeset(crtc->state))
>  		return;
>  
> +	format = ast_state->format;
> +	if (drm_WARN_ON_ONCE(dev, !format))
> +		return; /* BUG: We didn't set format in primary check(). */

Hm that entire ast_state->format machinery looks kinda strange, can't you
just look up the primary plane state everywhere and that's it?
drm_framebuffer are fully invariant and refcounted to the state, so there
really shouldn't be any need to copy format around.

But that's maybe for a next patch. With the commit message clarified that
everything works as designed, and maybe the two WARN_ON added:

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> +
>  	vbios_mode_info = &ast_state->vbios_mode_info;
>  
>  	ast_set_color_reg(ast, format);
>  	ast_set_vbios_color_reg(ast, format, vbios_mode_info);
>  
> -	if (!crtc->state->mode_changed)
> -		return;
> -
>  	adjusted_mode = &crtc->state->adjusted_mode;
>  
>  	ast_set_vbios_mode_reg(ast, adjusted_mode, vbios_mode_info);
> -- 
> 2.27.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
