Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDF7D5FD8
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 12:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbfJNKQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 06:16:04 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33295 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfJNKQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 06:16:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id y127so11403063lfc.0;
        Mon, 14 Oct 2019 03:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZPSVvZUElOUiKV/doqRMk+tVtdAW+rauLkS5pvoaQXI=;
        b=goFrFjG9tMRKI0Gjb/MPzDJ1wLQl3UXKgqYSqjWPmi/RUApbM5zmaiqaFQa9xAv1Ct
         JPklJoVd6/9Sp0De9Wmaz4syatvUtgjv6u+poHIIZxsnE+8bnfKhP46dr43Www8S6ja6
         TzzgSKSieQ4rbrx4QpQG4vlweFCKSNOGQ3mC4GiZ9bJRZzkupGx0YV2AJo24uYiTYPF3
         +nqgxlzDO3Q50by5kp1NZ75GCdb3+Ak7Hr+wcbRFPVzQurGnutXQr1tSGyrBSVqgaiUs
         EdYuY1uPkxCE7e/4K9gPZNVXz4fAxih6PJXdL/rMQTk/Lni9T7VnhNa2z297GWechl8x
         Iycg==
X-Gm-Message-State: APjAAAVsWxnJ6qpllIsbecnhbonr1e3/ebVg9p1iTJhJGgNpp4NnB79+
        7p/Y6cS54kpeH9KLQhRY7S54Z8kv
X-Google-Smtp-Source: APXvYqzM297RG6C4nfD1J51CsLKSovhQ+DMSTtHhVbESTao8adajczTfciygNySkOr+cZAsoqPtFDA==
X-Received: by 2002:ac2:4215:: with SMTP id y21mr16841858lfh.85.1571048161178;
        Mon, 14 Oct 2019 03:16:01 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id e29sm4100446ljb.105.2019.10.14.03.16.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 03:16:00 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iJxOd-0005zk-86; Mon, 14 Oct 2019 12:16:11 +0200
Date:   Mon, 14 Oct 2019 12:16:11 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     johan@kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        "# v5 . 3" <stable@vger.kernel.org>
Subject: Re: [RFT PATCH] xhci: Fix use-after-free regression in xhci clear
 hub TT implementation
Message-ID: <20191014101611.GN13531@localhost>
References: <1c4b7107-f5e1-4a69-2a73-0e339c7e1072@linux.intel.com>
 <1570798722-31594-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570798722-31594-1-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 03:58:42PM +0300, Mathias Nyman wrote:
> commit ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer") schedules work
> to clear TT buffer, but causes a use-after-free regression at the same time
> 
> Make sure hub_tt_work finishes before endpoint is disabled, otherwise
> the work will dereference already freed endpoint and device related
> pointers.
> 
> This was triggered when usb core failed to read the configuration
> descriptor of a FS/LS device during enumeration.
> xhci driver queued clear_tt_work while usb core freed and reallocated
> a new device for the next enumeration attempt.
> 
> EHCI driver implents ehci_endpoint_disable() that makes sure
> clear_tt_work has finished before it returns, but xhci lacks this support.
> usb core will call hcd->driver->endpoint_disable() callback before
> disabling endpoints, so we want this in xhci as well.
> 
> The added xhci_endpoint_disable() is based on ehci_endpoint_disable()
> 
> Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
> Cc: <stable@vger.kernel.org> # v5.3
> Reported-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 5cfbf9a04494..6e817686d04f 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -3071,6 +3071,48 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int ep_index,
>  	}
>  }
>  
> +static void xhci_endpoint_disable(struct usb_hcd *hcd,
> +				  struct usb_host_endpoint *host_ep)
> +{
> +	struct xhci_hcd		*xhci;
> +	struct xhci_virt_device	*vdev;
> +	struct xhci_virt_ep	*ep;
> +	struct usb_device	*udev;
> +	unsigned long		flags;
> +	unsigned int		ep_index;
> +
> +	xhci = hcd_to_xhci(hcd);
> +rescan:
> +	spin_lock_irqsave(&xhci->lock, flags);
> +
> +	udev = (struct usb_device *)host_ep->hcpriv;
> +	if (!udev || !udev->slot_id)
> +		goto done;
> +
> +	vdev = xhci->devs[udev->slot_id];
> +	if (!vdev)
> +		goto done;
> +
> +	ep_index = xhci_get_endpoint_index(&host_ep->desc);
> +	ep = &vdev->eps[ep_index];
> +	if (!ep)
> +		goto done;
> +
> +	/* wait for hub_tt_work to finish clearing hub TT */
> +	if (ep->ep_state & EP_CLEARING_TT) {
> +		spin_unlock_irqrestore(&xhci->lock, flags);
> +		schedule_timeout_uninterruptible(1);
> +		goto rescan;
> +	}
> +
> +	if (ep->ep_state)
> +		xhci_dbg(xhci, "endpoint disable with ep_state 0x%x\n",
> +			 ep->ep_state);
> +done:
> +	host_ep->hcpriv = NULL;
> +	spin_unlock_irqrestore(&xhci->lock, flags);
> +}
> +

I used essentially the same reproducer as you did for debugging this
after I first hit it with an actually stalled control endpoint, and this
patch works also with my fault-injection hack.

I've reviewed the code and it looks good to me except for one mostly
theoretical issue. You need to check ep->hc_priv while holding the
xhci->lock in xhci_clear_tt_buffer_complete() or you could end up having
xhci_endpoint_disable() reschedule indefinitely while waiting for
EP_CLEARING_TT to be cleared on a sufficiently weakly ordered
system.

Since cfbb8a84c2d2 ("xhci: Fix NULL pointer dereference in
xhci_clear_tt_buffer_complete()") isn't needed anymore and is slightly
misleading, I suggest amending the patch with the following:

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9b1e15fe2c8e..6c17e3fe181a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5280,20 +5280,13 @@ static void xhci_clear_tt_buffer_complete(struct usb_hcd *hcd,
        unsigned int ep_index;
        unsigned long flags;
 
-       /*
-        * udev might be NULL if tt buffer is cleared during a failed device
-        * enumeration due to a halted control endpoint. Usb core might
-        * have allocated a new udev for the next enumeration attempt.
-        */
-
        xhci = hcd_to_xhci(hcd);
+
+       spin_lock_irqsave(&xhci->lock, flags);
        udev = (struct usb_device *)ep->hcpriv;
-       if (!udev)
-               return;
        slot_id = udev->slot_id;
        ep_index = xhci_get_endpoint_index(&ep->desc);
 
-       spin_lock_irqsave(&xhci->lock, flags);
        xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_CLEARING_TT;
        xhci_ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
        spin_unlock_irqrestore(&xhci->lock, flags);

Feel free to add my:

Suggested-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Tested-by: Johan Hovold <johan@kernel.org>

Johan
