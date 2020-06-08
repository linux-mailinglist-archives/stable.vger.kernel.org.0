Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489361F2077
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 22:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgFHUKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 16:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgFHUKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 16:10:50 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A09C08C5C2;
        Mon,  8 Jun 2020 13:10:50 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x13so18850419wrv.4;
        Mon, 08 Jun 2020 13:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FpmDjv/4z+bOOzMaaZCzq+OX4BSSRVwW43zPHhJ2xCc=;
        b=utBp6bAo/kqQ2oA4ckj15HQYrQ59JUWEqJA3Of5/uxOsvMvb4EkBFGz67gIH6xZK2F
         +PEezeXivKuWi4lrP5l0ZVAJa8SI+M1tbHteo9tjSDU+AgeZTgj5tkX3n8qZ9T1OfNzh
         fMeNumH8wGu3RzzdHeU60ieAl7DY79DaqpCrukiWirXD+vjprfMkfaz8dOqf6jCOKpCl
         MxI6gyJeiQJG92a+j4R9A8xP57KzuuYMYHMfvba1f7ju+DqUL9nL6tWXLZjtr0zF/ejX
         qCh+RwpNCgd5PEUV8qdxxJqWFfW2siV7QaWEK549z4QLR/O9omuvZ+r9/ma9TQvvvQY5
         Ly2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FpmDjv/4z+bOOzMaaZCzq+OX4BSSRVwW43zPHhJ2xCc=;
        b=NnB2Z8UDrE/LMNznCtG8PS9aJYGBx1gRIEl24gIBkvNYeXHyi2nH8M8i8LlykFNoBu
         xYS8MsWp/Ny4eIu2rpAln5zBHpY3qj2EwemFxOmNLPUcYFfhPavRnulEirXPIT9MuI6i
         qJ4iLJEArcPC2HkjDwogOxFctCdcVu3B5IcR33K7Rq1edYSHNQ4AukAkbr4PQc2h9VmJ
         Hms58HQg59pe89HvJSJBoXJAm8SoLZj/R6uEwOV1xQEkvgY+XMy8enkRB/ncOCl4BFoS
         L2ZrtPUua3qC1g2dG0NbDqmyINmEWbKycUjqDF5gyKuc306jjk2bzbN0aBSVfutQKRmp
         Ylgg==
X-Gm-Message-State: AOAM532RWmAqcQfONqw2htzGecZpM3bvATqZnOAm//e2+97CKrnUpm5a
        ghpVm3gvFMUPBp4bxx7wRpv6L2vEn6c1wFCw+dtgDg==
X-Google-Smtp-Source: ABdhPJyy5itok2Iy8uyhjJuP9dIySwRmblOvMoIpl2MphBFuJdv3p5xFj6rtOPz3uZF59vWcOPZv2OGYgiEySofNba4=
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr483601wrq.362.1591647048950;
 Mon, 08 Jun 2020 13:10:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200605173744.68500-1-efremov@linux.com>
In-Reply-To: <20200605173744.68500-1-efremov@linux.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 8 Jun 2020 16:10:37 -0400
Message-ID: <CADnq5_Orcz=D=coVwd9U1prAPPDzJbFWnhzcONKvmMtCpFAbdw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/amd/display: Use kvfree() to free coeff in build_regamma()
To:     Denis Efremov <efremov@linux.com>
Cc:     Leo Li <sunpeng.li@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        David Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 5, 2020 at 1:38 PM Denis Efremov <efremov@linux.com> wrote:
>
> Use kvfree() instead of kfree() to free coeff in build_regamma()
> because the memory is allocated with kvzalloc().
>
> Fixes: e752058b8671 ("drm/amd/display: Optimize gamma calculations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied the series.  Thanks!

Alex

> ---
>  drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
> index 9431b48aecb4..56bb1f9f77ce 100644
> --- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
> +++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
> @@ -843,7 +843,7 @@ static bool build_regamma(struct pwl_float_data_ex *rgb_regamma,
>         pow_buffer_ptr = -1; // reset back to no optimize
>         ret = true;
>  release:
> -       kfree(coeff);
> +       kvfree(coeff);
>         return ret;
>  }
>
> --
> 2.26.2
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
