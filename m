Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273E6690CFB
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 16:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjBIPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 10:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjBIPbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 10:31:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFF75BA5D;
        Thu,  9 Feb 2023 07:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2363761B05;
        Thu,  9 Feb 2023 15:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79205C4339B;
        Thu,  9 Feb 2023 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675956671;
        bh=BlKYvnz7WNXl24gbX594yEpSvAcoGuqkkt+WsLo2+r8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZkqDugMVdeJGituJmAuVVFVKfpU1yQDHxuK9EoLv8qPAJXLfIWX6OwKqoyn7QMe3v
         XCSQbazMDJ+QW0jFw8Ff/+z7lo+LUA0FIjN8iRkiCiXYIiScfECGVSK129Bl8/QsIu
         uilb2SaS+1HIdT20gq/sZTpUBhhm7cXdjsJyquf25wNm5JTn9IyhrLwSDPvc/NL44E
         CJKEudKXMzz47JeChqn8pTruOF3huDljAFKTm7cdKgSvVWMV0XL1S3juDyqmagJsjP
         Nw18bO5CQJH+TX0Fd+U71IJSCObzU5sb+lZLfcLDRhzGHTejAE/wyuZUH/6a8NiA+n
         ZHMhhE11sb2SA==
Received: by mail-lf1-f43.google.com with SMTP id cf42so3677463lfb.1;
        Thu, 09 Feb 2023 07:31:11 -0800 (PST)
X-Gm-Message-State: AO0yUKWMwG6Q7+APHTonruGHBwg+mVmVwXaoHY4jpLh6l/OLJja7pSJZ
        55G1EDfvh3v8p8818kFo7jd2viJ6bAxJD+egwvM=
X-Google-Smtp-Source: AK7set/y+U5Z0Ktk9pQgBwA8AKvQcpjCb37bBs8fDFcgJpM/Ys8SVs0RKypLaWQKAZjsIAEcUl1P5fxS3XqvppwkIMA=
X-Received: by 2002:ac2:55ba:0:b0:4ca:f9e3:c324 with SMTP id
 y26-20020ac255ba000000b004caf9e3c324mr1794776lfg.190.1675956669475; Thu, 09
 Feb 2023 07:31:09 -0800 (PST)
MIME-Version: 1.0
References: <2ab9645789707f31fd37c49435e476d4b5c38a0a.1675901828.git.darren@os.amperecomputing.com>
 <DBBPR08MB4538C586B721C8209B03AEEEF7D99@DBBPR08MB4538.eurprd08.prod.outlook.com>
In-Reply-To: <DBBPR08MB4538C586B721C8209B03AEEEF7D99@DBBPR08MB4538.eurprd08.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 9 Feb 2023 16:30:57 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG8TY9eKJxtSWYPCu_8qs7W3FWwDSZ+teuwhHb1BHUf7g@mail.gmail.com>
Message-ID: <CAMj1kXG8TY9eKJxtSWYPCu_8qs7W3FWwDSZ+teuwhHb1BHUf7g@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() on
 eMAG and Altra Max machines
To:     Justin He <Justin.He@arm.com>
Cc:     Darren Hart <darren@os.amperecomputing.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Alexandru Elisei <alexandru.elisei@gmail.com>, nd <nd@arm.com>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(cc Nathan, another happy Ampere customer)

On Thu, 9 Feb 2023 at 05:26, Justin He <Justin.He@arm.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Darren Hart <darren@os.amperecomputing.com>
> > Sent: Thursday, February 9, 2023 8:28 AM
> > To: LKML <linux-kernel@vger.kernel.org>
> > Cc: stable@vger.kernel.org; linux-efi@vger.kernel.org; Alexandru Elisei
> > <alexandru.elisei@gmail.com>; Justin He <Justin.He@arm.com>; Huacai Chen
> > <chenhuacai@kernel.org>; Jason A. Donenfeld <Jason@zx2c4.com>; Ard
> > Biesheuvel <ardb@kernel.org>
> > Subject: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() on
> > eMAG and Altra Max machines
> >
> > Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
> > on Altra machines") identifies the Altra family via the family field in the type#1
> > SMBIOS record. eMAG and Altra Max machines are similarly affected but not
> > detected with the strict strcmp test.
> >
> > The type1_family smbios string is not an entirely reliable means of identifying
> > systems with this issue as OEMs can, and do, use their own strings for these
> > fields. However, until we have a better solution, capture the bulk of these
> > systems by adding strcmp matching for "eMAG"
> > and "Altra Max".
> >
> > Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap() on
> > Altra machines")
> > Cc: <stable@vger.kernel.org> # 6.1.x
> > Cc: <linux-efi@vger.kernel.org>
> > Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
> > Cc: Justin He <Justin.He@arm.com>
> > Cc: Huacai Chen <chenhuacai@kernel.org>
> > Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> Tested-by: justin.he@arm.com
> > ---
> > V1 -> V2: include eMAG
> >
> >  drivers/firmware/efi/libstub/arm64.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/firmware/efi/libstub/arm64.c
> > b/drivers/firmware/efi/libstub/arm64.c
> > index ff2d18c42ee7..4501652e11ab 100644
> > --- a/drivers/firmware/efi/libstub/arm64.c
> > +++ b/drivers/firmware/efi/libstub/arm64.c
> > @@ -19,10 +19,13 @@ static bool system_needs_vamap(void)
> >       const u8 *type1_family = efi_get_smbios_string(1, family);
> >
> >       /*
> > -      * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
> > -      * has not been called prior.
> > +      * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
> > +      * SetVirtualAddressMap() has not been called prior.
> >        */
> > -     if (!type1_family || strcmp(type1_family, "Altra"))
> > +     if (!type1_family || (
> > +         strcmp(type1_family, "eMAG") &&
> > +         strcmp(type1_family, "Altra") &&
> > +         strcmp(type1_family, "Altra Max")))
> In terms of resolving the boot hang issue, it looks good to me. And I've verified the
> "eMAG" part check.
> So please feel free to add:
> Tested-by: Justin He <justin.he@arm.com>
>

Thanks. I've queued this up now.

> But I have some other concerns:
> 1. On an Altra server, the type1_family returns "Server". I don't know whether it
> is a smbios or server firmware bug.

This is not really a bug. OEMs are free to put whatever they want into
those fields, although that is a great example of a sloppy vendor that
just puts random junk in there.

We could plumb in the type 4 smbios record too, and check the version
for *Altra* - however, it would be nice to get an idea of how many
more we will end up needing to handle here.

Also, is anyone looking to get this fixed? There is Altra code in the
public EDK2 repo, but it is very hard to get someone to care about
these things, and fix their firmware.




> 2. On an eMAG server, I once successfully run efibootmgr -t 10 to call the
> Set_variable rts, but currently I always met the error, even with above patch:
> # efibootmgr -t 9; efibootmgr -t 5;
> Could not set Timeout: Input/output error
> Could not set Timeout: Input/output error
>

Did this work before? Can you bisect?

> Meanwhile, on the Altra server, it works:
> # efibootmgr -t 9; efibootmgr -t 5;
> BootCurrent: 0007
> Timeout: 9 seconds
> BootOrder: 0007,0005,0006,0001
> Boot0001* UEFI: Built-in EFI Shell
> Boot0005* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
> Boot0006* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
> Boot0007* ubuntu
> BootCurrent: 0007
> Timeout: 5 seconds
> BootOrder: 0007,0005,0006,0001
> Boot0001* UEFI: Built-in EFI Shell
> Boot0005* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
> Boot0006* UEFI: PXE IPv4 Intel(R) I350 Gigabit Network Connection
> Boot0007* ubuntu
>
>
>
> --
> Cheers,
> Justin (Jia He)
>
>
