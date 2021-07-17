Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900133CC39F
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhGQNm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 09:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbhGQNm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 09:42:29 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2E0C061762
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 06:39:32 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h4so16863753ljo.6
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 06:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wMysod/FxYgvZzqmI+wGDhxKEpokYzXYS9Z8NQkl9ME=;
        b=dx3rzI7bTiu4T3bOQldfOy1OsFPlkh8bBfCb9jy5V8APCP58TFHseMNd9H/okgmswf
         hUKephRuwDpjGCW1EMdvDYrqArAsrkr0iOBqiPc/BNwsAcr63DSlQ8/fMJJKhjWoZTvJ
         VeTfrx1L3pkh4TvaF7hs8xXw2oxYnqrN+/WH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wMysod/FxYgvZzqmI+wGDhxKEpokYzXYS9Z8NQkl9ME=;
        b=N6L63FQy7NJc/+R3ZSh7BgKYBpoK6x2d7ZqNz0jHuzrvxe8se0R1xy9NBFUhxa7axj
         Z+UHKiwjQCoaHpRRfZCg0zdkjNxb0b5Eoivk1cFWCoAbXWFRcgg00yYvNUApA6YmKHwM
         1EleArz8P2HjRTykQMcue6evVKHaUHhs70VQnyAXGv4VmmFznK2NHiPY6ADxzdKk8m3F
         d1FZKdf17VGBfEAaFD5xzuvzfSwIRTM7xaXYMgfrOLosquYYXNOW0JjsEkzzAxM+90A5
         EuG9XBt7uaPNG+FIHfXDiptPQBwFmnxA0P/od6YiYeCVnXODTY7JCG52a7v1zUvid5/o
         WEXA==
X-Gm-Message-State: AOAM531pMCt6epEHHCxl5zU7IZR0SU5tZL5ooEuT/abDHwAvS8FwcWKC
        LPWDmjpPFlpukNpzmGJ+hYODYXQJS2tcG3u1QinqRA==
X-Google-Smtp-Source: ABdhPJwrBJIk83MDhG8twlHGK2D602TuoBySGjD8NgUQYkCsFRJjpLsnWZmn20MwEw5AyXgT+h/L6Y637xngf2CDgJM=
X-Received: by 2002:a2e:a90e:: with SMTP id j14mr8861414ljq.250.1626529170617;
 Sat, 17 Jul 2021 06:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060912.995381202@linuxfoundation.org> <20210712060916.499546891@linuxfoundation.org>
In-Reply-To: <20210712060916.499546891@linuxfoundation.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Sat, 17 Jul 2021 08:39:19 -0500
Message-ID: <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
Subject: Re: [PATCH 5.13 024/800] usb: renesas-xhci: Fix handling of unknown
 ROM state
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Moritz Fischer <mdf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 2:31 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Moritz Fischer <mdf@kernel.org>
>
> commit d143825baf15f204dac60acdf95e428182aa3374 upstream.
>
> The ROM load sometimes seems to return an unknown status
> (RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.
>
> If the ROM load indeed failed this leads to failures when trying to
> communicate with the controller later on.
>
> Attempt to load firmware using RAM load in those cases.
>
> Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
> Cc: stable@vger.kernel.org
> Cc: Mathias Nyman <mathias.nyman@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Tested-by: Vinod Koul <vkoul@kernel.org>
> Reviewed-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> Link: https://lore.kernel.org/r/20210615153758.253572-1-mdf@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>

After sending out 5.12.17 for testing, we had a user complain that all
of their USB devices disappeared with the error:

Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: Direct firmware load
for renesas_usb_fw.mem failed with error -2
Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: request_firmware failed: -2
Jul 15 23:18:53 kernel: xhci_hcd: probe of 0000:04:00.0 failed with error -2

After first assuming that something was missing in the backport to
5.12, I had the user try 5.13.2, and then 5.14-rc1. Both of those
failed in the same way, so it is not working in the current Linus tree
either.  Reverting this patch fixed the issue.

Justin

> ---
>  drivers/usb/host/xhci-pci-renesas.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> --- a/drivers/usb/host/xhci-pci-renesas.c
> +++ b/drivers/usb/host/xhci-pci-renesas.c
> @@ -207,7 +207,8 @@ static int renesas_check_rom_state(struc
>                         return 0;
>
>                 case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
> -                       return 0;
> +                       dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
> +                       break;
>
>                 case RENESAS_ROM_STATUS_ERROR: /* Error State */
>                 default: /* All other states are marked as "Reserved states" */
> @@ -224,13 +225,12 @@ static int renesas_fw_check_running(stru
>         u8 fw_state;
>         int err;
>
> -       /* Check if device has ROM and loaded, if so skip everything */
> -       err = renesas_check_rom(pdev);
> -       if (err) { /* we have rom */
> -               err = renesas_check_rom_state(pdev);
> -               if (!err)
> -                       return err;
> -       }
> +       /*
> +        * Only if device has ROM and loaded FW we can skip loading and
> +        * return success. Otherwise (even unknown state), attempt to load FW.
> +        */
> +       if (renesas_check_rom(pdev) && !renesas_check_rom_state(pdev))
> +               return 0;
>
>         /*
>          * Test if the device is actually needing the firmware. As most
>
>
