Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D829645E8B
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 17:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiLGQSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 11:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLGQR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 11:17:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8F22E9D7;
        Wed,  7 Dec 2022 08:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0565361AAD;
        Wed,  7 Dec 2022 16:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5121BC433C1;
        Wed,  7 Dec 2022 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670429877;
        bh=Gp9ocZH5kbHtJXuoAFUnVDuGcyqPBfPHfoB/M6dMUVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S//2AksFISIKCbuE+zXdABcst8Bhx831rQ0rC/Odx055LCpNU42hRIN6Vg4fYaHG5
         /9ljW/ptDcjmhHKGptSAVZn2vYpp6bSVVXB+BApWwSmlsD5p2Reoesnh9/HQ2umlv5
         XFsGz0W/W+hRKoxSuhCSs9r9OfgT9EZ6OVsA33IWY2PsnXU0rlJtRWaEyL+5WRfxYI
         suj62IFYjDFQfmgRfTXHfB6cNuiBzOsezw7b2/rv5e305tTygrLmXXjfOjBT/3Rwl4
         uHW9/jz7wOemCATTsZBiXsrMagZPsTx7m9ZQv3xtyuZtvND6qC2IFIeQfgnrdGOJI2
         6Dam9pgq0bl4A==
Date:   Wed, 7 Dec 2022 10:17:54 -0600
From:   Bjorn Andersson <andersson@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        bp@alien8.de, tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, stable@vger.kernel.org
Subject: Re: [PATCH 12/12] qcom: llcc/edac: Fix the base address used for
 accessing LLCC banks
Message-ID: <20221207161754.ipiordkogu2fk2dd@builder.lan>
References: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
 <20221207135922.314827-14-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207135922.314827-14-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 07:29:22PM +0530, Manivannan Sadhasivam wrote:
> The Qualcomm LLCC/EDAC drivers were using a fixed register stride for
> accessing the (Control and Status Registers) CSRs of each LLCC bank.
> This stride only works for some SoCs like SDM845 for which driver
> support was initially added.
> 
> But the later SoCs use different register stride that vary between the
> banks with holes in-between. So it is not possible to use a single register
> stride for accessing the CSRs of each bank. By doing so could result in a
> crash.
> 
> For fixing this issue, let's obtain the base address of each LLCC bank from
> devicetree and get rid of the fixed stride.
> 
> Cc: <stable@vger.kernel.org> # 4.20
> Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
> Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/edac/qcom_edac.c           | 14 +++----
>  drivers/soc/qcom/llcc-qcom.c       | 64 ++++++++++++++++++------------
>  include/linux/soc/qcom/llcc-qcom.h |  4 +-
>  3 files changed, 44 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
> index 97a27e42dd61..70bd39a91b89 100644
> --- a/drivers/edac/qcom_edac.c
> +++ b/drivers/edac/qcom_edac.c
> @@ -213,7 +213,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  
>  	for (i = 0; i < reg_data.reg_cnt; i++) {
>  		synd_reg = reg_data.synd_reg + (i * 4);
> -		ret = regmap_read(drv->regmap, drv->offsets[bank] + synd_reg,
> +		ret = regmap_read(drv->regmap[bank], synd_reg,
>  				  &synd_val);
>  		if (ret)
>  			goto clear;
> @@ -222,8 +222,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  			    reg_data.name, i, synd_val);
>  	}
>  
> -	ret = regmap_read(drv->regmap,
> -			  drv->offsets[bank] + reg_data.count_status_reg,
> +	ret = regmap_read(drv->regmap[bank], reg_data.count_status_reg,
>  			  &err_cnt);
>  	if (ret)
>  		goto clear;
> @@ -233,8 +232,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  	edac_printk(KERN_CRIT, EDAC_LLCC, "%s: Error count: 0x%4x\n",
>  		    reg_data.name, err_cnt);
>  
> -	ret = regmap_read(drv->regmap,
> -			  drv->offsets[bank] + reg_data.ways_status_reg,
> +	ret = regmap_read(drv->regmap[bank], reg_data.ways_status_reg,
>  			  &err_ways);
>  	if (ret)
>  		goto clear;
> @@ -296,8 +294,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>  
>  	/* Iterate over the banks and look for Tag RAM or Data RAM errors */
>  	for (i = 0; i < drv->num_banks; i++) {
> -		ret = regmap_read(drv->regmap,
> -				  drv->offsets[i] + DRP_INTERRUPT_STATUS,
> +		ret = regmap_read(drv->regmap[i], DRP_INTERRUPT_STATUS,
>  				  &drp_error);
>  
>  		if (!ret && (drp_error & SB_ECC_ERROR)) {
> @@ -312,8 +309,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>  		if (!ret)
>  			irq_rc = IRQ_HANDLED;
>  
> -		ret = regmap_read(drv->regmap,
> -				  drv->offsets[i] + TRP_INTERRUPT_0_STATUS,
> +		ret = regmap_read(drv->regmap[i], TRP_INTERRUPT_0_STATUS,
>  				  &trp_error);
>  
>  		if (!ret && (trp_error & SB_ECC_ERROR)) {
> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> index 23ce2f78c4ed..7264ac9993e0 100644
> --- a/drivers/soc/qcom/llcc-qcom.c
> +++ b/drivers/soc/qcom/llcc-qcom.c
> @@ -62,8 +62,6 @@
>  #define LLCC_TRP_WRSC_CACHEABLE_EN    0x21f2c
>  #define LLCC_TRP_ALGO_CFG8	      0x21f30
>  
> -#define BANK_OFFSET_STRIDE	      0x80000
> -
>  #define LLCC_VERSION_2_0_0_0          0x02000000
>  #define LLCC_VERSION_2_1_0_0          0x02010000
>  #define LLCC_VERSION_4_1_0_0          0x04010000
> @@ -927,6 +925,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  	const struct llcc_slice_config *llcc_cfg;
>  	u32 sz;
>  	u32 version;
> +	struct regmap *regmap;
>  
>  	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
>  	if (!drv_data) {
> @@ -934,12 +933,46 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	drv_data->regmap = qcom_llcc_init_mmio(pdev, "llcc_base");
> -	if (IS_ERR(drv_data->regmap)) {
> -		ret = PTR_ERR(drv_data->regmap);
> +	/* Initialize the first LLCC bank regmap */
> +	regmap = qcom_llcc_init_mmio(pdev, "llcc0_base");
> +	if (IS_ERR(regmap)) {
> +		ret = PTR_ERR(regmap);
> +		goto err;
> +	}
> +
> +	cfg = of_device_get_match_data(&pdev->dev);
> +
> +	ret = regmap_read(regmap, cfg->reg_offset[LLCC_COMMON_STATUS0],
> +			  &num_banks);

Don't be afraid of leaving this line unwrapped.

There's a few lines changed above that would be easier to read if
allowed beyond 80 chars as well.

> +	if (ret)
> +		goto err;
> +
> +	num_banks &= LLCC_LB_CNT_MASK;
> +	num_banks >>= LLCC_LB_CNT_SHIFT;
> +	drv_data->num_banks = num_banks;
> +
> +	drv_data->regmap = devm_kcalloc(dev, num_banks, sizeof(*drv_data->regmap), GFP_KERNEL);
> +	if (!drv_data->regmap) {
> +		ret = -ENOMEM;
>  		goto err;
>  	}
>  
> +	drv_data->regmap[0] = regmap;
> +
> +	/* Initialize rest of LLCC bank regmaps */
> +	for (i = 1; i < num_banks; i++) {
> +		char *base = kasprintf(GFP_KERNEL, "llcc%d_base", i);

As mentioned in the binding, I think you should obtain the regions by
index instead of name.

> +
> +		drv_data->regmap[i] = qcom_llcc_init_mmio(pdev, base);
> +		if (IS_ERR(drv_data->regmap[i])) {
> +			ret = PTR_ERR(drv_data->regmap[i]);
> +			kfree(base);
> +			goto err;
> +		}
> +
> +		kfree(base);
> +	}
> +
>  	drv_data->bcast_regmap =
>  		qcom_llcc_init_mmio(pdev, "llcc_broadcast_base");
>  	if (IS_ERR(drv_data->bcast_regmap)) {
> @@ -947,8 +980,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	cfg = of_device_get_match_data(&pdev->dev);
> -
>  	/* Extract version of the IP */
>  	ret = regmap_read(drv_data->bcast_regmap, cfg->reg_offset[LLCC_COMMON_HW_INFO],
>  			  &version);
> @@ -957,15 +988,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  
>  	drv_data->version = version;
>  
> -	ret = regmap_read(drv_data->regmap, cfg->reg_offset[LLCC_COMMON_STATUS0],
> -			  &num_banks);
> -	if (ret)
> -		goto err;
> -
> -	num_banks &= LLCC_LB_CNT_MASK;
> -	num_banks >>= LLCC_LB_CNT_SHIFT;
> -	drv_data->num_banks = num_banks;
> -
>  	llcc_cfg = cfg->sct_data;
>  	sz = cfg->size;
>  
> @@ -973,16 +995,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  		if (llcc_cfg[i].slice_id > drv_data->max_slices)
>  			drv_data->max_slices = llcc_cfg[i].slice_id;
>  
> -	drv_data->offsets = devm_kcalloc(dev, num_banks, sizeof(u32),
> -							GFP_KERNEL);
> -	if (!drv_data->offsets) {
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> -
> -	for (i = 0; i < num_banks; i++)
> -		drv_data->offsets[i] = i * BANK_OFFSET_STRIDE;
> -
>  	drv_data->bitmap = devm_bitmap_zalloc(dev, drv_data->max_slices,
>  					      GFP_KERNEL);
>  	if (!drv_data->bitmap) {
> diff --git a/include/linux/soc/qcom/llcc-qcom.h b/include/linux/soc/qcom/llcc-qcom.h
> index ad1fd718169d..4b8bf585f9ba 100644
> --- a/include/linux/soc/qcom/llcc-qcom.h
> +++ b/include/linux/soc/qcom/llcc-qcom.h
> @@ -129,12 +129,11 @@ struct llcc_edac_reg_offset {

Please also update @regmap description.

>   * @max_slices: max slices as read from device tree
>   * @num_banks: Number of llcc banks
>   * @bitmap: Bit map to track the active slice ids
> - * @offsets: Pointer to the bank offsets array
>   * @ecc_irq: interrupt for llcc cache error detection and reporting
>   * @version: Indicates the LLCC version
>   */
>  struct llcc_drv_data {
> -	struct regmap *regmap;
> +	struct regmap **regmap;

How about making this plural, to reflect that it's now a set of regmaps?

Regards,
Bjorn

>  	struct regmap *bcast_regmap;
>  	const struct llcc_slice_config *cfg;
>  	const struct llcc_edac_reg_offset *edac_reg_offset;
> @@ -143,7 +142,6 @@ struct llcc_drv_data {
>  	u32 max_slices;
>  	u32 num_banks;
>  	unsigned long *bitmap;
> -	u32 *offsets;
>  	int ecc_irq;
>  	u32 version;
>  };
> -- 
> 2.25.1
> 
