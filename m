Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467F43CB331
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhGPHYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGPHYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0B69613DF;
        Fri, 16 Jul 2021 07:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626420099;
        bh=mbCfFEU3BlNnsCWJrciFPtPkjWVQeJkXllgXFMCDGT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=myQEKWJJ7UPJKuKFkZR8Deh23ZII2LZrHuug14GkhSvHSbSaoKN2XW+RCfUUciipO
         yUZUefYMhD2o3+j7cgqzEeRqMJ4wOfhH8Y2mVBb1V+VcNOtdZS+deuwT+auU3QMGZ9
         z7RaHrQdmOMQ2YxGgcg0baHXcAv02j7XuvRk77mU10nOI/kbKAZH8741K+AUWqqfyJ
         OWikeLw1VAjbZYxcdHSi0stjeeXr+YCgyZd1KzL8Y2mYw78kJp+8j/Zela5Ifd0eWs
         Bgj9OGLjGEakR8yu+n12EvaQOPcDeDNFV80Z0NNQEffKqDLdpPDNo7KYOM27DCeatj
         uFo0WCKs8jP/g==
Date:   Fri, 16 Jul 2021 12:51:33 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mhi: pci_generic: Fix inbound IPCR channel
Message-ID: <20210716072133.GF3323@workstation>
References: <1625736749-24947-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625736749-24947-1-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 11:32:29AM +0200, Loic Poulain wrote:
> The qrtr-mhi client driver assumes that inbound buffers are
> automatically allocated and queued by the MHI core, but this
> no happens for mhi pci devices since IPCR inbound channel is
> not flagged with auto_queue, causing unusable IPCR (qrtr)
> feature. Fix that.
> 
> Cc: stable@vger.kernel.org
> Fixes: 855a70c12021 ("bus: mhi: Add MHI PCI support for WWAN modems")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
>  drivers/bus/mhi/pci_generic.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
> index 8bc6149..6d2ddec 100644
> --- a/drivers/bus/mhi/pci_generic.c
> +++ b/drivers/bus/mhi/pci_generic.c
> @@ -75,6 +75,22 @@ struct mhi_pci_dev_info {
>  		.doorbell_mode_switch = false,		\
>  	}
>  
> +#define MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(ch_num, ch_name, el_count, ev_ring) \
> +	{						\
> +		.num = ch_num,				\
> +		.name = ch_name,			\
> +		.num_elements = el_count,		\
> +		.event_ring = ev_ring,			\
> +		.dir = DMA_FROM_DEVICE,			\
> +		.ee_mask = BIT(MHI_EE_AMSS),		\
> +		.pollcfg = 0,				\
> +		.doorbell = MHI_DB_BRST_DISABLE,	\
> +		.lpm_notify = false,			\
> +		.offload_channel = false,		\
> +		.doorbell_mode_switch = false,		\
> +		.auto_queue = true,			\
> +	}
> +
>  #define MHI_EVENT_CONFIG_CTRL(ev_ring, el_count) \
>  	{					\
>  		.num_elements = el_count,	\
> @@ -213,7 +229,7 @@ static const struct mhi_channel_config modem_qcom_v1_mhi_channels[] = {
>  	MHI_CHANNEL_CONFIG_UL(14, "QMI", 4, 0),
>  	MHI_CHANNEL_CONFIG_DL(15, "QMI", 4, 0),
>  	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 8, 0),
> -	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 8, 0),
> +	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 8, 0),
>  	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
>  	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
>  	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),
> -- 
> 2.7.4
> 
