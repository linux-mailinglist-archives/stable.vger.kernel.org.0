Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF2B178CC8
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgCDIt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:49:59 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46652 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDIt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 03:49:59 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0248nw7H078347;
        Wed, 4 Mar 2020 02:49:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583311798;
        bh=0JcGB+sYExQaFDZtjuC7bhrD3uXfF+I4qmWNu5FYtd4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=WCIUYoHdET3ZvnYO4hTmE0npbgepCGNOICZagrx+WL27oSvGeuT2yfSFeXC6XXcdZ
         PLfqJJ8+FHRiSz4ZVxRFHh6e0dzDWCHwpjKL7Ivk1OIMfD9CFD6aFcFloA7edUUIgn
         E3czcYeAvtI6XwEOTOq3MJfCSVR1MlY4VEzbcrIY=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0248nwtX093196
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Mar 2020 02:49:58 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Mar
 2020 02:49:57 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Mar 2020 02:49:57 -0600
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0248nu2i052181;
        Wed, 4 Mar 2020 02:49:56 -0600
Subject: Re: [Patch 1/1] media: ti-vpe: cal: fix disable_irqs to only the
 intended target
To:     Benoit Parrot <bparrot@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200302135652.9365-1-bparrot@ti.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <678cb62a-4fdf-3b57-2fe5-699c6bf02b2f@ti.com>
Date:   Wed, 4 Mar 2020 10:49:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302135652.9365-1-bparrot@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/03/2020 15:56, Benoit Parrot wrote:
> disable_irqs() was mistakenly disabling all interrupts when called.
> This cause all port stream to stop even if only stopping one of them.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
>   drivers/media/platform/ti-vpe/cal.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index 6e009e479be3..6d4cbb8782ed 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -722,16 +722,16 @@ static void enable_irqs(struct cal_ctx *ctx)
>   
>   static void disable_irqs(struct cal_ctx *ctx)
>   {
> +	u32 val;
> +
>   	/* Disable IRQ_WDMA_END 0/1 */
> -	reg_write_field(ctx->dev,
> -			CAL_HL_IRQENABLE_CLR(2),
> -			CAL_HL_IRQ_CLEAR,
> -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	val = 0;
> +	set_field(&val, CAL_HL_IRQ_CLEAR, CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(2), val);
>   	/* Disable IRQ_WDMA_START 0/1 */
> -	reg_write_field(ctx->dev,
> -			CAL_HL_IRQENABLE_CLR(3),
> -			CAL_HL_IRQ_CLEAR,
> -			CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	val = 0;
> +	set_field(&val, CAL_HL_IRQ_CLEAR, CAL_HL_IRQ_MASK(ctx->csi2_port));
> +	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(3), val);
>   	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
>   	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0);
>   }
> 

I think the above works. But the enable_irqs is broken too, even if it doesn't cause any issues. Both IRQ_SET and IRQ_CLR are not supposed to be "modified" by a read-mod-write operation, but just written to.

The macros used also make the code very difficult to read. Something like this fixes both irq enable and disable, and makes it readable:

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index c8b1290c9e2b..660653031a0b 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -707,15 +707,9 @@ static void cal_quickdump_regs(struct cal_dev *dev)
 static void enable_irqs(struct cal_ctx *ctx)
 {
 	/* Enable IRQ_WDMA_END 0/1 */
-	reg_write_field(ctx->dev,
-			CAL_HL_IRQENABLE_SET(2),
-			CAL_HL_IRQ_ENABLE,
-			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	reg_write(ctx->dev, CAL_HL_IRQENABLE_SET(2), 1 << (ctx->csi2_port - 1));
 	/* Enable IRQ_WDMA_START 0/1 */
-	reg_write_field(ctx->dev,
-			CAL_HL_IRQENABLE_SET(3),
-			CAL_HL_IRQ_ENABLE,
-			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	reg_write(ctx->dev, CAL_HL_IRQENABLE_SET(3), 1 << (ctx->csi2_port - 1));
 	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
 	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0xFF000000);
 }
@@ -723,15 +717,9 @@ static void enable_irqs(struct cal_ctx *ctx)
 static void disable_irqs(struct cal_ctx *ctx)
 {
 	/* Disable IRQ_WDMA_END 0/1 */
-	reg_write_field(ctx->dev,
-			CAL_HL_IRQENABLE_CLR(2),
-			CAL_HL_IRQ_CLEAR,
-			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(2), 1 << (ctx->csi2_port - 1));
 	/* Disable IRQ_WDMA_START 0/1 */
-	reg_write_field(ctx->dev,
-			CAL_HL_IRQENABLE_CLR(3),
-			CAL_HL_IRQ_CLEAR,
-			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(3), 1 << (ctx->csi2_port - 1));
 	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
 	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0);
 }

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
