Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290E66A7135
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCAQeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCAQds (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:33:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0A29757;
        Wed,  1 Mar 2023 08:32:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 835F26142F;
        Wed,  1 Mar 2023 16:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B1DC4339C;
        Wed,  1 Mar 2023 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688318;
        bh=uPY4ydQ25CO6ep1QeYPgkwXlpb5MsMs035528mhZyo4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J20zqoI8C0fKAugpaNHU8PrsA6ehZHgZO1dFUVkBC3xGBKI6Cst82YCoEbImDMi0n
         k1thuaNKbfyDP28723GfGWynkO3x94RpohRvdhAGlcN0S/nU3sHECiBXWKTXQAw6mI
         5OXvcUls/f5p9dIR2403+gFcppx7Q7or3tk3LngH13dB8p+S+AuQbwL1foRF2zMDHL
         10CsETO7VFxPpn86jtZsbmY28JtwIXAbfCx/c2Iu0tIdJtOEsTYHsW5ESlanxgw5Ja
         ZgJzFi+bjbe2xy73NykwuXFQ/OGMH9OMPiC+u0RdZeOWao4uodbOr7eOwY/m6e4Lst
         yPN8oLvDpFdJA==
Received: by mail-lf1-f43.google.com with SMTP id n2so18357179lfb.12;
        Wed, 01 Mar 2023 08:31:58 -0800 (PST)
X-Gm-Message-State: AO0yUKUuETLv+1ZCHge/Qw5ie3VdVMjzf/1u3fswx41ASUueAlTT5j3V
        mVlQ1Il/i0D/FOxmxDqiUooGo2JYZOUZih444eQ=
X-Google-Smtp-Source: AK7set/Y/NoBB+dmLkejTZlxYAXOoRrq1VMr6b7rT1r/+40XOfvUw/fw7Xz3rDdCOW7FeF7uwCo5ThcRTnNTH25AcxQ=
X-Received: by 2002:ac2:5926:0:b0:4dc:807a:d143 with SMTP id
 v6-20020ac25926000000b004dc807ad143mr2038190lfi.7.1677688316941; Wed, 01 Mar
 2023 08:31:56 -0800 (PST)
MIME-Version: 1.0
References: <20230301163007.1303162-1-sashal@kernel.org> <20230301163007.1303162-2-sashal@kernel.org>
In-Reply-To: <20230301163007.1303162-2-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Mar 2023 17:31:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHHTPEPnfbN4XwDbo7GM3eJpQtgT67MpahELwZJeFkbLw@mail.gmail.com>
Message-ID: <CAMj1kXHHTPEPnfbN4XwDbo7GM3eJpQtgT67MpahELwZJeFkbLw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 2/4] efi: efivars: prevent double registration
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
> index a32d15b2928f7..87cbcbea40e90 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -1182,19 +1182,28 @@ int efivars_register(struct efivars *efivars,
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
