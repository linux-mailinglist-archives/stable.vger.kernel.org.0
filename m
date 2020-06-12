Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288AA1F747E
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 09:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgFLHRE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 12 Jun 2020 03:17:04 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:52913 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgFLHRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 03:17:03 -0400
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 1D41D2000D;
        Fri, 12 Jun 2020 07:16:59 +0000 (UTC)
Date:   Fri, 12 Jun 2020 09:16:58 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sivaprakash Murugesan <sivaprak@codeaurora.org>
Cc:     richard@nod.at, vigneshr@ti.com, peter.ujfalusi@ti.com,
        boris.brezillon@collabora.com, architt@codeaurora.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V3 1/2] mtd: rawnand: qcom: avoid write to unavailable
 register
Message-ID: <20200612091658.4f9fba49@xps13>
In-Reply-To: <1591944589-14357-2-git-send-email-sivaprak@codeaurora.org>
References: <1591944589-14357-1-git-send-email-sivaprak@codeaurora.org>
        <1591944589-14357-2-git-send-email-sivaprak@codeaurora.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sivaprakash,

Sivaprakash Murugesan <sivaprak@codeaurora.org> wrote on Fri, 12 Jun
2020 12:19:48 +0530:

> SFLASHC_BURST_CFG is only available on older ipq nand platforms, this
> register has been removed when the NAND controller is moved as part of qpic
> controller.
> 
> avoid register writes to this register on devices which are based on qpic

Avoid writing this register on ...

> NAND controllers.
> 
> Fixes: a0637834 (mtd: nand: qcom: support for IPQ4019 QPIC NANDcontroller)
> Fixes: dce84760 (mtd: nand: qcom: Support for IPQ8074 QPIC NAND controller)

I don't think having two Fixes tag is allowed. Take the older one
instead.

> Cc: stable@vger.kernel.org
> Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
> ---
> [V3]
>  * Addressed Miquel comments, added flag based on nand controller hw
>    to avoid the register writes to specific ipq platforms
>  drivers/mtd/nand/raw/qcom_nandc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
> index f1daf33..e0c55bb 100644
> --- a/drivers/mtd/nand/raw/qcom_nandc.c
> +++ b/drivers/mtd/nand/raw/qcom_nandc.c
> @@ -459,11 +459,13 @@ struct qcom_nand_host {
>   * among different NAND controllers.
>   * @ecc_modes - ecc mode for NAND
>   * @is_bam - whether NAND controller is using BAM
> + * @is_qpic - whether NAND CTRL is part of qpic IP
>   * @dev_cmd_reg_start - NAND_DEV_CMD_* registers starting offset
>   */
>  struct qcom_nandc_props {
>  	u32 ecc_modes;
>  	bool is_bam;
> +	bool is_qpic;
>  	u32 dev_cmd_reg_start;
>  };
>  
> @@ -2774,7 +2776,8 @@ static int qcom_nandc_setup(struct qcom_nand_controller *nandc)
>  	u32 nand_ctrl;
>  
>  	/* kill onenand */
> -	nandc_write(nandc, SFLASHC_BURST_CFG, 0);
> +	if (!nandc->props->is_qpic)
> +		nandc_write(nandc, SFLASHC_BURST_CFG, 0);
>  	nandc_write(nandc, dev_cmd_reg_addr(nandc, NAND_DEV_CMD_VLD),
>  		    NAND_DEV_CMD_VLD_VAL);
>  
> @@ -3029,18 +3032,21 @@ static int qcom_nandc_remove(struct platform_device *pdev)
>  static const struct qcom_nandc_props ipq806x_nandc_props = {
>  	.ecc_modes = (ECC_RS_4BIT | ECC_BCH_8BIT),
>  	.is_bam = false,
> +	.is_qpic = false,

This line is unneeded.

>  	.dev_cmd_reg_start = 0x0,
>  };
>  
>  static const struct qcom_nandc_props ipq4019_nandc_props = {
>  	.ecc_modes = (ECC_BCH_4BIT | ECC_BCH_8BIT),
>  	.is_bam = true,
> +	.is_qpic = true,
>  	.dev_cmd_reg_start = 0x0,
>  };
>  
>  static const struct qcom_nandc_props ipq8074_nandc_props = {
>  	.ecc_modes = (ECC_BCH_4BIT | ECC_BCH_8BIT),
>  	.is_bam = true,
> +	.is_qpic = true,
>  	.dev_cmd_reg_start = 0x7000,
>  };
>  

Much better patch IMHO, just a few nits and we'll be good.

Thanks,
Miquèl
