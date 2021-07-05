Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE0E3BB800
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhGEHnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhGEHnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 03:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A4AD613AE;
        Mon,  5 Jul 2021 07:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625470848;
        bh=zGHYK/Zq0c0G17od5h7JCpFMDS+7oZHhjCoKS9yvD1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZYRb2xrtH6IOdMRfo6tCJsxnvrTlVnqTYw1JI97/GePDOIf8XqaCW3dp2t7YL25tm
         Fp+S9zeDciRovRfrkPAD6AKqkcvyXtjQ69vhKM+rMs4QjzyPT6P6jgDh+DKvM5QDT/
         J39RRbPOmyjYtIhXzjY8nnyXhE4UUNHO3qfVSyrlY1LXPHgxk5V0p4JDakveWnnNBi
         u2w44OKTmdggKYV8+NUgw73niuZYuf2mvX45vaZcb26+47zskTJUH2X/Rjf3gxkQb9
         TzxU0qp9UIp/79cHNlv47Q5xW3DZiKMtZ9pQUpe6e8mW+7PxRPARA9Tto64k7c3HqL
         sWbnYlU1aNHcg==
Received: from johan by xi with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m0JDe-00087u-03; Mon, 05 Jul 2021 09:40:42 +0200
Date:   Mon, 5 Jul 2021 09:40:41 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] USB: serial: cp210x: fix control-characters error
 handling
Message-ID: <YOK3ecvJz3xV6C1j@hovoldconsulting.com>
References: <20210702134227.24621-1-johan@kernel.org>
 <20210702134227.24621-2-johan@kernel.org>
 <YN8m7wk0dfSLi+c5@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN8m7wk0dfSLi+c5@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 02, 2021 at 04:47:11PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 02, 2021 at 03:42:22PM +0200, Johan Hovold wrote:
> > In the unlikely event that setting the software flow-control characters
> > fails the other flow-control settings should still be updated.
> > 
> > Fixes: 7748feffcd80 ("USB: serial: cp210x: add support for software flow control")
> > Cc: stable@vger.kernel.org	# 5.11
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/cp210x.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> > index 09b845d0da41..b41e2c7649fb 100644
> > --- a/drivers/usb/serial/cp210x.c
> > +++ b/drivers/usb/serial/cp210x.c
> > @@ -1217,9 +1217,7 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
> >  		chars.bXonChar = START_CHAR(tty);
> >  		chars.bXoffChar = STOP_CHAR(tty);
> >  
> > -		ret = cp210x_set_chars(port, &chars);
> > -		if (ret)
> > -			return;
> > +		cp210x_set_chars(port, &chars);
> 
> What's the odds that someone tries to add the error checking back in
> here, in a few years?  Can you put a comment here saying why you are not
> checking it?

This is just how set_termios() works and how the other requests are
handled by the driver. I can add an explicit error message here though
just like when setting the line-control register so that it doesn't look
like an oversight. The error message is currently printed by the
set_chars() helper, but I can move that out when removing the helper
later in the series.

Johan
