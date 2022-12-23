Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF281655173
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 15:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiLWOhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 09:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiLWOhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 09:37:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CE237FA8;
        Fri, 23 Dec 2022 06:37:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D12611DB;
        Fri, 23 Dec 2022 14:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB422C433F2;
        Fri, 23 Dec 2022 14:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671806271;
        bh=X3m6JwJmkeHyk0BNor7qqjk1g6puhJN41xsYyHkX7lE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JSfWpy9MdKCbP509p6W/5f5fDmk4LYq303A8u0NFc1DG3N18ETt9SGIBlbGtYwINd
         kTNNeuNoI2A6LZrRi1iAdOT5YzPKX9XSDL58MdAV7L85YLwjTB2V60rbPF/QyvgUaN
         c/OxBRbgUUzO/1xG7h4mEOvGlC9riOpi2AtroTy+uLvJurGf/JN123cIZkIgVOKe6B
         QqdnqRetx7Z6Amv0SpDh3sMfGpq71lzG1mgs1ZulQsU4ji4rZX/ShvRx6838pQYLcJ
         OZe3WoYPiRIN9lY45VDfk4Ao5/VtI0EnEr26xVlxv1hsyLxNh/SPRvIxzCrasz4tFf
         HgsttMM3VKOBA==
Received: by mail-lj1-f182.google.com with SMTP id e13so2657143ljn.0;
        Fri, 23 Dec 2022 06:37:51 -0800 (PST)
X-Gm-Message-State: AFqh2koMIgiyMa3A+hznBDiq7oEzF80B/2RdvS/Kf4wMSLvo3qt2kvin
        W5/51mri5sk/pZDMSt9aSgIRx5HRbo2CfQykzns=
X-Google-Smtp-Source: AMrXdXuaiwY1SI2xVJtYy5XhYz03ZT0uLMIQ55gjgyy1WIPT8IDHFTg3LmFnIiB7XrcHV4GdgTx8aNu3qUsL25yzTZw=
X-Received: by 2002:a2e:910b:0:b0:279:bbff:a928 with SMTP id
 m11-20020a2e910b000000b00279bbffa928mr420239ljg.415.1671806269834; Fri, 23
 Dec 2022 06:37:49 -0800 (PST)
MIME-Version: 1.0
References: <20221219091004.562-1-johan+linaro@kernel.org>
In-Reply-To: <20221219091004.562-1-johan+linaro@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 23 Dec 2022 15:37:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHggvi9LRXKdEGWEs1xzOpD85H_S3CYQOX3byNaemSkZw@mail.gmail.com>
Message-ID: <CAMj1kXHggvi9LRXKdEGWEs1xzOpD85H_S3CYQOX3byNaemSkZw@mail.gmail.com>
Subject: Re: [PATCH] efi: fix NULL-deref in init error path
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Li Heng <liheng40@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Dec 2022 at 10:10, Johan Hovold <johan+linaro@kernel.org> wrote:
>
> In case runtime services are not supported or have been disabled the
> runtime services workqueue will never have been allocated.
>
> Do not try to destroy the workqueue unconditionally in the unlikely
> event that EFI initialisation fails to avoid dereferencing a NULL
> pointer.
>
> Fixes: 98086df8b70c ("efi: add missed destroy_workqueue when efisubsys_init fails")
> Cc: stable@vger.kernel.org
> Cc: Li Heng <liheng40@huawei.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Thanks for the fix - I will queue it up after -rc1

> ---
>  drivers/firmware/efi/efi.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 09716eebe8ac..a2b0cbc8741c 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -394,8 +394,8 @@ static int __init efisubsys_init(void)
>         efi_kobj = kobject_create_and_add("efi", firmware_kobj);
>         if (!efi_kobj) {
>                 pr_err("efi: Firmware registration failed.\n");
> -               destroy_workqueue(efi_rts_wq);
> -               return -ENOMEM;
> +               error = -ENOMEM;
> +               goto err_destroy_wq;
>         }
>
>         if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
> @@ -443,7 +443,10 @@ static int __init efisubsys_init(void)
>  err_put:
>         kobject_put(efi_kobj);
>         efi_kobj = NULL;
> -       destroy_workqueue(efi_rts_wq);
> +err_destroy_wq:
> +       if (efi_rts_wq)
> +               destroy_workqueue(efi_rts_wq);
> +
>         return error;
>  }
>
> --
> 2.37.4
>
