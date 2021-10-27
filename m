Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC4D43C5A7
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbhJ0I5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231566AbhJ0I5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E02660C51;
        Wed, 27 Oct 2021 08:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635324908;
        bh=jsFQ2hTPk1o/ulS9XWmpRn7TcjUOhIqJs34hGUXQZ08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u20JBEpP23dqtrJiBCgr8MYA30VQEXwx5LDZt+duCBCQxoQedfaJVSonFvtc9HwmY
         YYzxtCdI+nvFAA9BlZvmyVdtrYARMlOuTY5N4XgFA9iBgT09sM4vk4s83eM5p8ylB9
         I9JdxW3h0utZCbq8PZS2aeQfEf4IwtIeLJfCFr5Mdtj263MafplBx0efD1Ynsla7/z
         euiqL6tWvcq4HnppBBBf1erMWz8mgiCvopm6ihwFj8pMOyW6TBXSpUyJVJ5V1rroCj
         3lRUqpChMaTzJ1SFT1mqAYSxOpYnR4rMf4TOLqkx582LbKJPd9OxzgQLzKvRD/atDy
         v8DmDcnOiDMPg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfehv-00037H-S0; Wed, 27 Oct 2021 10:54:52 +0200
Date:   Wed, 27 Oct 2021 10:54:51 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Luca Ellero <luca.ellero@brickedbrain.com>
Subject: Re: [PATCH 1/5] comedi: ni_usb6501: fix NULL-deref in command paths
Message-ID: <YXkT24DuZHehBO/b@hovoldconsulting.com>
References: <20211025114532.4599-1-johan@kernel.org>
 <20211025114532.4599-2-johan@kernel.org>
 <be9dcb4f-3594-e756-78e3-74750a49fe91@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be9dcb4f-3594-e756-78e3-74750a49fe91@mev.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 03:12:28PM +0100, Ian Abbott wrote:
> On 25/10/2021 12:45, Johan Hovold wrote:
> > The driver uses endpoint-sized USB transfer buffers but had no sanity
> > checks on the sizes. This can lead to zero-size-pointer dereferences or
> > overflowed transfer buffers in ni6501_port_command() and
> > ni6501_counter_command() if a (malicious) device has smaller max-packet
> > sizes than expected (or when doing descriptor fuzz testing).
> > 
> > Add the missing sanity checks to probe().
> > 
> > Fixes: a03bb00e50ab ("staging: comedi: add NI USB-6501 support")
> > Cc: stable@vger.kernel.org      # 3.18
> > Cc: Luca Ellero <luca.ellero@brickedbrain.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >   drivers/comedi/drivers/ni_usb6501.c | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/comedi/drivers/ni_usb6501.c b/drivers/comedi/drivers/ni_usb6501.c
> > index 5b6d9d783b2f..eb2e5c23f25d 100644
> > --- a/drivers/comedi/drivers/ni_usb6501.c
> > +++ b/drivers/comedi/drivers/ni_usb6501.c
> > @@ -144,6 +144,10 @@ static const u8 READ_COUNTER_RESPONSE[]	= {0x00, 0x01, 0x00, 0x10,
> >   					   0x00, 0x00, 0x00, 0x02,
> >   					   0x00, 0x00, 0x00, 0x00};
> >   
> > +/* Largest supported packets */
> > +static const size_t TX_MAX_SIZE	= sizeof(SET_PORT_DIR_REQUEST);
> > +static const size_t RX_MAX_SIZE	= sizeof(READ_PORT_RESPONSE);
> > +
> >   enum commands {
> >   	READ_PORT,
> >   	WRITE_PORT,
> > @@ -486,12 +490,16 @@ static int ni6501_find_endpoints(struct comedi_device *dev)
> >   		ep_desc = &iface_desc->endpoint[i].desc;
> >   
> >   		if (usb_endpoint_is_bulk_in(ep_desc)) {
> > +			if (usb_endpoint_maxp(ep_desc) < RX_MAX_SIZE)
> > +				continue;
> >   			if (!devpriv->ep_rx)
> >   				devpriv->ep_rx = ep_desc;
> >   			continue;
> >   		}
> >   
> >   		if (usb_endpoint_is_bulk_out(ep_desc)) {
> > +			if (usb_endpoint_maxp(ep_desc) < TX_MAX_SIZE)
> > +				continue;
> >   			if (!devpriv->ep_tx)
> >   				devpriv->ep_tx = ep_desc;
> >   			continue;
> > 
> 
> Perhaps it should return an error if the first encountered bulk-in 
> endpoint has the wrong size or the first encountered bulk-out endpoint 
> has the wrong size. Something like:
> 
> 		if (usb_endpoint_is_bulk_in(ep_desc)) {
> 			if (!devpriv->ep_rx) {
> 				if (usb_endpoint_maxp(ep_desc) < RX_MAX_SIZE)
> 					break;
> 			}
> 			continue;

This is too convoluted, but I can move the max-packet sanity checks
after the endpoint look-ups instead.

It doesn't really matter in the end as the real devices presumably only
have two bulk endpoints.

Johan
