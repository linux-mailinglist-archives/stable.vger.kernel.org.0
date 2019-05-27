Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C490A2B0D6
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 11:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfE0JCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 05:02:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41213 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfE0JCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 05:02:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id q16so5633016ljj.8
        for <stable@vger.kernel.org>; Mon, 27 May 2019 02:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6arzR4YqGkPBtzu2gWocYl0obqGAIolw8EGTgdOvIUU=;
        b=b4RUeQi/s23zo3nPQkRYvzxoulyLr7jeWrIO3eIMalLbHS00BHQocmrEthMXUVEGSm
         hu4a9HhSiPdEyW46ZZlVXqmlfFPupEbadClzHYpaTzNbXPlsvSJy7G7zJmzJGZSRnLQx
         qckHlcWPZ9tC1L9bJWnQtPusAgE9urg8p4BfFjWsyQyEp8uWigfBNN8dpeJcTYiBcrv5
         /LLqg1wrtew5qzWuLSJt0IGXNxu9BnNlzlH5imY7/HgGXLCU/bfOsfEM2bWBWLI+xHNK
         SwUlx6ixCmqzc4R7GRY6dG3QGiQ9MLL2eaLecbdyIoLY3Tfn2JYiMFVxAk6ZXUpP3Ob5
         b7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6arzR4YqGkPBtzu2gWocYl0obqGAIolw8EGTgdOvIUU=;
        b=dg1SDEtQf7kW4klGZc3Tm2NFA0Ls+GK/0W4VtDLApjPB8wYHj0CLBYfPhBuUQd42sd
         QbTJFXnUdW1jiiPnF9FmkIHGSGEvWHHahSk6mRv29lgt2ccI3qYIJ4yndd2L+7DH1LC2
         6O3HjCn9r9M2FYPiczNoYPW0w0DwNjPpyelC41WQrZcw9rTa+bra5A0X2BoYAuYjWxeH
         kuonCSwHWXkZx6/aDEr2otYdmxo/FbY1ONGP6MFT5JjN3nTAocdu79ina53qpup2ZjrL
         vyVFHK/mcGt26kM+qrK/B10Zc7hTEjTg/V9IfFsSsbsAhagiPNVPGdBaV7Bt8M+zRYfk
         jBGA==
X-Gm-Message-State: APjAAAXnOlVdqfvjhc3ItMYhsqdxA/4HsXA9fr5tJIEmA6ahs0ElqfRg
        iliG5HzX5KTNRNDHZsS+hpH6UA==
X-Google-Smtp-Source: APXvYqxdBYrX+A2WgE/LteTx9xZ3ROczreDP92CLwLumO9BmnlGXdd+d2JHRxOgHAoIBD9iGiM6COQ==
X-Received: by 2002:a2e:88ce:: with SMTP id a14mr17873999ljk.122.1558947758189;
        Mon, 27 May 2019 02:02:38 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.155])
        by smtp.gmail.com with ESMTPSA id 8sm2162520lft.97.2019.05.27.02.02.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 02:02:37 -0700 (PDT)
Subject: Re: [PATCH 1/1] usb: chipidea: udc: workaround for endpoint conflict
 issue
To:     Peter Chen <peter.chen@nxp.com>, linux-usb@vger.kernel.org
Cc:     linux-imx@nxp.com, stable@vger.kernel.org, Jun Li <jun.li@nxp.com>
References: <20190527074222.42970-1-peter.chen@nxp.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <64ff033b-7f7e-ad91-ac06-73ebd8565286@cogentembedded.com>
Date:   Mon, 27 May 2019 12:02:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527074222.42970-1-peter.chen@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.05.2019 10:42, Peter Chen wrote:

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

    Um, please break the line before the function's type is fully described.

> +usb_ep *ci_udc_match_ep(struct usb_gadget *gadget,
> +			      struct usb_endpoint_descriptor *desc,
> +			      struct usb_ss_ep_comp_descriptor *comp_desc)
> +{
> +	struct ci_hdrc *ci = container_of(gadget, struct ci_hdrc, gadget);
> +	struct usb_ep *ep;
> +	u8 type = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +
> +	if ((type == USB_ENDPOINT_XFER_ISOC) &&
> +		(desc->bEndpointAddress & USB_DIR_IN)) {

    Please add 1 more tab here, so that this line doesn't blend with the 
following statement.

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
