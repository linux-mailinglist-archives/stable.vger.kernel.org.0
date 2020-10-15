Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19528F8B3
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 20:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbgJOSeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 14:34:31 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41539 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgJOSea (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 14:34:30 -0400
Received: by mail-ot1-f66.google.com with SMTP id n15so100621otl.8;
        Thu, 15 Oct 2020 11:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ViFRyZzY3eGmlGkyoQ+/ZMsox3DeqWihB59/NTmtCI=;
        b=XS5M5DlgXa4bBn61yuhMdvhhawnidmP9EokN+KUGooOsp91Jeh6yESJVEht7kU5sqP
         gRSXkEiJPCul1UE33N7FEOntLg69PQktz5lII/0c/uwCziNscz/E3Kjw9DdbaMhznMbE
         czyiIj/WX+1g7N+WHPBcLfScVGissDJ0GGjCBm/2Ul7jEbrpPUtga/ZDBlzQGHl8yhBP
         viNvQi3zHfaNWf/0IlXu9yTbFcsLHKMz87SK0JXHmBtVJdh0wTT0ODHwVlSFFWznQg7p
         U6GHE6O1XkxTSHyX+6EHtY6FzsdMfW3kUFJ/vpjG4ujFAHsoO77sNSTr1wqLEXy25rXV
         nYRA==
X-Gm-Message-State: AOAM5316AgVUlBY6pCk2MurQbaojMvSKv3D+nRIQoAyqj6eVBmHl6gdr
        I1R3WW5EeJbdQ62do4iwTkyWYEqsQS3YF5pLbtHFJiKn
X-Google-Smtp-Source: ABdhPJyHuxCI9aoRbG13Q6VQq8OqvTueuQIKvxr282I/izVF0CXUgnos0ZEm+ZHjPF0prbKDvqSeGnMtIwjLcPeSj5w=
X-Received: by 2002:a9d:5e14:: with SMTP id d20mr3390096oti.107.1602786869473;
 Thu, 15 Oct 2020 11:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200917130920.6689-1-geert+renesas@glider.be>
In-Reply-To: <20200917130920.6689-1-geert+renesas@glider.be>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 15 Oct 2020 20:34:17 +0200
Message-ID: <CAMuHMdWQapEyvd=rpdfW5XHbwLtaiyLsnAXn5dM8zGCpc9VSFA@mail.gmail.com>
Subject: Re: [PATCH v3] ata: sata_rcar: Fix DMA boundary mask
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-ide@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

On Thu, Sep 17, 2020 at 3:09 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
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

Can you please apply this patch?
This is a fix for a regression in v5.7-rc5, and was first posted almost
5 months ago.

Thanks!

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
>
>  /* Gen2 Physical Layer Control Registers */
>  #define RCAR_GEN2_PHY_CTL1_REG         0x1704

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
