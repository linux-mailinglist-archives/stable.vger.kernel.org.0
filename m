Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FEB606C5C
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiJUAE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJUAE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:04:28 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA1AB0F
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 17:04:22 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id f37so2250040lfv.8
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 17:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gVbYG5UIGEz3Lg7e/hjecpq/3zDJltuDah5cSWiqG7U=;
        b=Ht625h2x7cRN1vOTiwnyJrd17NSuVMl9D1WNcAqLBxkRZTYFPIJZ/iLgki/gezWcw7
         hpYyJ3pV7oU4+hKbrEUbHo4ZZXnIhemszhy6woUyaVuyX4rrmNoF2L+0fYWA3h351ncc
         WgAK9Vjj3KoST4JrLmjqmcRZoKAotkbzo1/lU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gVbYG5UIGEz3Lg7e/hjecpq/3zDJltuDah5cSWiqG7U=;
        b=vRhqUA6Y7yvPKI8r+u8tAFP8P13cPBJXPg1eESmdceez5C8sBKnjex9TJBBgpPyIFa
         Q+v9K+UhZF0yqCb/N9Uc+qfeEK2XOQ0VZA5OtheQLlgYG19aLSZrhjhj5AmtGXlOs+gJ
         8QVM3oY8ySQSaCZwktMvxDfrA7YpMAkk8iNnFwN411WDw9qM7TOH6CGUqIapSs9YAVxj
         dtWrldIG1WqAaWFQ7GcBdYojgUaBw2gcyLDmxwLcMVKJVlvpRsQr7+dzDb6zmyXHbaLr
         ZH76yhbGfGIyN43C8QbcXi1k85PZ5cAs4U7ade0KbtwBg5gjTtWkYSFy63g1wqb4MlMy
         cKVw==
X-Gm-Message-State: ACrzQf2HPYo1D4ehspSwXN8X8R30RBIfovZQ76j4hljoSWbzIVIr012M
        28nt6Wb5MfylCBTuZQFTk7CHfDuO2KhwUcgUEvUbSg==
X-Google-Smtp-Source: AMsMyM4HXNyo2IvqSwgaiJEBsszN3xOy6E1ki9bKIjI0CAZc+n1UJoYsog2t98VQIYsuOdhuy6lTqs9dUSjGPtHanu8=
X-Received: by 2002:a05:6512:3dac:b0:4a4:8044:9c3 with SMTP id
 k44-20020a0565123dac00b004a4804409c3mr5429553lfv.145.1666310660814; Thu, 20
 Oct 2022 17:04:20 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Oct 2022 20:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <20221019180934.1.If29e167d8a4771b0bf4a39c89c6946ed764817b9@changeid>
References: <20221019180934.1.If29e167d8a4771b0bf4a39c89c6946ed764817b9@changeid>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Thu, 20 Oct 2022 20:04:19 -0400
Message-ID: <CAE-0n53L9c5fTC9vut6+at583qoi2ecs29uQZF=6fAmZX2r2qA@mail.gmail.com>
Subject: Re: [PATCH] firmware: coreboot: Register bus in module init
To:     Brian Norris <briannorris@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Benson Leung <bleung@chromium.org>,
        chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>,
        Julius Werner <jwerner@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Brian Norris (2022-10-19 18:10:53)
[...]
> [    0.114560]  do_initcall_level+0x134/0x160
> [    0.114571]  do_initcalls+0x60/0xa0
> [    0.114579]  do_basic_setup+0x28/0x34
> [    0.114588]  kernel_init_freeable+0xf8/0x150
> [    0.114596]  kernel_init+0x2c/0x12c
> [    0.114607]  ret_from_fork+0x10/0x20
> [    0.114624] Code: 5280002b 1100054a b900092a f9800011 (885ffc01)
> [    0.114631] ---[ end trace 0000000000000000 ]---
>
> Fixes: b81e3140e412 ("firmware: coreboot: Make bus registration symmetric")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>

> diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
> index c52bcaa9def6..9ca21feb9d45 100644
> --- a/drivers/firmware/google/coreboot_table.c
> +++ b/drivers/firmware/google/coreboot_table.c
> @@ -199,6 +194,32 @@ static struct platform_driver coreboot_table_driver = {
>                 .of_match_table = of_match_ptr(coreboot_of_match),
>         },
>  };
> -module_platform_driver(coreboot_table_driver);
> +
> +static int __init coreboot_table_driver_init(void)
> +{
> +       int ret;
> +
> +       ret = bus_register(&coreboot_bus_type);
> +       if (ret)
> +               return ret;
> +
> +       ret = platform_driver_register(&coreboot_table_driver);
> +       if (ret) {
> +               bus_unregister(&coreboot_bus_type);
> +               return ret;
> +       }
> +
> +       return 0;

This could be 'return ret' and two lines could be saved, but that is
super nitpick so whatever.
