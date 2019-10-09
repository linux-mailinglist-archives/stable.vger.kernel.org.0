Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C386D0DA2
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 13:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfJILax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 07:30:53 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37231 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfJILax (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 07:30:53 -0400
Received: by mail-ot1-f68.google.com with SMTP id k32so1407692otc.4;
        Wed, 09 Oct 2019 04:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RXacikU0AKH0a8cL4TI2rXH1Tzq/pqcytSrL8Dn3Zw8=;
        b=RTx/AK10bD48wEe69Kaq2wVkXqU9LfM94WzgBfIzOgSe9MbJE3QZlyBKnylXqrBZm+
         QVxeurGffn9nO2rXbQgqJ4ckJMW9kjSrjPgFbmEsFzTZef3upW0z67R5IqAXVYhsSmGS
         irDCJ659yXOUuaX3qK2Rn8COhDCjsQvMmX7xQejYwYRbw0Aw9WCu+9OdFNV3Hc9nzaaj
         kZfA9wSE4ftzEx3nmZJI4iel85twVP0/cEfAypzblpPMoHW7qlTXchEPafUDGPRfXRnD
         4c2kAmNCKiB1j/SLdVRxZGEjthOhsGSc6EBDPDN+ELDL7PQvzP5U67qQ6Tr+AgK9miuW
         wJyA==
X-Gm-Message-State: APjAAAXTtUdJ+AanwiDQHkdF7qCUsvKDu6S/4G0Z8KPrtBQMYVQqTnye
        uU4VCMTf7koM4BsFlMd2yFfde67KkjB/8tEOEEM=
X-Google-Smtp-Source: APXvYqzgv6KySzCyCwbije3dycoip8/EkYhTSn/U8sbafZ+9IuVjS3Kvl7zSNX2/eZ2v4y89W5Lxm4LkZubFMtHPYi4=
X-Received: by 2002:a9d:7a82:: with SMTP id l2mr2385387otn.297.1570620652071;
 Wed, 09 Oct 2019 04:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <1570619086-30088-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <1570619086-30088-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 9 Oct 2019 13:30:40 +0200
Message-ID: <CAMuHMdWpxCwOL4Ewd_CQOMMXq9vKQ0zJCW0A0ume_XtsdEtwJA@mail.gmail.com>
Subject: Re: [PATCH v3] PCI: rcar: Fix missing MACCTLR register setting in rcar_pcie_hw_init()
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Simon Horman <horms@verge.net.au>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Wed, Oct 9, 2019 at 1:05 PM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
> should be written to 0 before enabling PCIETCTLR.CFINIT because
> the bit 0 is set to 1 on reset. To avoid unexpected behaviors from
> this incorrect setting, this patch fixes it.
>
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Cc: <stable@vger.kernel.org> # v3.16+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Changes from v2:
>  - Change the subject.
>  - Fix commit log again.
>  - Add the register setting into the initialization, instead of speedup.
>  - Change commit hash/target version on Fixes and Cc stable tags.
>  - Add Geert-san's Reviewed-by.
>  https://patchwork.kernel.org/patch/11180429/

Thanks for the update!

> --- a/drivers/pci/controller/pcie-rcar.c
> +++ b/drivers/pci/controller/pcie-rcar.c
> @@ -93,6 +93,7 @@
>  #define  LINK_SPEED_2_5GTS     (1 << 16)
>  #define  LINK_SPEED_5_0GTS     (2 << 16)
>  #define MACCTLR                        0x011058
> +#define  MACCTLR_RESERVED      BIT(0)
>  #define  SPEED_CHANGE          BIT(24)
>  #define  SCRAMBLE_DISABLE      BIT(27)
>  #define PMSR                   0x01105c
> @@ -615,6 +616,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
>         if (IS_ENABLED(CONFIG_PCI_MSI))
>                 rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
>
> +       rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
> +
>         /* Finish initialization - establish a PCI Express link */
>         rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);

I guess the same should be added to rcar_pcie_resume_noirq(),
as s2ram on R-Car Gen3 powers down the SoC?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
