Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13232909D6
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410436AbgJPQkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409112AbgJPQkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:40:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E038CC061755;
        Fri, 16 Oct 2020 09:40:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n9so1765326pgf.9;
        Fri, 16 Oct 2020 09:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IckxrY+DJUgifghNLeuNR0thZvPKeVF++1zmyr1erYw=;
        b=ESgt/PDnWql9lpWADVRcvJtTdx/yh6tAhrYC8ZbqFWYpenEaoveVB1MkC0MmzrYBkq
         A2hcACvYNVxP+qeCOXAm6TAoHg/hA945fUoFPjZyDgwGUzM0gBZIAAgt2f2WdEixOwMc
         MuvuXD0etsBBlcYQYZVQb0nnaZp6KJlo0Db6lw+kJqZnzH3zDaZxJ8q6h45XeRph8MCx
         rDJyF81mIAxRxSew5JoQXhgwt1mXtnZ6p+gLQPRXbuD31FMcP8zYOHwfP4c+cBdpMPa/
         g3a4a6g6G4qJAcV8hOS7BmEgZ9IbBpK/hWsUtfcO9d6EafuL7fBhEFwToR4bak2AEIOr
         WedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IckxrY+DJUgifghNLeuNR0thZvPKeVF++1zmyr1erYw=;
        b=ZQZ7syF6ObbW2/ktYVm4DWNpDvLu3y6rjFWc2PXj/62SrFct7P8BaJJMFTJONq03MY
         O+mHGh2RAu0YLR3OVezwATVRnDZxKNQAbiRk4ZfyPhQ8XLO/0SbFz7qoSUXUQ8vSEuf5
         qnh2XHnqFFKMf5ZELakTo9pJThyZWZvPdllkdOOujZhSwl9N5SxXLzcTxaYqf73pj6aL
         /sabuLrPbXIHVrVPpYqsjgY4HTe6zCaxUpbDy/2CfkpnRXNK4gjpTBrDiSrBbkY3Ccnh
         ezVs5TYKR5vuXRCkpPcgLaZuCtAEBmY0Wz86O00LdjnpT1bQiPA9/S/1SrlKZd5q8lmo
         2HCw==
X-Gm-Message-State: AOAM533aUFtw8ySkRAmoysJY6n6RRmf84/dCjCzU8y/NeoiN2HTMB+ie
        Y8MqcYCWSogu+OIBUbhrERWGwHzHOI+wsSx/3CkKziFATDl9AA==
X-Google-Smtp-Source: ABdhPJx6pQLev1hrd9p9RQDKLQbYA4y9N4AoDM8hkHzN15gVHnEjk9hji9W0yK8afB4GH5dGC6kXh6x1X4qhgS5fHFQ=
X-Received: by 2002:a63:308:: with SMTP id 8mr3912525pgd.203.1602866405342;
 Fri, 16 Oct 2020 09:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200917130920.6689-1-geert+renesas@glider.be>
In-Reply-To: <20200917130920.6689-1-geert+renesas@glider.be>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 16 Oct 2020 19:40:54 +0300
Message-ID: <CAHp75Vd3s1N_f9oM=MiMv6ZhtrOzYMKAQz+CURVkxG4JgGVw+Q@mail.gmail.com>
Subject: Re: [PATCH v3] ata: sata_rcar: Fix DMA boundary mask
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-ide@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 4:12 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> Before commit 9495b7e92f716ab2 ("driver core: platform: Initialize
> dma_parms for platform devices"), the R-Car SATA device didn't have DMA
> parameters.  Hence the DMA boundary mask supplied by its driver was
> silently ignored, as __scsi_init_queue() doesn't check the return value
> of dma_set_seg_boundary(), and the default value of 0xffffffff was used.
>
> Now the device has gained DMA parameters, the driver-supplied value is
> used, and the following warning is printed on Salvator-XS:
>
>     DMA-API: sata_rcar ee300000.sata: mapping sg segment across boundary [start=0x00000000ffffe000] [end=0x00000000ffffefff] [boundary=0x000000001ffffffe]
>     WARNING: CPU: 5 PID: 38 at kernel/dma/debug.c:1233 debug_dma_map_sg+0x298/0x300
>
> (the range of start/end values depend on whether IOMMU support is
>  enabled or not)
>
> The issue here is that SATA_RCAR_DMA_BOUNDARY doesn't have bit 0 set, so
> any typical end value, which is odd, will trigger the check.
>
> Fix this by increasing the DMA boundary value by 1.
>
> This also fixes the following WRITE DMA EXT timeout issue:
>
>     # dd if=/dev/urandom of=/mnt/de1/file1-1024M bs=1M count=1024
>     ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>     ata1.00: failed command: WRITE DMA EXT
>     ata1.00: cmd 35/00:00:00:e6:0c/00:0a:00:00:00/e0 tag 0 dma 1310720 out
>     res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>     ata1.00: status: { DRDY }
>
> as seen by Shimoda-san since commit 429120f3df2dba2b ("block: fix
> splitting segments on boundary masks").
>
> Fixes: 8bfbeed58665dbbf ("sata_rcar: correct 'sata_rcar_sht'")
> Fixes: 9495b7e92f716ab2 ("driver core: platform: Initialize dma_parms for platform devices")
> Fixes: 429120f3df2dba2b ("block: fix splitting segments on boundary masks")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Cc: stable <stable@vger.kernel.org>
> ---
> v3:
>   - Add Reviewed-by, Tested-by,
>   - Augment description and Fixes: with Shimoda-san's problem report
>     https://lore.kernel.org/r/1600255098-21411-1-git-send-email-yoshihiro.shimoda.uh@renesas.com,
>
> v2:
>   - Add Reviewed-by, Tested-by, Cc.
> ---
>  drivers/ata/sata_rcar.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
> index 141ac600b64c87ef..44b0ed8f6bb8a120 100644
> --- a/drivers/ata/sata_rcar.c
> +++ b/drivers/ata/sata_rcar.c
> @@ -120,7 +120,7 @@
>  /* Descriptor table word 0 bit (when DTA32M = 1) */
>  #define SATA_RCAR_DTEND                        BIT(0)
>
> -#define SATA_RCAR_DMA_BOUNDARY         0x1FFFFFFEUL
> +#define SATA_RCAR_DMA_BOUNDARY         0x1FFFFFFFUL

Wondering if GENMASK() here will be better to avoid such mistakes.

>
>  /* Gen2 Physical Layer Control Registers */
>  #define RCAR_GEN2_PHY_CTL1_REG         0x1704
> --
> 2.17.1
>


-- 
With Best Regards,
Andy Shevchenko
