Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146F61AE0FD
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgDQPXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 11:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728684AbgDQPXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 11:23:14 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8245DC061A0C
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 08:23:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x4so3314647wmj.1
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 08:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xwvBBGP6XODNxylPgMW6KMF6+zxJ6hauRpgc8isQ/s0=;
        b=jJ4sDmvxu2xQFEut1aJaSw96vpmEq7h0CmEEYHWKJeC8kmcGxVFO29D0KBh8/cbZmh
         QHpbRkCt0b0oQJz3QtDmz25A9R7rtGyVAFGDcqKBSIJbDkKIbGfkaAFHhSI8fK8eXZ0F
         6hnlqqERqB4VLXAZ5M0yABZUokDb55O/sXJlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xwvBBGP6XODNxylPgMW6KMF6+zxJ6hauRpgc8isQ/s0=;
        b=ZDHQwaC2ElPXFETUAx/9ZZds4gKplXFALwmHKzW7LWJibMT7fkuaIEXvyp/HBqbEts
         Z1eXbeoh1CCGz/qYsthI5/8CrneQbbUqMZ/B+sybbcpnTVv3EqHRpsSiLubf+yhFtyOq
         7WR1Sr2TyrHJtrQQYqk5UdwjdfE4EPRXiDoqEirFPB2mnJ24kY0ThZiLDv4+EufCLnRY
         PbatPnxS7moT8awmZDuHsOr8BLKkO1LFpcq4/aLrvJ3AMQi0S8vh2wXBBe6ArbZVQqgw
         GpNYwR1Ci93Yv+cBXUbpqKFXGUA4arOjJUUpSW0dhshQBOJug4QeIa9qSnnNP13ROLAj
         hRGQ==
X-Gm-Message-State: AGi0PuYVM3AnbzQmiQxG2/dgBcaz5wZZiWwWk0kvdHsxhcuH/ON2D+gp
        O/YnqzhoR3UKN9pJNWRZBIvX3KrZR8k=
X-Google-Smtp-Source: APiQypK7SNGOEdkYiufxXCGrkdhTlxCyEf/fSyck9qXER30rJkfzIOOTp560RnTadMQaEcQI5CVh6g==
X-Received: by 2002:a1c:a7c4:: with SMTP id q187mr4213973wme.56.1587136993223;
        Fri, 17 Apr 2020 08:23:13 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id c20sm8699843wmd.36.2020.04.17.08.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 08:23:12 -0700 (PDT)
Date:   Fri, 17 Apr 2020 17:23:10 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
Message-ID: <20200417152310.GQ3456981@phenom.ffwll.local>
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
X-Operating-System: Linux phenom 5.3.0-3-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Revert back to comparing fb->format->format instead fb->format for the
> page flip ioctl. This check was originally only here to disallow pixel
> format changes, but when we changed it to do the pointer comparison
> we potentially started to reject some (but definitely not all) modifier
> changes as well. In fact the current behaviour depends on whether the
> driver overrides the format info for a specific format+modifier combo.
> Eg. on i915 this now rejects compression vs. no compression changes but
> does not reject any other tiling changes. That's just inconsistent
> nonsense.
> 
> The main reason we have to go back to the old behaviour is to fix page
> flipping with Xorg. At some point Xorg got its atomic rights taken away
> and since then we can't page flip between compressed and non-compressed
> fbs on i915. Currently we get no page flipping for any games pretty much
> since Mesa likes to use compressed buffers. Not sure how compositors are
> working around this (don't use one myself). I guess they must be doing
> something to get non-compressed buffers instead. Either that or
> somehow no one noticed the tearing from the blit fallback.

Mesa only uses compressed buffers if you enable modifiers, and there's a
_loooooooooooot_ more that needs to be fixed in Xorg to enable that for
real. Like real atomic support. Without modifiers all you get is X tiling,
and that works just fine.

Which would also fix this issue here you're papering over.

So if this is the entire reason for this, I'm inclined to not do this.
Current Xorg is toast wrt modifiers, that's not news.
-Daniel

> 
> Looking back at the original discussion on this change we pretty much
> just did it in the name of skipping a few extra pointer dereferences.
> However, I've decided not to revert the whole thing in case someone
> has since started to depend on these changes. None of the other checks
> are relevant for i915 anyways.
> 
> Cc: stable@vger.kernel.org
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Fixes: dbd4d5761e1f ("drm: Replace 'format->format' comparisons to just 'format' comparisons")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/drm_plane.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
> index d6ad60ab0d38..f2ca5315f23b 100644
> --- a/drivers/gpu/drm/drm_plane.c
> +++ b/drivers/gpu/drm/drm_plane.c
> @@ -1153,7 +1153,7 @@ int drm_mode_page_flip_ioctl(struct drm_device *dev,
>  	if (ret)
>  		goto out;
>  
> -	if (old_fb->format != fb->format) {
> +	if (old_fb->format->format != fb->format->format) {
>  		DRM_DEBUG_KMS("Page flip is not allowed to change frame buffer format.\n");
>  		ret = -EINVAL;
>  		goto out;
> -- 
> 2.24.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
