Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4686A713B
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjCAQeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCAQeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:34:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C290497C8;
        Wed,  1 Mar 2023 08:33:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBA0561378;
        Wed,  1 Mar 2023 16:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C49DC433EF;
        Wed,  1 Mar 2023 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688309;
        bh=v/b7acOz8qcBWAoiXmmKqcdViieYmNPAzMaNDSvjrdo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E3k9Y0tJhHkfuJyvYcocqB1KGfXtf9H7o5P+KktFlTRBP2oaE3y7TdUEM79qANMti
         evFxZOpFPZJQbxCiaevD3grA5TjWmUokgossZG50o+smZwhz0zP2GPaPuErhHCFHA9
         GasJCajbCFVH3e0WZGq5IKNE9CPlrKNdhHd3lngeHM5XWe1vzkAiuWCI3D3hzTKLdn
         WMhRMHFjG4PgNX/FawgVoiwAVsY5I+ugo4thTbnNnURZkQsEg2BdRrTnS4Ww6vNtUU
         CAvCgWPtazL4MefFEbD/ShcBjlIzK/+6gfZKwfYMUI8SNMf1jLNNJp+Yei9vfoF1UR
         oYR2u3ejze8NQ==
Received: by mail-lf1-f46.google.com with SMTP id j11so2714480lfg.13;
        Wed, 01 Mar 2023 08:31:49 -0800 (PST)
X-Gm-Message-State: AO0yUKWx1Aj0WgxL7OEtC3rnOoSXnW/Xz7g6UqDLfIYXOSqBAEVllzK7
        672MLgr/QYYFnT7Kaa/mHaWUGkMJZSq3XvGU5qs=
X-Google-Smtp-Source: AK7set9czcjwLKNPFBwLk6vQNgCXxSgwzWG8IbojVdE1XX9/+o0/rDLOSEgkey5ACNx5ALw6AAo6DHFvy0mcIQj4dgs=
X-Received: by 2002:a05:6512:118d:b0:4db:37ff:f5d0 with SMTP id
 g13-20020a056512118d00b004db37fff5d0mr3785270lfr.1.1677688307336; Wed, 01 Mar
 2023 08:31:47 -0800 (PST)
MIME-Version: 1.0
References: <20230301162957.1303086-1-sashal@kernel.org> <20230301162957.1303086-2-sashal@kernel.org>
In-Reply-To: <20230301162957.1303086-2-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Mar 2023 17:31:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHssi6wRHOTTWvcPp1K3ssFxs_+Gzp_6BXaA5YOsJK6jQ@mail.gmail.com>
Message-ID: <CAMj1kXHssi6wRHOTTWvcPp1K3ssFxs_+Gzp_6BXaA5YOsJK6jQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 2/5] efi: efivars: prevent double registration
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
