Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBF11CEBB3
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 05:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgELDuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 23:50:06 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:47511 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727942AbgELDuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 23:50:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589255405; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=CYQ0jjYyDm9YKPn30GSjQdOx15wqINKsCVbfdgAZKhU=; b=sZyaotggValbslbZqD60FG3WQXF61kT5qEisb9p5C7T3fAf4Ifs2RFHOm3nqnSFaGwdbhsuv
 WqLgFS2fS56m1EU9JVGwkMrPs4sZSXDfm4tyszJ/OkIPCo8r3Koh/XBiaugempxQDo1yXdnT
 oBMfLTEg1Lmii11AhBDJrfDEBKU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eba1ce1.7f977e40c298-smtp-out-n01;
 Tue, 12 May 2020 03:49:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7CCB2C43637; Tue, 12 May 2020 03:49:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.7] (unknown [122.169.155.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mgautam)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2E6DDC433F2;
        Tue, 12 May 2020 03:49:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2E6DDC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=mgautam@codeaurora.org
Subject: Re: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when remove
 host
To:     Peter Chen <peter.chen@nxp.com>, mathias.nyman@intel.com
Cc:     linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-imx@nxp.com, Li Jun <jun.li@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
References: <20200512023547.31164-1-peter.chen@nxp.com>
From:   Manu Gautam <mgautam@codeaurora.org>
Message-ID: <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
Date:   Tue, 12 May 2020 09:19:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200512023547.31164-1-peter.chen@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 5/12/2020 8:05 AM, Peter Chen wrote:
> Cc: Baolin Wang <baolin.wang@linaro.org>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Fixes: b0c69b4bace3 ("usb: host: plat: Enable xHCI plat runtime PM")
> Reviewed-by: Peter Chen <peter.chen@nxp.com>
> Signed-off-by: Li Jun <jun.li@nxp.com>
> ---
>  drivers/usb/host/xhci-plat.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 1d4f6f85f0fe..f38d53528c96 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -362,6 +362,7 @@ static int xhci_plat_remove(struct platform_device *dev)
>  	struct clk *reg_clk = xhci->reg_clk;
>  	struct usb_hcd *shared_hcd = xhci->shared_hcd;
>  
> +	pm_runtime_get_sync(&dev->dev);
Where is corresponding _put() call?


>  	xhci->xhc_state |= XHCI_STATE_REMOVING;
>  
>  	usb_remove_hcd(shared_hcd);

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
