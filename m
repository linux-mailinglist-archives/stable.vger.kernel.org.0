Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07EE3B4F7E
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 18:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhFZQrC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 26 Jun 2021 12:47:02 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:44793 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhFZQrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Jun 2021 12:47:02 -0400
Received: by mail-ot1-f49.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so5066933otq.11;
        Sat, 26 Jun 2021 09:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HxcRIBCSc7MQbCKOyndHrkKI3BYQ9FTRmkxDuLtYrT8=;
        b=sJIoJBtoja2yelN1uMLLbJ85v1D7Fj/KYelZ/hR3ERnPxfY42FXrQubWGt7t57YEk9
         fIfvWtCY0xryY4Ta2vQ+d6X713bvozhhnEFYqLtuuVex6+/b0+LuJLMChJtVxupG/9BF
         3KbW1guEOUshZNhcUU2FheK5QUg3HXvjnd3Jv1NxNTCytpeAwRjGHP9G1B8FZoWtnI6J
         JKC9tq7gvHkflwTxH0ov7D86WI5qdn/UG4rxZTzePDlJAFIhGbPfimDiUnnwuXruJW1g
         ZCcEtDq8f4XLmmy6e97I6anbsj5t95W4bqAVvsimbNcKA/xlyGzBsz6PfXeqQPZOxq39
         femw==
X-Gm-Message-State: AOAM5309CxIpZeHz/ytTKyAc/9DItIY4Br/B0yATg/JEk4CKynzC0JTL
        e1fIwQAB63Qgb6vDPBonMfgInHfd0TmAW+eLkko=
X-Google-Smtp-Source: ABdhPJyeg/Y2k2Kh3fJCUN2qJd9anY5BtuizAmURtu6JDNx76NA/T6f3mcQX4DsZB1L0wOCadWZupcLkXqXx2M3c2+8=
X-Received: by 2002:a05:6830:2707:: with SMTP id j7mr14916038otu.37.1624725878591;
 Sat, 26 Jun 2021 09:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2106260509300.37803@angie.orcam.me.uk> <alpine.DEB.2.21.2106260524430.37803@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106260524430.37803@angie.orcam.me.uk>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Sat, 26 Jun 2021 18:44:27 +0200
Message-ID: <CAAdtpL6m6zRG7ruYdsjPjbuzuT64ZiBK9tuwcUGEcgkgTfFEmA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] MIPS: Malta: Do not byte-swap accesses to the CBUS UART
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
> Correct big-endian accesses to the CBUS UART, a Malta on-board discrete
> TI16C550C part wired directly to the system controller's device bus, and
> do not use byte swapping with the 32-bit accesses to the device.
>
> The CBUS is used for devices such as the boot flash memory needed early
> on in system bootstrap even before PCI has been initialised.  Therefore
> it uses the system controller's device bus, which follows the endianness
> set with the CPU, which means no byte-swapping is ever required for data
> accesses to CBUS, unlike with PCI.
>
> The CBUS UART uses the UPIO_MEM32 access method, that is the `readl' and
> `writel' MMIO accessors, which on the MIPS platform imply byte-swapping
> with PCI systems.  Consequently the wrong byte lane is accessed with the
> big-endian configuration and the UART is not correctly accessed.
>
> As it happens the UPIO_MEM32BE access method makes use of the `ioread32'
> and `iowrite32' MMIO accessors, which still use `readl' and `writel'
> respectively, however they byte-swap data passed, effectively cancelling
> swapping done with the accessors themselves and making it suitable for
> the CBUS UART.
>
> Make the CBUS UART switch between UPIO_MEM32 and UPIO_MEM32BE then,
> based on the endianness selected.  With this change in place the device
> is correctly recognised with big-endian Malta at boot, along with the
> Super I/O devices behind PCI:
>
> Serial: 8250/16550 driver, 5 ports, IRQ sharing enabled
> printk: console [ttyS0] disabled
> serial8250.0: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> printk: console [ttyS0] enabled
> printk: bootconsole [uart8250] disabled
> serial8250.0: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
> serial8250.0: ttyS2 at MMIO 0x1f000900 (irq = 20, base_baud = 230400) is a 16550A
>
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: e7c4782f92fc ("[MIPS] Put an end to <asm/serial.h>'s long and annyoing existence")
> Cc: stable@vger.kernel.org # v2.6.23+
> ---
> Changes from v1:
>
> - Remove console message duplicates from the commit description.
> ---
>  arch/mips/mti-malta/malta-platform.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
