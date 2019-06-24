Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22FE50112
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 07:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfFXFlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 01:41:52 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:41698 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbfFXFlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 01:41:52 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D9084C01C4;
        Mon, 24 Jun 2019 05:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561354911; bh=E1ERrISIW+x8N6/XjWkPCVdmvp0aiB6uJtVc4k+4tXo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AJakDklB8qWucLSsOgZ7kcmOZ6Sd0wVHNpfzhJg27zkf+9MeY50eFDFnlhPkeRUCM
         NsAHHH62qGvuMQA3TCQHdQ6F2WNUdq6O7en9wPPCFVRbuMp2Bv7lKP4VoddNKynS9o
         qDS05iIumGYXIsOvKTqq4kZK+pZcqyNkYoF1x2hxyILh9iNAfEvXRcL6javwhFxR3K
         LirNPYlsPwJc9TeWw/NgXFb7ZiEIZniIZftaqb97JQZ59uvXfi7/Wpqgz2igr3MNrx
         6nAL523LjnSJrMhc4jCg1Tqb1B9GbbkURgkDznKe0UNnz+ciIXjYGp3seVWsGzHye1
         4X8dgja8PUrxw==
Received: from [10.116.70.206] (unknown [10.116.70.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id EB20DA0231;
        Mon, 24 Jun 2019 05:41:47 +0000 (UTC)
Subject: Re: [PATCH] usb: dwc2: use a longer AHB idle timeout in
 dwc2_core_reset()
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
References: <20190620175022.29348-1-martin.blumenstingl@googlemail.com>
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Message-ID: <a7647aea-b3e6-b785-8476-1851f50beff1@synopsys.com>
Date:   Mon, 24 Jun 2019 09:41:46 +0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620175022.29348-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/2019 9:51 PM, Martin Blumenstingl wrote:
> Use a 10000us AHB idle timeout in dwc2_core_reset() and make it
> consistent with the other "wait for AHB master IDLE state" ocurrences.
> 
> This fixes a problem for me where dwc2 would not want to initialize when
> updating to 4.19 on a MIPS Lantiq VRX200 SoC. dwc2 worked fine with
> 4.14.
> Testing on my board shows that it takes 180us until AHB master IDLE
> state is signalled. The very old vendor driver for this SoC (ifxhcd)
> used a 1 second timeout.
> Use the same timeout that is used everywhere when polling for
> GRSTCTL_AHBIDLE instead of using a timeout that "works for one board"
> (180us in my case) to have consistent behavior across the dwc2 driver.
> 
> Cc: linux-stable <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---

Acked-by: Minas Harutyunyan <hminas@synopsys.com>

>   drivers/usb/dwc2/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> index 8b499d643461..8e41d70fd298 100644
> --- a/drivers/usb/dwc2/core.c
> +++ b/drivers/usb/dwc2/core.c
> @@ -531,7 +531,7 @@ int dwc2_core_reset(struct dwc2_hsotg *hsotg, bool skip_wait)
>   	}
>   
>   	/* Wait for AHB master IDLE state */
> -	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 50)) {
> +	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 10000)) {
>   		dev_warn(hsotg->dev, "%s: HANG! AHB Idle timeout GRSTCTL GRSTCTL_AHBIDLE\n",
>   			 __func__);
>   		return -EBUSY;
> 

