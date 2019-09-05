Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F60AA010
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 12:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbfIEKlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 06:41:39 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41498 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731215AbfIEKlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 06:41:39 -0400
Received: by mail-oi1-f195.google.com with SMTP id h4so1382995oih.8
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 03:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AbBV6oo8EEIqowDXyeUoAbrfMbexy7KJeFh9ZmY9cKQ=;
        b=Ic05xQnYjdm68gWTyNiOvYw20Hz8Ax+yQeHAE8UIfHAhAa16danRTGGUSrrIl9Zfy6
         rywCu4Iw06J5VQsWtX2POq3Gcuoi5bN9N9RV2O2AdZ0snBw6EDz9Ha0i1EVm7YmOcUDf
         JzkohUZZRwmQvHNec7xozwNGn61KtccMUdnLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AbBV6oo8EEIqowDXyeUoAbrfMbexy7KJeFh9ZmY9cKQ=;
        b=mro+eK3vF+0w30dTTJ3PIo/gH9YFbGxUTD6Mqm8s34h09ytK2mWMhW1Gqi+AA8n/co
         5qfPdc6lLdDV92sqQMizIE3Y4jfkcUuULEW2LwTczZ2NKzmMrmnEhH7Rl9n6r2d1Uj1k
         tjLDGRL9XJl4lkOjN5fP4P+jGIRdGdwbszhqjnN5iGLhuxpStohzrDn8gidmP3X4vD+4
         ZszJv2Z09YfzsegkOL1c5VyzHJ6580GQJfVhyOoC5gLugkWfIYGwfuuiWJd66zChtgFJ
         nUw8xn+DzhSkX2uO0yNQGWpLx8i3d3hax9NQcYhTs0nCAaTFqZ/lAZZ0QCi7NHe8LApA
         CvCQ==
X-Gm-Message-State: APjAAAXQuFvjbyhyiAvXxcuZGAgu76BMf7vokjTBcFyy6Ps74AcweekV
        OS7WUyDf8td8YpFpP13YKo1lUHLBnWQ5YZ4yqlCRjbt2Zz4=
X-Google-Smtp-Source: APXvYqw1asXU8p84eB6UIF6IHFqR62bfC+WWX4hUgop6z4xTLlQI6y/FeN0rMBqV0jh1EkLR9nK3TLawr6qrrPOsJMs=
X-Received: by 2002:aca:5697:: with SMTP id k145mr1816837oib.101.1567680098221;
 Thu, 05 Sep 2019 03:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190904202938.110207-1-sean@poorly.run>
In-Reply-To: <20190904202938.110207-1-sean@poorly.run>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 5 Sep 2019 12:41:27 +0200
Message-ID: <CAKMK7uFtcmZd9+wARmYuZwtimUV91fiFXNmr5Nuk4Z65QjHyuA@mail.gmail.com>
Subject: Re: [PATCH] drm: damage_helper: Fix race checking plane->state->fb
To:     Sean Paul <sean@poorly.run>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@gmail.com>,
        Deepak Rawat <drawat@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        David Airlie <airlied@linux.ie>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 4, 2019 at 10:29 PM Sean Paul <sean@poorly.run> wrote:
>
> From: Sean Paul <seanpaul@chromium.org>
>
> Since the dirtyfb ioctl doesn't give us any hints as to which plane is
> scanning out the fb it's marking as damaged, we need to loop through
> planes to find it.
>
> Currently we just reach into plane state and check, but that can race
> with another commit changing the fb out from under us. This patch locks
> the plane before checking the fb and will release the lock if the plane
> is not displaying the dirty fb.
>
> Fixes: b9fc5e01d1ce ("drm: Add helper to implement legacy dirtyfb")
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Deepak Rawat <drawat@vmware.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Thomas Hellstrom <thellstrom@vmware.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> Cc: Sean Paul <sean@poorly.run>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.0+
> Reported-by: Daniel Vetter <daniel@ffwll.ch>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
>  drivers/gpu/drm/drm_damage_helper.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_damage_helper.c b/drivers/gpu/drm/drm_damage_helper.c
> index 8230dac01a89..3a4126dc2520 100644
> --- a/drivers/gpu/drm/drm_damage_helper.c
> +++ b/drivers/gpu/drm/drm_damage_helper.c
> @@ -212,8 +212,14 @@ int drm_atomic_helper_dirtyfb(struct drm_framebuffer *fb,
>         drm_for_each_plane(plane, fb->dev) {
>                 struct drm_plane_state *plane_state;
>
> -               if (plane->state->fb != fb)
> +               ret = drm_modeset_lock(&plane->mutex, state->acquire_ctx);
> +               if (ret)

I think for paranoid safety we should have a WARN_ON(ret == -EALREADY)
here. It should be impossible, but if it's not for some oddball
reason, we'll blow up.

With that: Reviewed-by: Daniel Vetter <daniel@ffwll.ch>

But please give this a spin with some workloads and the ww_mutex
slowpath debugging enabled, just to makre sure.
-Daniel

> +                       goto out;
> +
> +               if (plane->state->fb != fb) {
> +                       drm_modeset_unlock(&plane->mutex);
>                         continue;
> +               }
>
>                 plane_state = drm_atomic_get_plane_state(state, plane);
>                 if (IS_ERR(plane_state)) {
> --
> Sean Paul, Software Engineer, Google / Chromium OS
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
