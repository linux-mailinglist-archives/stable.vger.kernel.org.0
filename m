Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1B7364D08
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 23:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhDSV1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 17:27:10 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41588 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbhDSV1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 17:27:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618867597; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=QJZmsp27tgalw/CmV9I9b8K83gFD0UekO84CrdH4sac=; b=RemuFQAq6MQNvvEysmD+IqZk+CTt/e73sja7xQOXvZTkqW/APPIX0uYuuSkb3mZHx8ai/GP+
 QLfbhSEKy66QNa7sF+/NkvHAke8YMvpzO/GUbDIFNEi/gmx8hwLn+Gyb3tcI36h6I6lWd4aj
 aIqXIRumIdVEsjF21RnrLwq6yac=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 607df58dc39407c327613de2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 19 Apr 2021 21:26:37
 GMT
Sender: wcheng=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A779BC4360C; Mon, 19 Apr 2021 21:26:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.110.119.120] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcheng)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 60C19C4338A;
        Mon, 19 Apr 2021 21:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 60C19C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=wcheng@codeaurora.org
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
From:   Wesley Cheng <wcheng@codeaurora.org>
Message-ID: <1dbcc47f-e0a2-076e-db6b-528c337621b0@codeaurora.org>
Date:   Mon, 19 Apr 2021 14:26:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/15/2021 3:20 PM, Thinh Nguyen wrote:
> From: Yu Chen <chenyu56@huawei.com>
> From: John Stultz <john.stultz@linaro.org>
> 
> According to the programming guide, to switch mode for DRD controller,
> the driver needs to do the following.
> 
> To switch from device to host:
> 1. Reset controller with GCTL.CoreSoftReset
> 2. Set GCTL.PrtCapDir(host mode)
> 3. Reset the host with USBCMD.HCRESET
> 4. Then follow up with the initializing host registers sequence
> 
> To switch from host to device:
> 1. Reset controller with GCTL.CoreSoftReset
> 2. Set GCTL.PrtCapDir(device mode)
> 3. Reset the device with DCTL.CSftRst
> 4. Then follow up with the initializing registers sequence
> 
> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
> switching from host to device. John Stult reported a lockup issue seen
> with HiKey960 platform without these steps[1]. Similar issue is observed
> with Ferry's testing platform[2].
> 
> So, apply the required steps along with some fixes to Yu Chen's and John
> Stultz's version. The main fixes to their versions are the missing wait
> for clocks synchronization before clearing GCTL.CoreSoftReset and only
> apply DCTL.CSftRst when switching from host to device.
> 
> [1] https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/
> [2] https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/
> 
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Ferry Toth <fntoth@gmail.com>
> Cc: Wesley Cheng <wcheng@codeaurora.org>
> Cc: <stable@vger.kernel.org>
> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
> Signed-off-by: Yu Chen <chenyu56@huawei.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
> Changes in v3:
> - Check if the desired mode is OTG, then keep the old flow
> - Remove condition for OTG support only since the device can still be
>   configured DRD host/device mode only
> - Remove redundant hw_mode check since __dwc3_set_mode() only applies when
>   hw_mode is DRD
> Changes in v2:
> - Initialize mutex per device and not as global mutex.
> - Add additional checks for DRD only mode
> 
>  drivers/usb/dwc3/core.c | 27 +++++++++++++++++++++++++++
>  drivers/usb/dwc3/core.h |  5 +++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 5c25e6a72dbd..2f118ad43571 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -114,6 +114,8 @@ void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode)
>  	dwc->current_dr_role = mode;
>  }
>  
> +static int dwc3_core_soft_reset(struct dwc3 *dwc);
> +
>  static void __dwc3_set_mode(struct work_struct *work)
>  {
>  	struct dwc3 *dwc = work_to_dwc(work);
> @@ -121,6 +123,8 @@ static void __dwc3_set_mode(struct work_struct *work)
>  	int ret;
>  	u32 reg;
>  
> +	mutex_lock(&dwc->mutex);
> +
>  	pm_runtime_get_sync(dwc->dev);
>  
>  	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_OTG)
> @@ -154,6 +158,25 @@ static void __dwc3_set_mode(struct work_struct *work)
>  		break;
>  	}
>  
> +	/* For DRD host or device mode only */
> +	if (dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG) {
> +		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
> +		reg |= DWC3_GCTL_CORESOFTRESET;
> +		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
> +
> +		/*
> +		 * Wait for internal clocks to synchronized. DWC_usb31 and
> +		 * DWC_usb32 may need at least 50ms (less for DWC_usb3). To
> +		 * keep it consistent across different IPs, let's wait up to
> +		 * 100ms before clearing GCTL.CORESOFTRESET.
> +		 */
> +		msleep(100);
> +
> +		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
> +		reg &= ~DWC3_GCTL_CORESOFTRESET;
> +		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
> +	}
> +
>  	spin_lock_irqsave(&dwc->lock, flags);
>  
>  	dwc3_set_prtcap(dwc, dwc->desired_dr_role);
> @@ -178,6 +201,8 @@ static void __dwc3_set_mode(struct work_struct *work)
>  		}
>  		break;
>  	case DWC3_GCTL_PRTCAP_DEVICE:
> +		dwc3_core_soft_reset(dwc);
> +
>  		dwc3_event_buffers_setup(dwc);
>  
>  		if (dwc->usb2_phy)
> @@ -200,6 +225,7 @@ static void __dwc3_set_mode(struct work_struct *work)
>  out:
>  	pm_runtime_mark_last_busy(dwc->dev);
>  	pm_runtime_put_autosuspend(dwc->dev);
> +	mutex_unlock(&dwc->mutex);
>  }
>  
>  void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
> @@ -1553,6 +1579,7 @@ static int dwc3_probe(struct platform_device *pdev)
>  	dwc3_cache_hwparams(dwc);
>  
>  	spin_lock_init(&dwc->lock);
> +	mutex_init(&dwc->mutex);
>  
>  	pm_runtime_set_active(dev);
>  	pm_runtime_use_autosuspend(dev);
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 695ff2d791e4..7e3afa5378e8 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -13,6 +13,7 @@
>  
>  #include <linux/device.h>
>  #include <linux/spinlock.h>
> +#include <linux/mutex.h>
>  #include <linux/ioport.h>
>  #include <linux/list.h>
>  #include <linux/bitops.h>
> @@ -947,6 +948,7 @@ struct dwc3_scratchpad_array {
>   * @scratch_addr: dma address of scratchbuf
>   * @ep0_in_setup: one control transfer is completed and enter setup phase
>   * @lock: for synchronizing
> + * @mutex: for mode switching
>   * @dev: pointer to our struct device
>   * @sysdev: pointer to the DMA-capable device
>   * @xhci: pointer to our xHCI child
> @@ -1088,6 +1090,9 @@ struct dwc3 {
>  	/* device lock */
>  	spinlock_t		lock;
>  
> +	/* mode switching lock */
> +	struct mutex		mutex;
> +
>  	struct device		*dev;
>  	struct device		*sysdev;
>  
> 
> base-commit: 4b853c236c7b5161a2e444bd8b3c76fe5aa5ddcb
> 
Hi Thinh,

Thanks for this change! Tested this on our platform w/ a DRD mode switch
loop and it looks good.

Tested-by: Wesley Cheng <wcheng@codeaurora.org>

Thanks
Wesley Cheng
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
