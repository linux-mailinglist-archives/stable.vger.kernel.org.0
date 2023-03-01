Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4076A7159
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjCAQhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCAQhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:37:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D40AD0A;
        Wed,  1 Mar 2023 08:36:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7B2EB810BD;
        Wed,  1 Mar 2023 16:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D64FC4339B;
        Wed,  1 Mar 2023 16:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688274;
        bh=yqxjSwQ+JJAYLm6kKcyCpCF9CSk4cCeFqvaJDphkTQ4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JvUGZobeIQnL5IXy56lyO2w4MuER+Hme7+XDywpjbiMlS6z0nMRc4dLFZx8BYw2Qw
         zXAb3619NW9u8CpoWIOUQqdi97Zi2uoG61i4XbGM4HqCY1559DWElhHzb4EYs2GLKL
         PUmbJpUCEwUKh7RY3wsexi+YRU+LlLGti3bCIRLJVoS6cQps294rAdUZxdOvZ53F28
         IW+HslPYTLLpkN6YKe4GA6XXVig2cWWyPNHws4yoUd1e6e8keMel62CMQbg9oq0B7S
         TOlwm9D3ThoblbuAmqMCnYb8viGywPrcJYKlyoXxL2mkpC5P0LUfojMBqA4Z9R/KiE
         UbkIgDUipLpcw==
Received: by mail-lj1-f178.google.com with SMTP id b13so14613108ljf.6;
        Wed, 01 Mar 2023 08:31:14 -0800 (PST)
X-Gm-Message-State: AO0yUKWKqfGspGoa6AumsrwHMH2QBXuZoTz4l364dL8D+NazhCaOGvrD
        csmndsZLDz5ojJM+/DXOgtC8PlRbm5U5hbHiQn4=
X-Google-Smtp-Source: AK7set9m1KfXepha64qgOZ9u4bOr9vDIPjrKzYFQ1xPYHhb0Ip27K1WFe0IiJgcLRP+nv6HWSJChOfsOTHFnbysoNkw=
X-Received: by 2002:a2e:be9b:0:b0:293:4ba5:f626 with SMTP id
 a27-20020a2ebe9b000000b002934ba5f626mr7516932ljr.2.1677688272654; Wed, 01 Mar
 2023 08:31:12 -0800 (PST)
MIME-Version: 1.0
References: <20230301162938.1302886-1-sashal@kernel.org> <20230301162938.1302886-2-sashal@kernel.org>
In-Reply-To: <20230301162938.1302886-2-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Mar 2023 17:31:01 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE-m4zMGC6cQ3KbFL+na6coaX6t6EoEt8oFXP7=swQQxQ@mail.gmail.com>
Message-ID: <CAMj1kXE-m4zMGC6cQ3KbFL+na6coaX6t6EoEt8oFXP7=swQQxQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.1 2/6] efi: efivars: prevent double registration
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
> index 0ba9f18312f5b..4ca256bcd6971 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -66,19 +66,28 @@ int efivars_register(struct efivars *efivars,
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
