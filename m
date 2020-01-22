Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98E51456D4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAVNfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:35:51 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34965 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVNfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 08:35:50 -0500
Received: by mail-lj1-f196.google.com with SMTP id j1so6845982lja.2;
        Wed, 22 Jan 2020 05:35:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3fjYpl4wYHR/AXS3qKqxZEP7aK65zfOBP0mwqPGjrtA=;
        b=T0R3PN7F59oDjKQVb8ZJKdQAhCIF41fbyyulNjzP/uS7CekogLqLVE0z4t/4m+exA0
         rP1sbF+jDPCmlsNoaqMkGgFspfMQEa42wwT4Xelz/Z2r+ASiOuFqQhGTd5Wp9cwiat9/
         V3HQB4+fkuUrw1q8HXaEspe0KWLbi+BQ+SP1AmuqsDJgW+sfRa26dhx6S5Npudzy2cTQ
         QCTzFcAOpcSXzDjzIFv91CYDiyNEjrgS8HKZnx4ngp4Qu6grPFU1jkyDD6d2+hwJxdpC
         4yHBA5aDgja8eqnJp66z84A2YZcF3IROihXp9VK1LOb3qqSZj5gYOVbFV79LMJ4fabCw
         da+w==
X-Gm-Message-State: APjAAAX3Byv3HRUMPSWTdoyJqrsNRFRI0wA/Csi5qp+Lpx66XhE2zo0U
        s94Z6MK6L03ef4lmUdWj+kk=
X-Google-Smtp-Source: APXvYqyaa6QEGddsxxgyDC9DIgNiciGftAEetahsfVv5p8N14JImC2X7tcl0L9SvcODXHx7L5DEFLA==
X-Received: by 2002:a2e:9804:: with SMTP id a4mr18980979ljj.10.1579700148682;
        Wed, 22 Jan 2020 05:35:48 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id h7sm21054271lfj.29.2020.01.22.05.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:35:48 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iuGAa-0008Mb-HY; Wed, 22 Jan 2020 14:35:44 +0100
Date:   Wed, 22 Jan 2020 14:35:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>, Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH 2/5] USB: serial: ir-usb: fix link-speed handling
Message-ID: <20200122133544.GE8375@localhost>
References: <20200122101530.29176-1-johan@kernel.org>
 <20200122101530.29176-3-johan@kernel.org>
 <20200122132450.GA3580@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122132450.GA3580@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 02:24:50PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jan 22, 2020 at 11:15:27AM +0100, Johan Hovold wrote:
> > Commit e0d795e4f36c ("usb: irda: cleanup on ir-usb module") added a USB
> > IrDA header with common defines, but mistakingly switched to using the
> > class-descriptor baud-rate bitmask values for the outbound header.
> > 
> > This broke link-speed handling for rates above 9600 baud, but a device
> > would also be able to operate at the default 9600 baud until a
> > link-speed request was issued (e.g. using the TCGETS ioctl).
> 
> People still use this driver/hardware?  And this wasn't found until now?
> wow...

Good question. I was considering just removing the driver, but since it
would have continued to work on low and default link speed I figured I
better just fix it up.

> > Fixes: e0d795e4f36c ("usb: irda: cleanup on ir-usb module")
> > Cc: stable <stable@vger.kernel.org>     # 2.6.27
> > Cc: Felipe Balbi <balbi@kernel.org>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for reviewing.

Johan
