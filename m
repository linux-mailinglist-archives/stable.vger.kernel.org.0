Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3FE3B4F7A
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 18:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhFZQp2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 26 Jun 2021 12:45:28 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:43759 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhFZQp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Jun 2021 12:45:28 -0400
Received: by mail-ot1-f42.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso12961870otu.10;
        Sat, 26 Jun 2021 09:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0SqgqCzvVZTB2+9gkf+mL/AkjbUz31GJoyV1zAWO3Mw=;
        b=t8cenyweKJ52AkIV3bBmQxopq2zFcEXPaghJiHTpctrED66ZmfQDcfX2uGRkdKZmMg
         MZecnzaxDqRwDH5Jj4Gs9nOQofmgd/bWihy1iBSJp9uhd3mrdKiTbPMoKSTOW4BuTP8e
         I3pDLEt7Ajd2NHML5o16OnweGn8s6fp+ynIq3H/JzpCigxi0YNfX+JdAvepFdeXmdlWe
         TAfE1LZZfjrwiWWsn7qMzOSOyteVJF+Fdw/pfFuXhT5ldXi61RVR4EZv4uTRrlO6TAv7
         tAUJ3PsH+OJFjiGM/JXiquKVW+SHWAtMdYox+5Kt8hX6Hxo/N2BoljMxQQYNnOJ4nNE/
         0xEA==
X-Gm-Message-State: AOAM530nbfxiYeDvaoVVJIJt3MegHxz3771JQxohc5Y+jeOWEO3/PtAl
        BuNyAJ7dRKeKAQjxoeMzVyEuIrFBRC3JsJ5+5GXjhcExe41zdQ==
X-Google-Smtp-Source: ABdhPJzf7jrdWtaiV6n2ZBW78g3OBAIr0hGbIRYFOVKYj85gbHhD+PmJssQAYoR0yLRsqcf2kOevf9t4EoZK4O5N9Mo=
X-Received: by 2002:a05:6830:241d:: with SMTP id j29mr15129902ots.371.1624725785294;
 Sat, 26 Jun 2021 09:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2106260509300.37803@angie.orcam.me.uk> <alpine.DEB.2.21.2106260516220.37803@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106260516220.37803@angie.orcam.me.uk>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Sat, 26 Jun 2021 18:42:53 +0200
Message-ID: <CAAdtpL7oCMK+AxRH6qn0GCbV1bDkN4Y5XOqdyJGC52y2N2ZxAw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] serial: 8250: Mask out floating 16/32-bit bus bits
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 26, 2021 at 6:11 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> Make sure only actual 8 bits of the IIR register are used in determining
> the port type in `autoconfig'.
>
> The `serial_in' port accessor returns the `unsigned int' type, meaning
> that with UPIO_AU, UPIO_MEM16, UPIO_MEM32, and UPIO_MEM32BE access types
> more than 8 bits of data are returned, of which the high order bits will
> often come from bus lines that are left floating in the data phase.  For
> example with the MIPS Malta board's CBUS UART, where the registers are
> aligned on 8-byte boundaries and which uses 32-bit accesses, data as
> follows is returned:
>
> YAMON> dump -32 0xbf000900 0x40
>
> BF000900: 1F000942 1F000942 1F000900 1F000900  ...B...B........
> BF000910: 1F000901 1F000901 1F000900 1F000900  ................
> BF000920: 1F000900 1F000900 1F000960 1F000960  ...........`...`
> BF000930: 1F000900 1F000900 1F0009FF 1F0009FF  ................
>
> YAMON>
>
> Evidently high-order 24 bits return values previously driven in the
> address phase (the 3 highest order address bits used with the command
> above are masked out in the simple virtual address mapping used here and
> come out at zeros on the external bus), a common scenario with bus lines
> left floating, due to bus capacitance.
>
> Consequently when the value of IIR, mapped at 0x1f000910, is retrieved
> in `autoconfig', it comes out at 0x1f0009c1 and when it is right-shifted
> by 6 and then assigned to 8-bit `scratch' variable, the value calculated
> is 0x27, not one of 0, 1, 2, 3 expected in port type determination.
>
> Fix the issue then, by assigning the value returned from `serial_in' to
> `scratch' first, which masks out 24 high-order bits retrieved, and only
> then right-shift the resulting 8-bit data quantity, producing the value
> of 3 in this case, as expected.  Fix the same issue in `serial_dl_read'.
>
> The problem first appeared with Linux 2.6.9-rc3 which predates our repo
> history, but the origin could be identified with the old MIPS/Linux repo
> also at: <git://git.kernel.org/pub/scm/linux/kernel/git/ralf/linux.git>
> as commit e0d2356c0777 ("Merge with Linux 2.6.9-rc3."), where code in
> `serial_in' was updated with this case:
>
> +       case UPIO_MEM32:
> +               return readl(up->port.membase + offset);
> +
>
> which made it produce results outside the unsigned 8-bit range for the
> first time, though obviously it is system dependent what actual values
> appear in the high order bits retrieved and it may well have been zeros
> in the relevant positions with the system the change originally was
> intended for.  It is at that point that code in `autoconf' should have
> been updated accordingly, but clearly it was overlooked.
>
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org # v2.6.12+
> ---
> Changes from v1:
>
> - Comments added as to truncation of bits above 7 required.
> ---
>  drivers/tty/serial/8250/8250_port.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
