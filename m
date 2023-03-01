Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93116A7132
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCAQdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCAQdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:33:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8F04BE81;
        Wed,  1 Mar 2023 08:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF451B810D8;
        Wed,  1 Mar 2023 16:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ED4C433EF;
        Wed,  1 Mar 2023 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688298;
        bh=mnMAYSsjWi1Hs/zRjWoStNLegmaNMvUg17qvnW6xzrI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Sg1AWJanvPO7CJn77DvWu9IVfcHyCTxqaeXdgY3BszZ3/TuF7uDMlkSgaoiWQkj+P
         GQWHSVythlXVajgWxhohPX6pDkPZ8AW/5jeeJtRJrRhYbBEH7b4Qg+2lV+sNWjeVIf
         yG2kq/jpR1eAkHTa2AdJYnQWEXAy8lT4D4hS8CsefXWivhAR42y8QBqQw1+QSKZiKs
         OWzLHDemLorTEQE597TwQ9qdSVWnxLKz0qLJTuP+rlaFMwnKO2kAMVmX9bJLLTjjZg
         qhO8uRwhVvvgmy25iL6eFuY59sLF41ulU16oysC1Ob84RGIy0M5Jlfp1R3eaXbTEb2
         f6TeXCruOSm8A==
Received: by mail-lf1-f54.google.com with SMTP id r27so18381643lfe.10;
        Wed, 01 Mar 2023 08:31:38 -0800 (PST)
X-Gm-Message-State: AO0yUKWu07m0UrVfgKlFUrzOVQsSbJ2lZvMi/CdZLuWDCh7JlF6+V/R1
        8D5iSnmPPhwKC/yY68BdfYQFNWUB+D501hvBjoc=
X-Google-Smtp-Source: AK7set9x/+TrvCUaV5YX0JqqeXk7N6EiVKgZr9nIwsnzUDvNXTafVn/ihTG4W3D/fgU9gLzbXY7C6NB3SZWolFQe00k=
X-Received: by 2002:a19:760f:0:b0:4db:f0a:d574 with SMTP id
 c15-20020a19760f000000b004db0f0ad574mr2019756lff.7.1677688296590; Wed, 01 Mar
 2023 08:31:36 -0800 (PST)
MIME-Version: 1.0
References: <20230301162948.1302994-1-sashal@kernel.org> <20230301162948.1302994-2-sashal@kernel.org>
In-Reply-To: <20230301162948.1302994-2-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Mar 2023 17:31:25 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFoa+q5V5rUmBMQ7bjmgzqzXgDVknYCrANOdQXg9Uk9tw@mail.gmail.com>
Message-ID: <CAMj1kXFoa+q5V5rUmBMQ7bjmgzqzXgDVknYCrANOdQXg9Uk9tw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.15 2/6] efi: efivars: prevent double registration
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

On Wed, 1 Mar 2023 at 17:29, Sasha Levin <sashal@kernel.org> wrote:
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
> index cae590bd08f27..871dee9343bfb 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -1164,19 +1164,28 @@ int efivars_register(struct efivars *efivars,
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
