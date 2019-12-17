Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8AE12302C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 16:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfLQPXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 10:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbfLQPXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 10:23:23 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB15D2072D;
        Tue, 17 Dec 2019 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576596202;
        bh=AWr53SZL6zU34wrDAuOc2PlBHR0vANdc062K7fLZoIA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=zMuAk80CRLTlgF5FRyg46dH0PWyW0TyFaSPmNu7ODQdpeBYHwNKv/Im1JDoIeMyEc
         trDdXpMBDaWWzsdE08cgYdIl3dZ+GIrKJSFyND0pqB+pMzi9apL0XRlyvFfHCJyY9m
         Ed4RniaX0lggCQB6edP3vZ7sYT0OA7v1nw2KCK2s=
Subject: Re: [PATCH v2 2/2] usbip: Fix error path of vhci_recv_ret_submit()
To:     Suwan Kim <suwan.kim027@gmail.com>, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        shuah <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
References: <20191213023055.19933-1-suwan.kim027@gmail.com>
 <20191213023055.19933-3-suwan.kim027@gmail.com>
From:   shuah <shuah@kernel.org>
Message-ID: <d72b3f16-3fc4-dd62-b51f-5a9ce68cfb4d@kernel.org>
Date:   Tue, 17 Dec 2019 08:23:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213023055.19933-3-suwan.kim027@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/19 7:30 PM, Suwan Kim wrote:
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
> So, in the case of transaction error in vhci_recv_ret_submit(),
> unlink URB from the endpoint, insert proper error code in
> urb->status and give back URB.
> 
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
> ---
>   drivers/usb/usbip/vhci_rx.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
> index 33f8972ba842..00fc98741c5d 100644
> --- a/drivers/usb/usbip/vhci_rx.c
> +++ b/drivers/usb/usbip/vhci_rx.c
> @@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
>   	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
>   
>   	/* recv transfer buffer */
> -	if (usbip_recv_xbuff(ud, urb) < 0)
> -		return;
> +	if (usbip_recv_xbuff(ud, urb) < 0) {
> +		urb->status = -EPROTO;
> +		goto error;
> +	}
>   
>   	/* recv iso_packet_descriptor */
> -	if (usbip_recv_iso(ud, urb) < 0)
> -		return;
> +	if (usbip_recv_iso(ud, urb) < 0) {
> +		urb->status = -EPROTO;
> +		goto error;
> +	}
>   
>   	/* restore the padding in iso packets */
>   	usbip_pad_iso(ud, urb);
>   
> +error:
>   	if (usbip_dbg_flag_vhci_rx)
>   		usbip_dump_urb(urb);
>   
> 

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
