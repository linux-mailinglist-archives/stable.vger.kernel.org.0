Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF4D66CC1A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbjAPRW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbjAPRVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:21:05 -0500
Received: from h2.cmg1.smtp.forpsi.com (h2.cmg1.smtp.forpsi.com [81.2.195.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C724736B25
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:37 -0800 (PST)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id HSpYp9eFIPm6CHSpapjexz; Mon, 16 Jan 2023 17:59:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1673888375; bh=SPfx/5k7n0wtVog2S606bstMmr2jYb0o5FKThwo52A0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=IbudbFQTPLWfmigsHEZwYLA3nABiVsejccOdY7fcY6M27gJ5jar5qO3x0Qr0und6p
         nEymgrDXfo3rkxMdWcyqEpwrhd/cor8xyZknBMkPceAMi2r0ZzUpoV4sRyPwTe4Xui
         j/XPp53BPCt8JeEUae7GfmrJocGcY8iDm6RYgZtXrOe+sYgf3kJ7TZSfr+/b+lFgHF
         l98sP8ooNQDBifCFV74u2bjRg3OVC0FjV4rrkEywxS95QpDPztbQUYBHL+aOgadNUk
         Ppy0D70WGRwb6QFAZD0YUH7PzMAgMu0LcbOGIiGXJvcqsshItlZL7QkL2QYczsr48h
         CCOVSzyiSTs8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1673888375; bh=SPfx/5k7n0wtVog2S606bstMmr2jYb0o5FKThwo52A0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=IbudbFQTPLWfmigsHEZwYLA3nABiVsejccOdY7fcY6M27gJ5jar5qO3x0Qr0und6p
         nEymgrDXfo3rkxMdWcyqEpwrhd/cor8xyZknBMkPceAMi2r0ZzUpoV4sRyPwTe4Xui
         j/XPp53BPCt8JeEUae7GfmrJocGcY8iDm6RYgZtXrOe+sYgf3kJ7TZSfr+/b+lFgHF
         l98sP8ooNQDBifCFV74u2bjRg3OVC0FjV4rrkEywxS95QpDPztbQUYBHL+aOgadNUk
         Ppy0D70WGRwb6QFAZD0YUH7PzMAgMu0LcbOGIiGXJvcqsshItlZL7QkL2QYczsr48h
         CCOVSzyiSTs8g==
Date:   Mon, 16 Jan 2023 17:59:32 +0100
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        Jimmy Hu <hhhuuu@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/7] usb: xhci: Check endpoint is valid before
 dereferencing it
Message-ID: <Y8WCdG5YSpX/Seit@lenoch>
References: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
 <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
X-CMAE-Envelope: MS4wfNGNgg6blrY9hAaPrC36bdIaV6b8EG123WQCVnhgz0yc++oMA6S4zf+CxledjQQ7mOVZ2pvVQ2Tjo0vjK0hCZDxtiArD67LTm5f51C5Hj3MBVdbSF+Q+
 GJ7ocdnu2J5DwpXCaq6aD5c/5BOiaYSFY4nBN1okn5WICCWJnEwH3gY/ssz0urhK3PE6hPnHE6iEvhbEFWG6jnUlvP6lQrzfWlgJoWiQQwozhv5Z45XziCO7
 7UlLr1e9qdvgUUik1rrL0uWY2MRyQnmhrnMkZFlyG6ICCjM1WoHGXJkmhBQ7Gc2wT4XFDKVMCiBtjACWSKzjuQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mathias,

On Mon, Jan 16, 2023 at 04:22:11PM +0200, Mathias Nyman wrote:
> From: Jimmy Hu <hhhuuu@google.com>
> 
> When the host controller is not responding, all URBs queued to all
> endpoints need to be killed. This can cause a kernel panic if we
> dereference an invalid endpoint.
> 
> Fix this by using xhci_get_virt_ep() helper to find the endpoint and
> checking if the endpoint is valid before dereferencing it.

I'm a bit confused this goes in and even to stable. Let me quote your
own analysis from
Message-ID: <0fe978ed-8269-9774-1c40-f8a98c17e838@linux.intel.com>
On Thu, Dec 22, 2022 at 03:18:53PM +0200, Mathias Nyman wrote:
> I think root cause is that freeing xhci->devs[i] and including rings isn't
> protected by the lock, this happens in xhci_free_virt_device() called by
> xhci_free_dev(), which in turn may be called by usbcore at any time
> 
> So xhci->devs[i] might just suddenly disappear
> 
> Patch just checks more often if xhci->devs[i] is valid, between every endpoint.
> So the race between xhci_free_virt_device() and xhci_kill_endpoint_urbs()
> doesn't trigger null pointer deref as easily.

I believe the above is correct and even Jimmy was unable to verify your
later patch (3rd in this serie), which brings a question how could be this
patch tested. It just burns a bug a bit deeper and I do not think it is the
right approach.

	ladis

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
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-ring.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index ddc30037f9ce..f5b0e1ce22af 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
>  	struct xhci_virt_ep *ep;
>  	struct xhci_ring *ring;
>  
> -	ep = &xhci->devs[slot_id]->eps[ep_index];
> +	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
> +	if (!ep)
> +		return;
> +
>  	if ((ep->ep_state & EP_HAS_STREAMS) ||
>  			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
>  		int stream_id;
> -- 
> 2.25.1
