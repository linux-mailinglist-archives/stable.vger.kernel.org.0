Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D972B4F83
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbgKPSaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:30:24 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43567 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388273AbgKPSaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 13:30:16 -0500
Received: by mail-ot1-f66.google.com with SMTP id y22so16961361oti.10;
        Mon, 16 Nov 2020 10:30:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EKTkIwyZwV4u31bWikdvLToVWPQ0dKuSSmU+Pq2qs18=;
        b=OBx7FTZbVE5pfNZKRkjCs1oOZ9rLisgEXS26DGMAeWv3zHwq4QD8DDT3bBiyDCJp3c
         Wr+ss4zOls94glUlKZ2SX8ShwocFukM2KKO9X3S6cN+tZD7u0N9ApXb9cf4Fw/3mroQ8
         LLz3CJ0sxqGpy+ReoLn8Uan+VEK9RiOcfUXxr7Mo9lQQM+tOBM0ylnGbHG7DdoGXPekg
         pBRRY5I1sbtHg+rAgB/36oHDEgDyhkxkDkXICpG8+rbiqj84n3UkxI+VGE0mJ8Gt+SR8
         pVSmYiQDHFqJfVWqjsglC/JDhMsvPnRcgIb4+4JyzedgQgn64a99wFqv9LFqNcvNgUQ6
         3m+w==
X-Gm-Message-State: AOAM531iaZp7H1TJQTSBXOCAFV089xOrZp+6vgB6ylpEBIeM/1HejpaY
        H3l6LdGU8QTesAhptLJxL+5a2vSTiJOC3QsogFc=
X-Google-Smtp-Source: ABdhPJwaG7Pky9iASkV2jF9CHeiGGbdlvySxrd+f3SixZRRhtECyte2s65bx+35zZwM2vyMzfwDRXnEritWBMCsd69E=
X-Received: by 2002:a9d:16f:: with SMTP id 102mr470113otu.206.1605551413603;
 Mon, 16 Nov 2020 10:30:13 -0800 (PST)
MIME-Version: 1.0
References: <20201110083334.456893-1-yaoaili126@163.com>
In-Reply-To: <20201110083334.456893-1-yaoaili126@163.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 16 Nov 2020 19:30:02 +0100
Message-ID: <CAJZ5v0gCAj2dBE6vu4atvK+ZD4w7tvQ_+j99g0Jj2=X31YsUtQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI, APEI, Fix error return value in apei_map_generic_address()
To:     yaoaili126@163.com
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, James Morse <james.morse@arm.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, yangfeng1@kingsoft.com,
        yaoaili@kingsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 9:50 AM <yaoaili126@163.com> wrote:
>
> From: Aili Yao <yaoaili@kingsoft.com>
>
> From commit 6915564dc5a8 ("ACPI: OSL: Change the type of
> acpi_os_map_generic_address() return value"),
> acpi_os_map_generic_address() will return logical address or NULL for
> error, but for ACPI_ADR_SPACE_SYSTEM_IO case, it should be also return 0
> as it's a normal case, but now it will return -ENXIO. So check it out for
> such case to avoid einj module initialization fail.
>
> Fixes: 6915564dc5a8 ("ACPI: OSL: Change the type of
> acpi_os_map_generic_address() return value")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: James Morse <james.morse@arm.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> ---
>  drivers/acpi/apei/apei-base.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
> index 552fd9f..3294cc8 100644
> --- a/drivers/acpi/apei/apei-base.c
> +++ b/drivers/acpi/apei/apei-base.c
> @@ -633,6 +633,10 @@ int apei_map_generic_address(struct acpi_generic_address *reg)
>         if (rc)
>                 return rc;
>
> +       /* IO space doesn't need mapping */
> +       if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
> +               return 0;
> +
>         if (!acpi_os_map_generic_address(reg))
>                 return -ENXIO;
>
> --

Applied as 5.10-rc material, thanks!
