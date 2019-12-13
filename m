Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B2211DBF0
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 03:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfLMCD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 21:03:29 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38363 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfLMCD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 21:03:29 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so727656pgm.5;
        Thu, 12 Dec 2019 18:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=sbQiyJc/inLjRaokZh7Q8U9UkbILv57sjMdX8isP4Mo=;
        b=GoJvGU/pGNn2G/E7yRVTN1E+5omlN/INnTODmiCukTeBCtVV93jNiI7auavjP+VNfB
         LKgnRr0LrIWAlifLg+wn9qlbpcx5pX5DWp5PRQQP7Ls6cKQBjx2LrLq8DLpBk21Fd8ey
         dsV8/8EZZ61gPmzFEHciUaWIgk1LGUkGxzuPiG+tAPvBE/M5npuCcN3qRIsPPPyRQr7K
         FUwh1+V/brjSEO4pMmIZXDFGSRd8P5DaZW5m6gMnxaSKJXgjnI41DRCgJqlowmdWrvJ3
         cyZrZutJtW3mSVFgRujqCTgKJuzeC+ymvIXoRuoz08F3C2DfWGk0PtGXIlRETRyClng3
         6fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=sbQiyJc/inLjRaokZh7Q8U9UkbILv57sjMdX8isP4Mo=;
        b=nPeMmsSuIqPp/qyH3/msJ/1UvooVR6BsmWK34EMt/6hSBseITRbuTj3waCBOqEgShU
         YzbjyhqCutcJo/KPd3lPtIQwun6PDmeMcaBynqU3hr1vmkwYb/JrZ+MhM0xzKMiV5UbL
         GR027jF3Uc5SwFkSpTb+9fOdrPLtwTOK0Qup6M2x7SVIWmQgw+Mx34yFDeWIlQEo5ayI
         CZ00HQCZV7ZVQ9Pn6GvbG52dKiznC6DZ3UC5abi571h/aNmjmUzwFELxZD6+rvHWy/XW
         0P5fVWM1vMJDBg/bKGKxAof7lFd4sB/CK1oiZydK3v/9aPg7jRDm1H0NdpRovUSbKrMW
         m38Q==
X-Gm-Message-State: APjAAAVVXqFIJ9qmrV5obh2CDEFKjZWB2iMj3EpjlS8EMDKKdfsDmcnL
        hkOIGGD5tA7L/hT2h0ZWIlE=
X-Google-Smtp-Source: APXvYqyCa8C9agmQfMzONvcN2uCU48yrCEeTvqttPet6mVz18Q2EdYaTOi0HVYAYkNIVj6V22w49kA==
X-Received: by 2002:a63:5950:: with SMTP id j16mr14651502pgm.314.1576202608242;
        Thu, 12 Dec 2019 18:03:28 -0800 (PST)
Received: from localhost.localdomain ([163.152.162.99])
        by smtp.gmail.com with ESMTPSA id i68sm8886098pfe.173.2019.12.12.18.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 18:03:27 -0800 (PST)
Date:   Fri, 13 Dec 2019 11:03:17 +0900
From:   Suwan Kim <suwan.kim027@gmail.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] usbip: Fix error path of vhci_recv_ret_submit()
Message-ID: <20191213020317.GA3276@localhost.localdomain>
References: <20191212052841.6734-3-suwan.kim027@gmail.com>
 <Pine.LNX.4.44L0.1912121050130.14053-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1912121050130.14053-100000@netrider.rowland.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 10:54:08AM -0500, Alan Stern wrote:
> On Thu, 12 Dec 2019, Suwan Kim wrote:
> 
> > If a transaction error happens in vhci_recv_ret_submit(), event
> > handler closes connection and changes port status to kick hub_event.
> > Then hub tries to flush the endpoint URBs, but that causes infinite
> > loop between usb_hub_flush_endpoint() and vhci_urb_dequeue() because
> > "vhci_priv" in vhci_urb_dequeue() was already released by
> > vhci_recv_ret_submit() before a transmission error occurred. Thus,
> > vhci_urb_dequeue() terminates early and usb_hub_flush_endpoint()
> > continuously calls vhci_urb_dequeue().
> > 
> > The root cause of this issue is that vhci_recv_ret_submit()
> > terminates early without giving back URB when transaction error
> > occurs in vhci_recv_ret_submit(). That causes the error URB to still
> > be linked at endpoint list without “vhci_priv".
> > 
> > So, in the case of trasnaction error in vhci_recv_ret_submit(),
> > unlink URB from the endpoint, insert proper error code in
> > urb->status and give back URB.
> > 
> > Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> > Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
> > ---
> >  drivers/usb/usbip/vhci_rx.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
> > index 33f8972ba842..dc26acad6baf 100644
> > --- a/drivers/usb/usbip/vhci_rx.c
> > +++ b/drivers/usb/usbip/vhci_rx.c
> > @@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
> >  	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
> >  
> >  	/* recv transfer buffer */
> > -	if (usbip_recv_xbuff(ud, urb) < 0)
> > -		return;
> > +	if (usbip_recv_xbuff(ud, urb) < 0) {
> > +		urb->status = -EPIPE;
> > +		goto error;
> > +	}
> >  
> >  	/* recv iso_packet_descriptor */
> > -	if (usbip_recv_iso(ud, urb) < 0)
> > -		return;
> > +	if (usbip_recv_iso(ud, urb) < 0) {
> > +		urb->status = -EPIPE;
> > +		goto error;
> > +	}
> 
> -EPIPE is used for STALL.  The appropriate error code for transaction 
> error would be -EPROTO (or -EILSEQ or -ETIME, but people seem to be 
> settling on -EPROTO).

Thanks for the feedback. I will fix it :)

Regards,
Suwan Kim
