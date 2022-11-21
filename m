Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CD63203F
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiKULTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiKULTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:19:05 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E34ABEB62
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:14:21 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id g7so5522244ile.0
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YKmL238oBqxiRNanxS8WxENXsxx4KWSkzL71xeQ1GGU=;
        b=cmTtkZsRLYZ2I7OrrX8A0P6ENVcoRjlUIfcoXkb+53K2jA1qr5lGYrpVGseSq278q+
         GLJCGg6rHlo8FEqW8LGQIYXFXJ5a5dwgunZ0fsd/adJPLzAbKdLRdKwSMgVFFqHd8hQG
         QO+fLy+vT8HOklP/uCk8dmMDdSwlr2Pl3c1yHtisY48EgVuuNTCiR3Cv3kjqmx3yqnQA
         uLHHCB1I18mgGAPJfPMwZAiURQL8TotvBLKGsFUCKCUpbVnE75cRojgHxAfmG9cLwOEb
         3U9B0C87KNHCKtfe5vPO4y0MRAFZ18zJtZZKROYda8xVEfwb/7M2z0I4epl0nYHUU/Hw
         xZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YKmL238oBqxiRNanxS8WxENXsxx4KWSkzL71xeQ1GGU=;
        b=ThgmUikjgm1AlV+CdAtvNt8GHKtP5S3tWoBbQtDZiRSEBlQvjbZWKd7d7kIoDuSMVK
         dGz4WrQmkCdfnMF4nQ85AR+sLTQdSuSs5vvNaSZ0+DbK+GXG1YhdQgEeugLsj0ihjoET
         Yr0GVGMAY70HeWRdx7nUDVScVm/aVcmcX5YF7cgj0kLnjEQw/pl9qQbfwocluJzKFuHM
         A1oirakfOAYqjo6Vf9eMOCstiv3ZV5c9PfErmq4orx/OMqdrmyEDxPuHBSzzHtB3GCBd
         GPZqueCqb8bNNV49wSHfBySjFslTWGSeL1kCgWXTZOQoPzXmQme4hTxKwmAl6w7gf8MW
         1iRA==
X-Gm-Message-State: ANoB5pnGIU421WLqUY6F6RbsOSa0an6SNWxXhujjT6KEPcShs9e24Xyk
        a4bLezmg/KMJxmZvd88HCHU/cU2z3CBWG80/58X/7g==
X-Google-Smtp-Source: AA0mqf5uuxubo0pCDvjXbIwnanubajZXjr7+F1Eregkc8LJqmNaOLK6kPnWI7ii9zYvuynlQ0vGgq5bNYlO61FtDZKs=
X-Received: by 2002:a05:6e02:523:b0:2f6:9105:7a15 with SMTP id
 h3-20020a056e02052300b002f691057a15mr2247770ils.292.1669029261089; Mon, 21
 Nov 2022 03:14:21 -0800 (PST)
MIME-Version: 1.0
References: <20221120142737.17519-1-LinoSanfilippo@gmx.de>
In-Reply-To: <20221120142737.17519-1-LinoSanfilippo@gmx.de>
From:   Dave Stevenson <dave.stevenson@raspberrypi.com>
Date:   Mon, 21 Nov 2022 11:14:04 +0000
Message-ID: <CAPY8ntB-LdH-oy86x-4Ox-JzgLLpmBNKu7j=bQo+Danj-r3+Dw@mail.gmail.com>
Subject: Re: [PATCH] drm/vc4: Fix NULL pointer access in vc4_platform_drm_probe()
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     airlied@gmail.com, daniel@ffwll.ch, eric@anholt.net,
        emma@anholt.net, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        l.sanfilippo@kunbus.com, p.rosenberger@kunbus.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lino

On Sun, 20 Nov 2022 at 15:26, Lino Sanfilippo <LinoSanfilippo@gmx.de> wrote:
>
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>
> In vc4_platform_drm_probe() function vc4_match_add_drivers() is called to
> find component matches for the component drivers. If no such match is found
> the passed variable "match" is still NULL after the function returns.

This would imply a very strange device tree that has bothered to add
the drm device but none of the devices that are required to run the
DRM pipeline, but avoiding a NULL deref is certainly preferable.

> Do not pass "match" to component_master_add_with_match() in this case since
> this results in a NULL pointer access as soon as match->num is used to
> allocate a component_match array. Instead return with -ENODEV from the
> drivers probe function.
>
> Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>

Acked-by: Dave Stevenson <dave.stevenson@raspberrypi.com>

> ---
>  drivers/gpu/drm/vc4/vc4_drv.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
> index 2027063fdc30..2e53d7f8ad44 100644
> --- a/drivers/gpu/drm/vc4/vc4_drv.c
> +++ b/drivers/gpu/drm/vc4/vc4_drv.c
> @@ -437,6 +437,9 @@ static int vc4_platform_drm_probe(struct platform_device *pdev)
>         vc4_match_add_drivers(dev, &match,
>                               component_drivers, ARRAY_SIZE(component_drivers));
>
> +       if (!match)
> +               return -ENODEV;
> +
>         return component_master_add_with_match(dev, &vc4_drm_ops, match);
>  }
>
>
> base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
> --
> 2.36.1
>
