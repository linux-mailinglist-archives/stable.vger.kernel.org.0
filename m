Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F96329234
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243337AbhCAUlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243600AbhCAUdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9107061601;
        Mon,  1 Mar 2021 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614624793;
        bh=RMgVl2CPO1xv43qphx/+Sc8JAROd+Z9d+qNlJBUHTbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+O82FIWx0ca3oTBoog9b4ZfE/5Zoscmqw2NU/QKt3J3Bn+QRyetes9ZrPONGwYXZ
         rLJt5/vIdwntHXmg8yFOn4A6f3vCxobzJ8qxmdNVeGVe4tBXDfYl1rwuq2fZkuypqF
         wN4pxpiVPwwXLBlC8dx1mulF7+Jn/xsq07A875kI=
Date:   Mon, 1 Mar 2021 19:52:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        kieran.bingham+renesas@ideasonboard.com
Subject: Re: rcar_du_kms.c:781:24: error: passing argument 1 of
 '__drmm_add_action' from incompatible pointer type
Message-ID: <YD032bZZ/y2Mh0ab@kroah.com>
References: <CA+G9fYvApAT=vx_XxhbMZ=rS8ShhYkSKa0JsHC8k0dFn5xwU=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvApAT=vx_XxhbMZ=rS8ShhYkSKa0JsHC8k0dFn5xwU=Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 11:11:26PM +0530, Naresh Kamboju wrote:
> On stable rc 5.11 the x86_64 build failed due to below errors/warnings.
> 
> drivers/gpu/drm/rcar-du/rcar_du_kms.c: In function 'rcar_du_modeset_cleanup':
> drivers/gpu/drm/rcar-du/rcar_du_kms.c:754:32: error: implicit
> declaration of function 'to_rcar_du_device'; did you mean
> 'to_rtc_device'? [-Werror=implicit-function-declaration]
>   struct rcar_du_device *rcdu = to_rcar_du_device(dev);
>                                 ^~~~~~~~~~~~~~~~~
>                                 to_rtc_device
> drivers/gpu/drm/rcar-du/rcar_du_kms.c:754:32: warning: initialization
> makes pointer from integer without a cast [-Wint-conversion]
> In file included from drivers/gpu/drm/rcar-du/rcar_du_kms.c:17:0:
> drivers/gpu/drm/rcar-du/rcar_du_kms.c: In function 'rcar_du_modeset_init':
> drivers/gpu/drm/rcar-du/rcar_du_kms.c:781:24: error: passing argument
> 1 of '__drmm_add_action' from incompatible pointer type
> [-Werror=incompatible-pointer-types]
>   ret = drmm_add_action(&rcdu->ddev, rcar_du_modeset_cleanup, NULL);
>                         ^
> include/drm/drm_managed.h:25:20: note: in definition of macro 'drmm_add_action'
>   __drmm_add_action(dev, action, data, #action)
>                     ^~~
> include/drm/drm_managed.h:27:18: note: expected 'struct drm_device *'
> but argument is of type 'struct drm_device **'
>  int __must_check __drmm_add_action(struct drm_device *dev,
>                   ^~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Very odd, my builds here didn't trigger that, sorry.  I'll go drop the
offending patch...

greg k-h
