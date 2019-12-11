Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6638011B1E3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388024AbfLKPdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387423AbfLKPdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:33:17 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63A042077B;
        Wed, 11 Dec 2019 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078396;
        bh=23YlAnpt744eiuxvp4LvcKrabFlhDLD+8Q8Ilp9BmqY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HlGrVixYom2ssG9+XLm7A52FHM9+bgKtLuuQ/18ur59yNWaULj75MFKcI3PpKX+2Z
         7RmrdC8S2f81L+VlreVej0IgovZwco6qqLgr56mFuqRenY+ugnDwhXB2KJYQ7cNYEQ
         7c2A37KwttEs2TgM4ezgBcYg1z9jEEe3EbnQS1dY=
Received: by mail-wm1-f49.google.com with SMTP id a5so1811783wmb.0;
        Wed, 11 Dec 2019 07:33:16 -0800 (PST)
X-Gm-Message-State: APjAAAXRVsL7zN+BmSoXnfowql2oSzZvpAR+M2zBmhIra1ZdteboF06Y
        5zvAhd6FNjrhMOk5rbd2+nlw2BZ8hKUu/bbMZ7U=
X-Google-Smtp-Source: APXvYqwjSC19g0o0KY/WlIEeOOsXoviY4IAXr7g5yUJbzDXE4omBhvNmA6CAL+nCmUBxUwEofGEO2mzo6hRqBLipPL4=
X-Received: by 2002:a05:600c:2409:: with SMTP id 9mr356922wmp.109.1576078394867;
 Wed, 11 Dec 2019 07:33:14 -0800 (PST)
MIME-Version: 1.0
References: <20191211104152.26496-1-wens@kernel.org> <28dfaeab-73cd-041b-9894-776064d13245@arm.com>
In-Reply-To: <28dfaeab-73cd-041b-9894-776064d13245@arm.com>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Wed, 11 Dec 2019 23:33:05 +0800
X-Gmail-Original-Message-ID: <CAGb2v640NEj+WK_zj-LouvwkLTVrwyMgWGq_xdU8qJkOKF0FFQ@mail.gmail.com>
Message-ID: <CAGb2v640NEj+WK_zj-LouvwkLTVrwyMgWGq_xdU8qJkOKF0FFQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Chen-Yu Tsai <wens@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 9:41 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 11/12/2019 10:41 am, Chen-Yu Tsai wrote:
> > From: Chen-Yu Tsai <wens@csie.org>
> >
> > max_pfn, as set in arch/arm/mm/init.c:
> >
> >      static void __init find_limits(unsigned long *min,
> >                                  unsigned long *max_low,
> >                                  unsigned long *max_high)
> >      {
> >           *max_low = PFN_DOWN(memblock_get_current_limit());
> >           *min = PFN_UP(memblock_start_of_DRAM());
> >           *max_high = PFN_DOWN(memblock_end_of_DRAM());
> >      }
> >
> > with memblock_end_of_DRAM() pointing to the next byte after DRAM. As
> > such, max_pfn points to the PFN after the end of DRAM.
> >
> > Thus when using max_pfn to check DMA masks, we should subtract one
> > when checking DMA ranges against it.
> >
> > Commit 8bf1268f48ad ("ARM: dma-api: fix off-by-one error in
> > __dma_supported()") fixed the same issue, but missed this spot.
> >
> > This issue was found while working on the sun4i-csi v4l2 driver on the
> > Allwinner R40 SoC. On Allwinner SoCs, DRAM is offset at 0x40000000,
> > and we are starting to use of_dma_configure() with the "dma-ranges"
> > property in the device tree to have the DMA API handle the offset.
> >
> > In this particular instance, dma-ranges was set to the same range as
> > the actual available (2 GiB) DRAM. The following error appeared when
> > the driver attempted to allocate a buffer:
> >
> >      sun4i-csi 1c09000.csi: Coherent DMA mask 0x7fffffff (pfn 0x40000-0xc0000)
> >      covers a smaller range of system memory than the DMA zone pfn 0x0-0xc0001
> >      sun4i-csi 1c09000.csi: dma_alloc_coherent of size 307200 failed
> >
> > Fixing the off-by-one error makes things work.
> >
> > Fixes: 11a5aa32562e ("ARM: dma-mapping: check DMA mask against available memory")
> > Fixes: 9f28cde0bc64 ("ARM: another fix for the DMA mapping checks")
> > Fixes: ab746573c405 ("ARM: dma-mapping: allow larger DMA mask than supported")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > ---
> >   arch/arm/mm/dma-mapping.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > index e822af0d9219..f4daafdbac56 100644
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -227,12 +227,12 @@ static int __dma_supported(struct device *dev, u64 mask, bool warn)
> >        * Translate the device's DMA mask to a PFN limit.  This
> >        * PFN number includes the page which we can DMA to.
> >        */
> > -     if (dma_to_pfn(dev, mask) < max_dma_pfn) {
> > +     if (dma_to_pfn(dev, mask) < max_dma_pfn - 1) {
>
> I think this correction actually wants to happen a couple of lines up in
> the definition:
>
>         unsigned long max_dma_pfn = min(max_pfn, arm_dma_pfn_limit);
>
> max_pfn is indeed an exclusive limit, but AFAICS arm_dma_pfn_limit is
> inclusive, so none of these "+1"s and "-1"s can be entirely right for
> both cases.

You're absolutely right. I'll fix it and send a v2 out.

Thanks

ChenYu

> Robin.
>
> >               if (warn)
> >                       dev_warn(dev, "Coherent DMA mask %#llx (pfn %#lx-%#lx) covers a smaller range of system memory than the DMA zone pfn 0x0-%#lx\n",
> >                                mask,
> >                                dma_to_pfn(dev, 0), dma_to_pfn(dev, mask) + 1,
> > -                              max_dma_pfn + 1);
> > +                              max_dma_pfn);
> >               return 0;
> >       }
> >
> >
