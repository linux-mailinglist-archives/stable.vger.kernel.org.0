Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCD063D44B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiK3LUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 06:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiK3LTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 06:19:49 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360E87B4F3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 03:19:13 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id g12so26520395wrs.10
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 03:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I3RzUia69JsX3Kd3MgvLd201iv7H9LUlNLNFTBAG1oE=;
        b=XJZu8B6AZ1y/nps845IKPVxnobpz0UM/T0N4yqGpYy/4vgMkfsdVoCES1tjIPjUpzE
         O6MXwZGObIqUaTG77wWEK44TfgoE/XQWuBy0SIj2Pa7tShPt12REbD4PsqZEMlaWzUJN
         0yTvZ1l8SN1B9qSc0npZ3FMGslDYTp42W8ry4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3RzUia69JsX3Kd3MgvLd201iv7H9LUlNLNFTBAG1oE=;
        b=ALNy2RvPTZvX1k9XAik+B94N9Z3GDPLze1gBm5NOJXHkRRaOM58Pa5305NqwtaUKFi
         qcfCbwy+/sNI2bKPAEDCE2egnoBL+sVQ7pldfRR8xR16J5F6+uUSH0VHnJaEu/pmiaAU
         FUlPGQ4IisSDodTAUUiR6MlOvVjXxoJx/zPvIFB6Dt5iCLsJs/+aanxv9MlrPckmfDnp
         dZAcbBWczxgTvGSYTRy4slnDlPUPau+xm2mkrsK03tBi0UFIj6VmOeiRJuUicpaJJ8QM
         BZLqg8CuGxWEn2N/93jG9qT4g5UsxBGlQXW7VZ4Je1aZ2Ah35xpnGsiB2Vnd8mLaHPmA
         cz4g==
X-Gm-Message-State: ANoB5pkmBVi6j9b688dTxEAw74Qse2hyj6exRGTQRB2oDFH+wK0ZkLkA
        0nhxcmdgnB0Opbn+GuO0/qRzlw==
X-Google-Smtp-Source: AA0mqf48e1fWgDwzk3rs0tRqwfO8D57O3sN1m1tha8i3SLpnlU69XIlzUcMxeWApDhPF71SViK70Hw==
X-Received: by 2002:a5d:4dc5:0:b0:242:1d11:f990 with SMTP id f5-20020a5d4dc5000000b002421d11f990mr7107346wru.686.1669807151744;
        Wed, 30 Nov 2022 03:19:11 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id y2-20020adfdf02000000b0023657e1b980sm1235585wrl.53.2022.11.30.03.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 03:19:10 -0800 (PST)
Date:   Wed, 30 Nov 2022 12:19:08 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Rob Clark <robdclark@gmail.com>
Cc:     dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@chromium.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Eric Anholt <eric@anholt.net>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        Rob Herring <robh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drm/shmem-helper: Remove errant put in error path
Message-ID: <Y4c8LMIkGPoPGy+4@phenom.ffwll.local>
Mail-Followup-To: Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@chromium.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Eric Anholt <eric@anholt.net>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        Rob Herring <robh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20221129200242.298120-1-robdclark@gmail.com>
 <20221129200242.298120-2-robdclark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129200242.298120-2-robdclark@gmail.com>
X-Operating-System: Linux phenom 5.19.0-2-amd64
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 12:02:41PM -0800, Rob Clark wrote:
> From: Rob Clark <robdclark@chromium.org>
> 
> drm_gem_shmem_mmap() doesn't own this reference!
> 
> Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rob Clark <robdclark@chromium.org>

With Guenter's nits addressed:

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>


> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 35138f8a375c..110a9eac2af8 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -623,7 +623,6 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
>  
>  	ret = drm_gem_shmem_get_pages(shmem);
>  	if (ret) {
> -		drm_gem_vm_close(vma);
>  		return ret;
>  	}
>  
> -- 
> 2.38.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
