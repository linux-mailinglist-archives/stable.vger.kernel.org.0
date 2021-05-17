Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E915383412
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbhEQPFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:22 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:35740 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242483AbhEQPCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:02:43 -0400
Received: by mail-oi1-f182.google.com with SMTP id v22so6752929oic.2;
        Mon, 17 May 2021 08:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wwp1lADG0O4ybcf+aZxFjCEd/2sWMhI3vZ4lEWKa5o8=;
        b=c0ZVEx+p43Pw4+RdbSwqKxJTcE9ClZOMbO3+pkI54uL0Q//o4Q3E0yqknq5vnjPdnD
         egZNOtcTtPSHUnO45iiSQk4QAymAqkObgOpOu61ncRK80uSrdIZe0oV1bFCOizqfGsRd
         UHowJeVS8/mXGHyf9nVckSpjHLJx4BkSMoSkhEWKRO8Ci3LnH7RPDi4KeRdt/lcWjaBr
         OYpdOYGdo7asP31i2rh/87KMfguLMOPMgD+lQqupf9l96IpgK9fz3LTiAuO8F0wPRwB2
         A5WNPiBlDDP2D15CepkETDLZAXSXhPw54sNWSAtfjqxLQ7VprPcQk2seEWFZb1BaewJJ
         750A==
X-Gm-Message-State: AOAM533Ed4ktxuF61TR2l7L711lqfrqN1lr2wdESOB+SrzsrjD0Nveo9
        gbT/gef8tC5/c8lB/ezic0QmQp4MQEYzZl78AiA=
X-Google-Smtp-Source: ABdhPJx+qvqH9oHalBbXzgcQAFus6QvTqi08L99jPCG1ATRBrUbLBs/6bVT0SnufG+9VMm+E0EYYL3aofAMJXkvqqTY=
X-Received: by 2002:aca:380a:: with SMTP id f10mr183028oia.157.1621263686629;
 Mon, 17 May 2021 08:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210512210413.1982933-1-luzmaximilian@gmail.com>
In-Reply-To: <20210512210413.1982933-1-luzmaximilian@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 17 May 2021 17:01:15 +0200
Message-ID: <CAJZ5v0j=_GuzgXdGj8R-MMAGDkgMx-tP1JwQ1kxb+dWyEi8DCQ@mail.gmail.com>
Subject: Re: [PATCH] serial: 8250_dw: Add device HID for new AMD UART controller
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Sachi King <nakato@nakato.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 12:25 AM Maximilian Luz <luzmaximilian@gmail.com> wrote:
>
> Add device HID AMDI0022 to the AMD UART controller driver match table
> and create a platform device for it. This controller can be found on
> Microsoft Surface Laptop 4 devices and seems similar enough that we can
> just copy the existing AMDI0020 entries.
>
> Cc: <stable@vger.kernel.org> # 5.10+
> Tested-by: Sachi King <nakato@nakato.io>
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

or please let me know if this needs to go in through ACPI (I'm
assuming that it doesn't).

> ---
>  drivers/acpi/acpi_apd.c           | 1 +
>  drivers/tty/serial/8250/8250_dw.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
> index 0ec5b3f69112..6e02448d15d9 100644
> --- a/drivers/acpi/acpi_apd.c
> +++ b/drivers/acpi/acpi_apd.c
> @@ -226,6 +226,7 @@ static const struct acpi_device_id acpi_apd_device_ids[] = {
>         { "AMDI0010", APD_ADDR(wt_i2c_desc) },
>         { "AMD0020", APD_ADDR(cz_uart_desc) },
>         { "AMDI0020", APD_ADDR(cz_uart_desc) },
> +       { "AMDI0022", APD_ADDR(cz_uart_desc) },
>         { "AMD0030", },
>         { "AMD0040", APD_ADDR(fch_misc_desc)},
>         { "HYGO0010", APD_ADDR(wt_i2c_desc) },
> diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
> index 9e204f9b799a..a3a0154da567 100644
> --- a/drivers/tty/serial/8250/8250_dw.c
> +++ b/drivers/tty/serial/8250/8250_dw.c
> @@ -714,6 +714,7 @@ static const struct acpi_device_id dw8250_acpi_match[] = {
>         { "APMC0D08", 0},
>         { "AMD0020", 0 },
>         { "AMDI0020", 0 },
> +       { "AMDI0022", 0 },
>         { "BRCM2032", 0 },
>         { "HISI0031", 0 },
>         { },
> --
