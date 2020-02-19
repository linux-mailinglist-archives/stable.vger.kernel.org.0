Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90705163805
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 01:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgBSAHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 19:07:44 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:21542 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgBSAHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 19:07:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582070863; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=ix4I8HGZpni8gwUgc++/jUAdQuDMXvzl5RoCu8Kns8U=; b=wpMLy0VF4kXRrP5CKBxL3D3JUxbKquR+sipEvnOpu7/Dnh2s4ozSd2kaqGciVKtlaS3morQg
 tkHuGOIOYTWUGV+FCewIlDllx/PoaVHtEAqt98WWcWm06gG5j2Ffl9hdOfYPeXOtpH5LIsAW
 bNpgAdMU18lb03GxKTXAoK6wBaw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4c7c4e.7f6364d45688-smtp-out-n03;
 Wed, 19 Feb 2020 00:07:42 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F0DBCC447A4; Wed, 19 Feb 2020 00:07:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 616A8C43383;
        Wed, 19 Feb 2020 00:07:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 616A8C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=jackp@codeaurora.org
Date:   Tue, 18 Feb 2020 16:07:36 -0800
From:   Jack Pham <jackp@codeaurora.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Pratham Pratap <prathampratap@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>, Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Update chain bit correctly when using
 sg list
Message-ID: <20200219000736.GA5511@jackp-linux.qualcomm.com>
References: <20200218235104.112323-1-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218235104.112323-1-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi John,

Thanks for following-up with this! While you're doing minor tweaks
anyway, I hope you don't mind me picking some nits below.

On Tue, Feb 18, 2020 at 11:51:04PM +0000, John Stultz wrote:
> From: Pratham Pratap <prathampratap@codeaurora.org>
> 
> If scatter-gather operation is allowed, a large USB request is split
> into multiple TRBs. For preparing TRBs for sg list, driver iterates
> over the list and creates TRB for each sg and mark the chain bit to
> false for the last sg. The current IOMMU driver is clubbing the list
> of sgs which shares a page boundary into one and giving it to USB driver.
> With this the number of sgs mapped it not equal to the the number of sgs
> passed. Because of this USB driver is not marking the chain bit to false
> since it couldn't iterate to the last sg. This patch addresses this issue
> by marking the chain bit to false if it is the last mapped sg.
> 
> At a practical level, this patch resolves USB transfer stalls
> seen with adb on dwc3 based db845c, pixel3 and other qcom
> hardware after functionfs gadget added scatter-gather support
> around v4.20.
> 
> Credit also to Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
> who implemented a very similar fix to this issue.
> 
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Yang Fei <fei.yang@intel.com>
> Cc: Thinh Nguyen <thinhn@synopsys.com>
> Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
> Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Cc: Jack Pham <jackp@codeaurora.org>
> Cc: Todd Kjos <tkjos@google.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Linux USB List <linux-usb@vger.kernel.org>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Pratham Pratap <prathampratap@codeaurora.org>
> [jstultz: Slight tweak to remove sg_is_last() usage, reworked
>           commit message, minor comment tweak]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/usb/dwc3/gadget.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 1b8014ab0b25..10aa511051e8 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1071,7 +1071,14 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
>  		unsigned int rem = length % maxp;
>  		unsigned chain = true;
>  
> -		if (sg_is_last(s))
> +		/*
> +		 * IOMMU driver is coalescing the list of sgs which shares a
> +		 * page boundary into one and giving it to USB driver. With
> +		 * this the number of sgs mapped it not equal to the the number
                                                 ^^ s/it/is/     ^^^ /d

Or could we more specifically say "number of sgs mapped could be less
than number passed"?

> +		 * of sgs passed. Mark the chain bit to false if it is the last
> +		 * mapped sg.
> +		 */
> +		if ((i == remaining - 1))

These outer parens are superfluous.

Also wondering if it would be more or less clear to just set the
variable once (and awkwardly move the comment to appear above the
local var declaration):

		unsigned chain = (i < remaining - 1);

>  			chain = false;
>  
>  		if (rem && usb_endpoint_dir_out(dep->endpoint.desc) && !chain) {

Jack
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
