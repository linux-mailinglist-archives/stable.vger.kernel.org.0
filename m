Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DC66672A5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjALMxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjALMxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:53:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D7F4C72A;
        Thu, 12 Jan 2023 04:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D74B81DD5;
        Thu, 12 Jan 2023 12:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299A9C433EF;
        Thu, 12 Jan 2023 12:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673527979;
        bh=KhGJ43kAcwbRgrNywX6229dXcT8RlNXS/1naQj29GZY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hA1qoUVMCBX1ZA5TTKXBMBXCAPpMBzyatbst3XxWkoBjFEfSckO8H0KGAlin7b1yN
         sPTDCh2kyerqyczq8J9peg1ueSlC4S31VfrhU2e48ydVvIZ/XPd95PvtvynRDGBF7k
         BnaXhxpbNSFKsqpB4nO0M2otI/pOy+N+v8CSiSsp0qZnTbcyxvXvIErodIbNEQ/FyN
         /WcFm5h90+vjFS7ZPVmqsaGmMACrLjtLXN6jPRipjEPSiQZv0uMu2pbmfaYGyCMorp
         477AuoD27m7ib0UGjVxkNyBcaDPrS38TJY+HqDelbk+JgGzX5SYCiehPrzz6J9s1VU
         PrZrDUh+/0lQg==
Received: by mail-lj1-f174.google.com with SMTP id x37so19235411ljq.1;
        Thu, 12 Jan 2023 04:52:59 -0800 (PST)
X-Gm-Message-State: AFqh2kq1Sq7m/j2m+owhHK2KfSdR72H62UgnmpfjXN0fFTHJTVxvw9If
        AZ7/7d6NRnite+Ujl2cMcTXp2CEA4C/Tc2hNRdk=
X-Google-Smtp-Source: AMrXdXv1m4WnBCC5qv+6gyF8ML8/Eas5paaC4uL+pKjK0Aj+qKNZit5DIOi8Zdq3uHwVgMUdzVVzMuGzc6vdx2kuSKw=
X-Received: by 2002:a2e:a901:0:b0:27f:ef88:3ecb with SMTP id
 j1-20020a2ea901000000b0027fef883ecbmr1745468ljq.189.1673527977229; Thu, 12
 Jan 2023 04:52:57 -0800 (PST)
MIME-Version: 1.0
References: <20230111132734.1571990-1-ardb@kernel.org> <CAJZ5v0hZMGMBnYog1CwUfGe8WU9GHmNgdn3gJdwdpiz-V2J-Ow@mail.gmail.com>
 <CAMj1kXFyba7e3mVeV2F+g85+1coYJotK=PFpvia6gAD8j1=tog@mail.gmail.com> <CAJZ5v0jPDx2_Qmw8T+9jMmccToZ51QLEa_rMyfU0P0W6BoL_vg@mail.gmail.com>
In-Reply-To: <CAJZ5v0jPDx2_Qmw8T+9jMmccToZ51QLEa_rMyfU0P0W6BoL_vg@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 12 Jan 2023 13:52:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXERnQwa-N3V8hy_bO8wpF=7V9ox5tSbTAtZfZ5NTWBS6Q@mail.gmail.com>
Message-ID: <CAMj1kXERnQwa-N3V8hy_bO8wpF=7V9ox5tSbTAtZfZ5NTWBS6Q@mail.gmail.com>
Subject: Re: [PATCH] ACPI: PRM: Check whether EFI runtime is available
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     linux-efi@vger.kernel.org, stable@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Jan 2023 at 13:52, Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Jan 11, 2023 at 10:17 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Wed, 11 Jan 2023 at 21:23, Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > On Wed, Jan 11, 2023 at 2:27 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > The ACPI PRM address space handler calls efi_call_virt_pointer() to
> > > > execute PRM firmware code, but doing so is only permitted when the EFI
> > > > runtime environment is available. Otherwise, such calls are guaranteed
> > > > to result in a crash, and must therefore be avoided.
> > > >
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > > Cc: Len Brown <lenb@kernel.org>
> > > > Cc: linux-acpi@vger.kernel.org
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > ---
> > > >  drivers/acpi/prmt.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
> > > > index 998101cf16e47145..74f924077866ae69 100644
> > > > --- a/drivers/acpi/prmt.c
> > > > +++ b/drivers/acpi/prmt.c
> > > > @@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
> > > >         efi_status_t status;
> > > >         struct prm_context_buffer context;
> > > >
> > > > +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> > > > +               pr_err("PRM: EFI runtime services unavailable\n");
> > > > +               return AE_NOT_IMPLEMENTED;
> > > > +       }
> > > > +
> > >
> > > Does the check need to be made in the address space handler and if so, then why?
> > >
> >
> > Yes. efi_enabled(EFI_RUNTIME_SERVICES) will transition from true to
> > false if an exception occurs while executing the firmware code.
>
> OK
>
> > Unlike the EFI variable runtime services, which are quite uniform,
> > this PRM code will be vendor specific, and so the likelihood that it
> > is buggy and only tested with Windows is much higher, and so I would
> > like us to be more cautious here.
>
> OK
>
> > > It looks like it would be better to prevent it from being installed if
> > > EFI runtime services are not enabled in the first place, in
> > > init_prmt().
> > >
> >
> > We could add another check there as well, yes. And perhaps the one in
> > the handler should we pr_warn_once() to prevent it from firing
> > repeatedly.
>
> Sounds good to me, so are you going to send an update of the patch?
> Or how would you like to proceed otherwise?
>

I'll respin it.
