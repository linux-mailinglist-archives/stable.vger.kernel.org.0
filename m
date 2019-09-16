Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742E6B370C
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 11:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfIPJYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 05:24:32 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17118 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbfIPJYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 05:24:31 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d7f54cf0000>; Mon, 16 Sep 2019 02:24:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Sep 2019 02:24:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Sep 2019 02:24:30 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 09:24:29 +0000
Received: from [10.21.132.148] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 09:24:28 +0000
Subject: Re: [PATCH v3] dmaengine: tegra210-adma: fix transfer failure
To:     Sameer Pujar <spujar@nvidia.com>, <vkoul@kernel.org>,
        <ldewangan@nvidia.com>
CC:     <thierry.reding@gmail.com>, <dmaengine@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
References: <1568623038-20879-1-git-send-email-spujar@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <05b78209-5e9a-410a-9307-21dc1410180a@nvidia.com>
Date:   Mon, 16 Sep 2019 10:24:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568623038-20879-1-git-send-email-spujar@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568625872; bh=vnWvDTplzC3IcJzYIzYsVeQ79L05HIe7eC0KLtTtCes=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZUFLBENSwieSu+IZOe2QCAuayxFXVP5TfsTsAlcNluduJE9QYHpdjFVyh/2XUThEr
         iEGRoJjFK0q+7TpJ/v1wf1+8xVBwAjCWFoquUPzbAjPY5D0sfCjc5yYe5NKUXslvxI
         0th+iG8Yn8v4JlAF603Qr/h8a2e5Juq14fCnnIStrjHTUfubwDgeQb0FnC31RoKeaf
         fy/n+k8q/PkQmJaqvWGxD87hu5ZitEUE8TCG9OZyF8OvAc8GgdOevNa3ihYtzQg7n6
         XSev/AI86EoB/y/oyWUvqjufBQgohmGS2zmyRR1/YuxAtLTafdFGpWxOO2+UFJiFSL
         uFwHdX/RbKabA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/09/2019 09:37, Sameer Pujar wrote:
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
>  drivers/dma/tegra210-adma.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
> index 5f8adf5..e19732f 100644
> --- a/drivers/dma/tegra210-adma.c
> +++ b/drivers/dma/tegra210-adma.c
> @@ -66,6 +66,8 @@
>  #define TEGRA186_FIFO_CTRL_DEFAULT (TEGRA186_ADMA_CH_FIFO_CTRL_TXSIZE(3) | \
>  				    TEGRA186_ADMA_CH_FIFO_CTRL_RXSIZE(3))
>  
> +#define TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(reqs)	(reqs << 4)
> +

Shouldn't we place this under the defines for ADMA_CH_CONFIG register?
This would be consistent with how we organise the definitions today.

>  #define ADMA_CH_REG_FIELD_VAL(val, mask, shift)	(((val) & mask) << shift)
>  
>  struct tegra_adma;
> @@ -77,6 +79,7 @@ struct tegra_adma;
>   * @ch_req_tx_shift: Register offset for AHUB transmit channel select.
>   * @ch_req_rx_shift: Register offset for AHUB receive channel select.
>   * @ch_base_offset: Register offset of DMA channel registers.
> + * @has_outstanding_reqs: If DMA channel can have outstanding requests.
>   * @ch_fifo_ctrl: Default value for channel FIFO CTRL register.
>   * @ch_req_mask: Mask for Tx or Rx channel select.
>   * @ch_req_max: Maximum number of Tx or Rx channels available.
> @@ -95,6 +98,7 @@ struct tegra_adma_chip_data {
>  	unsigned int ch_req_max;
>  	unsigned int ch_reg_size;
>  	unsigned int nr_channels;
> +	bool has_outstanding_reqs;
>  };
>  
>  /*
> @@ -594,6 +598,8 @@ static int tegra_adma_set_xfer_params(struct tegra_adma_chan *tdc,
>  			 ADMA_CH_CTRL_FLOWCTRL_EN;
>  	ch_regs->config |= cdata->adma_get_burst_config(burst_size);
>  	ch_regs->config |= ADMA_CH_CONFIG_WEIGHT_FOR_WRR(1);
> +	if (cdata->has_outstanding_reqs)
> +		ch_regs->config |= TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(8);
>  	ch_regs->fifo_ctrl = cdata->ch_fifo_ctrl;
>  	ch_regs->tc = desc->period_len & ADMA_CH_TC_COUNT_MASK;
>  
> @@ -778,6 +784,7 @@ static const struct tegra_adma_chip_data tegra210_chip_data = {
>  	.ch_req_tx_shift	= 28,
>  	.ch_req_rx_shift	= 24,
>  	.ch_base_offset		= 0,
> +	.has_outstanding_reqs	= false,
>  	.ch_fifo_ctrl		= TEGRA210_FIFO_CTRL_DEFAULT,
>  	.ch_req_mask		= 0xf,
>  	.ch_req_max		= 10,
> @@ -792,6 +799,7 @@ static const struct tegra_adma_chip_data tegra186_chip_data = {
>  	.ch_req_tx_shift	= 27,
>  	.ch_req_rx_shift	= 22,
>  	.ch_base_offset		= 0x10000,
> +	.has_outstanding_reqs	= true,
>  	.ch_fifo_ctrl		= TEGRA186_FIFO_CTRL_DEFAULT,
>  	.ch_req_mask		= 0x1f,
>  	.ch_req_max		= 20,
> 

Otherwise ...

Acked-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
