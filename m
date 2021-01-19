Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589372FBE76
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404384AbhASSBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 13:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404025AbhASSBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 13:01:30 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D90C061573
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 10:01:13 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id j21so5116437oou.11
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 10:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PnoLUYUr452SA00XwegpMttTU6JAnqwLEkpQzY+iQ4M=;
        b=EH6+xQCMT/keuuoCaUxTOVvaF2GlE+iKrQRwVW9Wa4ZMD7+lnMa6TRBnyLo3XP2a9S
         nya3saf+LtmbttEORKWhEUo2cAI6/fnVK91wGRPwMCU7YRlooPSFcGzSeaal0jn4XUFb
         cCxIVT/ICzrHK/GZMj0edDpbi4eZdXl6zGvgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PnoLUYUr452SA00XwegpMttTU6JAnqwLEkpQzY+iQ4M=;
        b=FPy4lTlWpd2sMwfo67jM3ipZvl4XLi+T8UtRH/3ZIF1r7Oj/y6YYgsG/Z/k7BJme0t
         mF5dOVaDydK/RudhEszmoZTT2EdmcBM89e4IGdoY/5n3qQvWQXRWJm2Ku7kgmqLQ8sdG
         5b9GO+Gh+eCtR6CIVTg2NBD+FuYbkc5kph+zwIi7gUPKvTz4DMjSC3uylspXgwzy71Qr
         oKg32gvqYF+u7n6tr/8iD3A+Bt8YsGz0mZHm70EYXlusepixnP7DdaTQlgfCsw5aTgBF
         jH9rhSx0LvPZRQM0dqhbQ5hwyMqD/1W0RGQbHfE/2hg0t+Uwkj9SNsu0LSk0MqQ1XFME
         BG/g==
X-Gm-Message-State: AOAM531L9D8hDVPLXHt8c+bOpLVJteH5C4uDLfzIUn9uOz+f4fO3cZSw
        4XMSG1JXDLoxbfXIYKs0QBHV+gadVQHlkqZPq+fOUQ==
X-Google-Smtp-Source: ABdhPJxPGwDWUaSok8hVtjiKBYa1X4wZDXYG8xZQDhASNu44d5/e3Z3YyqtQ3056r6Oa0bEJT2uCK3l/Qhjoqg73GJ8=
X-Received: by 2002:a4a:11c2:: with SMTP id 185mr3699747ooc.85.1611079272605;
 Tue, 19 Jan 2021 10:01:12 -0800 (PST)
MIME-Version: 1.0
References: <20210119174455.2423205-1-festevam@gmail.com>
In-Reply-To: <20210119174455.2423205-1-festevam@gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 19 Jan 2021 19:01:01 +0100
Message-ID: <CAKMK7uE5vo8G8AYTUAndy7Jj2wqmQGR1kcjjRn-ymGsxw-EvQQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Call shutdown conditionally
To:     Fabio Estevam <festevam@gmail.com>
Cc:     "Clark, Rob" <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Dave Airlie <airlied@linux.ie>,
        Krishna Manikandan <mkrishn@codeaurora.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 6:47 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> Calling the drm_atomic_helper_shutdown() on i.MX5 leads to
> the following flow:
>
> [   24.557742] [<c0769b78>] (msm_atomic_commit_tail) from [<c06db0b4>]
> (commit_tail+0xa4/0x1b0)
> [   24.566349] [<c06db0b4>] (commit_tail) from [<c06dbed0>]
> (drm_atomic_helper_commit+0x154/0x188)
> [   24.575193] [<c06dbed0>] (drm_atomic_helper_commit) from
> [<c06db604>] (drm_atomic_helper_disable_all+0x154/0x1c0)
> [   24.585599] [<c06db604>] (drm_atomic_helper_disable_all) from
> [<c06db704>] (drm_atomic_helper_shutdown+0x94/0x12c)
> [   24.596094] [<c06db704>] (drm_atomic_helper_shutdown) from
>
> In the i.MX5 case, priv->kms is not populated (as i.MX5 does not use any
> of the Qualcomm display controllers), causing a NULL pointer
> dereference in msm_atomic_commit_tail():
>
> [   24.268964] 8<--- cut here ---
> [   24.274602] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [   24.283434] pgd = (ptrval)
> [   24.286387] [00000000] *pgd=ca212831
> [   24.290788] Internal error: Oops: 17 [#1] SMP ARM
> [   24.295609] Modules linked in:
> [   24.298777] CPU: 0 PID: 197 Comm: init Not tainted 5.11.0-rc2-next-20210111 #333
> [   24.306276] Hardware name: Freescale i.MX53 (Device Tree Support)
> [   24.312442] PC is at msm_atomic_commit_tail+0x54/0xb9c
> [   24.317743] LR is at commit_tail+0xa4/0x1b0
>
> Fix the problem by calling drm_atomic_helper_shutdown() conditionally.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 9d5cbf5fe46e ("drm/msm: add shutdown support for display platform_driver")
> Suggested-by: Rob Clark <robdclark@gmail.com>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/gpu/drm/msm/msm_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> index 108c405e03dd..c082b72b9e3b 100644
> --- a/drivers/gpu/drm/msm/msm_drv.c
> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -1311,7 +1311,8 @@ static void msm_pdev_shutdown(struct platform_device *pdev)
>  {
>         struct drm_device *drm = platform_get_drvdata(pdev);
>
> -       drm_atomic_helper_shutdown(drm);
> +       if (get_mdp_ver(pdev))
> +               drm_atomic_helper_shutdown(drm);

Don't we need the same treatment for suspend/resume too? Also if you
feel like follow up patch to push this into the helpers with a
DRIVER_MODESET check like I described would be kinda neat.
-Daniel


>  }
>
>  static const struct of_device_id dt_match[] = {
> --
> 2.25.1
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
