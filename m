Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D59672884
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 20:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjARTg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 14:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjARTgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 14:36:25 -0500
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E034B9EFA;
        Wed, 18 Jan 2023 11:36:20 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id v30so83410edb.9;
        Wed, 18 Jan 2023 11:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TFaCbGRXO/pQ0TUpQ1SBb2CqrXmII77VOVr2Wb3CdJg=;
        b=2iBDEzcZy6zBBhtMVSZcqajreeIfnJYGhQIAzTVzeRRlshZlkGw37wQwS1l8ENHMxV
         E1txsgebOh7OovxTn9ESKiK9Ru+xrTZeauLkPhI4HUE6uFoMcopbXEyyJZubbOjnQJzW
         tHfVlApXIp8pvUVZzUl0722cSNoMvQJS3jf7Z0GzWvgNycOu9E2xiQyQFGBlzXfJHf6/
         jG10hjfk90Y/aUkHBblLwHziUheEW7LXj3o9cR2L8qqp6GvgEws9h0regTsqMmU7Peo3
         IrcPfyD9u8OSxH8dm8KvQK9HR1eahJJytsKd7ZQy4s+uh46xfEVA58iyilxx2y+WVGrm
         Zzxw==
X-Gm-Message-State: AFqh2kocESlD8BPqSK6vIOKQF46yhdHierPG+1QCsqt/BFe/RU84XU49
        q07J+osn4bxuqIlET9KFDoiM9bcpWabg9pIYuAY19KOJ
X-Google-Smtp-Source: AMrXdXtH/J5JYaM2D5yLut+qn0FbDvdIwh4x02bBN0equIIryPDtQQHEE95ojIXGbVyqOTw6IOe98kESuA9eFFjdoik=
X-Received: by 2002:a05:6402:40d6:b0:46d:53d7:d1f6 with SMTP id
 z22-20020a05640240d600b0046d53d7d1f6mr912154edb.211.1674070579297; Wed, 18
 Jan 2023 11:36:19 -0800 (PST)
MIME-Version: 1.0
References: <20230112133319.3615177-1-ardb@kernel.org> <CAJZ5v0iuwwDjDQDsdP3uvAO18EOcWXzCS6Yu0g62q40Em0vSOA@mail.gmail.com>
 <CAMj1kXF1OfDrtWNt1VAE4Z1_bvhUKUUrqie0LroXXxsm3jAM0w@mail.gmail.com>
In-Reply-To: <CAMj1kXF1OfDrtWNt1VAE4Z1_bvhUKUUrqie0LroXXxsm3jAM0w@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 18 Jan 2023 20:36:07 +0100
Message-ID: <CAJZ5v0hs-xFdREnhPNqBcHcCh558WvNwmA-1bgQrJwDQd7+Zng@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: PRM: Check whether EFI runtime is available
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, linux-efi@vger.kernel.org,
        stable@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 4:51 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 17 Jan 2023 at 13:29, Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Thu, Jan 12, 2023 at 2:33 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > The ACPI PRM address space handler calls efi_call_virt_pointer() to
> > > execute PRM firmware code, but doing so is only permitted when the EFI
> > > runtime environment is available. Otherwise, such calls are guaranteed
> > > to result in a crash, and must therefore be avoided.
> > >
> > > Given that the EFI runtime services may become unavailable after a crash
> > > occurring in the firmware, we need to check this each time the PRM
> > > address space handler is invoked. If the EFI runtime services were not
> > > available at registration time to being with, don't install the address
> > > space handler at all.
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > Cc: Len Brown <lenb@kernel.org>
> > > Cc: linux-acpi@vger.kernel.org
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > > v2: check both at registration and at invocation time
> > >
> > >  drivers/acpi/prmt.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
> > > index 998101cf16e47145..3d4c4620f9f95309 100644
> > > --- a/drivers/acpi/prmt.c
> > > +++ b/drivers/acpi/prmt.c
> > > @@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
> > >         efi_status_t status;
> > >         struct prm_context_buffer context;
> > >
> > > +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> > > +               pr_err_ratelimited("PRM: EFI runtime services no longer available\n");
> > > +               return AE_NO_HANDLER;
> >
> > This error code is only used in GPE handling ATM.
> >
> > The one that actually causes ACPICA to log a "no handler" error (in
> > acpi_ex_access_region()) is AE_NOT_EXIST.  Should it be used here?
> >
>
> Not sure. Any error value is returned to the caller, the only
> difference is that AE_NOT_EXIST and AE_NOT_IMPLEMENTED trigger the
> non-ratelimited logging machinery.
>
> Given that neither value seems appropriate (the region is implemented
> and it has a handler), and we already emit a rate limited error
> message, I think AE_NOT_EXIST is not the right choice.

OK, applied as-is as 6.2-rc material, thanks!
