Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213F34EAA9A
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 11:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiC2Ji5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 05:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiC2JiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 05:38:18 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B5897B97;
        Tue, 29 Mar 2022 02:36:27 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id i11so5826628plg.12;
        Tue, 29 Mar 2022 02:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFEP+4MzWHajoB14yHUulSCyNblEw9o47q75qU5Tdek=;
        b=jbxChcH6l4E4+rE6SOYlHXS9Cprn1w9u+jMBk/N41JCaLIqM5klcHOBtUvIqHVkR/B
         IYTdf7iBrN+c3otifH3LJQMVngaRFUJyn+r3jjbj3QRTt8hhI1tzdp5J9cuF7H8U0JaE
         dO473oyPRq1h2XJevGdUsh4jMZ0WbWxdj0vVwjotTB/YmwNED6h0AmBkILACSj3dPtUD
         SUgraLli5FAw/AuvntHGDFHtXr249U1JgrM+8GfdhR1Q1AU6k2vUIt6szpZhJDahs9z4
         IFlFLg1jMTysTsEv469yZ44A1Nx2y8ZwGMFFFTvigku45af374VcpCEJ+Yu2bx3Y7eCa
         +Ojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFEP+4MzWHajoB14yHUulSCyNblEw9o47q75qU5Tdek=;
        b=4V3I2DfVG0vwF06dOGjTEBEGS7jluTcJbVn2kID2KVCIeFzNnx5Vya4IGD1ZQVHooN
         pp4WDH91ovm0h72Fe9KoOGIidwCyUsu4b96ZblhAWY7ZMXs4oju92C8LjPkQk0HhtRAB
         QvlyIwV2oNyJruRHk5FKlxbMt5XYKF9+ZRkW7/nCtrLQnTjjGfC1yUHezeVb2NFhfLhD
         udC0HFpB4IqvnIH0NvJcaqAA6XKBl+Rcxo32P5EWlTIEgYlXR22oj/0Y0xphzd/Z73up
         RwSyqkE/A6G59uu5/68o+sqntsy/dn1feaqqoX01NkBFCsf8Kv2wRSZIFy64DuvR4/bD
         Yi+Q==
X-Gm-Message-State: AOAM530qIFwMx/4AQMTzjBEZGj/sTQNTYkZ5XFL3oEN2BDd+Oj1ppqbI
        lRrsVj5k0q8x2/FGvwMa1FKAi+w1Wg2aXjY3fdQ=
X-Google-Smtp-Source: ABdhPJyiiZjRrT2knI3JEfT8yuNbK5HSyhUBWSoBfyY6qYaKeeIQnfmm7TN4ToPJZQ830POk1h/Ri8E7uK+43J86QB8=
X-Received: by 2002:a17:90b:3850:b0:1c6:572e:f39a with SMTP id
 nl16-20020a17090b385000b001c6572ef39amr3630800pjb.233.1648546586563; Tue, 29
 Mar 2022 02:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220327052028.2013-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220327052028.2013-1-xiam0nd.tong@gmail.com>
From:   Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Date:   Tue, 29 Mar 2022 11:36:15 +0200
Message-ID: <CAMeQTsboqXW-UeL9+E0vztTg_08w3WxvNhx-HqOdNc9yYJ4V+w@mail.gmail.com>
Subject: Re: [PATCH] gma500: fix an incorrect NULL check on list iterator
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 7:20 AM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> The bug is here:
>         return crtc;
>
> The list iterator value 'crtc' will *always* be set and non-NULL by
> list_for_each_entry(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element is found.
>
> To fix the bug, return 'crtc' when found, otherwise return NULL.
>
> Cc: stable@vger.kernel.org
> fixes: 89c78134cc54d ("gma500: Add Poulsbo support")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Thanks for the patch

Applied to drm-misc-next

-Patrik

> ---
>  drivers/gpu/drm/gma500/psb_intel_display.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
> index d5f95212934e..42d1a733e124 100644
> --- a/drivers/gpu/drm/gma500/psb_intel_display.c
> +++ b/drivers/gpu/drm/gma500/psb_intel_display.c
> @@ -535,14 +535,15 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
>
>  struct drm_crtc *psb_intel_get_crtc_from_pipe(struct drm_device *dev, int pipe)
>  {
> -       struct drm_crtc *crtc = NULL;
> +       struct drm_crtc *crtc;
>
>         list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
>                 struct gma_crtc *gma_crtc = to_gma_crtc(crtc);
> +
>                 if (gma_crtc->pipe == pipe)
> -                       break;
> +                       return crtc;
>         }
> -       return crtc;
> +       return NULL;
>  }
>
>  int gma_connector_clones(struct drm_device *dev, int type_mask)
> --
> 2.17.1
>
