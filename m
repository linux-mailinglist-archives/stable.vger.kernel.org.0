Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413435F60BE
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 07:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJFFpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 01:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJFFpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 01:45:06 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD521F2F0
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 22:45:04 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ogJgs-00044A-Os; Thu, 06 Oct 2022 07:45:02 +0200
Message-ID: <2da7598f-26ae-3da2-2534-d843aae7140c@leemhuis.info>
Date:   Thu, 6 Oct 2022 07:45:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] Revert "drm/amdgpu: use dirty framebuffer helper"
Content-Language: en-US, de-DE
To:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20221005154719.57566-1-hamza.mahfooz@amd.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20221005154719.57566-1-hamza.mahfooz@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1665035104;1a80d12a;
X-HE-SMSGID: 1ogJgs-00044A-Os
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CCing regression and stable lists, to make sure they are aware of the
regression]

On 05.10.22 17:47, Hamza Mahfooz wrote:
> This reverts commit 10b6e91bd1ee9cd237ffbc244ad9c25b5fd3e167.

/me can't find that id and wonders what he did wrong -- or is this not
meant to refer to Linus tree?

And isn't this reverting both 66f99628eb24409cb8feb5061f78283c8b65f820
and abbc7a3dafb91b9d4ec56b70ec9a7520f8e13334 in one go?

> Unfortunately, this commit causes performance regressions on non-PSR
> setups. So, just revert it until FB_DAMAGE_CLIPS support can be added.
> 
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2189
> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>

This seems to be missing a Reported-by tag, a CC: stable tag (needed to
ensure backporting), and a Fixes: tag.

But the reason why I started writing this mail is totally different from
the comments above:

In case you are not aware of it, that patch apparently broke amdgpu for
some users of 5.4.215:
https://bugzilla.kernel.org/show_bug.cgi?id=216554

So more Link: and Reported-by: tags might would be nice.

Ciao, Thorsten

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> index 23998f727c7f..1a06b8d724f3 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> @@ -38,8 +38,6 @@
>  #include <linux/pci.h>
>  #include <linux/pm_runtime.h>
>  #include <drm/drm_crtc_helper.h>
> -#include <drm/drm_damage_helper.h>
> -#include <drm/drm_drv.h>
>  #include <drm/drm_edid.h>
>  #include <drm/drm_gem_framebuffer_helper.h>
>  #include <drm/drm_fb_helper.h>
> @@ -500,12 +498,6 @@ static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
>  	.create_handle = drm_gem_fb_create_handle,
>  };
>  
> -static const struct drm_framebuffer_funcs amdgpu_fb_funcs_atomic = {
> -	.destroy = drm_gem_fb_destroy,
> -	.create_handle = drm_gem_fb_create_handle,
> -	.dirty = drm_atomic_helper_dirtyfb,
> -};
> -
>  uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,
>  					  uint64_t bo_flags)
>  {
> @@ -1108,10 +1100,8 @@ static int amdgpu_display_gem_fb_verify_and_init(struct drm_device *dev,
>  	if (ret)
>  		goto err;
>  
> -	if (drm_drv_uses_atomic_modeset(dev))
> -		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs_atomic);
> -	else
> -		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
> +	ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
> +
>  	if (ret)
>  		goto err;
>  
