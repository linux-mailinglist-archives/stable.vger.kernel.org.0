Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C7822024B
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 04:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGOCW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 22:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgGOCW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 22:22:26 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FEC220729;
        Wed, 15 Jul 2020 02:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594779745;
        bh=c4adXwgTz9+ULV0x1H07n31CpFW3Edu+uF+WF0+7G9c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RmuNG9E7sSX4nRDZbRLxTevXtFu/bIOq03QJKfFuVBIO7XnxDNP94KFf+qM8bT4WK
         j/fuHFx6wkd8kst4Y6b4xD4w8mg8DOsxn1JIRT+OC2wJX+qJUlzQLvyxneFzq/elTs
         DZPNJSSV110zvBjvyjBN71PShvY2BsXkcLrjLyTs=
Received: by mail-lj1-f178.google.com with SMTP id e4so831551ljn.4;
        Tue, 14 Jul 2020 19:22:25 -0700 (PDT)
X-Gm-Message-State: AOAM533edfqQm05gs4QWglCwoldo0kiaUuaza/Si/iPU/aN+/spoPLd3
        Umf7lDAPnk0mJUtgsFGR7yKDY1b65VI5/IEJZ+I=
X-Google-Smtp-Source: ABdhPJwrm2+zB1EhS3SfHGX0vYG35lCOW5okEt60TUk+1VM15EsRhzYEWaRG8mG/z5J3yAFF7b16dRsNls1wv3SMH6s=
X-Received: by 2002:a2e:3a14:: with SMTP id h20mr3363025lja.331.1594779743917;
 Tue, 14 Jul 2020 19:22:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200714184105.507384017@linuxfoundation.org> <20200714184106.782410654@linuxfoundation.org>
In-Reply-To: <20200714184106.782410654@linuxfoundation.org>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Wed, 15 Jul 2020 10:22:13 +0800
X-Gmail-Original-Message-ID: <CAGb2v65ecm+9iK7GY6xKUHNhjdDimcL8Kd6eg-yX_nOm5rMZjA@mail.gmail.com>
Message-ID: <CAGb2v65ecm+9iK7GY6xKUHNhjdDimcL8Kd6eg-yX_nOm5rMZjA@mail.gmail.com>
Subject: Re: [PATCH 5.4 026/109] drm/sun4i: mixer: Call of_dma_configure if
 theres an IOMMU
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Jul 15, 2020 at 3:11 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Maxime Ripard <maxime@cerno.tech>
>
> [ Upstream commit 842ec61f4006a6477a9deaedd69131e9f46e4cb5 ]
>
> The main DRM device is actually a virtual device so it doesn't have the
> iommus property, which is instead on the DMA masters, in this case the
> mixers.

The iommu driver and DT changes were added in v5.8-rc1. IMO There is no
point in backporting this patch to any stable kernel.

ChenYu

> Add a call to of_dma_configure with the mixers DT node but on the DRM
> virtual device to configure it in the same way than the mixers.
>
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Link: https://patchwork.freedesktop.org/patch/msgid/9a4daf438dd3f2fe07afb23688bfb793a0613d7d.1589378833.git-series.maxime@cerno.tech
> (cherry picked from commit b718102dbdfd0285ad559687a30e27cc9124e592)
> [Maxime: Applied to -fixes since it missed the merge window and display is
>          broken without it]
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/sun4i/sun8i_mixer.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.c b/drivers/gpu/drm/sun4i/sun8i_mixer.c
> index 18b4881f44814..e24f225d80f1f 100644
> --- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
> +++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
> @@ -452,6 +452,19 @@ static int sun8i_mixer_bind(struct device *dev, struct device *master,
>         mixer->engine.ops = &sun8i_engine_ops;
>         mixer->engine.node = dev->of_node;
>
> +       if (of_find_property(dev->of_node, "iommus", NULL)) {
> +               /*
> +                * This assume we have the same DMA constraints for
> +                * all our the mixers in our pipeline. This sounds
> +                * bad, but it has always been the case for us, and
> +                * DRM doesn't do per-device allocation either, so we
> +                * would need to fix DRM first...
> +                */
> +               ret = of_dma_configure(drm->dev, dev->of_node, true);
> +               if (ret)
> +                       return ret;
> +       }
> +
>         /*
>          * While this function can fail, we shouldn't do anything
>          * if this happens. Some early DE2 DT entries don't provide
> --
> 2.25.1
>
>
>
