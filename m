Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2656443B281
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 14:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhJZMgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 08:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhJZMgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 08:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D19460EBD;
        Tue, 26 Oct 2021 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635251653;
        bh=OgXTpTqGy+Puhv4DfZesA7ODv5bRJ4Hhhmq8mNydSYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UIuWKZ5B4Yqs5ADcEeVsg2EKfFDwtukCsjYhTxnxGoDOR+kfBHhpZbxOqnwxFqm/3
         EcXK/xMg19Pgy0gp8hU1cC0U+szZgAt4w3OZVajA2+hLSI6uvw1DuCK0xnVSqSZMsA
         QJ8AVXz5y/PIBhKFQjF6gyF/jjkII2IahuVzngghZTy8TcuheJivukuXIfB4VPUnYd
         ztz0eJ4PMVlSu6KOGbFhdmYKOUpONik7cI1TIRDSXb4H3QiwFW50YqHmYEpTE+b5Ph
         D/GO1Y6G2DCI5JoJYuiAKH09ReLKSMV7gfEcLizcdz6Ozy7rzL5cNFPpxfnHS4Kmhr
         0tVEVQIbNB9nQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfLeP-0001j9-Bo; Tue, 26 Oct 2021 14:33:57 +0200
Date:   Tue, 26 Oct 2021 14:33:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.14 165/169] usbnet: sanity check for maxpacket
Message-ID: <YXf1tdKi0b0M4XCx@hovoldconsulting.com>
References: <20211025191017.756020307@linuxfoundation.org>
 <20211025191038.360463849@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025191038.360463849@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:15:46PM +0200, Greg Kroah-Hartman wrote:
> From: Oliver Neukum <oneukum@suse.com>
> 
> commit 397430b50a363d8b7bdda00522123f82df6adc5e upstream.
> 
> maxpacket of 0 makes no sense and oopses as we need to divide
> by it. Give up.
> 
> V2: fixed typo in log and stylistic issues
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
> Reviewed-by: Johan Hovold <johan@kernel.org>
> Link: https://lore.kernel.org/r/20211021122944.21816-1-oneukum@suse.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Please drop this one from all stable queues until

	https://lore.kernel.org/r/20211026124015.3025136-1-wanghai38@huawei.com

has landed.

> ---
>  drivers/net/usb/usbnet.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1788,6 +1788,10 @@ usbnet_probe (struct usb_interface *udev
>  	if (!dev->rx_urb_size)
>  		dev->rx_urb_size = dev->hard_mtu;
>  	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
> +	if (dev->maxpacket == 0) {
> +		/* that is a broken device */
> +		goto out4;
> +	}
>  
>  	/* let userspace know we have a random address */
>  	if (ether_addr_equal(net->dev_addr, node_id))

Johan
