Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5537B3EB2C9
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbhHMIo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239249AbhHMIo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB5F60F11;
        Fri, 13 Aug 2021 08:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628844271;
        bh=15kFW9FzjAOMPwRmv84+cYUiRNfsKRfToladgJA4ZCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPLFZNk9B+P0/XrbjDG2YKNHHNPwjoE5JlmrtHtj1Bo9nVNedgo//9eKUvNZEPwzR
         EWCTeploPGwciwM/CfJXvgqk8ciORcVgALvXmqrChFWKmciLN66FHOS5Vbdn1Qm/CL
         RCCdMi+Wqcr+In0SAa55BwWLB06q8FnqSxnfPPGs=
Date:   Fri, 13 Aug 2021 10:44:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     wcheng@codeaurora.org, balbi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: gadget: Use
 list_replace_init() before traversing" failed to apply to 5.10-stable tree
Message-ID: <YRYw7ETwvz9dC76C@kroah.com>
References: <1628498902192246@kroah.com>
 <YRQrmJuVH6PlaP1P@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRQrmJuVH6PlaP1P@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 08:57:12PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Aug 09, 2021 at 10:48:22AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 5.4-stable and 4.19-stable.
> 
> --
> Regards
> Sudip

> >From e01c2051bac15d89168e30c2cfa2cd828104ed4d Mon Sep 17 00:00:00 2001
> From: Wesley Cheng <wcheng@codeaurora.org>
> Date: Thu, 29 Jul 2021 00:33:14 -0700
> Subject: [PATCH] usb: dwc3: gadget: Use list_replace_init() before traversing
>  lists
> 
> commit d25d85061bd856d6be221626605319154f9b5043 upstream
> 
> The list_for_each_entry_safe() macro saves the current item (n) and
> the item after (n+1), so that n can be safely removed without
> corrupting the list.  However, when traversing the list and removing
> items using gadget giveback, the DWC3 lock is briefly released,
> allowing other routines to execute.  There is a situation where, while
> items are being removed from the cancelled_list using
> dwc3_gadget_ep_cleanup_cancelled_requests(), the pullup disable
> routine is running in parallel (due to UDC unbind).  As the cleanup
> routine removes n, and the pullup disable removes n+1, once the
> cleanup retakes the DWC3 lock, it references a request who was already
> removed/handled.  With list debug enabled, this leads to a panic.
> Ensure all instances of the macro are replaced where gadget giveback
> is used.
> 
> Example call stack:
> 
> Thread#1:
> __dwc3_gadget_ep_set_halt() - CLEAR HALT
>   -> dwc3_gadget_ep_cleanup_cancelled_requests()
>     ->list_for_each_entry_safe()
>     ->dwc3_gadget_giveback(n)
>       ->dwc3_gadget_del_and_unmap_request()- n deleted[cancelled_list]
>       ->spin_unlock
>       ->Thread#2 executes
>       ...
>     ->dwc3_gadget_giveback(n+1)
>       ->Already removed!
> 
> Thread#2:
> dwc3_gadget_pullup()
>   ->waiting for dwc3 spin_lock
>   ...
>   ->Thread#1 released lock
>   ->dwc3_stop_active_transfers()
>     ->dwc3_remove_requests()
>       ->fetches n+1 item from cancelled_list (n removed by Thread#1)
>       ->dwc3_gadget_giveback()
>         ->dwc3_gadget_del_and_unmap_request()- n+1
> deleted[cancelled_list]
>         ->spin_unlock
> 
> Fix this condition by utilizing list_replace_init(), and traversing
> through a local copy of the current elements in the endpoint lists.
> This will also set the parent list as empty, so if another thread is
> also looping through the list, it will be empty on the next iteration.
> 
> Fixes: d4f1afe5e896 ("usb: dwc3: gadget: move requests to cancelled_list")
> Cc: stable <stable@vger.kernel.org>
> Acked-by: Felipe Balbi <balbi@kernel.org>
> Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
> Link: https://lore.kernel.org/r/1627543994-20327-1-git-send-email-wcheng@codeaurora.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [sudip: adjust context]
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
>  drivers/usb/dwc3/gadget.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)

This breaks systems, and is reverted in my tree and will be sent to
Linus later today (the revert), so I'll drop this from the stable trees
for now.

thanks,

greg k-h
