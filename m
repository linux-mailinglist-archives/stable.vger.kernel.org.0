Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411D4653E8C
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 11:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiLVKvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 05:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVKvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 05:51:15 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F227932;
        Thu, 22 Dec 2022 02:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671706274; x=1703242274;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=CrZLdDeZWDVo8FK6+1dIOoyIZVEvLuy5zxZWQ9Y3KoI=;
  b=fVeFRHl1Y40P5RAO+DEp8MfHRa36G1TdpLlFT5Z7gQale/ZQ/FGIbZtj
   wqGQhGoZS4YVcqEef2VXt6QQHLzhTzsOpwOIpA7cdWJeM+Hvtg9TQu3PY
   +9cEBYUOoOdALAArn7NVkjuPb4131KORDuY2JxVanYvpYOVlGSVsYhSTo
   IHrKTJBKTROD3gUAAotoTcwSzmveAbCf0/5pedzKFVKzZbZwZxX5KdWFU
   tUZwXvObEXsqDUzom+AgNOkJ/IuRWwxeC2e1Uc2kLdp9/6deyQ1Jyiees
   pJj2Iwyc5Pm36UeSlZRn06ahjy0opNxym3vy85IvlqgfK2tY0IgdoLxob
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="384454541"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="384454541"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 02:51:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="601846989"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="601846989"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga003.jf.intel.com with ESMTP; 22 Dec 2022 02:51:11 -0800
Message-ID: <379b395f-b65c-96fe-7ecc-f18e3740b990@linux.intel.com>
Date:   Thu, 22 Dec 2022 12:52:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Content-Language: en-US
To:     Jimmy Hu <hhhuuu@google.com>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     badhri@google.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221222072912.1843384-1-hhhuuu@google.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH v2] usb: xhci: Check endpoint is valid before
 dereferencing it
In-Reply-To: <20221222072912.1843384-1-hhhuuu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.12.2022 9.29, Jimmy Hu wrote:
> When the host controller is not responding, all URBs queued to all
> endpoints need to be killed. This can cause a kernel panic if we
> dereference an invalid endpoint.
> 
> Fix this by using xhci_get_virt_ep() helper to find the endpoint and
> checking if the endpoint is valid before dereferencing it.
> 
> [233311.853271] xhci-hcd xhci-hcd.1.auto: xHCI host controller not responding, assume dead
> [233311.853393] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8
> 
> [233311.853964] pc : xhci_hc_died+0x10c/0x270
> [233311.853971] lr : xhci_hc_died+0x1ac/0x270
> 
> [233311.854077] Call trace:
> [233311.854085]  xhci_hc_died+0x10c/0x270
> [233311.854093]  xhci_stop_endpoint_command_watchdog+0x100/0x1a4
> [233311.854105]  call_timer_fn+0x50/0x2d4
> [233311.854112]  expire_timers+0xac/0x2e4
> [233311.854118]  run_timer_softirq+0x300/0xabc
> [233311.854127]  __do_softirq+0x148/0x528
> [233311.854135]  irq_exit+0x194/0x1a8
> [233311.854143]  __handle_domain_irq+0x164/0x1d0
> [233311.854149]  gic_handle_irq.22273+0x10c/0x188
> [233311.854156]  el1_irq+0xfc/0x1a8
> [233311.854175]  lpm_cpuidle_enter+0x25c/0x418 [msm_pm]
> [233311.854185]  cpuidle_enter_state+0x1f0/0x764
> [233311.854194]  do_idle+0x594/0x6ac
> [233311.854201]  cpu_startup_entry+0x7c/0x80
> [233311.854209]  secondary_start_kernel+0x170/0x198
> 
> Fixes: 50e8725e7c42 ("xhci: Refactor command watchdog and fix split string.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jimmy Hu <hhhuuu@google.com>
> ---
>   drivers/usb/host/xhci-ring.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index ddc30037f9ce..f5b0e1ce22af 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
>   	struct xhci_virt_ep *ep;
>   	struct xhci_ring *ring;
>   
> -	ep = &xhci->devs[slot_id]->eps[ep_index];
> +	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
> +	if (!ep)
> +		return;
> +


This is a good generic change that should be added anyway, but but might not fix
the rootcause. It will reduce the risk of the race drastically.

We do check that xhci-devs[slot_id] exists once before calling xhci_kill_endpoint_urbs()
for the endpoints of that virt_dev in xhci_hc_died().
And xhci_hc_died() should always be calling with lock held (need to doublecheck this is true).

Older kernels used release and re-aquire the lock while giving back urbs for an endpoint,
so older kernels really need this change.

But newer kernels don't release the lock anymore when giving back URBs.

Looks like real issue is that we don't take the lock when we free the virt_dev.

-Mathias

