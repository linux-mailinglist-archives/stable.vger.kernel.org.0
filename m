Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A09ACB6B1
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 10:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbfJDIyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 04:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbfJDIyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 04:54:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F4921848;
        Fri,  4 Oct 2019 08:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570179290;
        bh=7pBtZWVSbsYAd5KnurK91a0H19J66T3/kC0+VsvmiiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l9jHef6LHhrUSbUaHCTgb87viMVlcpfy5LOAoZ05ID2QMyHSuKPTe3WAbkNkYpXag
         WNkDRPkbKTA3WZouN4Bvffu/YAzXSi+HgdbP/1jU2xUkQ1H+xkHJdoQJeQq99KfOv6
         RuiXzLKJbuPvtfuNPsG7Fjxks4QZxMKqctQI4njE=
Date:   Fri, 4 Oct 2019 10:54:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org,
        Rainer Weikusat <rainer.weikusat@sncag.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: keyspan: fix NULL-derefs on open() and
 write()
Message-ID: <20191004085448.GA267760@kroah.com>
References: <20191003134958.8692-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003134958.8692-1-johan@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 03:49:58PM +0200, Johan Hovold wrote:
> Fix NULL-pointer dereferences on open() and write() which can be
> triggered by a malicious USB device.
> 
> The current URB allocation helper would fail to initialise the newly
> allocated URB if the device has unexpected endpoint descriptors,
> something which could lead NULL-pointer dereferences in a number of
> open() and write() paths when accessing the URB. For example:
> 
> 	BUG: kernel NULL pointer dereference, address: 0000000000000000
> 	...
> 	RIP: 0010:usb_clear_halt+0x11/0xc0
> 	...
> 	Call Trace:
> 	 ? tty_port_open+0x4d/0xd0
> 	 keyspan_open+0x70/0x160 [keyspan]
> 	 serial_port_activate+0x5b/0x80 [usbserial]
> 	 tty_port_open+0x7b/0xd0
> 	 ? check_tty_count+0x43/0xa0
> 	 tty_open+0xf1/0x490
> 
> 	BUG: kernel NULL pointer dereference, address: 0000000000000000
> 	...
> 	RIP: 0010:keyspan_write+0x14e/0x1f3 [keyspan]
> 	...
> 	Call Trace:
> 	 serial_write+0x43/0xa0 [usbserial]
> 	 n_tty_write+0x1af/0x4f0
> 	 ? do_wait_intr_irq+0x80/0x80
> 	 ? process_echoes+0x60/0x60
> 	 tty_write+0x13f/0x2f0
> 
> 	BUG: kernel NULL pointer dereference, address: 0000000000000000
> 	...
> 	RIP: 0010:keyspan_usa26_send_setup+0x298/0x305 [keyspan]
> 	...
> 	Call Trace:
> 	 keyspan_open+0x10f/0x160 [keyspan]
> 	 serial_port_activate+0x5b/0x80 [usbserial]
> 	 tty_port_open+0x7b/0xd0
> 	 ? check_tty_count+0x43/0xa0
> 	 tty_open+0xf1/0x490
> 
> Fixes: fdcba53e2d58 ("fix for bugzilla #7544 (keyspan USB-to-serial converter)")
> Cc: stable <stable@vger.kernel.org>	# 2.6.21
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
