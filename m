Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B15C6605FF
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 18:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjAFRyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 12:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjAFRxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 12:53:55 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC87A9
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 09:53:54 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so4098460wmb.2
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 09:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GHbXKYEfBQ8k18yvEj5GJ6Gqi0uOqe0xAgSwSiXa+Q=;
        b=V55nkZ92AGtNCvV8RPNuqTTAVXI89wklWiLVGrs7BnsXhJNUKRmB/CpzYOBOiw9Sd9
         KLhU75XHjuZ7O9TFWix/cgyGxlMVd7KmsTXJAUF+bCJE5BHlsf5Mw/w1fiJ21+GGGzCg
         w5L86CL42Wh++y9bn1PAXUcuA5V+YXkF54Hsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GHbXKYEfBQ8k18yvEj5GJ6Gqi0uOqe0xAgSwSiXa+Q=;
        b=q+rwfZPfzdCL+ojxpfHLmZ1/VKf1D9tk00V48bkoWdxfOckSXzLY05qZ4a1Vx7Iobg
         BTA6BAHHTyzUjXj1Gdo2a/eNpMSpQUsvK37VzJrAX8VCrSYYyRYbR1c+2lA3NbZOwFuJ
         UZ9VTo1UG2eGp3e6bY3D76za72OSLwrm2d9KDsIGl/HnX8X7/g1VVKk6G6eVfaklGmtc
         CqrwJcoGfBRS18ZCuF7tRrX3SuHpDg3tHt/o4yE/nBZ2F9oQZgnvfWCSVB8wjbVmUU/0
         Q+GUdrWN0E0BleRezO0EdMGRNl+Cw0pAa0K7CMvrXpYjpF5dse+ZFzk6vEw3Rhp0BTdz
         7qPQ==
X-Gm-Message-State: AFqh2krn9PMi/WWgv2gUjh5g16rZ45DfN8v1JBf+5FC9/p0zHWTYAHuM
        BgSmSjxX+z6Vgo7fvp6HXbSCbg==
X-Google-Smtp-Source: AMrXdXsZklbcpQLvNKmHYjVJ8RsVqFufvmJpMcBdaZKRVy/wyCjXEAOFtZhLM8QwwpSTJpw0I4VMaw==
X-Received: by 2002:a05:600c:3b02:b0:3c7:18:b339 with SMTP id m2-20020a05600c3b0200b003c70018b339mr48171334wms.37.1673027632819;
        Fri, 06 Jan 2023 09:53:52 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c350800b003d990372dd5sm7823216wmq.20.2023.01.06.09.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 09:53:51 -0800 (PST)
Date:   Fri, 6 Jan 2023 18:53:49 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
Mail-Followup-To: Brian Norris <briannorris@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 05:40:17PM -0800, Brian Norris wrote:
> The self-refresh helper framework overloads "disable" to sometimes mean
> "go into self-refresh mode," and this mode activates automatically
> (e.g., after some period of unchanging display output). In such cases,
> the display pipe is still considered "on", and user-space is not aware
> that we went into self-refresh mode. Thus, users may expect that
> vblank-related features (such as DRM_IOCTL_WAIT_VBLANK) still work
> properly.
> 
> However, we trigger the WARN_ONCE() here if a CRTC driver tries to leave
> vblank enabled here.
> 
> Add a new exception, such that we allow CRTCs to be "disabled" (with
> self-refresh active) with vblank interrupts still enabled.
> 
> Cc: <stable@vger.kernel.org> # dependency for subsequent patch
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> 
>  drivers/gpu/drm/drm_atomic_helper.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index d579fd8f7cb8..7b5eddadebd5 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1207,6 +1207,12 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
>  
>  		if (!drm_dev_has_vblank(dev))
>  			continue;
> +		/*
> +		 * Self-refresh is not a true "disable"; let vblank remain
> +		 * enabled.
> +		 */
> +		if (new_crtc_state->self_refresh_active)
> +			continue;

This very fishy, because we check in crtc_needs_disable whether this
output should stay on due to self-refresh. Which means you should never
end up in here.

And yes vblank better work in self refresh :-) If it doesn't, then you
need to fake it with a timer, that's at least what i915 has done for
transparent self-refresh.

We might need a few more helpers. Also, probably more igt, or is this
something igt testing has uncovered? If so, please cite the igt testcase
which hits this.
-Daniel

>  
>  		ret = drm_crtc_vblank_get(crtc);
>  		WARN_ONCE(ret != -EINVAL, "driver forgot to call drm_crtc_vblank_off()\n");
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
