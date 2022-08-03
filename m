Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0BD589209
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 20:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiHCSGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 14:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbiHCSGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 14:06:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEAA042AE6
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 11:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659550013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rh/D//LpX2EQSZeExryw0yfWU5X+yGvodAZfXC00FRk=;
        b=Ulrh6H41Y/U5woryt2wWSjl+QNkcIJ844XUKDhlULo0J9+tmvkWvpjh+aXa2Mvh6H3XhEp
        iOB483qdoy1GC56g58gt5JSJ17Jk8w0Lt48GwNirADESCXmGsT62zNGR1/4nbq4RH52jLw
        NNYcp9bTl9oFAnQca5l/PDkbs30g09k=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-xB7fGUy6O1WP_dDcY-0a-g-1; Wed, 03 Aug 2022 14:06:51 -0400
X-MC-Unique: xB7fGUy6O1WP_dDcY-0a-g-1
Received: by mail-qv1-f71.google.com with SMTP id a11-20020ad45c4b000000b004747a998b9eso10386094qva.9
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 11:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=Rh/D//LpX2EQSZeExryw0yfWU5X+yGvodAZfXC00FRk=;
        b=hGFC6iYF15l4y/byxPeect02/KT/M57m35YxSHA8/azzPFVYKN8KxTotaAPr/7divf
         cUmQfOPTsVSr0jqTgK0FOd0L//7M9byQqA9WORJOXRifEHTBM8F42d71xTboQnzIt2aN
         7BpVLVoFODQSuU369f7QwF5ATziadBfDreSqdQORwp95VKtBR7pwOP2WM7b6yi4uu6Ki
         yuiMM+T5rIpEwaC4s7Gy5x00KkciuJ1l0fBCWgYJ05UxHqO8xy7xqAwn2a67FYV5LtCi
         VAUjrqdbHCsjRATkOXhHX1xweOx+gt7NUbEv5dXOQAqTCzka3GZgzZnqBz5Bk1auaDWK
         p/XQ==
X-Gm-Message-State: AJIora9fd1dpqVsDa1kDHQ0Ovvjz5yiQOG8dBld/nB0bSeReR+UFKrHt
        EDBzNyPH+ny5vLEtOLrnuh637kcdOfcz1F4fNMcGFHohpr/JAu8bKydVURp9iX3Gl185I7qGBif
        nAh/cGitOYx/jusCG
X-Received: by 2002:a05:620a:28cf:b0:6b5:e32f:febb with SMTP id l15-20020a05620a28cf00b006b5e32ffebbmr18518175qkp.258.1659550011424;
        Wed, 03 Aug 2022 11:06:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v1wP4M+hCDHMvv7zAVXU8ZZsm0m0Hr8gMyZl3KqH9ZCDJtIXmNHrJmFeE8kKzevcYazksmzg==
X-Received: by 2002:a05:620a:28cf:b0:6b5:e32f:febb with SMTP id l15-20020a05620a28cf00b006b5e32ffebbmr18518161qkp.258.1659550011181;
        Wed, 03 Aug 2022 11:06:51 -0700 (PDT)
Received: from [192.168.8.138] (pool-100-0-245-4.bstnma.fios.verizon.net. [100.0.245.4])
        by smtp.gmail.com with ESMTPSA id g1-20020a05620a40c100b006b55036fd3fsm13720397qko.70.2022.08.03.11.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 11:06:50 -0700 (PDT)
Message-ID: <4fd72edfab4cfb6e8ca9731f1087c2209299bdd2.camel@redhat.com>
Subject: Re: [PATCH] drm/nouveau: recognise GA103
From:   Lyude Paul <lyude@redhat.com>
To:     Karol Herbst <kherbst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     nouveau@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        stable@vger.kernel.org
Date:   Wed, 03 Aug 2022 14:06:49 -0400
In-Reply-To: <20220803142745.2679510-1-kherbst@redhat.com>
References: <20220803142745.2679510-1-kherbst@redhat.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Wed, 2022-08-03 at 16:27 +0200, Karol Herbst wrote:
> Appears to be ok with general GA10x code.
> 
> Signed-off-by: Karol Herbst <kherbst@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.15+
> ---
>  .../gpu/drm/nouveau/nvkm/engine/device/base.c | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> index 62efbd0f3846..b7246b146e51 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> @@ -2605,6 +2605,27 @@ nv172_chipset = {
>         .fifo     = { 0x00000001, ga102_fifo_new },
>  };
>  
> +static const struct nvkm_device_chip
> +nv173_chipset = {
> +       .name = "GA103",
> +       .bar      = { 0x00000001, tu102_bar_new },
> +       .bios     = { 0x00000001, nvkm_bios_new },
> +       .devinit  = { 0x00000001, ga100_devinit_new },
> +       .fb       = { 0x00000001, ga102_fb_new },
> +       .gpio     = { 0x00000001, ga102_gpio_new },
> +       .i2c      = { 0x00000001, gm200_i2c_new },
> +       .imem     = { 0x00000001, nv50_instmem_new },
> +       .mc       = { 0x00000001, ga100_mc_new },
> +       .mmu      = { 0x00000001, tu102_mmu_new },
> +       .pci      = { 0x00000001, gp100_pci_new },
> +       .privring = { 0x00000001, gm200_privring_new },
> +       .timer    = { 0x00000001, gk20a_timer_new },
> +       .top      = { 0x00000001, ga100_top_new },
> +       .disp     = { 0x00000001, ga102_disp_new },
> +       .dma      = { 0x00000001, gv100_dma_new },
> +       .fifo     = { 0x00000001, ga102_fifo_new },
> +};
> +
>  static const struct nvkm_device_chip
>  nv174_chipset = {
>         .name = "GA104",
> @@ -3092,6 +3113,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
>                 case 0x167: device->chip = &nv167_chipset; break;
>                 case 0x168: device->chip = &nv168_chipset; break;
>                 case 0x172: device->chip = &nv172_chipset; break;
> +               case 0x173: device->chip = &nv173_chipset; break;
>                 case 0x174: device->chip = &nv174_chipset; break;
>                 case 0x176: device->chip = &nv176_chipset; break;
>                 case 0x177: device->chip = &nv177_chipset; break;

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

