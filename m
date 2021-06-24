Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CF13B308D
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 15:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhFXN4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 09:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFXN4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 09:56:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5400E613ED;
        Thu, 24 Jun 2021 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624542851;
        bh=t3/lMbrZi8JwpFf/iREZw2AVExACR+FpzzvHglGYIT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hc6PE9s33prcn1skxwTm/GXPPV91JhEo1cwgo/N6xsI0ujWg7Fu9R44yWWoOAEEsH
         Zz/eVLJB7LdSxCYIRtgnTdIjV7PEjmSDgs7VOB3Kj7N0K27Jg1HYaVeWA9uFM+LUMv
         yT+3wEZLV9zi0MeVz+I/6LFF0fTIkPkvcHQ4FQ2Y=
Date:   Thu, 24 Jun 2021 15:54:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 7/8] bus: mhi: pci_generic: Apply no-op for wake using
 sideband wake boolean
Message-ID: <YNSOgSQ/K3Aavyjx@kroah.com>
References: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
 <20210621161616.77524-8-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621161616.77524-8-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 09:46:15PM +0530, Manivannan Sadhasivam wrote:
> From: Bhaumik Bhatt <bbhatt@codeaurora.org>
> 
> Devices such as SDX24 do not have the provision for inband wake
> doorbell in the form of channel 127 and instead have a sideband
> GPIO for it. Newer devices such as SDX55 or SDX65 support inband
> wake method by default. Ensure the functionality is used based on
> this such that device wake stays held when a client driver uses
> mhi_device_get() API or the equivalent debugfs entry.
> 
> Cc: stable@vger.kernel.org
> Fixes: e3e5e6508fc1 ("bus: mhi: pci_generic: No-Op for device_wake operations")
> Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Link: https://lore.kernel.org/r/1624053302-22470-1-git-send-email-bbhatt@codeaurora.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/bus/mhi/pci_generic.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
> index d84b74396c6a..eb9263bd1bd8 100644
> --- a/drivers/bus/mhi/pci_generic.c
> +++ b/drivers/bus/mhi/pci_generic.c
> @@ -32,6 +32,8 @@
>   * @edl: emergency download mode firmware path (if any)
>   * @bar_num: PCI base address register to use for MHI MMIO register space
>   * @dma_data_width: DMA transfer word size (32 or 64 bits)
> + * @sideband_wake: Devices using dedicated sideband GPIO for wakeup instead
> + *                 of inband wake support (such as sdx24)
>   */
>  struct mhi_pci_dev_info {
>  	const struct mhi_controller_config *config;
> @@ -40,6 +42,7 @@ struct mhi_pci_dev_info {
>  	const char *edl;
>  	unsigned int bar_num;
>  	unsigned int dma_data_width;
> +	bool sideband_wake;
>  };
>  
>  #define MHI_CHANNEL_CONFIG_UL(ch_num, ch_name, el_count, ev_ring) \
> @@ -242,7 +245,8 @@ static const struct mhi_pci_dev_info mhi_qcom_sdx65_info = {
>  	.edl = "qcom/sdx65m/edl.mbn",
>  	.config = &modem_qcom_v1_mhiv_config,
>  	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
> -	.dma_data_width = 32
> +	.dma_data_width = 32,
> +	.sideband_wake = false

Please put a trailing , here and for the other definitions, so in the
future you will not have to modify the previous line, like you had to do
here.

thanks,

greg k-h
