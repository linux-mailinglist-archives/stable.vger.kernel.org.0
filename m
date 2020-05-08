Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE4A1CA4B3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 09:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgEHHAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 03:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725991AbgEHHAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 03:00:37 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1291C05BD43
        for <stable@vger.kernel.org>; Fri,  8 May 2020 00:00:36 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so9409143wmc.5
        for <stable@vger.kernel.org>; Fri, 08 May 2020 00:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8MnCc1khSljqIz98fLPIacDy/8apvfnoTAzjX1a/XTA=;
        b=NJ58n12wUmvKp+G7bWopRKxtR/va+EFmrzC9cpGIOeOqvMOAgJfdASAR/dk4e46lrx
         4IqkG5/MwNcOIPcxaoCxzw5waP18CXhGYNfdbLUCsfODEXLbAhklGp5tFN8az8sRayzd
         Cf3dc41BXm+quJsgzmm7Uc+yVIE3Svmt2nDrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8MnCc1khSljqIz98fLPIacDy/8apvfnoTAzjX1a/XTA=;
        b=mG+eKszggrCeXd3AX0N3rBM0rC4pYeAmYFnWGqF50fZPmQw+IPG2NSNy2wahgJQfki
         8m5PyIt3wPZPosfGvoLlQI8fXPrEjUZ70GeHL2brfp+wJRnbEuO3bX1zFwc6iDF+z+ae
         UWAYpeb4FKFHPAfQyPbimcsDjpLgzL+/F4IMFSFPcXHMkKzmhvnCucMi6YxXm57PpF8P
         VL58GdCkGtOXsYHqlZf2QAUqQKWsbo49lkK9J9KCH/uPHAAQAIOSl29/rtDrlxABG94x
         OpIKlq4TR9qc++egNsYu9nUhvHOLUgw3QajZV85qpWeu4tsrpGDSyFVN4ZyasFDMBjI0
         EzjA==
X-Gm-Message-State: AGi0PuYebWXJmtltvA045KrzAvVBPqcJgeHlA7kmdsXTK+4s6MmK5Ffz
        kN5vHw7ulFBwEB2g2+zEDvd94g==
X-Google-Smtp-Source: APiQypLOqs4JdrZ323p/FA7Dw8Zkacjt0l2kb4eU+AwHxgdaHxIjPyu74gv/Tyfnwg4V31/pphUu2Q==
X-Received: by 2002:a1c:4c3:: with SMTP id 186mr10967389wme.75.1588921235701;
        Fri, 08 May 2020 00:00:35 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id x18sm11050540wmi.29.2020.05.08.00.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 00:00:34 -0700 (PDT)
Date:   Fri, 8 May 2020 09:00:33 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     airlied@redhat.com, daniel@ffwll.ch, kraxel@redhat.com,
        sam@ravnborg.org, emil.velikov@collabora.com, cogarre@gmail.com,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH v3] drm/ast: Don't check new mode if CRTC is being
 disabled
Message-ID: <20200508070033.GE1383626@phenom.ffwll.local>
References: <20200507090640.21561-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507090640.21561-1-tzimmermann@suse.de>
X-Operating-System: Linux phenom 5.4.0-4-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 11:06:40AM +0200, Thomas Zimmermann wrote:
> Suspending failed because there's no mode if the CRTC is being
> disabled. Early-out in this case. This fixes runtime PM for ast.
> 
> v3:
> 	* fixed commit message
> v2:
> 	* added Tested-by/Reported-by tags
> 	* added Fixes tags and CC (Sam)
> 	* improved comment
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reported-by: Cary Garrett <cogarre@gmail.com>
> Tested-by: Cary Garrett <cogarre@gmail.com>
> Fixes: b48e1b6ffd28 ("drm/ast: Add CRTC helpers for atomic modesetting")
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: <stable@vger.kernel.org> # v5.6+

Yeah legacy crtc helpers just let you shut stuff off and no checks.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/gpu/drm/ast/ast_mode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
> index 7a9f20a2fd303..0cbbb21edb4e1 100644
> --- a/drivers/gpu/drm/ast/ast_mode.c
> +++ b/drivers/gpu/drm/ast/ast_mode.c
> @@ -801,6 +801,9 @@ static int ast_crtc_helper_atomic_check(struct drm_crtc *crtc,
>  		return -EINVAL;
>  	}
>  
> +	if (!state->enable)
> +		return 0; /* no mode checks if CRTC is being disabled */
> +
>  	ast_state = to_ast_crtc_state(state);
>  
>  	format = ast_state->format;
> -- 
> 2.26.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
