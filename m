Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CE166729E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjALMwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjALMwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:52:07 -0500
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610784C718;
        Thu, 12 Jan 2023 04:52:02 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id i9so26717729edj.4;
        Thu, 12 Jan 2023 04:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cNbdLSpVe6z1vEy5/enEI/UAw8bCJ+KJDcus4p+6jP8=;
        b=Nk4HZGKuF7C9a9pQCDQYI0EAz8ZFxDl4XO9Y8nI6t5HevdwQestBZIPDsFq1vD9/LT
         2LDjRLqJDsQNJG043Am7iAPTlMhwgyJzXLj1eunk/ZXw3syV0h3RFuWEcZ7kXK1OI1NM
         +GX9VXPLo2pS6Gwgqi+HfrcNAzpLAsuWuLXJAlZU+Cmp/HDsCbq+SIrjNxR3IT7ID6m6
         rUWm3EcQpIU8VzlBiJ7HkGpBrA1Y/CfwhLtMANkekGMUkFWzM/Azw92ht2BEVjUhuSiI
         NmbRF+DHtQ/hYPKOQRc4+W5QboeNv237cpMmpj7pdrEa+taf6Vgp4XuBfllLkWpYbpDX
         lkOA==
X-Gm-Message-State: AFqh2kqGD6iF2a5rOU1nYI+OI6R6jmURYpHnkfAvXJO135TTJjVE5GDh
        qp+/KE6iPpL8/7fQ3BeT+GzPvGxs4nozaduonKG9zkL/
X-Google-Smtp-Source: AMrXdXup3VrpQj4tV2hrVSee8f37WlP8SBGwSDx2PW2gCCRWI6IhtH4XgHD8ZnKUtN2C/wgJdaGGRjMKegSvEFr9x6M=
X-Received: by 2002:a50:eb49:0:b0:46d:731c:2baf with SMTP id
 z9-20020a50eb49000000b0046d731c2bafmr7609544edp.280.1673527920758; Thu, 12
 Jan 2023 04:52:00 -0800 (PST)
MIME-Version: 1.0
References: <20230111132734.1571990-1-ardb@kernel.org> <CAJZ5v0hZMGMBnYog1CwUfGe8WU9GHmNgdn3gJdwdpiz-V2J-Ow@mail.gmail.com>
 <CAMj1kXFyba7e3mVeV2F+g85+1coYJotK=PFpvia6gAD8j1=tog@mail.gmail.com>
In-Reply-To: <CAMj1kXFyba7e3mVeV2F+g85+1coYJotK=PFpvia6gAD8j1=tog@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 12 Jan 2023 13:51:49 +0100
Message-ID: <CAJZ5v0jPDx2_Qmw8T+9jMmccToZ51QLEa_rMyfU0P0W6BoL_vg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: PRM: Check whether EFI runtime is available
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, linux-efi@vger.kernel.org,
        stable@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023 at 10:17 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 11 Jan 2023 at 21:23, Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Wed, Jan 11, 2023 at 2:27 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > The ACPI PRM address space handler calls efi_call_virt_pointer() to
> > > execute PRM firmware code, but doing so is only permitted when the EFI
> > > runtime environment is available. Otherwise, such calls are guaranteed
> > > to result in a crash, and must therefore be avoided.
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > Cc: Len Brown <lenb@kernel.org>
> > > Cc: linux-acpi@vger.kernel.org
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  drivers/acpi/prmt.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
> > > index 998101cf16e47145..74f924077866ae69 100644
> > > --- a/drivers/acpi/prmt.c
> > > +++ b/drivers/acpi/prmt.c
> > > @@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
> > >         efi_status_t status;
> > >         struct prm_context_buffer context;
> > >
> > > +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> > > +               pr_err("PRM: EFI runtime services unavailable\n");
> > > +               return AE_NOT_IMPLEMENTED;
> > > +       }
> > > +
> >
> > Does the check need to be made in the address space handler and if so, then why?
> >
>
> Yes. efi_enabled(EFI_RUNTIME_SERVICES) will transition from true to
> false if an exception occurs while executing the firmware code.

OK

> Unlike the EFI variable runtime services, which are quite uniform,
> this PRM code will be vendor specific, and so the likelihood that it
> is buggy and only tested with Windows is much higher, and so I would
> like us to be more cautious here.

OK

> > It looks like it would be better to prevent it from being installed if
> > EFI runtime services are not enabled in the first place, in
> > init_prmt().
> >
>
> We could add another check there as well, yes. And perhaps the one in
> the handler should we pr_warn_once() to prevent it from firing
> repeatedly.

Sounds good to me, so are you going to send an update of the patch?
Or how would you like to proceed otherwise?

> > >         /*
> > >          * The returned acpi_status will always be AE_OK. Error values will be
> > >          * saved in the first byte of the PRM message buffer to be used by ASL.
> > > --
