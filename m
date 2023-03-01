Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42EA6A713D
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCAQe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCAQeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:34:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F308D48E1F;
        Wed,  1 Mar 2023 08:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8C08B810C2;
        Wed,  1 Mar 2023 16:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF2AC4339B;
        Wed,  1 Mar 2023 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688327;
        bh=ekrTEQ0q++a5WN0k+M9CsbiFIswHRa1ALpiUlb9/+Ss=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KgPB/tuSBEAaOXBtYXpzsqZKTy4ozyrttC8GXchWTpgRovOjLIiynCEN1SqGu3NMl
         YBe9Gn0grYSviUj+ZAhB7BzSFOjHTKun2IYtZK1/ywePOwaGx2q3deM6TUoNH0VGyr
         XvNfUYMJD7NnWOfLykNyxw/O9FPhXcAdh36TZQt1D1sUbQS/PsLw2NQ3slEP8uN51o
         3Q6nSM+XfgYhD1qPDevVNjn+GlonFclyneI109Z8aiBezIOfUJ4qOS+1EIDNXpAKHJ
         cSGLse/FsePcoU/RBxD3U9myldCSlkuDAhoEFlSrFB7UipHfL939YKVNpeAnaTbBBS
         mk+++6sgetfFg==
Received: by mail-lf1-f48.google.com with SMTP id i9so18412797lfc.6;
        Wed, 01 Mar 2023 08:32:07 -0800 (PST)
X-Gm-Message-State: AO0yUKU1fHC+oceOkVe9v1yaOxE+vZPb3T4gGaDveDzq2atbfdhYpX6l
        /1rSgnPUXyGmH3HjzuARY3meJVbpB/l3QppQPY4=
X-Google-Smtp-Source: AK7set+gTLkj1nm9gIjJG3pSAjb+pOBd8d6F56tj2HqtCxfViqoktxFzETrcNp3ZewQtLDE5l7we+RdSjy5AiY0m61A=
X-Received: by 2002:ac2:5329:0:b0:4dd:805b:5b75 with SMTP id
 f9-20020ac25329000000b004dd805b5b75mr2024650lfh.7.1677688325522; Wed, 01 Mar
 2023 08:32:05 -0800 (PST)
MIME-Version: 1.0
References: <20230301163017.1303229-1-sashal@kernel.org> <20230301163017.1303229-2-sashal@kernel.org>
In-Reply-To: <20230301163017.1303229-2-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Mar 2023 17:31:53 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF3mhfFu4xtTJJjNwHFCk8SbvPE49neS6BjgptGabdaXQ@mail.gmail.com>
Message-ID: <CAMj1kXF3mhfFu4xtTJJjNwHFCk8SbvPE49neS6BjgptGabdaXQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 2/3] efi: efivars: prevent double registration
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Mar 2023 at 17:30, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Johan Hovold <johan+linaro@kernel.org>
>
> [ Upstream commit 0217a40d7ba6e71d7f3422fbe89b436e8ee7ece7 ]
>
> Add the missing sanity check to efivars_register() so that it is no
> longer possible to override an already registered set of efivar ops
> (without first deregistering them).
>
> This can help debug initialisation ordering issues where drivers have so
> far unknowingly been relying on overriding the generic ops.
>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK this is not a bugfix.

> ---
>  drivers/firmware/efi/vars.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index e619ced030d52..462e88b9d2ba4 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -1195,19 +1195,28 @@ int efivars_register(struct efivars *efivars,
>                      const struct efivar_operations *ops,
>                      struct kobject *kobject)
>  {
> +       int rv;
> +
>         if (down_interruptible(&efivars_lock))
>                 return -EINTR;
>
> +       if (__efivars) {
> +               pr_warn("efivars already registered\n");
> +               rv = -EBUSY;
> +               goto out;
> +       }
> +
>         efivars->ops = ops;
>         efivars->kobject = kobject;
>
>         __efivars = efivars;
>
>         pr_info("Registered efivars operations\n");
> -
> +       rv = 0;
> +out:
>         up(&efivars_lock);
>
> -       return 0;
> +       return rv;
>  }
>  EXPORT_SYMBOL_GPL(efivars_register);
>
> --
> 2.39.2
>
