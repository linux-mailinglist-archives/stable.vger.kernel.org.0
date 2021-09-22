Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F3B413EE8
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 03:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhIVBSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 21:18:17 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13860 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhIVBSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 21:18:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632273408; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=oaqFD/Hj6mpuWTjt+/L5itwzAWWv5BkTLbVKreF7s24=; b=PaDT/LoRP/BOychqn38DBuSp0zKOJhQQzyzX3qAW4l8LFenwawPNp1fotz720gRTIZ+68D/Z
 9CbVk0AsDCDh6nk8f9aDmoJCQe4tkjhwzTOxvp5KBUu1D+k++C526f2xlysavMtIqhxCboff
 NWnYBhG35El5SUk4PX5tnYXJ9ek=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 614a83ffb585cc7d246e159a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 22 Sep 2021 01:16:47
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3EAD0C4360D; Wed, 22 Sep 2021 01:16:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 179C5C4338F;
        Wed, 22 Sep 2021 01:16:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 179C5C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Date:   Tue, 21 Sep 2021 18:16:43 -0700
From:   Jack Pham <jackp@codeaurora.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] xhci: Improve detection of device initiated wake
 signal.
Message-ID: <20210922011643.GD3515@jackp-linux.qualcomm.com>
References: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
 <20210311115353.2137560-3-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311115353.2137560-3-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mathias,

On Thu, Mar 11, 2021 at 01:53:51PM +0200, Mathias Nyman wrote:
> A xHC USB 3 port might miss the first wake signal from a USB 3 device
> if the port LFPS reveiver isn't enabled fast enough after xHC resume.
> 
> xHC host will anyway be resumed by a PME# signal, but will go back to
> suspend if no port activity is seen.
> The device resends the U3 LFPS wake signal after a 100ms delay, but
> by then host is already suspended, starting all over from the
> beginning of this issue.
> 
> USB 3 specs say U3 wake LFPS signal is sent for max 10ms, then device
> needs to delay 100ms before resending the wake.
> 
> Don't suspend immediately if port activity isn't detected in resume.
> Instead add a retry. If there is no port activity then delay for 120ms,
> and re-check for port activity.

We have a use case with which this change is causing unnecessary delay.
Consider a USB2* device is attached and host is initiating the resume.
Since this is not a device initiated wakeup there wouldn't be any
pending event seen on the PORTSC registers, yet this adds an additional
120ms delay to re-check the PORTSC before returning and allowing the USB
core to perform resume signaling.

Is there a way to avoid this delay in that case?  Perhaps could we
distinguish whether we arrive here at xhci_resume() due to a
host-initiated resume vs. a device remote wakeup?

* I think it should be similar for attached USB3 devices as well, since
the host-initiated exit from U3 wouldn't happen until usb_port_resume().

Thanks,
Jack

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index bd27bd670104..48a68fcf2b36 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1088,6 +1088,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>  	struct usb_hcd		*secondary_hcd;
>  	int			retval = 0;
>  	bool			comp_timer_running = false;
> +	bool			pending_portevent = false;
>  
>  	if (!hcd->state)
>  		return 0;
> @@ -1226,13 +1227,22 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>  
>   done:
>  	if (retval == 0) {
> -		/* Resume root hubs only when have pending events. */
> -		if (xhci_pending_portevent(xhci)) {
> +		/*
> +		 * Resume roothubs only if there are pending events.
> +		 * USB 3 devices resend U3 LFPS wake after a 100ms delay if
> +		 * the first wake signalling failed, give it that chance.
> +		 */
> +		pending_portevent = xhci_pending_portevent(xhci);
> +		if (!pending_portevent) {
> +			msleep(120);
> +			pending_portevent = xhci_pending_portevent(xhci);
> +		}
> +
> +		if (pending_portevent) {
>  			usb_hcd_resume_root_hub(xhci->shared_hcd);
>  			usb_hcd_resume_root_hub(hcd);
>  		}
>  	}

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
