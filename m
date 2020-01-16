Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0982513DFEA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgAPQVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:21:13 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41354 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgAPQVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:21:13 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so23335812ljc.8;
        Thu, 16 Jan 2020 08:21:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Oyv6HUhQJ+ugxt03sULpvXf+nEqbMw6YaCFbn4jEVg=;
        b=qPeBh4HB/hG5xxZfLXGGpsPWVdIj7f2qFYo8BvC66wqnQrHmlaO+NzrHITZPwh/FvY
         OlR7/MM+Il1c2alDCyMOOBx0vWe+O8wJfJxsjPkJpJ0yZuTlzfZUBUsefRiMufpLwmrd
         dSQY/W68J4HuU/WkmrcmNDjdTMV2JDsO8heNbDMwH+/Nkg7DW6KBp/WICNSIm+J1lzqD
         iP2WJLX3hffmOvFEv60iUqsb/MLTKwMD/YxDbnbazYEXICPk4sJvqEm3uiMpSwfd697s
         Sk1t9kCWHdEvJusHvOIG+XG7StBviJklLStcMAtW6rjVy3SAH2+3tmkBzE9k+lC3Sfn0
         /jcw==
X-Gm-Message-State: APjAAAUEXFg2Pd55OdgJzvV74rq6HHoQQrH6MQ5OfTvaxrLGjgg573Fp
        jzmEL6JWVeA2Aawhxfam+XLk/Ogf
X-Google-Smtp-Source: APXvYqxtYxg9uZ2T0HP/gexGAeygGVRNpFPcMqdEN+h24fzwD29kOHYc6c8h4nZ0TD/swcDyZzZD3w==
X-Received: by 2002:a2e:916:: with SMTP id 22mr2873167ljj.60.1579191670678;
        Thu, 16 Jan 2020 08:21:10 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id l21sm10777444lfh.74.2020.01.16.08.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:21:09 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1is7tN-0001RS-9s; Thu, 16 Jan 2020 17:21:09 +0100
Date:   Thu, 16 Jan 2020 17:21:09 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] USB: serial: opticon: stop all I/O on close()
Message-ID: <20200116162109.GO2301@localhost>
References: <20200114110146.5929-1-johan@kernel.org>
 <20200114110146.5929-2-johan@kernel.org>
 <20200114121857.GB1503960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114121857.GB1503960@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 01:18:57PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 14, 2020 at 12:01:46PM +0100, Johan Hovold wrote:
> > Make sure to stop any submitted write URBs on close(). This specifically
> > avoids a NULL-pointer dereference or use-after-free in case of a late
> > completion event after driver unbind.
> > 
> > Fixes: 648d4e16567e ("USB: serial: opticon: add write support")
> > Cc: stable <stable@vger.kernel.org>	# 2.6.30: xxx: USB: serial: opticon: add chars_in_buffer() implementation
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for the review.

I just submitted a patch preventing individual ports from being unbound,
which almost no USB-serial driver can handle generally without crashing.

And as USB core handles the case were the USB interface driver is
unbound, this one doesn't fix anything critical.

So I'll apply this for -next with the following updated commit message:

    USB: serial: opticon: stop all I/O on close()
    
    Make sure to stop any submitted write URBs on close().
    
    Note that the tty layer will wait up to 30 seconds for the buffers to
    drain before close() is called.

and drop the Fixes and stable tags instead.

Johan
