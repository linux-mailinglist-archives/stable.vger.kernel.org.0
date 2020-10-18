Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6040F2916DC
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 12:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgJRKAG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 18 Oct 2020 06:00:06 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42034 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgJRKAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Oct 2020 06:00:05 -0400
Received: by mail-oi1-f195.google.com with SMTP id 16so8987334oix.9;
        Sun, 18 Oct 2020 03:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hFbBEL05hQkRuuFO8zgRwVDCNcQ9GwFWuVeQdc80tWY=;
        b=fzK5xdZ7LnEpPRoqJJLC/YYf1Fm5Em3tdWXDzG4BoMb9mN9QYpuk6GZ/CwvkE3B7P2
         c0GsA/VNjted+HmD2/x/gaZQxG8C1ml+6b3tuVG0KPdmE0r0nx5XdMtA630wctmDDxj8
         VU1uxxes/eMNUXC68ul5KtKt6PAXSl2qpYC8PV0dGOEaBt4sNLRjK/DpLOTu3lj7NYZz
         KHYBy/0KMv5HerL47Cgw8lZ64E4vG8irKxOmwR6n4+HjM3arp3PlEYJ431UBDum7/j18
         sTw1UrujieaNiJqagHtxNd5Emfqw2/3u7eVFZtZYNJa16L56gOeVcaOLuazvRqHUWTfn
         09NA==
X-Gm-Message-State: AOAM530rBYLvjCT7bVwLP51dfcOML8DZjnVQcqxOksghEm6b66aLOIsl
        +NMijcTBbAyq7xeIB6cRLi3ZOFhrMexNRYOoeIM=
X-Google-Smtp-Source: ABdhPJwgY+OSIkqWUBV2XsALqfiZJHN4ZM3RJlhewKhbr14eofMi1pfBU7T2lHizkNLfBH71N1ThodZhWIMtPo6q8O8=
X-Received: by 2002:aca:c490:: with SMTP id u138mr8178254oif.54.1603015204078;
 Sun, 18 Oct 2020 03:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200917130920.6689-1-geert+renesas@glider.be>
 <CAHp75Vd3s1N_f9oM=MiMv6ZhtrOzYMKAQz+CURVkxG4JgGVw+Q@mail.gmail.com> <b9b74843-70ea-f53c-53cf-e929d0542d2c@gmail.com>
In-Reply-To: <b9b74843-70ea-f53c-53cf-e929d0542d2c@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 18 Oct 2020 11:59:52 +0200
Message-ID: <CAMuHMdXsP7LSzWksCondrvA1r=Ybx-R5FQYzZ8Z9BwZaYB82Ow@mail.gmail.com>
Subject: Re: [PATCH v3] ata: sata_rcar: Fix DMA boundary mask
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-ide@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sergei,

On Sat, Oct 17, 2020 at 9:15 PM Sergei Shtylyov
<sergei.shtylyov@gmail.com> wrote:
> On 10/16/20 7:40 PM, Andy Shevchenko wrote:
> >> Before commit 9495b7e92f716ab2 ("driver core: platform: Initialize
> >> dma_parms for platform devices"), the R-Car SATA device didn't have DMA
> >> parameters.  Hence the DMA boundary mask supplied by its driver was
> >> silently ignored, as __scsi_init_queue() doesn't check the return value
> >> of dma_set_seg_boundary(), and the default value of 0xffffffff was used.
> >>
> >> Now the device has gained DMA parameters, the driver-supplied value is
> >> used, and the following warning is printed on Salvator-XS:
> >>
> >>     DMA-API: sata_rcar ee300000.sata: mapping sg segment across boundary [start=0x00000000ffffe000] [end=0x00000000ffffefff] [boundary=0x000000001ffffffe]
> >>     WARNING: CPU: 5 PID: 38 at kernel/dma/debug.c:1233 debug_dma_map_sg+0x298/0x300
> >>
> >> (the range of start/end values depend on whether IOMMU support is
> >>  enabled or not)
> >>
> >> The issue here is that SATA_RCAR_DMA_BOUNDARY doesn't have bit 0 set, so
> >> any typical end value, which is odd, will trigger the check.
> >>
> >> Fix this by increasing the DMA boundary value by 1.
> >>
> >> This also fixes the following WRITE DMA EXT timeout issue:
> >>
> >>     # dd if=/dev/urandom of=/mnt/de1/file1-1024M bs=1M count=1024
> >>     ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> >>     ata1.00: failed command: WRITE DMA EXT
> >>     ata1.00: cmd 35/00:00:00:e6:0c/00:0a:00:00:00/e0 tag 0 dma 1310720 out
> >>     res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>     ata1.00: status: { DRDY }
> >>
> >> as seen by Shimoda-san since commit 429120f3df2dba2b ("block: fix
> >> splitting segments on boundary masks").
> >>
> >> Fixes: 8bfbeed58665dbbf ("sata_rcar: correct 'sata_rcar_sht'")
> >> Fixes: 9495b7e92f716ab2 ("driver core: platform: Initialize dma_parms for platform devices")
> >> Fixes: 429120f3df2dba2b ("block: fix splitting segments on boundary masks")
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> >> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> >> Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >> Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> >> Cc: stable <stable@vger.kernel.org>
> >> ---
> >> v3:
> >>   - Add Reviewed-by, Tested-by,
> >>   - Augment description and Fixes: with Shimoda-san's problem report
> >>     https://lore.kernel.org/r/1600255098-21411-1-git-send-email-yoshihiro.shimoda.uh@renesas.com,
> >>
> >> v2:
> >>   - Add Reviewed-by, Tested-by, Cc.
> >> ---
> >>  drivers/ata/sata_rcar.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
> >> index 141ac600b64c87ef..44b0ed8f6bb8a120 100644
> >> --- a/drivers/ata/sata_rcar.c
> >> +++ b/drivers/ata/sata_rcar.c
> >> @@ -120,7 +120,7 @@
> >>  /* Descriptor table word 0 bit (when DTA32M = 1) */
> >>  #define SATA_RCAR_DTEND                        BIT(0)
> >>
> >> -#define SATA_RCAR_DMA_BOUNDARY         0x1FFFFFFEUL
> >> +#define SATA_RCAR_DMA_BOUNDARY         0x1FFFFFFFUL
> >
> > Wondering if GENMASK() here will be better to avoid such mistakes.
>
>    How? The bit 0 is reserved, so only even byte counts are possiblе...

The DMA Transfer Count Register (ATAPI_DMA_TRANS_CNT) indeed does not
support odd values ("Bit 0 is ignored because the ATAPI data bus is
handled on a 16-bit basis (on a word basis)"), and is limited to
transfers less than 512 MiB.
Similarly the DMA Start Address Register (ATAPI_DMA_START_ADR) requires
that start address to be 32-bit aligned.

I believe the alignment and even size restrictions are met by the block
layer, by performing only transfers that are a multiple of the device's
block size (512 bytes minimum).

However, the SATA_RCAR_DMA_BOUNDARY definition is only used to set the
DMA boundary mask, which limits the MSB bits of an address. The LSB
bits of the mask should always be set, as a typical segment end (=
length - 1, i.e. ending in 0x1ff for a 512-byte block size) will always
have the 9 LSB bits set, else it will trigger the warning.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
