Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F3B752E1
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 17:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389300AbfGYPhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 11:37:04 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41331 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389301AbfGYPhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 11:37:03 -0400
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1hqfnQ-0001bw-8U; Thu, 25 Jul 2019 17:36:44 +0200
Message-ID: <1564069001.3006.1.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/7] media: hantro: Set DMA max segment size
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Cc:     kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        fbuergisser@chromium.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Thu, 25 Jul 2019 17:36:41 +0200
In-Reply-To: <20190725141756.2518-2-ezequiel@collabora.com>
References: <20190725141756.2518-1-ezequiel@collabora.com>
         <20190725141756.2518-2-ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-07-25 at 11:17 -0300, Ezequiel Garcia wrote:
> From: Francois Buergisser <fbuergisser@chromium.org>
> 
> The Hantro codec is typically used in platforms with an IOMMU,
> so we need to set a proper DMA segment size.

... to make sure the DMA-mapping subsystem produces contiguous mappings?

> Devices without an
> IOMMU will still fallback to default 64KiB segments.

I don't understand this comment. The default max_seg_size may be 64 KiB,
but if we are always setting it to DMA_BUT_MASK(32), there is no falling
back.

> Cc: stable@vger.kernel.org
> Fixes: 775fec69008d3 ("media: add Rockchip VPU JPEG encoder driver")
> Signed-off-by: Francois Buergisser <fbuergisser@chromium.org>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/staging/media/hantro/hantro_drv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
> index b71a06e9159e..4eae1dbb1ac8 100644
> --- a/drivers/staging/media/hantro/hantro_drv.c
> +++ b/drivers/staging/media/hantro/hantro_drv.c
> @@ -731,6 +731,7 @@ static int hantro_probe(struct platform_device *pdev)
>  		dev_err(vpu->dev, "Could not set DMA coherent mask.\n");
>  		return ret;
>  	}
> +	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));

This should be complemented by a call to
vb2_dma_contig_clear_max_seg_size() in _remove,
to avoid leaking dev->dma_parms.

>  
>  	for (i = 0; i < vpu->variant->num_irqs; i++) {
>  		const char *irq_name = vpu->variant->irqs[i].name;

regards
Philipp
