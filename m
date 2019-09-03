Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E557A71FC
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 19:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfICRxc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Sep 2019 13:53:32 -0400
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:60516 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbfICRxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 13:53:32 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id 445299E774F;
        Tue,  3 Sep 2019 18:53:30 +0100 (BST)
Date:   Tue, 3 Sep 2019 18:53:28 +0100
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Bakker <xc-racer2@live.ca>,
        =?UTF-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 066/167] iio: adc: exynos-adc: Add S5PV210
 variant
Message-ID: <20190903185328.74299c4d@archlinux>
In-Reply-To: <20190903162519.7136-66-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
        <20190903162519.7136-66-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  3 Sep 2019 12:23:38 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Jonathan Bakker <xc-racer2@live.ca>
> 
> [ Upstream commit 882bf52fdeab47dbe991cc0e564b0b51c571d0a3 ]
> 
> S5PV210's ADC variant is almost the same as v1 except that it has 10
> channels and doesn't require the pmu register
> 
> Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I have no particular objection to adding new IDs (which is more
or less what this patch is), but I didn't know autosel was
picking them up.  So a bit of surprise... If intentional
then fine to apply to stable.

> ---
>  drivers/iio/adc/exynos_adc.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index 4be29ed447559..41da522fc6735 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -115,6 +115,7 @@
>  #define MAX_ADC_V2_CHANNELS		10
>  #define MAX_ADC_V1_CHANNELS		8
>  #define MAX_EXYNOS3250_ADC_CHANNELS	2
> +#define MAX_S5PV210_ADC_CHANNELS	10
>  
>  /* Bit definitions common for ADC_V1 and ADC_V2 */
>  #define ADC_CON_EN_START	(1u << 0)
> @@ -282,6 +283,16 @@ static const struct exynos_adc_data exynos_adc_v1_data = {
>  	.start_conv	= exynos_adc_v1_start_conv,
>  };
>  
> +static const struct exynos_adc_data exynos_adc_s5pv210_data = {
> +	.num_channels	= MAX_S5PV210_ADC_CHANNELS,
> +	.mask		= ADC_DATX_MASK,	/* 12 bit ADC resolution */
> +
> +	.init_hw	= exynos_adc_v1_init_hw,
> +	.exit_hw	= exynos_adc_v1_exit_hw,
> +	.clear_irq	= exynos_adc_v1_clear_irq,
> +	.start_conv	= exynos_adc_v1_start_conv,
> +};
> +
>  static void exynos_adc_s3c2416_start_conv(struct exynos_adc *info,
>  					  unsigned long addr)
>  {
> @@ -478,6 +489,9 @@ static const struct of_device_id exynos_adc_match[] = {
>  	}, {
>  		.compatible = "samsung,s3c6410-adc",
>  		.data = &exynos_adc_s3c64xx_data,
> +	}, {
> +		.compatible = "samsung,s5pv210-adc",
> +		.data = &exynos_adc_s5pv210_data,
>  	}, {
>  		.compatible = "samsung,exynos-adc-v1",
>  		.data = &exynos_adc_v1_data,

