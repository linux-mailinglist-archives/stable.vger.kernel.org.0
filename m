Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0343B37E1
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 22:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhFXUe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 16:34:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232163AbhFXUe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 16:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DQaVe3svyqtnMuTAQBTKyVNiLfF5PLoMKvvy1C7mW1A=; b=ijwSo6GU38nyg5zIJU9iXy83Vs
        CZilmBC5pEFAycYay1pNJsMetUPMd+sr+MSak1aPo0Tu8CQ6c1BWPbLdkHwsIrlOC2VFw0tSlY56g
        4fUwWHWH3j/HlY8APC+9zSBFkHQcvJIaeQP47LulKI9y6+PyAHv6jzi7mdPC/DJ4cVKk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwW17-00B1gI-7R; Thu, 24 Jun 2021 22:32:05 +0200
Date:   Thu, 24 Jun 2021 22:32:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wolfram Sang <wsa@kernel.org>, Johan Hovold <johan@kernel.org>,
        linux-i2c@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: robotfuzz-osif: fix control-request directions
Message-ID: <YNTrxT9gRrfMlN+2@lunn.ch>
References: <20210524090912.3989-1-johan@kernel.org>
 <YNL2NLSpBQqnc2bH@hovoldconsulting.com>
 <YNTmqcrYb9KzW8Zh@kunai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNTmqcrYb9KzW8Zh@kunai>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 24, 2021 at 10:10:17PM +0200, Wolfram Sang wrote:
> On Wed, Jun 23, 2021 at 10:52:04AM +0200, Johan Hovold wrote:
> > On Mon, May 24, 2021 at 11:09:12AM +0200, Johan Hovold wrote:
> > > The direction of the pipe argument must match the request-type direction
> > > bit or control requests may fail depending on the host-controller-driver
> > > implementation.
> > > 
> > > Control transfers without a data stage are treated as OUT requests by
> > > the USB stack and should be using usb_sndctrlpipe(). Failing to do so
> > > will now trigger a warning.
> > > 
> > > Fix the OSIFI2C_SET_BIT_RATE and OSIFI2C_STOP requests which erroneously
> > > used the osif_usb_read() helper and set the IN direction bit.
> > > 
> > > Reported-by: syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com
> > > Fixes: 83e53a8f120f ("i2c: Add bus driver for for OSIF USB i2c device.")
> > > Cc: stable@vger.kernel.org      # 3.14
> > > Cc: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > 
> > Wolfram, can you pick this one up for 5.14?
> 
> Sorry, I thought Andrew was the maintainer of this driver and was
> waiting for his ack.

Ah, sorry. I did take a quick look at the change, it seemed
sensible. But i've not used this hardware in years, i have no way to
test it, etc.

     Andrew
