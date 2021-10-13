Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1754D42B984
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 09:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhJMHvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 03:51:36 -0400
Received: from twhmllg3.macronix.com ([122.147.135.201]:59872 "EHLO
        TWHMLLG3.macronix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238649AbhJMHvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 03:51:35 -0400
X-Greylist: delayed 1725 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2021 03:51:34 EDT
Received: from TWHMLLG3.macronix.com (localhost [127.0.0.2] (may be forged))
        by TWHMLLG3.macronix.com with ESMTP id 19D758O6002107;
        Wed, 13 Oct 2021 15:05:08 +0800 (GMT-8)
        (envelope-from zhengxunli@mxic.com.tw)
Received: from twhfmlp1.macronix.com (twhfmlp1.macronix.com [172.17.20.91])
        by TWHMLLG3.macronix.com with ESMTP id 19D74Egk001058;
        Wed, 13 Oct 2021 15:04:14 +0800 (GMT-8)
        (envelope-from zhengxunli@mxic.com.tw)
Received: from MXML06C.mxic.com.tw (mxml06c.macronix.com [172.17.14.55])
        by Forcepoint Email with ESMTP id 4A9624BE66CA0D66112B;
        Wed, 13 Oct 2021 15:04:15 +0800 (CST)
In-Reply-To: <OF11A0CCB6.4C81ABAD-ON4825876D.00256D6A-4825876D.00256F7A@LocalDomain>
References: <20211008162228.1753083-1-miquel.raynal@bootlin.com> <20211008162228.1753083-9-miquel.raynal@bootlin.com> <OF11A0CCB6.4C81ABAD-ON4825876D.00256D6A-4825876D.00256F7A@LocalDomain>
To:     "Miquel Raynal" <miquel.raynal@bootlin.com>
Cc:     "Rob Herring" <robh+dt@kernel.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Xiangsheng Hou" <Xiangsheng.Hou@mediatek.com>,
        "Boris Brezillon" <bbrezillon@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        jaimeliao@mxic.com.tw, juliensu@mxic.com.tw,
        "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org, "Mason Yang" <masonccyang@mxic.com.tw>,
        "Richard Weinberger" <richard@nod.at>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        "Tudor Ambarus" <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>, linux-spi@vger.kernel.org
Subject: =?Big5?B?UmU6IKZeq0g6IFtSRkMgUEFUQ0ggMDgvMTBdIHNwaTogbXhpYzogRml4IHRoZQ==?=
 =?Big5?B?IHRyYW5zbWl0IHBhdGg=?=
MIME-Version: 1.0
X-KeepSent: 7B755571:931AC374-4825876D:0025ED60;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3FP6 SHF907 April 26, 2018
Message-ID: <OF7B755571.931AC374-ON4825876D.0025ED60-4825876D.0026D775@mxic.com.tw>
From:   zhengxunli@mxic.com.tw
Date:   Wed, 13 Oct 2021 15:04:15 +0800
X-MIMETrack: Serialize by Router on MXML06C/TAIWAN/MXIC(Release 9.0.1FP10 HF265|July 25, 2018) at
 2021/10/13 PM 03:04:15,
        Serialize complete at 2021/10/13 PM 03:04:15
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: TWHMLLG3.macronix.com 19D74Egk001058
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> By working with external hardware ECC engines, we figured out that
> Under certain circumstances, it is needed for the SPI controller to
> check INT_TX_EMPTY and INT_RX_NOT_EMPTY in both receive and transmit
> path (not only in the receive path). The delay penalty being
> negligible, move this code in the common path.
> 
> Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
> Cc: stable@vger.kernel.org
> Suggested-by: Mason Yang <masonccyang@mxic.com.tw>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/spi/spi-mxic.c | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
> index 96b418293bf2..4fb19e6f94b0 100644
> --- a/drivers/spi/spi-mxic.c
> +++ b/drivers/spi/spi-mxic.c
> @@ -304,25 +304,21 @@ static int mxic_spi_data_xfer(struct mxic_spi 
> *mxic, const void *txbuf,
> 
>        writel(data, mxic->regs + TXD(nbytes % 4));
> 
> +      ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
> +                sts & INT_TX_EMPTY, 0, USEC_PER_SEC);
> +      if (ret)
> +         return ret;
> +
> +      ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
> +                sts & INT_RX_NOT_EMPTY, 0,
> +                USEC_PER_SEC);
> +      if (ret)
> +         return ret;
> +
> +      data = readl(mxic->regs + RXD);
>        if (rxbuf) {
> -         ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
> -                   sts & INT_TX_EMPTY, 0,
> -                   USEC_PER_SEC);
> -         if (ret)
> -            return ret;
> -
> -         ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
> -                   sts & INT_RX_NOT_EMPTY, 0,
> -                   USEC_PER_SEC);
> -         if (ret)
> -            return ret;
> -
> -         data = readl(mxic->regs + RXD);
>           data >>= (8 * (4 - nbytes));
>           memcpy(rxbuf + pos, &data, nbytes);
> -         WARN_ON(readl(mxic->regs + INT_STS) & INT_RX_NOT_EMPTY);
> -      } else {
> -         readl(mxic->regs + RXD);
>        }
>        WARN_ON(readl(mxic->regs + INT_STS) & INT_RX_NOT_EMPTY);
> 
> -- 
> 2.27.0
> 

Reviewed-by: Zhengxun Li <zhengxunli@mxic.com.tw>


CONFIDENTIALITY NOTE:

This e-mail and any attachments may contain confidential information 
and/or personal data, which is protected by applicable laws. Please be 
reminded that duplication, disclosure, distribution, or use of this e-mail 
(and/or its attachments) or any part thereof is prohibited. If you receive 
this e-mail in error, please notify us immediately and delete this mail as 
well as its attachment(s) from your system. In addition, please be 
informed that collection, processing, and/or use of personal data is 
prohibited unless expressly permitted by personal data protection laws. 
Thank you for your attention and cooperation.

Macronix International Co., Ltd.

=====================================================================



============================================================================

CONFIDENTIALITY NOTE:

This e-mail and any attachments may contain confidential information and/or personal data, which is protected by applicable laws. Please be reminded that duplication, disclosure, distribution, or use of this e-mail (and/or its attachments) or any part thereof is prohibited. If you receive this e-mail in error, please notify us immediately and delete this mail as well as its attachment(s) from your system. In addition, please be informed that collection, processing, and/or use of personal data is prohibited unless expressly permitted by personal data protection laws. Thank you for your attention and cooperation.

Macronix International Co., Ltd.

=====================================================================

