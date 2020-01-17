Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B78C140864
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 11:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgAQKxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 05:53:20 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37955 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgAQKxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 05:53:20 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so18012161lfm.5;
        Fri, 17 Jan 2020 02:53:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UEInedYznmpXOIQGT+R+Gws+vggxod54NAgVi43UacQ=;
        b=NvQ5WbfqUNgg8xyaW8UsfoVbHsxkgMhauRPU10YMcJTaaJ9XhUFeKCy0qUzFI0j9nw
         xu+tzX/r72RqYOK3JvLDTTzWbaje3u/SxMVYUkvrKOWsB76bslfDPPYwMbcMEoO9Dp5z
         VqdJ2O1szkloP6jJUNcjLFIf4CRVGE/Kh2MF74d7Kyheq9rcLtUa5KaX+xoVpyIzcwn6
         7L9qRlU9f0ugbkVnxIF+aU0DXiMubDk3BTGlqgkOviLhcOjFKsZISgy1LmwUhFccq2Lc
         VrSABDxmaIUGFZI8ytq4xPgZkYE++nS4dDnXS+JUybGP4x0sSvyYi3DhHhLpEw4HeHWD
         uiCQ==
X-Gm-Message-State: APjAAAUVcgviSGWADgOgDw+JJLlvA08sfNY5usqIEYi9hUhuv4FFMAiJ
        JpipoCka3afgrtnPC4GT+h/jONFc
X-Google-Smtp-Source: APXvYqxT0bqjvtaQGICAtv2B3j0ZD2AFXuBkMGenlc7XNdj9S/5Ir4k+Ri0LYu5w29Kpj9HrskR3cg==
X-Received: by 2002:ac2:4436:: with SMTP id w22mr5047439lfl.185.1579258398755;
        Fri, 17 Jan 2020 02:53:18 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id l1sm11794816lfj.71.2020.01.17.02.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 02:53:18 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1isPFd-0001kv-Iq; Fri, 17 Jan 2020 11:53:17 +0100
Date:   Fri, 17 Jan 2020 11:53:17 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5/5] USB: serial: quatech2: handle unbound ports
Message-ID: <20200117105317.GU2301@localhost>
References: <20200117095026.27655-1-johan@kernel.org>
 <20200117095026.27655-6-johan@kernel.org>
 <20200117103639.GA1835567@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117103639.GA1835567@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 11:36:39AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 17, 2020 at 10:50:26AM +0100, Johan Hovold wrote:
> > Check for NULL port data in the event handlers to avoid dereferencing a
> > NULL pointer in the unlikely case where a port device isn't bound to a
> > driver (e.g. after an allocation failure on port probe).
> > 
> > Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
> > Cc: stable <stable@vger.kernel.org>     # 3.5
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/quatech2.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
> > index a62981ca7a73..c76a2c0c32ff 100644
> > --- a/drivers/usb/serial/quatech2.c
> > +++ b/drivers/usb/serial/quatech2.c
> > @@ -470,6 +470,13 @@ static int get_serial_info(struct tty_struct *tty,
> >  
> >  static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
> >  {
> > +	struct qt2_port_private *port_priv;
> > +
> > +	/* May be called from qt2_process_read_urb() for an unbound port. */
> > +	port_priv = usb_get_serial_port_data(port);
> > +	if (!port_priv)
> > +		return;
> > +
> 
> Where is the null dereference here?  Will port be NULL somehow?

The NULL-dereference happens in qt2_update_lsr() and qt2_update_msr()
called below.

> >  	switch (*ch) {
> >  	case QT2_LINE_STATUS:
> >  		qt2_update_lsr(port, ch + 1);
> > @@ -484,14 +491,27 @@ static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
> >  static void qt2_process_xmit_empty(struct usb_serial_port *port,
> >  				   unsigned char *ch)
> >  {
> > +	struct qt2_port_private *port_priv;
> >  	int bytes_written;
> >  
> > +	/* May be called from qt2_process_read_urb() for an unbound port. */
> > +	port_priv = usb_get_serial_port_data(port);
> > +	if (!port_priv)
> > +		return;
> > +
> >  	bytes_written = (int)(*ch) + (int)(*(ch + 1) << 4);
> 
> What's the harm in doing a pointless calculation here?  Nothing seems to
> happen in this function at all.

Right, none at all.

Both of these handler appear to be here for documentation purposes. In
case any one ever adds code here, they need to be aware that the port
data may be NULL.

I should have mentioned this in the commit message and perhaps split
the last two checks in a separate patch as they do not need to be
backported. 

The alternative would be a more intrusive change handling an unbound
port entirely in qt2_process_read_urb().

> >  }
> >  
> >  /* not needed, kept to document functionality */
> >  static void qt2_process_flush(struct usb_serial_port *port, unsigned char *ch)
> >  {
> > +	struct qt2_port_private *port_priv;
> > +
> > +	/* May be called from qt2_process_read_urb() for an unbound port. */
> > +	port_priv = usb_get_serial_port_data(port);
> > +	if (!port_priv)
> > +		return;
> > +
> >  	return;
> >  }
> 
> This whole function can just be removed, right?

Yep, just "kept to document functionality" the header says.

I'll respin this last one in some way, thanks.

Johan
