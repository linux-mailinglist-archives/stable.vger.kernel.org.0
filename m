Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCBCB382E
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfIPKfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:35:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18437 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfIPKfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 06:35:23 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d7f656f0000>; Mon, 16 Sep 2019 03:35:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 16 Sep 2019 03:35:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 16 Sep 2019 03:35:22 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 10:35:21 +0000
Received: from [10.21.132.148] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 10:35:19 +0000
Subject: Re: [PATCH v4] dmaengine: tegra210-adma: fix transfer failure
To:     Sameer Pujar <spujar@nvidia.com>, <vkoul@kernel.org>,
        <ldewangan@nvidia.com>
CC:     <thierry.reding@gmail.com>, <dmaengine@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
References: <1568626513-16541-1-git-send-email-spujar@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <13f32a5b-7c90-4909-bb23-fe95c572857c@nvidia.com>
Date:   Mon, 16 Sep 2019 11:35:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568626513-16541-1-git-send-email-spujar@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568630127; bh=S6NL50hAM1XR14TGnyKj929JaX+MCLO9cOEicP+6BQY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=rV7iLfdPkuQNJH6FByxfyE2O0irJTdfWvXHzlrt9mpW2upXW6Ep/Y6p9Shzg8eMK6
         rddtXEu/dFlm+hoDbVQI0QUJFL5qRxL5DfC2Us/x20v6l9/+BD7iWl7risPHxrwVpH
         qE3IhziqMDON4cjIA9Wo54qGT4AwuB7r2m6hZn3EUyXP5LgJvg8xzOurR7hp7A8u0M
         bQHqlHELFlBGI22VqcyY7RmhoxuifXHLeG2HWm7oNcjzc44QoiePbYi9HIni4za94i
         fqlzKIFCTGasUIvoOx8XD5nearEfsp0n9FmOT/S/jjyFltLVwfDwUMfXiHjbO29Mkr
         UZnMS50ot8NCA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/09/2019 10:35, Sameer Pujar wrote:
> From Tegra186 onwards OUTSTANDING_REQUESTS field is added in channel
> configuration register(bits 7:4) which defines the maximum number of reads
> from the source and writes to the destination that may be outstanding at
> any given point of time. This field must be programmed with a value
> between 1 and 8. A value of 0 will prevent any transfers from happening.
> 
> Thus added 'has_outstanding_reqs' bool member in chip data structure and is
> set to false for Tegra210, since the field is not applicable. For Tegra186
> it is set to true and channel configuration is updated with maximum
> outstanding requests.
> 
> Fixes: 433de642a76c ("dmaengine: tegra210-adma: add support for Tegra186/Tegra194")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Sameer Pujar <spujar@nvidia.com>
> ---
>  drivers/dma/tegra210-adma.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
> index 5f8adf5..6e12685 100644
> --- a/drivers/dma/tegra210-adma.c
> +++ b/drivers/dma/tegra210-adma.c
> @@ -40,6 +40,7 @@
>  #define ADMA_CH_CONFIG_MAX_BURST_SIZE                   16
>  #define ADMA_CH_CONFIG_WEIGHT_FOR_WRR(val)		((val) & 0xf)
>  #define ADMA_CH_CONFIG_MAX_BUFS				8
> +#define TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(reqs)	(reqs << 4)
>  
>  #define ADMA_CH_FIFO_CTRL				0x2c
>  #define TEGRA210_ADMA_CH_FIFO_CTRL_TXSIZE(val)		(((val) & 0xf) << 8)
> @@ -77,6 +78,7 @@ struct tegra_adma;
>   * @ch_req_tx_shift: Register offset for AHUB transmit channel select.
>   * @ch_req_rx_shift: Register offset for AHUB receive channel select.
>   * @ch_base_offset: Register offset of DMA channel registers.
> + * @has_outstanding_reqs: If DMA channel can have outstanding requests.
>   * @ch_fifo_ctrl: Default value for channel FIFO CTRL register.
>   * @ch_req_mask: Mask for Tx or Rx channel select.
>   * @ch_req_max: Maximum number of Tx or Rx channels available.
> @@ -95,6 +97,7 @@ struct tegra_adma_chip_data {
>  	unsigned int ch_req_max;
>  	unsigned int ch_reg_size;
>  	unsigned int nr_channels;
> +	bool has_outstanding_reqs;
>  };
>  
>  /*
> @@ -594,6 +597,8 @@ static int tegra_adma_set_xfer_params(struct tegra_adma_chan *tdc,
>  			 ADMA_CH_CTRL_FLOWCTRL_EN;
>  	ch_regs->config |= cdata->adma_get_burst_config(burst_size);
>  	ch_regs->config |= ADMA_CH_CONFIG_WEIGHT_FOR_WRR(1);
> +	if (cdata->has_outstanding_reqs)
> +		ch_regs->config |= TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(8);
>  	ch_regs->fifo_ctrl = cdata->ch_fifo_ctrl;
>  	ch_regs->tc = desc->period_len & ADMA_CH_TC_COUNT_MASK;
>  
> @@ -778,6 +783,7 @@ static const struct tegra_adma_chip_data tegra210_chip_data = {
>  	.ch_req_tx_shift	= 28,
>  	.ch_req_rx_shift	= 24,
>  	.ch_base_offset		= 0,
> +	.has_outstanding_reqs	= false,
>  	.ch_fifo_ctrl		= TEGRA210_FIFO_CTRL_DEFAULT,
>  	.ch_req_mask		= 0xf,
>  	.ch_req_max		= 10,
> @@ -792,6 +798,7 @@ static const struct tegra_adma_chip_data tegra186_chip_data = {
>  	.ch_req_tx_shift	= 27,
>  	.ch_req_rx_shift	= 22,
>  	.ch_base_offset		= 0x10000,
> +	.has_outstanding_reqs	= true,
>  	.ch_fifo_ctrl		= TEGRA186_FIFO_CTRL_DEFAULT,
>  	.ch_req_mask		= 0x1f,
>  	.ch_req_max		= 20,
> 

Acked-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon
-- 
nvpublic
