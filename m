Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A076F62E720
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 22:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbiKQVlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 16:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiKQVlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 16:41:05 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1156828F;
        Thu, 17 Nov 2022 13:41:04 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1322d768ba7so3783157fac.5;
        Thu, 17 Nov 2022 13:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nc+c1ZgyaRHbiRmnbtBUUwq9SlkKMk4TXjmG53a3qPI=;
        b=nVvdu7JjyqkMcVh0WyCRhREoZFkY9TCHEnNLzr+ogGqNGJR+sFmPKas4PS6VZx3R+F
         B5I57zIftnK/XsEP9bHGsyDaZZyyyYzIH7nVzWhpzXoc8dt0liEKqxA3wpLInzrJFraK
         uTps7bxurQEC6N71TBxEzdZhL+ATw3nhc1GGhjb9KqdVO+5AKaR24AH5zfeg81Mk7rgd
         F0rYnPRiVhXSfIU5l7eupBixu3JTRrI0A9EfldNo55GTD9ZpHI2iid7gzeKb2pAfxu9r
         nIfd/ULkmoTQ/SnGsb2JYm4onWueWg7QS8F6xOGKJ4J/DIRkyRvSj230OefIYh1v0tAq
         Nf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nc+c1ZgyaRHbiRmnbtBUUwq9SlkKMk4TXjmG53a3qPI=;
        b=RBh4Z4vKAi4qEHyIhbRvZ0RcEuaUNOYkqCUbEgxdf5lUmFKty1G+Xztwg8+o8Da56H
         4tp8RnbG68wWoSaUND7PKwsiqaV8FefpJuabf9plH5e5/CLCM5OdsBAj8TuNur/G9id2
         uVFIje1GqPYV8GaJRQQBVS2ArBcg+ZkO8kmqS/k1YOkh8huHYbIZ4J4HBIX1E5W4Hngd
         I16L+05jWtIF2sDggkQzYrqr2Q2cmGHm4r36WtiUfOh/cWZ0kns3oxn85ZuAXoEx2/vG
         xlDxo13XHaVCfE1GFzUIzZJgrubwpOObweDJFLaj1b2wGXhiO7iJ5zatkryPCK4/QR2J
         XxCA==
X-Gm-Message-State: ANoB5pmVun5UosbJh46Nb5WuZeaA5AtdpWvP0VT/L5HZYSjdqUZIDmOs
        yb8YSeDhPwDwyH67S62TiI045XhrUaQ5REQ5SSQ=
X-Google-Smtp-Source: AA0mqf4kfKVTGi28Jg/pTNx2eiR1aNW14wXxeGvdl18I0KBg/P9rdGDpIevTBJ7ln+4qdyUStAa7R+2g/qBCXeQbqPs=
X-Received: by 2002:a05:6870:b07:b0:13b:d07f:f29d with SMTP id
 lh7-20020a0568700b0700b0013bd07ff29dmr2479858oab.96.1668721263887; Thu, 17
 Nov 2022 13:41:03 -0800 (PST)
MIME-Version: 1.0
References: <20221114222046.386560-1-lyude@redhat.com>
In-Reply-To: <20221114222046.386560-1-lyude@redhat.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 17 Nov 2022 16:40:52 -0500
Message-ID: <CADnq5_PrarJPZQu6uRwDdCqhZr7Hvbtxo_HuhiQ7H1DYRgSyqQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/dc/dce120: Fix audio register mapping, stop
 triggering KASAN
To:     Lyude Paul <lyude@redhat.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Alan Liu <HaoPing.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>, David Airlie <airlied@gmail.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 5:21 PM Lyude Paul <lyude@redhat.com> wrote:
>
> There's been a very long running bug that seems to have been neglected for
> a while, where amdgpu consistently triggers a KASAN error at start:
>
>   BUG: KASAN: global-out-of-bounds in read_indirect_azalia_reg+0x1d4/0x2a0 [amdgpu]
>   Read of size 4 at addr ffffffffc2274b28 by task modprobe/1889
>
> After digging through amd's rather creative method for accessing registers,
> I eventually discovered the problem likely has to do with the fact that on
> my dce120 GPU there are supposedly 7 sets of audio registers. But we only
> define a register mapping for 6 sets.
>
> So, fix this and fix the KASAN warning finally.
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org

This is the correct fix for asics having 7 audio instances.  It looks
correct to me, assuming DCE12 actually has 7 audio instances.
@Wentland, Harry Do you know off hand?  If you can confirm that, the
patch is:
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>


> ---
> Sending this one separately from the rest of my fixes since:
>
> * It's definitely completely unrelated to the Gitlab 2171 issue
> * I'm not sure if this is the correct fix since it's in DC
>
>  drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
> index 1b70b78e2fa15..af631085e88c5 100644
> --- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
> +++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
> @@ -359,7 +359,8 @@ static const struct dce_audio_registers audio_regs[] = {
>         audio_regs(2),
>         audio_regs(3),
>         audio_regs(4),
> -       audio_regs(5)
> +       audio_regs(5),
> +       audio_regs(6),
>  };
>
>  #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\
> --
> 2.37.3
>
