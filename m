Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F38726F5DE
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 08:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIRG0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 02:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIRG0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 02:26:07 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58C5208DB;
        Fri, 18 Sep 2020 06:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600410366;
        bh=u/eJ6TFCIf/fhVj5p/bfsI8cRKnKB9SGd2sw158iADI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XJjlKArkJQ0t6XLyOD9SmaFP53lil63z4VNzQh10rzGl3GRdYIPUO+BbQXcNKp24w
         jmmBzNjYdxJfKHLd3bK7JB9EULBZ87o2pSQz21uC51IOb8w+qSTAZr2RPyXQz0/D1N
         z53wCLgvQwlqNscXttjEdyCOHBhU3kty09wBGKEI=
Received: by mail-oi1-f176.google.com with SMTP id u126so5671989oif.13;
        Thu, 17 Sep 2020 23:26:06 -0700 (PDT)
X-Gm-Message-State: AOAM533Ya4OaThzKg+yZOUltsCRp8+MQQGi5WQwgC99xnKganFcWtqld
        0A76IPqtaoqH1T0HNhGXVHKuMxtLwOUzR8iCd28=
X-Google-Smtp-Source: ABdhPJyJpHt/enAmujpj3l8B6b0l/LGtHcOMS/5AR06YPfev4YAmduKtEKAy93B4ONSBcgTGhTsC7wVP0vdKcN4X5OQ=
X-Received: by 2002:aca:d845:: with SMTP id p66mr8024864oig.47.1600410365979;
 Thu, 17 Sep 2020 23:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200918021455.2067301-1-sashal@kernel.org> <20200918021455.2067301-23-sashal@kernel.org>
In-Reply-To: <20200918021455.2067301-23-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 18 Sep 2020 09:25:54 +0300
X-Gmail-Original-Message-ID: <CAMj1kXF4yyg02N8NuU4wMBJn1Aon4K_r54QAL7jbKZAa-cKyBQ@mail.gmail.com>
Message-ID: <CAMj1kXF4yyg02N8NuU4wMBJn1Aon4K_r54QAL7jbKZAa-cKyBQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 23/90] efi/arm: Defer probe of PCIe backed
 efifb on DT systems
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Sep 2020 at 05:15, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit 64c8a0cd0a535891d5905c3a1651150f0f141439 ]
>
> The new of_devlink support breaks PCIe probing on ARM platforms booting
> via UEFI if the firmware exposes a EFI framebuffer that is backed by a
> PCI device. The reason is that the probing order gets reversed,
> resulting in a resource conflict on the framebuffer memory window when
> the PCIe probes last, causing it to give up entirely.
>
> Given that we rely on PCI quirks to deal with EFI framebuffers that get
> moved around in memory, we cannot simply drop the memory reservation, so
> instead, let's use the device link infrastructure to register this
> dependency, and force the probing to occur in the expected order.
>
> Co-developed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lore.kernel.org/r/20200113172245.27925-9-ardb@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Same question as the previous time you proposed this patch for stable:
is the of_devlink framework being backported in its entirety? If not,
this patch does not belong in -stable.


> ---
>  drivers/firmware/efi/arm-init.c | 107 ++++++++++++++++++++++++++++++--
>  1 file changed, 103 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 8ee91777abce7..e4ddd6e6edb31 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -14,10 +14,12 @@
>  #define pr_fmt(fmt)    "efi: " fmt
>
>  #include <linux/efi.h>
> +#include <linux/fwnode.h>
>  #include <linux/init.h>
>  #include <linux/memblock.h>
>  #include <linux/mm_types.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/of_fdt.h>
>  #include <linux/platform_device.h>
>  #include <linux/screen_info.h>
> @@ -262,15 +264,112 @@ void __init efi_init(void)
>                 efi_memmap_unmap();
>  }
>
> +static bool efifb_overlaps_pci_range(const struct of_pci_range *range)
> +{
> +       u64 fb_base = screen_info.lfb_base;
> +
> +       if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> +               fb_base |= (u64)(unsigned long)screen_info.ext_lfb_base << 32;
> +
> +       return fb_base >= range->cpu_addr &&
> +              fb_base < (range->cpu_addr + range->size);
> +}
> +
> +static struct device_node *find_pci_overlap_node(void)
> +{
> +       struct device_node *np;
> +
> +       for_each_node_by_type(np, "pci") {
> +               struct of_pci_range_parser parser;
> +               struct of_pci_range range;
> +               int err;
> +
> +               err = of_pci_range_parser_init(&parser, np);
> +               if (err) {
> +                       pr_warn("of_pci_range_parser_init() failed: %d\n", err);
> +                       continue;
> +               }
> +
> +               for_each_of_pci_range(&parser, &range)
> +                       if (efifb_overlaps_pci_range(&range))
> +                               return np;
> +       }
> +       return NULL;
> +}
> +
> +/*
> + * If the efifb framebuffer is backed by a PCI graphics controller, we have
> + * to ensure that this relation is expressed using a device link when
> + * running in DT mode, or the probe order may be reversed, resulting in a
> + * resource reservation conflict on the memory window that the efifb
> + * framebuffer steals from the PCIe host bridge.
> + */
> +static int efifb_add_links(const struct fwnode_handle *fwnode,
> +                          struct device *dev)
> +{
> +       struct device_node *sup_np;
> +       struct device *sup_dev;
> +
> +       sup_np = find_pci_overlap_node();
> +
> +       /*
> +        * If there's no PCI graphics controller backing the efifb, we are
> +        * done here.
> +        */
> +       if (!sup_np)
> +               return 0;
> +
> +       sup_dev = get_dev_from_fwnode(&sup_np->fwnode);
> +       of_node_put(sup_np);
> +
> +       /*
> +        * Return -ENODEV if the PCI graphics controller device hasn't been
> +        * registered yet.  This ensures that efifb isn't allowed to probe
> +        * and this function is retried again when new devices are
> +        * registered.
> +        */
> +       if (!sup_dev)
> +               return -ENODEV;
> +
> +       /*
> +        * If this fails, retrying this function at a later point won't
> +        * change anything. So, don't return an error after this.
> +        */
> +       if (!device_link_add(dev, sup_dev, 0))
> +               dev_warn(dev, "device_link_add() failed\n");
> +
> +       put_device(sup_dev);
> +
> +       return 0;
> +}
> +
> +static const struct fwnode_operations efifb_fwnode_ops = {
> +       .add_links = efifb_add_links,
> +};
> +
> +static struct fwnode_handle efifb_fwnode = {
> +       .ops = &efifb_fwnode_ops,
> +};
> +
>  static int __init register_gop_device(void)
>  {
> -       void *pd;
> +       struct platform_device *pd;
> +       int err;
>
>         if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
>                 return 0;
>
> -       pd = platform_device_register_data(NULL, "efi-framebuffer", 0,
> -                                          &screen_info, sizeof(screen_info));
> -       return PTR_ERR_OR_ZERO(pd);
> +       pd = platform_device_alloc("efi-framebuffer", 0);
> +       if (!pd)
> +               return -ENOMEM;
> +
> +       if (IS_ENABLED(CONFIG_PCI))
> +               pd->dev.fwnode = &efifb_fwnode;
> +
> +       err = platform_device_add_data(pd, &screen_info, sizeof(screen_info));
> +       if (err)
> +               return err;
> +
> +       return platform_device_add(pd);
>  }
>  subsys_initcall(register_gop_device);
> --
> 2.25.1
>
