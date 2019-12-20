Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA757128088
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 17:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfLTQWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 11:22:47 -0500
Received: from netrider.rowland.org ([192.131.102.5]:57169 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727233AbfLTQWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 11:22:47 -0500
Received: (qmail 7436 invoked by uid 500); 20 Dec 2019 11:22:46 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 20 Dec 2019 11:22:46 -0500
Date:   Fri, 20 Dec 2019 11:22:46 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Johan Hovold <johan@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: core: fix check for duplicate endpoints
In-Reply-To: <20191219161016.6695-1-johan@kernel.org>
Message-ID: <Pine.LNX.4.44L0.1912201121070.5210-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Dec 2019, Johan Hovold wrote:

> Amend the endpoint-descriptor sanity checks to detect all duplicate
> endpoint addresses in a configuration.
> 
> Commit 0a8fd1346254 ("USB: fix problems with duplicate endpoint
> addresses") added a check for duplicate endpoint addresses within a
> single alternate setting, but did not look for duplicate addresses in
> other interfaces.
> 
> The current check would also not detect all duplicate addresses when one
> endpoint is as a (bi-directional) control endpoint.
> 
> This specifically avoids overwriting the endpoint entries in struct
> usb_device when enabling a duplicate endpoint, something which could
> potentially lead to crashes or leaks, for example, when endpoints are
> later disabled.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> Exploiting this to trigger a crash probably requires a lot more
> malicious intent than the syzbot fuzzer currently possesses, but I think
> we need to plug this nonetheless.
> 
> Johan

This is a good improvement.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

>  drivers/usb/core/config.c | 70 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 58 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
> index 5f40117e68e7..21291950cc97 100644
> --- a/drivers/usb/core/config.c
> +++ b/drivers/usb/core/config.c
> @@ -203,9 +203,58 @@ static const unsigned short super_speed_maxpacket_maxes[4] = {
>  	[USB_ENDPOINT_XFER_INT] = 1024,
>  };
>  
> -static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
> -    int asnum, struct usb_host_interface *ifp, int num_ep,
> -    unsigned char *buffer, int size)
> +static bool endpoint_is_duplicate(struct usb_endpoint_descriptor *e1,
> +		struct usb_endpoint_descriptor *e2)
> +{
> +	if (e1->bEndpointAddress == e2->bEndpointAddress)
> +		return true;
> +
> +	if (usb_endpoint_xfer_control(e1) || usb_endpoint_xfer_control(e2)) {
> +		if (usb_endpoint_num(e1) == usb_endpoint_num(e2))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Check for duplicate endpoint addresses in other interfaces and in the
> + * altsetting currently being parsed.
> + */
> +static bool config_endpoint_is_duplicate(struct usb_host_config *config,
> +		int inum, int asnum, struct usb_endpoint_descriptor *d)
> +{
> +	struct usb_endpoint_descriptor *epd;
> +	struct usb_interface_cache *intfc;
> +	struct usb_host_interface *alt;
> +	int i, j, k;
> +
> +	for (i = 0; i < config->desc.bNumInterfaces; ++i) {
> +		intfc = config->intf_cache[i];
> +
> +		for (j = 0; j < intfc->num_altsetting; ++j) {
> +			alt = &intfc->altsetting[j];
> +
> +			if (alt->desc.bInterfaceNumber == inum &&
> +					alt->desc.bAlternateSetting != asnum)
> +				continue;
> +
> +			for (k = 0; k < alt->desc.bNumEndpoints; ++k) {
> +				epd = &alt->endpoint[k].desc;
> +
> +				if (endpoint_is_duplicate(epd, d))
> +					return true;
> +			}
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +static int usb_parse_endpoint(struct device *ddev, int cfgno,
> +		struct usb_host_config *config, int inum, int asnum,
> +		struct usb_host_interface *ifp, int num_ep,
> +		unsigned char *buffer, int size)
>  {
>  	unsigned char *buffer0 = buffer;
>  	struct usb_endpoint_descriptor *d;
> @@ -242,13 +291,10 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
>  		goto skip_to_next_endpoint_or_interface_descriptor;
>  
>  	/* Check for duplicate endpoint addresses */
> -	for (i = 0; i < ifp->desc.bNumEndpoints; ++i) {
> -		if (ifp->endpoint[i].desc.bEndpointAddress ==
> -		    d->bEndpointAddress) {
> -			dev_warn(ddev, "config %d interface %d altsetting %d has a duplicate endpoint with address 0x%X, skipping\n",
> -			    cfgno, inum, asnum, d->bEndpointAddress);
> -			goto skip_to_next_endpoint_or_interface_descriptor;
> -		}
> +	if (config_endpoint_is_duplicate(config, inum, asnum, d)) {
> +		dev_warn(ddev, "config %d interface %d altsetting %d has a duplicate endpoint with address 0x%X, skipping\n",
> +				cfgno, inum, asnum, d->bEndpointAddress);
> +		goto skip_to_next_endpoint_or_interface_descriptor;
>  	}
>  
>  	endpoint = &ifp->endpoint[ifp->desc.bNumEndpoints];
> @@ -522,8 +568,8 @@ static int usb_parse_interface(struct device *ddev, int cfgno,
>  		if (((struct usb_descriptor_header *) buffer)->bDescriptorType
>  		     == USB_DT_INTERFACE)
>  			break;
> -		retval = usb_parse_endpoint(ddev, cfgno, inum, asnum, alt,
> -		    num_ep, buffer, size);
> +		retval = usb_parse_endpoint(ddev, cfgno, config, inum, asnum,
> +				alt, num_ep, buffer, size);
>  		if (retval < 0)
>  			return retval;
>  		++n;
> 

