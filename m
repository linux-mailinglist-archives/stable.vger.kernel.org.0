Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDD45E5FF5
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiIVKcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiIVKcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:32:23 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F800D6916;
        Thu, 22 Sep 2022 03:32:19 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4MYBRh1LdCz9sQw;
        Thu, 22 Sep 2022 12:32:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1663842736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcSMI9o79BEi4BYCfBNfXpEPRAzEwth0h8PN/3Lb7hI=;
        b=sF2Iw8irqYZ2giNv4jI/4zOj2NNyXc/XzeLxn3FgZUAbcWqYukOlcammalA0BUgPIPolrE
        Rw78XacPNgbBb8wl1rZ9E7xMwS9g3GNYVjQ8s08CpOrL/08nz+RTTEBVdcW5cIvvAEFsQo
        dT2qURjeRkQVGYFxIDDbJPU9dWfYDC5nUcjs2EihxPlN4MogHNuEjo8kRQ3xkHRTlsEeK/
        DE4EVV8UM2D0uFVqppeRENRSxUfIla5KB8+RRW6koBfZifIzBEips6GWimF4MAvKcowY6g
        dQ1IOHWyhzXNEN6oEoSEPlMuiM3uP0LC4RJVlrL6DaLyRsChBpfp/XhQuiS87Q==
Message-ID: <d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org>
Date:   Thu, 22 Sep 2022 12:32:13 +0200
MIME-Version: 1.0
Subject: Re: [PATCH AUTOSEL 5.4 3/5] drm/amdgpu: use dirty framebuffer helper
Content-Language: en-CA
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     guchun.chen@amd.com, airlied@linux.ie, contact@emersion.fr,
        dri-devel@lists.freedesktop.org, Xinhui.Pan@amd.com,
        amd-gfx@lists.freedesktop.org, aurabindo.pillai@amd.com,
        seanpaul@chromium.org, Hamza Mahfooz <hamza.mahfooz@amd.com>,
        daniel@ffwll.ch, Alex Deucher <alexander.deucher@amd.com>,
        evan.quan@amd.com, christian.koenig@amd.com, greenfoo@u92.eu
References: <20220921155436.235371-1-sashal@kernel.org>
 <20220921155436.235371-3-sashal@kernel.org>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@mailbox.org>
In-Reply-To: <20220921155436.235371-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 739b6371571c7f7200f
X-MBO-RS-META: wc3htxwqz1fpkxzby6gtuenpjfyxefbx
X-Rspamd-Queue-Id: 4MYBRh1LdCz9sQw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-09-21 17:54, Sasha Levin wrote:
> From: Hamza Mahfooz <hamza.mahfooz@amd.com>
> 
> [ Upstream commit 66f99628eb24409cb8feb5061f78283c8b65f820 ]
> 
> Currently, we aren't handling DRM_IOCTL_MODE_DIRTYFB. So, use
> drm_atomic_helper_dirtyfb() as the dirty callback in the amdgpu_fb_funcs
> struct.
> 
> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> index b588e0e409e7..d8687868407d 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> @@ -35,6 +35,7 @@
>  #include <linux/pci.h>
>  #include <linux/pm_runtime.h>
>  #include <drm/drm_crtc_helper.h>
> +#include <drm/drm_damage_helper.h>
>  #include <drm/drm_edid.h>
>  #include <drm/drm_gem_framebuffer_helper.h>
>  #include <drm/drm_fb_helper.h>
> @@ -495,6 +496,7 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
>  static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
>  	.destroy = drm_gem_fb_destroy,
>  	.create_handle = drm_gem_fb_create_handle,
> +	.dirty = drm_atomic_helper_dirtyfb,
>  };
>  
>  uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,

This patch has issues, see https://patchwork.freedesktop.org/patch/503749/ .


-- 
Earthling Michel Dänzer            |                  https://redhat.com
Libre software enthusiast          |         Mesa and Xwayland developer

