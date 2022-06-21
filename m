Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1807A553510
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349045AbiFUO7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352119AbiFUO6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 10:58:35 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AE238B3
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 07:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655823459;
        bh=2aoALuBN00PmSduFlvoiJAMS9RSBNzGb6YDz57hSH1E=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=djCN/8gyhyDdNOWu4iPYK0d7o+FkPgrY6MaGaQhBgDK1wq9Kw5O5Cf1/57dL2vmEm
         lymJjAgBheG/LxZUu9xYSefZac6++MaisgpEiMPtW9fqcQBfLGq8v1EPDG4EOGvJ0l
         182ID0St4IhU64xoqnPn8nEiZIcOTHtl2EndpEiM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.178.187]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MK3W0-1oP2C51NOg-00LT4V; Tue, 21
 Jun 2022 16:57:39 +0200
Message-ID: <8701b28a-fb86-c95f-6a3e-ddea9cd10b97@gmx.de>
Date:   Tue, 21 Jun 2022 16:57:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
Content-Language: en-US
To:     Daniel Vetter <daniel.vetter@ffwll.ch>, security@kernel.org
Cc:     =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@amd.com>,
        Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        openeuler-security@openeuler.org, guodaxing@huawei.com,
        Weigang <weigang12@huawei.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:olwoDj5ajuFNfyUfJO/5W6aI2NBbLy52fS5aI3h3pi86Z3yubUZ
 smFWLU1PetueAJMKH8IM/jykyH7Hl/2vtsUWGasS5/gW2fn03IC+FlR1/S9mjytzgBApqu7
 F7mqNCHW61pQZaEYNMZkpH6lI9xJzWJ+SGP2FvgEEzjAp9kX5iRqkJNF1FYGeH696vvmoxi
 B02+h6PU5y77YBzXn5tjA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vj27VgHztt4=:C/9MzOiLcv+gOEwJfOFi+j
 eHpTIu5kmJp3Bil79v3h15/am0vBEQ/Ls7cHB85EHOclC1K9ql2R0bqdvl9JL4LlvpTrAGLpH
 s3caiH4urVGkVhUkMQ8pdDpVsrlkKyeg/E/nVOpjS96cVI11qXAldGMn/5b2MukPQNQTn/u1f
 QgCXuWkiFeHw0NtF1gEbRBYcjtTMMgQyyqwqlwuJcThJN1b97QrIOI9pME2lZIexiROEwSmYE
 5m4lD/x4HOBTm1Hr1d19/qRowpukXko/YB6u1Yr4ankYcOAfd7JNDYrn8WQbAYyNpGYhn2EoC
 KKhXsii2SAkj4qOgYVVoQP03gAfoxnUMyX2rKqa9xQS6Ms/hEMXW1sAswYxnfjHxfydVmxXbL
 hISbycNxek6c2Mh8JmpJQt/4Iv4qXJ+vRcvuPNrOBNcOBj+T3R35WseeDRcUxOqXW0miwW6bB
 OULkVktE7PE6OT1Xf+Vko1bIGCD+IY489hgmeyvZZuML+liu4nI8l94dWWhvzTrIEN9i8+r9a
 UXdbZTu3a4N4f/M2FzAWLRiGCabENHG1y7Sc35K0EVEluHsm9pdZeiZIEPdZAExR6CrRQ1a55
 re7o2OXNELUHh27lPC9WYn1SKPXEKVZLFOSUkC9Na0H9MBPRLyYzQ1Agx+7aFtYM3RxMZA3MR
 q4w+XMFIjKOXpDbVJkcpdmb9ke2AUZ1yjvXTsJ/mfWUlmT1ulO7EKhxOb5h8mzhJ/nZLTwgZw
 4jNxhiukshqgkZ2bJ7WPVtgOoDK1S+oxVuYIZXQmTGYg1rvWDGci+cgEWz/j7LGs7aZ0YKiWQ
 hzgPTEPq/dVyyJmEsFcS93Y869VSMWfQ9k4AmDPoJksxAtNYvSQQ0MjYlRw85Lwpgskxv+ikc
 /j+kR5VUQhB2X0etxZHWwur2mZMBDWfWm5DRgVj5m8M95PFHUOnVvZpQ4PcBKdfrW1+UTqn7D
 eacG1BX6sOcjIKcZc6jBZeqUZAhIbo0nSol2eIJllD4fjlxWLokOS8Se6l4MR3bpeCkP9+yUe
 ZeBVwOvJaf7F6tL+88mc+4LKNy4hFDp3/lpVaXb7IF6X3UGro1VdNsu863LGCu6FSsGVwxZ10
 oX6pTIZlcFW5+FMSTaOnZIBeN+FSrWmkRiYKM8EwxERfNJLWcZ3OKyQGQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/22 11:23, Daniel Vetter wrote:
> The drm fbdev emulation does not forward mode changes to the driver,
> and hence all changes where rejected in 865afb11949e ("drm/fb-helper:
> reject any changes to the fbdev").
>
> Unfortunately this resulted in bugs on multiple monitor systems with
> different resolutions. In that case the fbdev emulation code sizes the
> underlying framebuffer for the largest screen (which dictates
> x/yres_virtual), but adjust the fbdev x/yres to match the smallest
> resolution. The above mentioned patch failed to realize that, and
> errornously validated x/yres against the fb dimensions.
>
> This was fixed by just dropping the validation for too small sizes,
> which restored vt switching with 12ffed96d436 ("drm/fb-helper: Allow
> var->x/yres(_virtual) < fb->width/height again").
>
> But this also restored all kinds of validation issues and their
> fallout in the notoriously buggy fbcon code for too small sizes. Since
> no one is volunteering to really make fbcon and vc/vt fully robust
> against these math issues make sure this barn door is closed for good
> again.

I don't understand why you are blaming fbcon here (again)...

The real problem is that user-provided input (virt/physical screen sizes)
isn't correctly validated.
And that's even what your patch below does.

Helge

> Since it's a bit tricky to remember the x/yres we picked across both
> the newer generic fbdev emulation and the older code with more driver
> involvement, we simply check that it doesn't change. This relies on
> drm_fb_helper_fill_var() having done things correctly, and nothing
> having trampled it yet.
>
> Note that this leaves all the other fbdev drivers out in the rain.
> Given that distros have finally started to move away from those
> completely for real I think that's good enough. The code it spaghetti
> enough that I do not feel confident to even review fixes for it.
>
> What might help fbdev is doing something similar to what was done in
> a49145acfb97 ("fbmem: add margin check to fb_check_caps()") and ensure
> x/yres_virtual aren't too small, for some value of "too small". Maybe
> checking that they're at least x/yres makes sense?
>
> Fixes: 12ffed96d436 ("drm/fb-helper: Allow var->x/yres(_virtual) < fb->w=
idth/height again")
> Cc: Michel D=C3=A4nzer <michel.daenzer@amd.com>
> Cc: Daniel Stone <daniels@collabora.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: <stable@vger.kernel.org> # v4.11+
> Cc: Helge Deller <deller@gmx.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: openeuler-security@openeuler.org
> Cc: guodaxing@huawei.com
> Cc: Weigang (Jimmy) <weigang12@huawei.com>
> Reported-by: Weigang (Jimmy) <weigang12@huawei.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
> Note: Weigang asked for this to stay under embargo until it's all
> review and tested.
> -Daniel
> ---
>  drivers/gpu/drm/drm_fb_helper.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_he=
lper.c
> index 695997ae2a7c..5664a177a404 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -1355,8 +1355,8 @@ int drm_fb_helper_check_var(struct fb_var_screenin=
fo *var,
>  	 * to KMS, hence fail if different settings are requested.
>  	 */
>  	if (var->bits_per_pixel > fb->format->cpp[0] * 8 ||
> -	    var->xres > fb->width || var->yres > fb->height ||
> -	    var->xres_virtual > fb->width || var->yres_virtual > fb->height) {
> +	    var->xres !=3D info->var.xres || var->yres !=3D info->var.yres ||
> +	    var->xres_virtual !=3D fb->width || var->yres_virtual !=3D fb->hei=
ght) {
>  		drm_dbg_kms(dev, "fb requested width/height/bpp can't fit in current =
fb "
>  			  "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\n",
>  			  var->xres, var->yres, var->bits_per_pixel,

