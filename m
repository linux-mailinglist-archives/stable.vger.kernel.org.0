Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76713F9224
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 03:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbhH0Bv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 21:51:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41530 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241109AbhH0Bv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 21:51:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630029068; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+ninKRRjL2n7zvyhwcNWuopB94ABdYmh0Yjwjroinx4=;
 b=kfSrDcMAy7UO8R7l2ikYy6bmcv72K3iEQiaBnTiVYNuKdEmRb9n1I3zpYNzRT56srpqn5jzc
 d11YsOSUiQv+4+BTwJhk1T2w8NZ/gLHETEKnM6Zb334LzTD5LCjJPb+tYuiD0ABp73zOAGAQ
 0XU/aFfVfEOBHbYo+2a840bxjJU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 612844ffd6653df767034a1d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 27 Aug 2021 01:50:55
 GMT
Sender: wat=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A2B8CC43460; Fri, 27 Aug 2021 01:50:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wat)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A982AC4338F;
        Fri, 27 Aug 2021 01:50:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 27 Aug 2021 09:50:53 +0800
From:   wat@codeaurora.org
To:     gregkh@linuxfoundation.org
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org
Subject: Re: patch "xhci: Fix failure to give back some cached cancelled
 URBs." added to usb-testing
In-Reply-To: <16299760127797@kroah.com>
References: <16299760127797@kroah.com>
Message-ID: <d977fba1a5885ab8fb23a2b296946582@codeaurora.org>
X-Sender: wat@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-08-26 19:06, gregkh@linuxfoundation.org wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     xhci: Fix failure to give back some cached cancelled URBs.
> 
> to my usb git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> in the usb-testing branch.
> 
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
> 
> The patch will be merged to the usb-next branch sometime soon,
> after it passes testing, and the merge window is open.
> 
> If you have any questions about this process, please let me know.
> 
Thanks, we have tested the patch, it's ok.

> 
> From 94f339147fc3eb9edef7ee4ef6e39c569c073753 Mon Sep 17 00:00:00 2001
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
> Date: Fri, 20 Aug 2021 15:35:00 +0300
> Subject: xhci: Fix failure to give back some cached cancelled URBs.
> 
> Only TDs with status TD_CLEARING_CACHE will be given back after
> cache is cleared with a set TR deq command.
> 
> xhci_invalidate_cached_td() failed to set the TD_CLEARING_CACHE status
> for some cancelled TDs as it assumed an endpoint only needs to clear 
> the
> TD it stopped on.
> 
> This isn't always true. For example with streams enabled an endpoint 
> may
> have several stream rings, each stopping on a different TDs.
> 
> Note that if an endpoint has several stream rings, the current code
> will still only clear the cache of the stream pointed to by the last
> cancelled TD in the cancel list.
> 
> This patch only focus on making sure all canceled TDs are given back,
> avoiding hung task after device removal.
> Another fix to solve clearing the caches of all stream rings with
> cancelled TDs is needed, but not as urgent.
> 
> This issue was simultanously discovered and debugged by
> by Tao Wang, with a slightly different fix proposal.
> 
> Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two 
> steps")
> Cc: <stable@vger.kernel.org> #5.12
> Reported-by: Tao Wang <wat@codeaurora.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Link:
> https://lore.kernel.org/r/20210820123503.2605901-4-mathias.nyman@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/host/xhci-ring.c | 40 ++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c 
> b/drivers/usb/host/xhci-ring.c
> index d0faa67a689d..9017986241f5 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -942,17 +942,21 @@ static int xhci_invalidate_cancelled_tds(struct
> xhci_virt_ep *ep)
>  					 td->urb->stream_id);
>  		hw_deq &= ~0xf;
> 
> -		if (td->cancel_status == TD_HALTED) {
> -			cached_td = td;
> -		} else if (trb_in_td(xhci, td->start_seg, td->first_trb,
> -			      td->last_trb, hw_deq, false)) {
> +		if (td->cancel_status == TD_HALTED ||
> +		    trb_in_td(xhci, td->start_seg, td->first_trb, td->last_trb,
> hw_deq, false)) {
>  			switch (td->cancel_status) {
>  			case TD_CLEARED: /* TD is already no-op */
>  			case TD_CLEARING_CACHE: /* set TR deq command already queued */
>  				break;
>  			case TD_DIRTY: /* TD is cached, clear it */
>  			case TD_HALTED:
> -				/* FIXME  stream case, several stopped rings */
> +				td->cancel_status = TD_CLEARING_CACHE;
> +				if (cached_td)
> +					/* FIXME  stream case, several stopped rings */
> +					xhci_dbg(xhci,
> +						 "Move dq past stream %u URB %p instead of stream %u URB %p\n",
> +						 td->urb->stream_id, td->urb,
> +						 cached_td->urb->stream_id, cached_td->urb);
>  				cached_td = td;
>  				break;
>  			}
> @@ -961,18 +965,24 @@ static int xhci_invalidate_cancelled_tds(struct
> xhci_virt_ep *ep)
>  			td->cancel_status = TD_CLEARED;
>  		}
>  	}
> -	if (cached_td) {
> -		cached_td->cancel_status = TD_CLEARING_CACHE;
> 
> -		err = xhci_move_dequeue_past_td(xhci, slot_id, ep->ep_index,
> -						cached_td->urb->stream_id,
> -						cached_td);
> -		/* Failed to move past cached td, try just setting it noop */
> -		if (err) {
> -			td_to_noop(xhci, ring, cached_td, false);
> -			cached_td->cancel_status = TD_CLEARED;
> +	/* If there's no need to move the dequeue pointer then we're done */
> +	if (!cached_td)
> +		return 0;
> +
> +	err = xhci_move_dequeue_past_td(xhci, slot_id, ep->ep_index,
> +					cached_td->urb->stream_id,
> +					cached_td);
> +	if (err) {
> +		/* Failed to move past cached td, just set cached TDs to no-op */
> +		list_for_each_entry_safe(td, tmp_td, &ep->cancelled_td_list,
> cancelled_td_list) {
> +			if (td->cancel_status != TD_CLEARING_CACHE)
> +				continue;
> +			xhci_dbg(xhci, "Failed to clear cancelled cached URB %p, mark
> clear anyway\n",
> +				 td->urb);
> +			td_to_noop(xhci, ring, td, false);
> +			td->cancel_status = TD_CLEARED;
>  		}
> -		cached_td = NULL;
>  	}
>  	return 0;
>  }
