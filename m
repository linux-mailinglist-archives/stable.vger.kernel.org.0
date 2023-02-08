Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A07E68FB05
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 00:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBHXRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 18:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBHXRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 18:17:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD7E7ED6;
        Wed,  8 Feb 2023 15:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C4D61807;
        Wed,  8 Feb 2023 23:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C72C4339C;
        Wed,  8 Feb 2023 23:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675898219;
        bh=lZTjuuQABIxMxNQZRg3voM5ATP3tc817vShiNCzwY5Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aghsUWVeGeD8zl174xRgZOzbTJ8x8tYXswtvh9PmMEsXwkH62hWnv7UV5ODoS7N+I
         cJQigGd24MHJV3bUxwWO91gbWiJmfeokOG3T85IVn3g2Zf88TW5Y04HswwuONAarEk
         HejRrfWbM4TFXUq2LECkdQcHxzYjv4qjqAx4aHWn2Xdix5ssf5X9VSpvNB2/If2KPA
         4igtsdhG7Zab3JdipKDVgFxJ0Woq+CDEfidptljQGbhRPY2MaXZJ7khFqFBDWEFN3n
         FHVc7A+KsCOtLDbjezB8N3qg9WLub0piF3FVpe+yRJF2NsHw62y/HeomxEA448zFWV
         CGeDuWuu4MI4A==
Received: by mail-lf1-f43.google.com with SMTP id h24so761347lfv.6;
        Wed, 08 Feb 2023 15:16:59 -0800 (PST)
X-Gm-Message-State: AO0yUKUZtCODzuA56RHo2N6X9EYipUb9MVJDekcz4ySgX8livOYmxQW+
        aus97+/h5FOb0zov6Sv32nmoeZ7EMc7sRgi91zE=
X-Google-Smtp-Source: AK7set8KwuT63HyPuqX5+P3hAzXpgNLa/3LGCHtoW6bQKDkwBaYVJEjNL9TlHN0EiYGu+mZcAUrZFKpBeuU0qW//HTw=
X-Received: by 2002:ac2:559b:0:b0:4b6:fae9:c9b9 with SMTP id
 v27-20020ac2559b000000b004b6fae9c9b9mr1582076lfg.207.1675898217727; Wed, 08
 Feb 2023 15:16:57 -0800 (PST)
MIME-Version: 1.0
References: <a968c446bde75bf019580366854349bf94e6c961.1675897882.git.darren@os.amperecomputing.com>
In-Reply-To: <a968c446bde75bf019580366854349bf94e6c961.1675897882.git.darren@os.amperecomputing.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 9 Feb 2023 00:16:46 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF2Bi_iyjzUK2zie_pt6Vnm4QwvarHicJoRzUiX7nU0Kw@mail.gmail.com>
Message-ID: <CAMj1kXF2Bi_iyjzUK2zie_pt6Vnm4QwvarHicJoRzUiX7nU0Kw@mail.gmail.com>
Subject: Re: [PATCH] arm64: efi: Force the use of SetVirtualAddressMap() on
 Altra Max machines
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        linux-efi@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Darren,

On Thu, 9 Feb 2023 at 00:14, Darren Hart <darren@os.amperecomputing.com> wrote:
>
> Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
> on Altra machines") identifies the Altra family via the family field in
> the type#1 SMBIOS record. Altra Max machines are similarly affected but
> not detected with the strict strcmp test.
>
> Rather than risk greedy matching with strncmp, add a second test for
> Altra Max. Do not refactor to handle multiple tests as these should be
> the only two needed.
>

Famous last words ...

Unfortunately, I just had a report the other day that 'eMAG' and
'Server' (!) are also being used.

https://lore.kernel.org/all/20230131040355.3116-1-justin.he@arm.com/


> Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap() on Altra machines")
> Cc: <stable@vger.kernel.org> # 6.1.x
> Cc: <linux-efi@vger.kernel.org>
> Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> ---
>  drivers/firmware/efi/libstub/arm64.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
> index ff2d18c42ee7..97f4423059c7 100644
> --- a/drivers/firmware/efi/libstub/arm64.c
> +++ b/drivers/firmware/efi/libstub/arm64.c
> @@ -19,10 +19,10 @@ static bool system_needs_vamap(void)
>         const u8 *type1_family = efi_get_smbios_string(1, family);
>
>         /*
> -        * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
> -        * has not been called prior.
> +        * Ampere Altra and Altra Max machines crash in SetTime() if
> +        * SetVirtualAddressMap() has not been called prior.
>          */
> -       if (!type1_family || strcmp(type1_family, "Altra"))
> +       if (!type1_family || (strcmp(type1_family, "Altra") && strcmp(type1_family, "Altra Max")))
>                 return false;
>
>         efi_warn("Working around broken SetVirtualAddressMap()\n");
> --
> 2.34.3
>
