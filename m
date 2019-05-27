Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248BB2B187
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 11:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfE0Joq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 05:44:46 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:50685 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfE0Joq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 05:44:46 -0400
Received: by mail-it1-f193.google.com with SMTP id a186so16040842itg.0;
        Mon, 27 May 2019 02:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5IWtc1Nplr8XJrVmHx2z/tq6KB3yhYMybqEb35DhbU=;
        b=aaoHw03mthV3hb3aSDlbcoAN/D3uFsZqDgKJwr6zqClQElarhwP/e/Gee5IyK46LUo
         sru9K/0EIQTs+UQa9pm23PqoqOOnJjALIZGOegSwKtXmKorIxtxuYLU29FiNf9MKpX14
         7I6PIR+JkiHnTgM0bp2XnrzknzNzfmbqnEPO76NsZNwmlKPjdurpq/32mebNrvwQmG5R
         dXlD5grmFBu8shC8QcDx+OuXXxrF73j92ZIfBgvbQ8hjAr8OKOh7tekjvrecvlNaGuLf
         7VtgIIBX20c/6GjBo9GjagVKgMC/HrqrsMKthX5/QuNp0OnWnYoO9qSdANQxe6HYQitl
         vitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5IWtc1Nplr8XJrVmHx2z/tq6KB3yhYMybqEb35DhbU=;
        b=oRhx4jJrZs7Zje1y8Hzl2hDF9IvgvKY224pS0xZml0LpT6KAanVVyPi7hiMl77nZt7
         E9H3J1eW6vtcHkLd4nuhlukkmyuus1TV7SCatbEFAe7gr/BgLwYVx7Xe7MB//Tbazixc
         BRKVwxY0BccDS8tEJULQhC/safRs83cXFiI+lzKjGv7PSuKiFkQnwkNelk9pnFKfPFJg
         zViJzlaoYLHrrftGAhG+4haANChrTOFRU5l3FP0n2h0ppcubLWdTUFtcoytdqJ6vSuNR
         TZuz2ekKB4Mzvwen8nC8oeIdYvHs+4wBjni5Uh50fiOqF/zckbMARUdDvpEkle+tnTrd
         uW+w==
X-Gm-Message-State: APjAAAUayhqG4FM7FMWr6bBhjbTOUArM72bOYSFuXO0fMnl/iFR7o/zp
        r5WgNZPO5T3NTrT7BLTvSNiK2PR3Av+P1uaJAag=
X-Google-Smtp-Source: APXvYqxIUZUvevqdI7bMDN9gJkebIJ/5iWR+PRttW8X9e7pHr/RBT/0qn6DsZwhAQN8rgHNIYpRx3KIlnsT3IdIVpi8=
X-Received: by 2002:a02:3b12:: with SMTP id c18mr32617367jaa.44.1558950285596;
 Mon, 27 May 2019 02:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190527074222.42970-1-peter.chen@nxp.com> <64ff033b-7f7e-ad91-ac06-73ebd8565286@cogentembedded.com>
In-Reply-To: <64ff033b-7f7e-ad91-ac06-73ebd8565286@cogentembedded.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Mon, 27 May 2019 17:44:34 +0800
Message-ID: <CAL411-ouY92Yk2TGqdx9KuhT71p=qEcSC426JwmerBmFAXd+=A@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: chipidea: udc: workaround for endpoint conflict issue
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Peter Chen <peter.chen@nxp.com>, linux-usb@vger.kernel.org,
        linux-imx@nxp.com, stable@vger.kernel.org, Jun Li <jun.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 5:04 PM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
> On 27.05.2019 10:42, Peter Chen wrote:
>
> > An endpoint conflict occurs when the USB is working in device mode
> > during an isochronous communication. When the endpointA IN direction
> > is an isochronous IN endpoint, and the host sends an IN token to
> > endpointA on another device, then the OUT transaction may be missed
> > regardless the OUT endpoint number. Generally, this occurs when the
> > device is connected to the host through a hub and other devices are
> > connected to the same hub.
> >
> > The affected OUT endpoint can be either control, bulk, isochronous, or
> > an interrupt endpoint. After the OUT endpoint is primed, if an IN token
> > to the same endpoint number on another device is received, then the OUT
> > endpoint may be unprimed (cannot be detected by software), which causes
> > this endpoint to no longer respond to the host OUT token, and thus, no
> > corresponding interrupt occurs.
> >
> > There is no good workaround for this issue, the only thing the software
> > could do is numbering isochronous IN from the highest endpoint since we
> > have observed most of device number endpoint from the lowest.
> >
> > Cc: <stable@vger.kernel.org> #v3.14+
> > Cc: Jun Li <jun.li@nxp.com>
> > Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > ---
> >   drivers/usb/chipidea/udc.c | 24 ++++++++++++++++++++++++
> >   1 file changed, 24 insertions(+)
> >
> > diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
> > index 829e947cabf5..411d387a45c9 100644
> > --- a/drivers/usb/chipidea/udc.c
> > +++ b/drivers/usb/chipidea/udc.c
> > @@ -1622,6 +1622,29 @@ static int ci_udc_pullup(struct usb_gadget *_gadget, int is_on)
> >   static int ci_udc_start(struct usb_gadget *gadget,
> >                        struct usb_gadget_driver *driver);
> >   static int ci_udc_stop(struct usb_gadget *gadget);
> > +
> > +
> > +/* Match ISOC IN from the highest endpoint */
> > +static struct
>
>     Um, please break the line before the function's type is fully described.
>
> > +usb_ep *ci_udc_match_ep(struct usb_gadget *gadget,
> > +                           struct usb_endpoint_descriptor *desc,
> > +                           struct usb_ss_ep_comp_descriptor *comp_desc)
> > +{
> > +     struct ci_hdrc *ci = container_of(gadget, struct ci_hdrc, gadget);
> > +     struct usb_ep *ep;
> > +     u8 type = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> > +
> > +     if ((type == USB_ENDPOINT_XFER_ISOC) &&
> > +             (desc->bEndpointAddress & USB_DIR_IN)) {
>
>     Please add 1 more tab here, so that this line doesn't blend with the
> following statement.
>
> > +             list_for_each_entry_reverse(ep, &ci->gadget.ep_list, ep_list) {
> > +                     if (ep->caps.dir_in && !ep->claimed)
> > +                             return ep;
> > +             }
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> >   /**
> >    * Device operations part of the API to the USB controller hardware,
> >    * which don't involve endpoints (or i/o)

Will change both comments, thanks.

Peter
