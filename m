Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DDB2F896
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 10:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfE3Iaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 04:30:39 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35107 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfE3Iaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 04:30:39 -0400
Received: by mail-lj1-f196.google.com with SMTP id h11so5247487ljb.2
        for <stable@vger.kernel.org>; Thu, 30 May 2019 01:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/1crWiF562CDI9B6MQnp+qBczed5VahJW87q5+4ix9g=;
        b=zUtJYe9OZ6ZcCyqiKk+6KGEr5BbPf2gOYNpRNVkgrz7+yY1Ro0wn92bPs6fKalli3j
         wh5x3wAhnPUnRyTl7E84g5a3TvS1ZCOLtk+lA+gplHQpao+xhJXskSxnwzpFKkP66vTe
         kY8fsrOc8vkYvfCPnqHLgnh7mgCBECyA9fwuTM/1IyNSUAFkjmP51NHH/6BIVuGwJcMN
         W6psu1KH6f1b0Ewvyss7QBvgm3ZsnXJ29tbdHVAc22DgQozyhLSa+JhpfGfWGz+RgEbr
         wXIekZpzAzmF/mHnVtJHYeYBR+QifXJRhQ0cd13n5ScOwlMBfYNPedcKl+OGX48y/xOF
         OKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/1crWiF562CDI9B6MQnp+qBczed5VahJW87q5+4ix9g=;
        b=OXxjKiGxX3TZN28CxTgKQfl6ro7MgDiP6kTZRZxiLtdqEsh7Y3Qze+B9HwGB5YBnMD
         GfqheG3iZSFo+cIUttT+iGXxXbfHV7c84arEZBzw7zHq8QE+rhpqPyv1OcD6SW7KMHlH
         He7x8u5FzqL5A9L8esLihS9b7QWQ3t6/SULSJyCEKWK+PL2tfm79Hu62LDNnnZ1RcKQp
         GZ0VGje6wq9koySLCsApUWZ3ISf1vX79TMgi7H4WDq5kaDbPnquE6SsJ4Wzh4RFB+TSm
         qJP2eEv59PaHD9t3TVFjD0rCw6zAUuCQvFLWvRDiPiqk17Wyypm8uFXgZ4tNnqDDBK4g
         dHWA==
X-Gm-Message-State: APjAAAVfEIadvILPyH8zQzIPQ0ZYgWGqKuPl3ZmcPhD2mU/sgdJtKDvb
        2pIes4+3fZFXsoDaSao5as68nQ==
X-Google-Smtp-Source: APXvYqxGfsgTW7yHj/AYhTuGJL0qm4wwyatngeRc3XknlFAq1yhrKek602C3buhC2/ROCp1OOV77xw==
X-Received: by 2002:a2e:5b18:: with SMTP id p24mr1369678ljb.50.1559204603276;
        Thu, 30 May 2019 01:23:23 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.85.229])
        by smtp.gmail.com with ESMTPSA id s6sm336548lje.89.2019.05.30.01.23.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:23:22 -0700 (PDT)
Subject: Re: [PATCH 1/1] usb: chipidea: udc: workaround for endpoint conflict
 issue
To:     Peter Chen <peter.chen@nxp.com>, linux-usb@vger.kernel.org
Cc:     linux-imx@nxp.com, stable@vger.kernel.org, Jun Li <jun.li@nxp.com>
References: <20190530064505.6292-1-peter.chen@nxp.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <2036f4d4-1d5d-f0b3-f0cb-5df59cc91be9@cogentembedded.com>
Date:   Thu, 30 May 2019 11:22:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530064505.6292-1-peter.chen@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 30.05.2019 9:45, Peter Chen wrote:

> An endpoint conflict occurs when the USB is working in device mode
> during an isochronous communication. When the endpointA IN direction
> is an isochronous IN endpoint, and the host sends an IN token to
> endpointA on another device, then the OUT transaction may be missed
> regardless the OUT endpoint number. Generally, this occurs when the
> device is connected to the host through a hub and other devices are
> connected to the same hub.
> 
> The affected OUT endpoint can be either control, bulk, isochronous, or
> an interrupt endpoint. After the OUT endpoint is primed, if an IN token
> to the same endpoint number on another device is received, then the OUT
> endpoint may be unprimed (cannot be detected by software), which causes
> this endpoint to no longer respond to the host OUT token, and thus, no
> corresponding interrupt occurs.
> 
> There is no good workaround for this issue, the only thing the software
> could do is numbering isochronous IN from the highest endpoint since we
> have observed most of device number endpoint from the lowest.
> 
> Cc: <stable@vger.kernel.org> #v3.14+
> Cc: Jun Li <jun.li@nxp.com>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
> Changes for v2:
> - Some coding style improvements

    Nothing really changed in the patch... :-/

>   drivers/usb/chipidea/udc.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
> index 829e947cabf5..411d387a45c9 100644
> --- a/drivers/usb/chipidea/udc.c
> +++ b/drivers/usb/chipidea/udc.c
> @@ -1622,6 +1622,29 @@ static int ci_udc_pullup(struct usb_gadget *_gadget, int is_on)
>   static int ci_udc_start(struct usb_gadget *gadget,
>   			 struct usb_gadget_driver *driver);
>   static int ci_udc_stop(struct usb_gadget *gadget);
> +
> +
> +/* Match ISOC IN from the highest endpoint */
> +static struct
> +usb_ep *ci_udc_match_ep(struct usb_gadget *gadget,

    Here...

> +			      struct usb_endpoint_descriptor *desc,
> +			      struct usb_ss_ep_comp_descriptor *comp_desc)
> +{
> +	struct ci_hdrc *ci = container_of(gadget, struct ci_hdrc, gadget);
> +	struct usb_ep *ep;
> +	u8 type = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +
> +	if ((type == USB_ENDPOINT_XFER_ISOC) &&
> +		(desc->bEndpointAddress & USB_DIR_IN)) {

    ... and here.

> +		list_for_each_entry_reverse(ep, &ci->gadget.ep_list, ep_list) {
> +			if (ep->caps.dir_in && !ep->claimed)
> +				return ep;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
>   /**
>    * Device operations part of the API to the USB controller hardware,
>    * which don't involve endpoints (or i/o)
[...]

MBR, Sergei
