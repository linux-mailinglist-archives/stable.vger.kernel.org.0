Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8265E439D11
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhJYRLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:11:08 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:35429 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhJYREM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 13:04:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635181309; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=flSp6r7j7r9TerCeVctiXj336S86cQyNXe6kwX66Was=;
 b=iNkxNa9HG3CFBacZ8t+WLeTgqYJ6fcQVHwUCwYzrMgJhmbnsmrmof7uOKqWe7PsFej73HUPu
 wbDTqlRjnbMIjvWMPEoWGSswWzBak3XRd509Bvy159MKAXwVpztY0JO2s3CIv0KG8wYZ7dw4
 TI1XrOC8EQBSeVN3hCbKSxiVhQ0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6176e2cb14914866fa7c5b7c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 17:00:59
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E0F13C4479F; Mon, 25 Oct 2021 17:00:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CB0BC43150;
        Mon, 25 Oct 2021 17:00:56 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Oct 2021 10:00:56 -0700
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     mani@kernel.org, linux-arm-msm@vger.kernel.org,
        hemantk@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH] mhi: pci_generic: Graceful shutdown on freeze
Organization: Qualcomm Innovation Center, Inc.
Reply-To: bbhatt@codeaurora.org
Mail-Reply-To: bbhatt@codeaurora.org
In-Reply-To: <1635151940-22147-1-git-send-email-loic.poulain@linaro.org>
References: <1635151940-22147-1-git-send-email-loic.poulain@linaro.org>
Message-ID: <25236e618b450cf89e918505da624fa5@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-10-25 01:52 AM, Loic Poulain wrote:
> There is no reason for shutting down MHI ungracefully on freeze,
> this causes the MHI host stack & device stack to not be aligned
> anymore since the proper MHI reset sequence is not performed for
> ungraceful shutdown.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/bus/mhi/pci_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/mhi/pci_generic.c 
> b/drivers/bus/mhi/pci_generic.c
> index 6a42425..d4a3ce2 100644
> --- a/drivers/bus/mhi/pci_generic.c
> +++ b/drivers/bus/mhi/pci_generic.c
> @@ -1018,7 +1018,7 @@ static int __maybe_unused mhi_pci_freeze(struct
> device *dev)
>  	 * context.
>  	 */
>  	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
> -		mhi_power_down(mhi_cntrl, false);
> +		mhi_power_down(mhi_cntrl, true);
>  		mhi_unprepare_after_power_down(mhi_cntrl);
>  	}
Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>

Thanks,
Bhaumik
---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
