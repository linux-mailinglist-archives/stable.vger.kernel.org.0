Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6967247D3C9
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241349AbhLVOgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbhLVOgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 09:36:14 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7C2C061574;
        Wed, 22 Dec 2021 06:36:13 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso3137566otf.0;
        Wed, 22 Dec 2021 06:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKV2BgPx3gxDDsLRq0VaVFxrk1VsU28qjAbSzmWcK8s=;
        b=F4FtXIvPLHbNUO3PvwjUupkMTlh/8PoI8Mlv+LjOyiWfHwe3Rp4hnQZYbK32u0+Uf9
         d2vsLj3kr/GNU6EArfgKY/7c01pFl10W5OlApZ8PcERSfkfKRDeWRSILqMhwWhSMJMzl
         VnPXpUUwQs39GmhzqKEw98M/UcJxxDoM0A0ovMyK57n2LZ6URDRbzkEgd8Z9c/VR8Gil
         61TtT5V1UDXYkcSnbPGKlZ2h+jyTxrBQuh0b6sD5WelYsvqD9k7sIMY/0vVuxC5qol0J
         fMyR/bh7AXjyBNk3tTMl0MMIGVHuTu0YO5n5j8xGABViZbXX3EdAwDSn8f6T4KLQ31/o
         0e+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKV2BgPx3gxDDsLRq0VaVFxrk1VsU28qjAbSzmWcK8s=;
        b=L+3FMA92WetuaCW7jRseyGw3Pj9i3r2+PmsIwAznWHC3pBS/yQ65IsBY5VsOg30ixu
         G5bSwf1moIrXh7qeJheG3w9RYKfIgDZQx8/9Fth+KJWddx1CyRiKd+jQH9B/zCFCmGu2
         k0PRj/wYQ1aJJvkXd1hAGf5mfLOuGgOw828HXm99E0SVWcKoa5lVMEpZC5SZQahiH6aI
         vyuQHImrYAPEmM7HU06tLXM7x9lUpIydx657c0dNBZ64FxGjVanW2tGnQtmLjyFa6R/C
         xrlq295G/wOyqHmZ2Raof26jZbjAIHROrp0Z79z05nzIkJUqnv/N+hLyHj9z61TfWMT6
         9k0g==
X-Gm-Message-State: AOAM532hX9gC2K1rsGTlP/rew32xh1EZtjQ6FqYtoweF4foofrRWGYn1
        24TACv0m1JHB9Ku1KyFc0s3llvOpL0cIMXfzEgY=
X-Google-Smtp-Source: ABdhPJy3WcmtsTxv7JJwydEOin6GI2gdo+m/5Hy64ORpHVjNNh9PY34ZN27QovkF7vfUp/iqgBerodD18DXLUYQeGSA=
X-Received: by 2002:a9d:6855:: with SMTP id c21mr2261142oto.357.1640183773245;
 Wed, 22 Dec 2021 06:36:13 -0800 (PST)
MIME-Version: 1.0
References: <20211218042226.2608212-1-yzhai003@ucr.edu>
In-Reply-To: <20211218042226.2608212-1-yzhai003@ucr.edu>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 22 Dec 2021 09:36:02 -0500
Message-ID: <CADnq5_MT3Ci94jytrXWM_WJaMU7BpzQHMhJnPb-hgUhU6JDa1w@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Fix the uninitialized variable in enable_stream_features()
To:     Yizhuo Zhai <yzhai003@ucr.edu>
Cc:     David Airlie <airlied@linux.ie>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Jun Lei <jun.lei@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Wenjing Liu <wenjing.liu@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        "Guo, Bing" <Bing.Guo@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Agustin Gutierrez <agustin.gutierrez@amd.com>,
        Mark Morra <MarkAlbert.Morra@amd.com>,
        Robin Singh <robin.singh@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Applied.  Thanks!

Alex

On Fri, Dec 17, 2021 at 11:22 PM Yizhuo Zhai <yzhai003@ucr.edu> wrote:
>
> In function enable_stream_features(), the variable "old_downspread.raw"
> could be uninitialized if core_link_read_dpcd() fails, however, it is
> used in the later if statement, and further, core_link_write_dpcd()
> may write random value, which is potentially unsafe.
>
> Fixes: 6016cd9dba0f ("drm/amd/display: add helper for enabling mst stream features")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yizhuo Zhai <yzhai003@ucr.edu>
> ---
>  drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
> index c8457babfdea..fd5a0e7eb029 100644
> --- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
> +++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
> @@ -1844,6 +1844,8 @@ static void enable_stream_features(struct pipe_ctx *pipe_ctx)
>                 union down_spread_ctrl old_downspread;
>                 union down_spread_ctrl new_downspread;
>
> +               memset(&old_downspread, 0, sizeof(old_downspread));
> +
>                 core_link_read_dpcd(link, DP_DOWNSPREAD_CTRL,
>                                 &old_downspread.raw, sizeof(old_downspread));
>
> --
> 2.25.1
>
