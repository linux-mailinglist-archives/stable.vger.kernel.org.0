Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0EE41132D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 12:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhITK6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 06:58:49 -0400
Received: from mail.netline.ch ([148.251.143.180]:46339 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhITK6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 06:58:46 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 06:58:46 EDT
Received: from localhost (localhost [127.0.0.1])
        by netline-mail3.netline.ch (Postfix) with ESMTP id 4F55B20201B;
        Mon, 20 Sep 2021 12:50:11 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at netline-mail3.netline.ch
Received: from netline-mail3.netline.ch ([127.0.0.1])
        by localhost (netline-mail3.netline.ch [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id gN7c22HlVRu9; Mon, 20 Sep 2021 12:50:10 +0200 (CEST)
Received: from thor (24.99.2.85.dynamic.wline.res.cust.swisscom.ch [85.2.99.24])
        by netline-mail3.netline.ch (Postfix) with ESMTPA id A999620201A;
        Mon, 20 Sep 2021 12:50:10 +0200 (CEST)
Received: from [127.0.0.1]
        by thor with esmtp (Exim 4.95-RC2)
        (envelope-from <michel@daenzer.net>)
        id 1mSGsD-000Wag-Ug;
        Mon, 20 Sep 2021 12:50:09 +0200
Message-ID: <8d632b43-c41f-dd46-3d4c-cef19dbd3994@daenzer.net>
Date:   Mon, 20 Sep 2021 12:50:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-CA
To:     Simon Ser <contact@emersion.fr>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        amd-gfx@lists.freedesktop.org
References: <20210920103133.3573-1-contact@emersion.fr>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Subject: Re: [PATCH] amdgpu: check tiling flags when creating FB on GFX8-
In-Reply-To: <20210920103133.3573-1-contact@emersion.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-09-20 12:31, Simon Ser wrote:
> On GFX9+, format modifiers are always enabled and ensure the
> frame-buffers can be scanned out at ADDFB2 time.
> 
> On GFX8-, format modifiers are not supported and no other check
> is performed. This means ADDFB2 IOCTLs will succeed even if the
> tiling isn't supported for scan-out, and will result in garbage
> displayed on screen [1].
> 
> Fix this by adding a check for tiling flags for GFX8 and older.
> The check is taken from radeonsi in Mesa (see how is_displayable
> is populated in gfx6_compute_surface).
> 
> [1]: https://github.com/swaywm/wlroots/issues/3185
> 
> Signed-off-by: Simon Ser <contact@emersion.fr>
> Cc: stable@vger.kernel.org
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Harry Wentland <hwentlan@amd.com>
> Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
> Cc: Michel Dänzer <michel@daenzer.net>
> Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 31 +++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> index 58bfc7f00d76..dfe434a56a8c 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> @@ -837,6 +837,28 @@ static int convert_tiling_flags_to_modifier(struct amdgpu_framebuffer *afb)
>  	return 0;
>  }
>  
> +/* Mirrors the is_displayable check in radeonsi's gfx6_compute_surface */
> +static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
> +{
> +	u64 micro_tile_mode;
> +
> +	/* Zero swizzle mode means linear */
> +	if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0)
> +		return 0;
> +
> +	micro_tile_mode = AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MODE);
> +	switch (micro_tile_mode) {
> +	case 0: /* DISPLAY */
> +	case 3: /* RENDER */
> +		return 0;
> +	default:
> +		drm_dbg_kms(afb->base.dev,
> +			    "Micro tile mode %llu not supported for scanout\n",
> +			    micro_tile_mode);
> +		return -EINVAL;
> +	}
> +}
> +
>  static void get_block_dimensions(unsigned int block_log2, unsigned int cpp,
>  				 unsigned int *width, unsigned int *height)
>  {
> @@ -1103,6 +1125,7 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
>  				    const struct drm_mode_fb_cmd2 *mode_cmd,
>  				    struct drm_gem_object *obj)
>  {
> +	struct amdgpu_device *adev = drm_to_adev(dev);
>  	int ret, i;
>  
>  	/*
> @@ -1122,6 +1145,14 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
>  	if (ret)
>  		return ret;
>  
> +	if (!dev->mode_config.allow_fb_modifiers) {
> +		drm_WARN(dev, adev->family >= AMDGPU_FAMILY_AI,
> +			 "GFX9+ requires FB check based on format modifier\n");

drm_WARN_ONCE would be better, to avoid spamming dmesg if there's a driver bug.


With that,

Acked-by: Michel Dänzer <mdaenzer@redhat.com>


-- 
Earthling Michel Dänzer            |                  https://redhat.com
Libre software enthusiast          |         Mesa and Xwayland developer
