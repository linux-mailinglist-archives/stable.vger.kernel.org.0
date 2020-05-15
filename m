Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B254D1D5617
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 18:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgEOQc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 12:32:27 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33115 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgEOQc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 12:32:27 -0400
Received: by mail-ot1-f67.google.com with SMTP id v17so2398039ote.0;
        Fri, 15 May 2020 09:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1EkG6O/3cmUPYt5DCQJXeRo2YDJdl3A9XsZfu0rbjpI=;
        b=J8GcQEZcq0uG1iye5NP9ZfV5wqn7JSx+VMYpTy8Gq0qzKobMC7mXd3JromxwtbdvAA
         Qum5rRLXBa/I0mobuEdDTtSk6IP7iNp37+Vd1LiNi289SKkA1OPbE10PG+IIIB1nWbKq
         05jpLyy4SNawXgV4V76RRz4eX35FGlSxiiAtWxpDYM+8Nt0HRVzyQLCO5xir1rwh/kD3
         0+dGbkIDwMKUIn057FPB2usmUomDm9G4YjDAi/M8a+9it1YIXwA0vq07ZSj2V1I6BjJ+
         n/VORGqR/aD2xt/ZiATbuhrE3jJ9z7XZrhp+h/lvm5+UrSRI99CFSOHXVzmAvVshHgK3
         F93A==
X-Gm-Message-State: AOAM532L7pru267NtOM9nijzch36dHmzNDvGsm64r14A4cM0nRrnlsTz
        v+amUpA0EmWzwkYvw+LpZ7KFq+0OKgVxZRSHOwAOlw==
X-Google-Smtp-Source: ABdhPJxo0/cj2tVHy034QYN22JdcAzua5TQIunVoodyMMWprdbREtuanWAuUarfMnKINXK9/gLW23mnPdEZd/9cbVdI=
X-Received: by 2002:a9d:6ac8:: with SMTP id m8mr2917760otq.262.1589560346499;
 Fri, 15 May 2020 09:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200515093613.18691-1-ardb@kernel.org>
In-Reply-To: <20200515093613.18691-1-ardb@kernel.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 15 May 2020 18:32:14 +0200
Message-ID: <CAJZ5v0guHdbZTsU5e7KDAHDy9Gnh67JwtSSCeDaK8mUwAk1d3g@mail.gmail.com>
Subject: Re: [PATCH] ACPI: GED: add support for _Exx / _Lxx handler methods
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 11:37 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Per the ACPI spec, interrupts in the range [0, 255] may be handled
> in AML using individual methods whose naming is based on the format
> _Exx or _Lxx, where xx is the hex representation of the interrupt
> index.
>
> Add support for this missing feature to our ACPI GED driver.
>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Cc: <stable@vger.kernel.org> # v4.9+
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/acpi/evged.c | 22 +++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/evged.c b/drivers/acpi/evged.c
> index aba0d0027586..6d7a522952bf 100644
> --- a/drivers/acpi/evged.c
> +++ b/drivers/acpi/evged.c
> @@ -79,6 +79,8 @@ static acpi_status acpi_ged_request_interrupt(struct acpi_resource *ares,
>         struct resource r;
>         struct acpi_resource_irq *p = &ares->data.irq;
>         struct acpi_resource_extended_irq *pext = &ares->data.extended_irq;
> +       char ev_name[5];
> +       u8 trigger;
>
>         if (ares->type == ACPI_RESOURCE_TYPE_END_TAG)
>                 return AE_OK;
> @@ -87,14 +89,28 @@ static acpi_status acpi_ged_request_interrupt(struct acpi_resource *ares,
>                 dev_err(dev, "unable to parse IRQ resource\n");
>                 return AE_ERROR;
>         }
> -       if (ares->type == ACPI_RESOURCE_TYPE_IRQ)
> +       if (ares->type == ACPI_RESOURCE_TYPE_IRQ) {
>                 gsi = p->interrupts[0];
> -       else
> +               trigger = p->triggering;
> +       } else {
>                 gsi = pext->interrupts[0];
> +               trigger = p->triggering;
> +       }
>
>         irq = r.start;
>
> -       if (ACPI_FAILURE(acpi_get_handle(handle, "_EVT", &evt_handle))) {
> +       switch (gsi) {
> +       case 0 ... 255:
> +               sprintf(ev_name, "_%c%02hhX",
> +                       trigger == ACPI_EDGE_SENSITIVE ? 'E' : 'L', gsi);
> +
> +               if (ACPI_SUCCESS(acpi_get_handle(handle, ev_name, &evt_handle)))
> +                       break;
> +               /* fall through */
> +       default:
> +               if (ACPI_SUCCESS(acpi_get_handle(handle, "_EVT", &evt_handle)))
> +                       break;
> +
>                 dev_err(dev, "cannot locate _EVT method\n");
>                 return AE_ERROR;
>         }
> --

Applied as 5.8 material, thanks!
