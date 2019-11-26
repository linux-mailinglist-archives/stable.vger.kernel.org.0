Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DE110A081
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 15:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfKZOkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 09:40:36 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36236 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZOkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 09:40:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so22729099wru.3
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 06:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=vDlRkpzIOrPRGh5pysj0vN3V4ARniTOU0E64e7Y7I4k=;
        b=We11rIf9pkSTfvXQfufaU9H4/tUZLZP0zPiq0QyBZx7rXYqB/Lbo00B9w3TyI38XDv
         IhhGUDrIyAjy3QwAIPo/ExlDP8YSHI0593gfyeq7rRfh69HiUpK3fujAH1PdUg1sySIg
         sCASiOk+mxUmzGq9FfOGPhaUbRwd8+9WobLFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vDlRkpzIOrPRGh5pysj0vN3V4ARniTOU0E64e7Y7I4k=;
        b=BkoPpZAD9uEZxeca2qNKDQHTu+EUI1WCOr60r8fpcFUt2atqKvVVto4PSOG+tJHnIZ
         kzBLzKOnTBzbPfClJUKtwPAURg0In3UGwpMbQ+QKTpTh8WAlHHlh6g5vyWIXB6gfGGxW
         9BAtzS6JVd+QTgIUqUORHoRx5T6R/BQJcmYM/+YtSJLXs3WtvB+KiJNNqBAsjKV8wIaF
         OPYdO5ltNVUiw1mr5lF3nVqZ8NwsV0kQydaBBvY3YsilNVjjRVb0DSbgCr4Cvmn/kefA
         gQ3CG5p/eEL7WjCNxpvnJFPvEgpGo3wbidLBv5ZtylvW9pf2mYABtALwoDAGFGk3NiME
         CTzA==
X-Gm-Message-State: APjAAAVamedIcmg3DSlb5sJrRQSebQnT8mq2dWr5dPOBrXX2r7N10zCx
        LaGNaH537/FR7fcghKuE1nE7kw==
X-Google-Smtp-Source: APXvYqxUmVBdcCYS7XSP5o8fYGZrhfhKicMhDiOZnyWOiksf2+PAvxuADqC946BHGNEBKb39ApM0Fg==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr1904540wrx.304.1574779233142;
        Tue, 26 Nov 2019 06:40:33 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id z26sm1479738wmk.33.2019.11.26.06.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 06:40:32 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:40:30 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v2 1/4] drm/rect: Avoid division by zero
Message-ID: <20191126144030.GY29965@phenom.ffwll.local>
References: <20191122175623.13565-1-ville.syrjala@linux.intel.com>
 <20191122175623.13565-2-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191122175623.13565-2-ville.syrjala@linux.intel.com>
X-Operating-System: Linux phenom 5.3.0-2-amd64 
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 07:56:20PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Check for zero width/height destination rectangle in
> drm_rect_clip_scaled() to avoid a division by zero.
> 
> Cc: stable@vger.kernel.org
> Fixes: f96bdf564f3e ("drm/rect: Handle rounding errors in drm_rect_clip_scaled, v3.")
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Benjamin Gaignard <benjamin.gaignard@st.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Testcase: igt/kms_selftest/drm_rect_clip_scaled_div_by_zero
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Clamping src to 0 if dst is 0 makes sense to me.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/gpu/drm/drm_rect.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_rect.c b/drivers/gpu/drm/drm_rect.c
> index b8363aaa9032..818738e83d06 100644
> --- a/drivers/gpu/drm/drm_rect.c
> +++ b/drivers/gpu/drm/drm_rect.c
> @@ -54,7 +54,12 @@ EXPORT_SYMBOL(drm_rect_intersect);
>  
>  static u32 clip_scaled(u32 src, u32 dst, u32 clip)
>  {
> -	u64 tmp = mul_u32_u32(src, dst - clip);
> +	u64 tmp;
> +
> +	if (dst == 0)
> +		return 0;
> +
> +	tmp = mul_u32_u32(src, dst - clip);
>  
>  	/*
>  	 * Round toward 1.0 when clipping so that we don't accidentally
> -- 
> 2.23.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
