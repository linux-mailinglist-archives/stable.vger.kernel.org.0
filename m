Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F51179100
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 14:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgCDNMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 08:12:40 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50584 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388091AbgCDNMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 08:12:40 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 024DCdEa075120;
        Wed, 4 Mar 2020 07:12:39 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583327559;
        bh=5xGBvCCNbOxlYfM2cTKcfGoxokVXH8qQTRieJmYkdlg=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=DubHYOaBXGOe56OgUD+HfTAcAgbMAcRmFrTqEGeg3Or0Ad+oKwXhnILlkcYiAsUgX
         EUCPwA9HajZR39olpcWoh+6Md8snf3mG+Mkth8EZkLMrvnv0uWMvNlmaAAfQeeYH9U
         yZYTLnSe/OiZIGPgy9IjSFSGxMcjUUakemAcwiBk=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 024DCdSZ005491
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Mar 2020 07:12:39 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Mar
 2020 07:12:39 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Mar 2020 07:12:39 -0600
Received: from ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with SMTP id 024DCdxK092569;
        Wed, 4 Mar 2020 07:12:39 -0600
Date:   Wed, 4 Mar 2020 07:17:14 -0600
From:   Benoit Parrot <bparrot@ti.com>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
CC:     Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [Patch 1/1] media: ti-vpe: cal: fix disable_irqs to only the
 intended target
Message-ID: <20200304131714.rpykdxhgqxmaxyx5@ti.com>
References: <20200302135652.9365-1-bparrot@ti.com>
 <678cb62a-4fdf-3b57-2fe5-699c6bf02b2f@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <678cb62a-4fdf-3b57-2fe5-699c6bf02b2f@ti.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tomi,

Thanks for the review.

Tomi Valkeinen <tomi.valkeinen@ti.com> wrote on Wed [2020-Mar-04 10:49:55 +0200]:
> On 02/03/2020 15:56, Benoit Parrot wrote:
> > disable_irqs() was mistakenly disabling all interrupts when called.
> > This cause all port stream to stop even if only stopping one of them.
> > 
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > ---
> >   drivers/media/platform/ti-vpe/cal.c | 16 ++++++++--------
> >   1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> > index 6e009e479be3..6d4cbb8782ed 100644
> > --- a/drivers/media/platform/ti-vpe/cal.c
> > +++ b/drivers/media/platform/ti-vpe/cal.c
> > @@ -722,16 +722,16 @@ static void enable_irqs(struct cal_ctx *ctx)
> >   
> >   static void disable_irqs(struct cal_ctx *ctx)
> >   {
> > +	u32 val;
> > +
> >   	/* Disable IRQ_WDMA_END 0/1 */
> > -	reg_write_field(ctx->dev,
> > -			CAL_HL_IRQENABLE_CLR(2),
> > -			CAL_HL_IRQ_CLEAR,
> > -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> > +	val = 0;
> > +	set_field(&val, CAL_HL_IRQ_CLEAR, CAL_HL_IRQ_MASK(ctx->csi2_port));
> > +	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(2), val);
> >   	/* Disable IRQ_WDMA_START 0/1 */
> > -	reg_write_field(ctx->dev,
> > -			CAL_HL_IRQENABLE_CLR(3),
> > -			CAL_HL_IRQ_CLEAR,
> > -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> > +	val = 0;
> > +	set_field(&val, CAL_HL_IRQ_CLEAR, CAL_HL_IRQ_MASK(ctx->csi2_port));
> > +	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(3), val);
> >   	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
> >   	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0);
> >   }
> > 
> 
> I think the above works. But the enable_irqs is broken too, even if it doesn't cause any issues. Both IRQ_SET and IRQ_CLR are not supposed to be "modified" by a read-mod-write operation, but just written to.
>

Well maybe not consistent now, that disable_irqs has been modified but not
broken per se.

> The macros used also make the code very difficult to read. Something like this fixes both irq enable and disable, and makes it readable:

Ah but the mask macro are all consistent with each other, whether that
create one too many level of abstraction is a different subject. This setup
was oroginally requested by the maintainer. So I'll "fix" enable_irqs also
but I'll keep the macro as is.

Benoit

> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index c8b1290c9e2b..660653031a0b 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -707,15 +707,9 @@ static void cal_quickdump_regs(struct cal_dev *dev)
>  static void enable_irqs(struct cal_ctx *ctx)
>  {
>  	/* Enable IRQ_WDMA_END 0/1 */
> -	reg_write_field(ctx->dev,
> -			CAL_HL_IRQENABLE_SET(2),
> -			CAL_HL_IRQ_ENABLE,
> -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	reg_write(ctx->dev, CAL_HL_IRQENABLE_SET(2), 1 << (ctx->csi2_port - 1));
>  	/* Enable IRQ_WDMA_START 0/1 */
> -	reg_write_field(ctx->dev,
> -			CAL_HL_IRQENABLE_SET(3),
> -			CAL_HL_IRQ_ENABLE,
> -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	reg_write(ctx->dev, CAL_HL_IRQENABLE_SET(3), 1 << (ctx->csi2_port - 1));
>  	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
>  	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0xFF000000);
>  }
> @@ -723,15 +717,9 @@ static void enable_irqs(struct cal_ctx *ctx)
>  static void disable_irqs(struct cal_ctx *ctx)
>  {
>  	/* Disable IRQ_WDMA_END 0/1 */
> -	reg_write_field(ctx->dev,
> -			CAL_HL_IRQENABLE_CLR(2),
> -			CAL_HL_IRQ_CLEAR,
> -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(2), 1 << (ctx->csi2_port - 1));
>  	/* Disable IRQ_WDMA_START 0/1 */
> -	reg_write_field(ctx->dev,
> -			CAL_HL_IRQENABLE_CLR(3),
> -			CAL_HL_IRQ_CLEAR,
> -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(3), 1 << (ctx->csi2_port - 1));
>  	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
>  	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0);
>  }
> 
>  Tomi
> 
> -- 
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
