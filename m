Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6FF11D181
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 16:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbfLLPyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 10:54:09 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33557 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729507AbfLLPyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 10:54:09 -0500
Received: (qmail 17464 invoked by uid 500); 12 Dec 2019 10:54:08 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 12 Dec 2019 10:54:08 -0500
Date:   Thu, 12 Dec 2019 10:54:08 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Suwan Kim <suwan.kim027@gmail.com>
cc:     shuah@kernel.org, <valentina.manea.m@gmail.com>,
        <gregkh@linuxfoundation.org>, <marmarek@invisiblethingslab.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] usbip: Fix error path of vhci_recv_ret_submit()
In-Reply-To: <20191212052841.6734-3-suwan.kim027@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1912121050130.14053-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Dec 2019, Suwan Kim wrote:

> If a transaction error happens in vhci_recv_ret_submit(), event
> handler closes connection and changes port status to kick hub_event.
> Then hub tries to flush the endpoint URBs, but that causes infinite
> loop between usb_hub_flush_endpoint() and vhci_urb_dequeue() because
> "vhci_priv" in vhci_urb_dequeue() was already released by
> vhci_recv_ret_submit() before a transmission error occurred. Thus,
> vhci_urb_dequeue() terminates early and usb_hub_flush_endpoint()
> continuously calls vhci_urb_dequeue().
> 
> The root cause of this issue is that vhci_recv_ret_submit()
> terminates early without giving back URB when transaction error
> occurs in vhci_recv_ret_submit(). That causes the error URB to still
> be linked at endpoint list without “vhci_priv".
> 
> So, in the case of trasnaction error in vhci_recv_ret_submit(),
> unlink URB from the endpoint, insert proper error code in
> urb->status and give back URB.
> 
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
> ---
>  drivers/usb/usbip/vhci_rx.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
> index 33f8972ba842..dc26acad6baf 100644
> --- a/drivers/usb/usbip/vhci_rx.c
> +++ b/drivers/usb/usbip/vhci_rx.c
> @@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
>  	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
>  
>  	/* recv transfer buffer */
> -	if (usbip_recv_xbuff(ud, urb) < 0)
> -		return;
> +	if (usbip_recv_xbuff(ud, urb) < 0) {
> +		urb->status = -EPIPE;
> +		goto error;
> +	}
>  
>  	/* recv iso_packet_descriptor */
> -	if (usbip_recv_iso(ud, urb) < 0)
> -		return;
> +	if (usbip_recv_iso(ud, urb) < 0) {
> +		urb->status = -EPIPE;
> +		goto error;
> +	}

-EPIPE is used for STALL.  The appropriate error code for transaction 
error would be -EPROTO (or -EILSEQ or -ETIME, but people seem to be 
settling on -EPROTO).

Alan Stern

