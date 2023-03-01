Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE396A712E
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjCAQdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCAQdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:33:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5071A497E4;
        Wed,  1 Mar 2023 08:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D154B80E95;
        Wed,  1 Mar 2023 16:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2815AC4339B;
        Wed,  1 Mar 2023 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688289;
        bh=yqxjSwQ+JJAYLm6kKcyCpCF9CSk4cCeFqvaJDphkTQ4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qHZLBgsINlWEhoeg1wXTyEsPszgXTWqzYDoTcusSQUK4RG90SgUFeVxNbPYlFecCH
         Xiuwb4Wau+XBxLCngOnYaXTTkDt8rSpBwgvYR1oIAXyK7ELIYp2gZoRsYX6Y1dRVQy
         4sk32900oSLXHUzUZlOhRA9v0YDpc7NrbPWoZAmILnb0id2gCjIvs4CxIWJSUvK14q
         lTYv3rmQI+j5objalksnLK+YxrhVqVZan/+xRHG4FTxQdAW71eRNrqroIKXfNqqPSU
         JME4IMNv/9Z9wnt+CKZRlYSeY/gA+cHlrSlmblo1EkKH0BXlelMrDn2pVMkZH8192T
         /j5+VER4UANAg==
Received: by mail-lf1-f54.google.com with SMTP id j11so2713050lfg.13;
        Wed, 01 Mar 2023 08:31:29 -0800 (PST)
X-Gm-Message-State: AO0yUKXcsNuguXxnYFPobwHisEqptli6wIeMx3aY4/7+qLLg6+eRChAR
        WTELVRGfCQCb0UDEM3nmGUpY1D/LgxYURECGaMo=
X-Google-Smtp-Source: AK7set+I2IezZImfifTROVZPNh3DIrhkIWQFXci9c6fb03oSgCfAi52BlVtuxEVndJqRT+V63lY7g78v6sISc6tWQAk=
X-Received: by 2002:ac2:4c2a:0:b0:4dc:807a:d148 with SMTP id
 u10-20020ac24c2a000000b004dc807ad148mr2020408lfq.7.1677688287143; Wed, 01 Mar
 2023 08:31:27 -0800 (PST)
MIME-Version: 1.0
References: <20230301162929.1302785-1-sashal@kernel.org> <20230301162929.1302785-2-sashal@kernel.org>
In-Reply-To: <20230301162929.1302785-2-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Mar 2023 17:31:15 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHr4tFjC65v5BN465tYBr1_gsMhCHEd6R-d3CoJ=aiYsQ@mail.gmail.com>
Message-ID: <CAMj1kXHr4tFjC65v5BN465tYBr1_gsMhCHEd6R-d3CoJ=aiYsQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.2 2/6] efi: efivars: prevent double registration
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
