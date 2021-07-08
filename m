Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C26D3C1A33
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 21:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhGHT5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 15:57:42 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:27562 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhGHT5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 15:57:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625774099; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=XmhpdNAlbBG2whMnaimLCcRx1eKYhn6f80bIkt0IMKA=;
 b=IbTFRIgCTJuHj6dLqT9h4NnM1fH2lDMxb0/ByxASmM6WLP804v6tNL0G14CHi0Jsd2c/A150
 gAD/y9SVt6JJShM2DYAyDLiztTeqR/MBXPniESDrzmi9wjTFlOFpGS+rYmcazsMXP7RMjTki
 sW3+GyVghXIn9Ch09OzEShUq6WE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60e75808ec0b18a74589a461 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Jul 2021 19:54:48
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7E6ECC4338A; Thu,  8 Jul 2021 19:54:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5DC3C433D3;
        Thu,  8 Jul 2021 19:54:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Jul 2021 12:54:46 -0700
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     mani@kernel.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mhi: pci_generic: Fix inbound IPCR channel
Organization: Qualcomm Innovation Center, Inc.
Reply-To: bbhatt@codeaurora.org
Mail-Reply-To: bbhatt@codeaurora.org
In-Reply-To: <1625736749-24947-1-git-send-email-loic.poulain@linaro.org>
References: <1625736749-24947-1-git-send-email-loic.poulain@linaro.org>
Message-ID: <107247c48a6991547fa5cedd0f19d63c@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-08 02:32 AM, Loic Poulain wrote:
> The qrtr-mhi client driver assumes that inbound buffers are
> automatically allocated and queued by the MHI core, but this
> no happens for mhi pci devices since IPCR inbound channel is
> not flagged with auto_queue, causing unusable IPCR (qrtr)
> feature. Fix that.
> 
> Cc: stable@vger.kernel.org
> Fixes: 855a70c12021 ("bus: mhi: Add MHI PCI support for WWAN modems")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/bus/mhi/pci_generic.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/mhi/pci_generic.c 
> b/drivers/bus/mhi/pci_generic.c
> index 8bc6149..6d2ddec 100644
> --- a/drivers/bus/mhi/pci_generic.c
> +++ b/drivers/bus/mhi/pci_generic.c
> @@ -75,6 +75,22 @@ struct mhi_pci_dev_info {
>  		.doorbell_mode_switch = false,		\
>  	}
> 
> +#define MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(ch_num, ch_name, el_count, 
> ev_ring) \
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
> @@ -213,7 +229,7 @@ static const struct mhi_channel_config
> modem_qcom_v1_mhi_channels[] = {
>  	MHI_CHANNEL_CONFIG_UL(14, "QMI", 4, 0),
>  	MHI_CHANNEL_CONFIG_DL(15, "QMI", 4, 0),
>  	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 8, 0),
> -	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 8, 0),
> +	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 8, 0),
>  	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
>  	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
>  	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),
Why do we need to make this change when we have your new change being
picked up that does this from qrtr/mhi.c?

Thanks,
Bhaumik
---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
