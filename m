Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704F266E2C9
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 16:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjAQPw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 10:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjAQPwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 10:52:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDC78A5F;
        Tue, 17 Jan 2023 07:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 355AEB816AC;
        Tue, 17 Jan 2023 15:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAECC433D2;
        Tue, 17 Jan 2023 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673970687;
        bh=LAHU/ov+crM226aErjpc7ArqwNV9Y9BlNGZh0t5iruI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EQ8+CmdAqB2tDt+rySG0KGugqrfpCd4chqpIYTH458UkTgbyK46sZlHxXdlMnwszH
         pt5SfD3O7wz9lNcuMBKVwHup9sc0teCKoeXQzfkHmarPLfh3UHAW3gbyZBPF/sZsY7
         zu2J6nqwEXKkdeEkYgMzZbgMtKVufCiKsg7R5KV+po0xKi0m/0Lnh1ASDe+gUVcfSt
         1aMWe4Pup7FgeiwpKGD0aE0fmaBCmwJp2xUcg83lD1a6uX75mRmSqJr+8XV/SMXwrA
         zB5A1io7kD1m7LXBDNiECCREf/vKbRn0+UNC0+XHihawKI52WIrhbikQre6S+PBX2f
         VxNO0PryV5VRA==
Received: by mail-lj1-f175.google.com with SMTP id o7so33217842ljj.8;
        Tue, 17 Jan 2023 07:51:27 -0800 (PST)
X-Gm-Message-State: AFqh2kpnMnE/+0llkb5EIbj/9P6P+ucRRy7pX275F9I5VnGDVlH8XwDy
        lPcN3cebVyGCFOdzE/BbFHV0GUcQTnaU627ApXE=
X-Google-Smtp-Source: AMrXdXuQGfpw1SP+KWFNPYv1WII/g2JF24ofbpB9adMX+emOrcrwLULN5i7a9+BFoLtbsdXiITzqFIWa9xHEv/dMi0I=
X-Received: by 2002:a2e:9449:0:b0:28b:9755:77a with SMTP id
 o9-20020a2e9449000000b0028b9755077amr358957ljh.152.1673970685853; Tue, 17 Jan
 2023 07:51:25 -0800 (PST)
MIME-Version: 1.0
References: <20230112133319.3615177-1-ardb@kernel.org> <CAJZ5v0iuwwDjDQDsdP3uvAO18EOcWXzCS6Yu0g62q40Em0vSOA@mail.gmail.com>
In-Reply-To: <CAJZ5v0iuwwDjDQDsdP3uvAO18EOcWXzCS6Yu0g62q40Em0vSOA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 17 Jan 2023 16:51:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF1OfDrtWNt1VAE4Z1_bvhUKUUrqie0LroXXxsm3jAM0w@mail.gmail.com>
Message-ID: <CAMj1kXF1OfDrtWNt1VAE4Z1_bvhUKUUrqie0LroXXxsm3jAM0w@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: PRM: Check whether EFI runtime is available
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

On Tue, 17 Jan 2023 at 13:29, Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Thu, Jan 12, 2023 at 2:33 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > The ACPI PRM address space handler calls efi_call_virt_pointer() to
> > execute PRM firmware code, but doing so is only permitted when the EFI
> > runtime environment is available. Otherwise, such calls are guaranteed
> > to result in a crash, and must therefore be avoided.
> >
> > Given that the EFI runtime services may become unavailable after a crash
> > occurring in the firmware, we need to check this each time the PRM
> > address space handler is invoked. If the EFI runtime services were not
> > available at registration time to being with, don't install the address
> > space handler at all.
> >
> > Cc: <stable@vger.kernel.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: linux-acpi@vger.kernel.org
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > v2: check both at registration and at invocation time
> >
> >  drivers/acpi/prmt.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
> > index 998101cf16e47145..3d4c4620f9f95309 100644
> > --- a/drivers/acpi/prmt.c
> > +++ b/drivers/acpi/prmt.c
> > @@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
> >         efi_status_t status;
> >         struct prm_context_buffer context;
> >
> > +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> > +               pr_err_ratelimited("PRM: EFI runtime services no longer available\n");
> > +               return AE_NO_HANDLER;
>
> This error code is only used in GPE handling ATM.
>
> The one that actually causes ACPICA to log a "no handler" error (in
> acpi_ex_access_region()) is AE_NOT_EXIST.  Should it be used here?
>

Not sure. Any error value is returned to the caller, the only
difference is that AE_NOT_EXIST and AE_NOT_IMPLEMENTED trigger the
non-ratelimited logging machinery.

Given that neither value seems appropriate (the region is implemented
and it has a handler), and we already emit a rate limited error
message, I think AE_NOT_EXIST is not the right choice.


>
> > +       }
> > +
> >         /*
> >          * The returned acpi_status will always be AE_OK. Error values will be
> >          * saved in the first byte of the PRM message buffer to be used by ASL.
> > @@ -325,6 +330,11 @@ void __init init_prmt(void)
> >
> >         pr_info("PRM: found %u modules\n", mc);
> >
> > +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> > +               pr_err("PRM: EFI runtime services unavailable\n");
> > +               return;
> > +       }
> > +
> >         status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
> >                                                     ACPI_ADR_SPACE_PLATFORM_RT,
> >                                                     &acpi_platformrt_space_handler,
> > --
> > 2.39.0
> >
